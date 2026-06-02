import 'package:flutter/material.dart';

class AppLifecycleTracker {
  DateTime? _pausedAt;
  late final AppLifecycleListener _lifecycleListener;

  void listen(
    Future<void> Function() onPaused,
    Future<void> Function(Duration? pauseDuration) onResume,
  ) {
    _lifecycleListener = AppLifecycleListener(
      onStateChange: (state) async {
        switch (state) {
          case AppLifecycleState.paused:
            _handlePause();
            await onPaused();
            break;
          case AppLifecycleState.resumed:
            final duration = _handleResume();
            await onResume(duration);
            break;
          default:
            break;
        }
      },
    );
  }

  void dispose() {
    _lifecycleListener.dispose();
  }

  /// à appeler quand l’app passe en pause
  void _handlePause() {
    _pausedAt = DateTime.now();
  }

  /// à appeler quand l’app revient en foreground
  /// retourne la durée passée en pause (null si inconnue)
  Duration? _handleResume() {
    if (_pausedAt == null) return null;
    final now = DateTime.now();
    final pausedDuration = now.difference(_pausedAt!);
    _pausedAt = null; // reset
    return pausedDuration;
  }
}
