import 'dart:async';
import 'dart:ui';

class ProgressTimer {
  final int durationInSeconds;
  final void Function(double progress) onProgress;
  final VoidCallback onTimeout;
  final double tick;

  Timer? _timer;
  double _progress = 0.0;
  late double _increment;

  bool _isPaused = false;

  ProgressTimer({
    required this.durationInSeconds,
    required this.onProgress,
    required this.onTimeout,
    this.tick = 1,
  }) {
    final totalTicks = durationInSeconds / tick;
    _increment = 1.0 / totalTicks;
  }

  /// Démarre le timer depuis zéro
  void start() {
    stop(); // reset propre si redémarrage

    _progress = 0.0;
    _isPaused = false;
    _startInternalTimer();
  }

  /// Timer interne qui incrémente le progrès
  void _startInternalTimer() {
    _timer = Timer.periodic(Duration(milliseconds: (tick * 1000).toInt()), (_) {
      if (_isPaused) return; // sécurité (ne devrait pas arriver)

      _progress += _increment;

      if (_progress >= 1.0) {
        _progress = 1.0;
        onProgress(_progress);
        stop();
        onTimeout();
      } else {
        onProgress(_progress);
      }
    });
  }

  /// Pause : stoppe le timer mais garde l'état (progression)
  void pause() {
    if (!isRunning) return;
    _isPaused = true;
    _timer?.cancel();
    _timer = null;
  }

  /// Reprend le timer là où il s'est arrêté
  void resume() {
    if (_isPaused && _progress < 1.0) {
      _isPaused = false;
      _startInternalTimer();
    }
  }

  /// Stop complet : reset du timer
  void stop() {
    _timer?.cancel();
    _timer = null;
    _isPaused = false;
  }

  int get totalDuration => durationInSeconds;

  /// Temps déjà écoulé (en secondes)
  double get elapsedSeconds => durationInSeconds * _progress;

  /// Temps restant (en secondes)
  double get remainingSeconds => durationInSeconds - elapsedSeconds;

  /// Progression entre 0 et 1
  double get progress => _progress;

  /// Le timer tourne actuellement
  bool get isRunning => _timer != null && !_isPaused;

  /// Le timer est en pause
  bool get isPaused => _isPaused;
}
