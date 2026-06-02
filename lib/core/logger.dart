import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:hydrao_flutter_offline/core/logger_rolling_file.dart';
import 'package:hydrao_flutter_offline/models/technical_data.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

RollingFileOutput? rollingOutput;

String logFilename = 'logs.txt';
String backupLogFilename = 'backup_logs.txt';

bool _loggerInitialized = false;

// ── Niveaux de log ────────────────────────────────────────────────────────────
enum LogLevel { trace, debug, info, warning, error, fatal }

// ── Logger principal : bypass total du package logger ────────────────────────
class AppLogger {
  void _write(
    LogLevel level,
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (rollingOutput == null) return;

    final time = DateTime.now()
        .toIso8601String()
        .split('T')
        .last
        .substring(0, 8);
    final date = DateTime.now().toIso8601String().split('T').first;
    final lvl = level.name.toUpperCase().padRight(7);

    final lines = <String>[];
    lines.add("[$date $time] $lvl | $message");

    if (error != null) {
      lines.add("  └─ Error: $error");
    }
    if (stackTrace != null) {
      lines.add("  └─ StackTrace:");
      final stackLines = stackTrace.toString().split('\n');
      lines.addAll(stackLines.take(8).map((l) => "     $l"));
    }

    // Écriture directe sans passer par le package logger
    rollingOutput!.writeLines(lines);

    // Affichage console en debug
    assert(() {
      for (final l in lines) {
        // ignore: avoid_print
        print(l);
      }
      return true;
    }());
  }

  void t(dynamic message, {dynamic error, StackTrace? stackTrace}) =>
      _write(LogLevel.trace, message, error: error, stackTrace: stackTrace);
  void d(dynamic message, {dynamic error, StackTrace? stackTrace}) =>
      _write(LogLevel.debug, message, error: error, stackTrace: stackTrace);
  void i(dynamic message, {dynamic error, StackTrace? stackTrace}) =>
      _write(LogLevel.info, message, error: error, stackTrace: stackTrace);
  void w(dynamic message, {dynamic error, StackTrace? stackTrace}) =>
      _write(LogLevel.warning, message, error: error, stackTrace: stackTrace);
  void e(dynamic message, {dynamic error, StackTrace? stackTrace}) =>
      _write(LogLevel.error, message, error: error, stackTrace: stackTrace);
  void f(dynamic message, {dynamic error, StackTrace? stackTrace}) =>
      _write(LogLevel.fatal, message, error: error, stackTrace: stackTrace);
}

// ── Instance globale ──────────────────────────────────────────────────────────
final appLogger = AppLogger();

// ── Init ──────────────────────────────────────────────────────────────────────
Future<void> initLogger() async {
  if (_loggerInitialized) return;
  _loggerInitialized = true;

  final logFilePath = await getLogFilePath(logFilename);
  final backupLogFilePath = await getLogFilePath(backupLogFilename);

  // Créer le fichier physiquement avant tout
  final file = File(logFilePath);
  if (!file.existsSync()) {
    await file.create(recursive: true);
  }

  rollingOutput = RollingFileOutput(
    filePath: logFilePath,
    backupFilePath: backupLogFilePath,
    maxBytes: 2 * 1024 * 1024,
  );

  appLogger.i("=== Session démarrée : ${DateTime.now().toIso8601String()} ===");
  List<String> technicalInfos = [];
  TechnicalData technicalData = await TechnicalData.init();
  technicalInfos.add('------------------------------');
  technicalInfos.add("Application : ${technicalData.getApp()}");
  technicalInfos.add("OS : ${technicalData.getOs()}");
  technicalInfos.add("Device : ${technicalData.getDevice()}");
  appLogger.i(technicalInfos.join('\n'));
}

Future<void> disposeLogger() async {
  await rollingOutput?.flush();
}

// ── Helpers fichiers (inchangés) ──────────────────────────────────────────────
Future<String> getLogFilePath(String filename) async {
  final directory = await getApplicationDocumentsDirectory();
  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }
  return p.join(directory.path, filename);
}

Future<Uint8List?> getSafeBytes(File file) async {
  try {
    return await file.readAsBytes();
  } on FileSystemException catch (_) {
    try {
      final List<int> allBytes = [];
      await for (final chunk in file.openRead()) {
        allBytes.addAll(chunk);
      }
      return Uint8List.fromList(allBytes);
    } catch (e2) {
      return null;
    }
  }
}

Future<File?> getLogFileForSharing() async {
  try {
    await rollingOutput!.flush();
    rollingOutput!.isPaused = true;

    final sourceFile = File(rollingOutput!.localFilePath);
    if (!sourceFile.existsSync() || sourceFile.lengthSync() == 0) return null;

    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/share_$logFilename');
    final bytes = await getSafeBytes(sourceFile);
    if (bytes == null || bytes.isEmpty) return null;

    await tempFile.writeAsBytes(bytes, flush: true);
    return tempFile;
  } catch (e) {
    return null;
  } finally {
    rollingOutput!.isPaused = false;
  }
}

Future<File?> getOldLogFileForSharing() async {
  try {
    final sourceFile = File(rollingOutput!.localBackupFilePath);
    if (!sourceFile.existsSync() || sourceFile.lengthSync() == 0) return null;

    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/share_$backupLogFilename');
    final bytes = await getSafeBytes(sourceFile);
    if (bytes == null || bytes.isEmpty) return null;

    await tempFile.writeAsBytes(bytes, flush: true);
    return tempFile;
  } catch (e) {
    return null;
  }
}

Future<File?> createLogsZip() async {
  try {
    await rollingOutput!.flush();
    rollingOutput!.isPaused = true;

    final directory = await getTemporaryDirectory();
    final zipPath = '${directory.path}/logs_support.zip';

    final zipFile = File(zipPath);
    if (zipFile.existsSync()) await zipFile.delete();

    final encoder = ZipFileEncoder();
    encoder.create(zipPath);
    bool hasFile = false;

    final logFile = await getLogFileForSharing();
    if (logFile != null && logFile.lengthSync() > 0) {
      encoder.addFile(logFile);
      hasFile = true;
    }

    final backupFile = await getOldLogFileForSharing();
    if (backupFile != null && backupFile.lengthSync() > 0) {
      encoder.addFile(backupFile);
      hasFile = true;
    }

    encoder.close();
    if (!hasFile) return null;

    final result = File(zipPath);
    return (result.existsSync() && result.lengthSync() > 0) ? result : null;
  } catch (e) {
    return null;
  } finally {
    rollingOutput!.isPaused = false;
  }
}
