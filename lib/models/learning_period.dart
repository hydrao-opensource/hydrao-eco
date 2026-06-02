import 'package:hydrao_flutter_offline/models/threshold.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';

enum LearningStatus { begin, learn, end, cancel }

class LearningPeriod {
  final Showerhead sh;
  final List<Shower> showers;
  final bool applyThresholds;

  LearningPeriod({
    required this.sh,
    required this.showers,
    this.applyThresholds = true,
  });

  List<HydraoThreshold>? getNewThresholds() {
    if (showers.isEmpty) return null;

    // compute average max volume from showers and apply some challenge to reduce water consumption (- 5% ???)
    final totalVolume = showers.fold<double>(
      0.0,
      (sum, shower) => sum + shower.volume,
    );
    final double avgMaxVolume = (totalVolume / showers.length) * 0.95;

    if (avgMaxVolume < 4) return null;

    // compute new thresholds with challenge
    final step = avgMaxVolume / 4;
    return [
      HydraoThreshold(color: "#00FF00", liter: (step).round().toDouble()),
      HydraoThreshold(color: "#0000FF", liter: (step * 2).round().toDouble()),
      HydraoThreshold(color: "#FF00FF", liter: (step * 3).round().toDouble()),
      HydraoThreshold(
        color: "#FF0000",
        liter: (avgMaxVolume).round().toDouble(),
      ),
    ];
  }

  int? getAverageDuration() {
    if (showers.isEmpty) return null;

    final totalDuration = showers.fold<double>(
      0,
      (sum, shower) => sum + (shower.duration ?? 0),
    );
    return (totalDuration / showers.length).round();
  }

  LearningPeriod filter(List<int> showerIds, bool newApplyThresholds) {
    List<Shower> filteredShowers = showers
        .where((shower) => showerIds.contains(shower.id))
        .toList();

    return LearningPeriod(
      sh: sh,
      showers: filteredShowers,
      applyThresholds: newApplyThresholds,
    );
  }

  List<int> getShowerIds() {
    return showers.map((shower) => shower.id).toList();
  }
}
