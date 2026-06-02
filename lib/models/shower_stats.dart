import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';

class ShowerStats {
  final DateTime? minDate; // première douche (la plus ancienne)
  final DateTime? maxDate; // dernière douche (la plus récente)
  final int? minVolume; // plus petit volume
  final int? maxVolume; // plus gros volume
  final double? averageVolume; // volume moyen
  final int count; // nombre de douches
  final int totalVolume; // volume total

  const ShowerStats({
    required this.minDate,
    required this.maxDate,
    required this.minVolume,
    required this.maxVolume,
    required this.averageVolume,
    required this.count,
    required this.totalVolume,
  });

  bool get hasData => count > 0;

  /// Calcule les stats en un seul passage sur la liste.
  static ShowerStats fromShowers(List<Shower> showers) {
    if (showers.isEmpty) {
      return const ShowerStats(
        minDate: null,
        maxDate: null,
        minVolume: null,
        maxVolume: null,
        averageVolume: null,
        count: 0,
        totalVolume: 0,
      );
    }

    DateTime minDate = showers.first.date;
    DateTime maxDate = showers.first.date;
    int minVolume = showers.first.volume;
    int maxVolume = showers.first.volume;
    int totalVolume = 0;

    for (final s in showers) {
      final d = s.date;
      final v = s.volume;

      if (d.isBefore(minDate)) minDate = d;
      if (d.isAfter(maxDate)) maxDate = d;

      if (v < minVolume) minVolume = v;
      if (v > maxVolume) maxVolume = v;

      totalVolume += v;
    }

    final count = showers.length;
    final averageVolume = totalVolume / count;

    return ShowerStats(
      minDate: minDate,
      maxDate: maxDate,
      minVolume: minVolume,
      maxVolume: maxVolume,
      averageVolume: averageVolume,
      count: count,
      totalVolume: totalVolume,
    );
  }
}
