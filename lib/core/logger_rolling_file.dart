import 'dart:collection';
import 'dart:io';

class RollingFileOutput {
  final String localFilePath;
  final String localBackupFilePath;
  final int maxBytes;
  bool isPaused = false;

  final Queue<List<String>> _queue = Queue();
  bool _isProcessing = false;

  RollingFileOutput({
    required String filePath,
    required String backupFilePath,
    this.maxBytes = 1024 * 1024,
  }) : localFilePath = filePath,
       localBackupFilePath = backupFilePath;

  // ── Point d'entrée public (appelé directement par AppLogger) ─────────────
  void writeLines(List<String> lines) {
    if (isPaused) return;
    _queue.add(List<String>.from(lines));
    _processQueue();
  }

  // ── Boucle sérialisée ─────────────────────────────────────────────────────
  Future<void> _processQueue() async {
    if (_isProcessing) return;
    _isProcessing = true;

    while (_queue.isNotEmpty) {
      final lines = _queue.removeFirst();
      await _writeLines(lines);
    }

    _isProcessing = false;
  }

  Future<void> _writeLines(List<String> lines) async {
    try {
      await _ensureFileExists();
      await _checkRotation();

      final file = File(localFilePath);
      final sink = file.openWrite(mode: FileMode.append);
      for (final line in lines) {
        sink.writeln(line);
      }
      await sink.flush();
      await sink.close();
    } catch (e) {
      // ignore: avoid_print
      print("RollingFileOutput - erreur écriture: $e");
    }
  }

  Future<void> _ensureFileExists() async {
    final file = File(localFilePath);
    if (!file.existsSync()) {
      await file.create(recursive: true);
    }
  }

  Future<void> _checkRotation() async {
    try {
      final file = File(localFilePath);
      if (!file.existsSync()) return;
      if (await file.length() <= maxBytes) return;

      final backup = File(localBackupFilePath);
      if (backup.existsSync()) await backup.delete();
      await file.rename(localBackupFilePath);
      await File(localFilePath).create(recursive: true);
    } catch (e) {
      // ignore: avoid_print
      print("RollingFileOutput - erreur rotation: $e");
    }
  }

  // ── Attendre la fin des écritures en cours ────────────────────────────────
  Future<void> flush() async {
    while (_isProcessing || _queue.isNotEmpty) {
      await Future.delayed(const Duration(milliseconds: 50), () {});
    }
  }

  Future<void> destroy() async {
    await flush();
  }
}
