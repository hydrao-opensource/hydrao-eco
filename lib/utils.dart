import 'dart:async';
import 'dart:core';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

// --- functions

Future<T?> retry<T>(
  String key,
  Future<T> Function() action, {
  int maxRetries = 3,
  int delayMs = 1000,
  FutureOr<bool> Function()? shouldContinue,
}) async {
  int attempt = 0;
  while (true) {
    if (shouldContinue != null && !(await shouldContinue())) {
      appLogger.d('❌ $key INTERRUPTED by shouldContinue callback');
      return null;
    }

    try {
      attempt++;
      appLogger.d('🟡 $key ... ($attempt / $maxRetries)');
      return await action();
    } catch (e, stack) {
      if (attempt >= maxRetries) {
        appLogger.e('❌ $key FAILED for all retries : $e / $stack');
        rethrow;
      }
      appLogger.e('⚠️ $key ($attempt / $maxRetries) FAILED : $e');

      // Interruptible delay
      final completer = Completer<void>();
      final timer = Timer(Duration(milliseconds: delayMs), () {
        if (!completer.isCompleted) completer.complete();
      });

      // Si shouldContinue devient false pendant le délai → on annule
      while (!completer.isCompleted) {
        await Future.delayed(const Duration(milliseconds: 100), () {});
        if (shouldContinue != null && !(await shouldContinue())) {
          appLogger.d(
            '❌ $key INTERRUPTED during timer by shouldContinue callback',
          );
          timer.cancel();
          return null;
        }
      }

      timer.cancel();
    }
  }
}

Future<void> safeCancel(StreamSubscription<dynamic>? sub) async {
  if (sub != null) {
    try {
      await sub.cancel().timeout(const Duration(milliseconds: 300));
    } catch (_) {
      // Ignore si timeout ou erreur
    }
  }
}

bool isLateInitialized<T>(T Function() getter) {
  try {
    getter();
    return true;
  } catch (e) {
    if (e.runtimeType.toString() == 'LateError') return false;
    rethrow;
  }
}

// --- Strings

extension StringMacExtensions on String {
  /// Retourne true si la chaîne est une adresse MAC valide
  /// au format XX:XX:XX:XX:XX:XX (hexadécimal).
  bool looksLikeMacAddress() {
    final macRegex = RegExp(r'^[0-9A-Fa-f]{2}(:[0-9A-Fa-f]{2}){5}$');
    return macRegex.hasMatch(this);
  }
}

// --- JSON

Map<String, dynamic> sanitizeJson(Map<String, dynamic> map) {
  Map<String, dynamic> clean = {};
  map.forEach((key, value) {
    if (value is double && (value.isNaN || value.isInfinite)) {
      appLogger.d("[UTILS] sanitizeJson key=$key, value=$value / map=$map");
      clean[key] = null; // ou 0.0
    } else if (value is Map<String, dynamic>) {
      clean[key] = sanitizeJson(value);
    } else if (value is List) {
      clean[key] = value.map((e) {
        if (e is Map<String, dynamic>) return sanitizeJson(e);
        if (e is double && (e.isNaN || e.isInfinite)) {
          appLogger.d(
            "[UTILS] sanitizeJson LIST key=$key, value=$value / map=$map",
          );
          return null;
        }
        return e;
      }).toList();
    } else {
      clean[key] = value;
    }
  });
  return clean;
}

// --- Date

bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

// --- List

extension ListCopyExtension<T> on List<T> {
  List<T> copy() => List<T>.from(this);
}

extension ListEqualExtension<T> on List<T> {
  bool isEqual(List<T> other) {
    final UnorderedIterableEquality<T> eq = UnorderedIterableEquality();
    return eq.equals(this, other);
  }
}

// --- Colors

Color getTextColorForBackground({
  required Color background,
  Color surfaceColor = Colors.white,
  Color textLight = Colors.white,
  Color textDark = Colors.black,
}) {
  final Color blendedColor = Color.alphaBlend(background, surfaceColor);
  // final brightness = ThemeData.estimateBrightnessForColor(background);
  return blendedColor.computeLuminance() > 0.5 ? textDark : textLight;
}

extension ColorUtils on Color {
  Color darken([double amount = 0.1]) {
    final hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  Color lighten([double amount = 0.1]) {
    final hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }
}
// --- Format

/// format = y MMM d => 10 mars 2025
String formatDate(BuildContext context, DateTime date) {
  final locale = Localizations.localeOf(context).toString();
  return DateFormat.MMMd(locale).format(date);
}

/// format = Hm => 18h30
String formatTime(BuildContext context, DateTime date) {
  final locale = Localizations.localeOf(context).toString();
  return DateFormat.Hm(locale).format(date);
}

String formatVolume(double value) {
  return formatDouble(value);
}

String formatMoney(double value) {
  return value.round().toString();
}

String formatTemperature(double value) {
  return formatDouble(value);
}

String formatDuration(double value) {
  return formatDouble(value);
}

String formatDouble(double value) {
  // Si c’est un entier (12.0 → 12)
  if (value == value.roundToDouble()) {
    return value.toInt().toString();
  }

  // Sinon, on garde 1 chiffre après la virgule
  return value.toStringAsFixed(1);
}

String formatFullDate(BuildContext context, DateTime d) {
  final locale = Localizations.localeOf(context);

  return DateFormat.yMMMMd(locale.toString()).format(d); // "10 mars 2025"
}

String formatShortDate(BuildContext context, DateTime d) {
  final locale = Localizations.localeOf(context);

  return DateFormat.yMMMd(locale.toString()).format(d); // "10 mars 2025"
}

String formatRelative(BuildContext context, DateTime d) {
  final locale = Localizations.localeOf(context);

  return timeago.format(d, locale: "${locale.languageCode}_short");
}

// --- I18N

String getDurationUnit(BuildContext context, String frUnit) {
  final locale = Localizations.localeOf(context);

  Map<String, String> enUnits = {"min": "min", "sec": "s"};

  switch (locale.languageCode) {
    case 'en':
    case 'us':
      return enUnits[frUnit] ?? frUnit;
  }
  return frUnit;
}
