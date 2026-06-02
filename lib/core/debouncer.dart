import 'dart:async';

class Debouncer<T> {
  Debouncer({required this.duration, required this.onDebounced, this.equals});

  final Duration duration;
  final void Function(T value) onDebounced;
  final bool Function(T a, T b)? equals;

  Timer? _timer;
  T? _lastValue;

  /// Met à jour la valeur et relance le timer
  void update(T newValue) {
    final eq = equals ?? (T a, T b) => a == b;

    // On ignore si la valeur est identique
    if (_lastValue != null && eq(_lastValue as T, newValue)) {
      return;
    }

    _lastValue = newValue;

    // Annulation du timer précédent
    _timer?.cancel();

    // Nouveau timer
    _timer = Timer(duration, () {
      if (_lastValue != null) {
        onDebounced(_lastValue as T);
      }
    });
  }

  /// Arrête le timer en cours sans déclencher le callback
  void stop() {
    _timer?.cancel();
    _timer = null;
    _lastValue = null;
  }

  /// Libère complètement le debouncer
  void dispose() {
    stop();
  }
}
