import 'dart:math';

import 'package:collection/collection.dart';
import 'package:hydrao_flutter_offline/conversions.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';
import 'package:hydrao_flutter_offline/utils.dart';

enum ShowerFilter {
  // N last showers
  lastShowersCount,
  // user options
  hideIgnored,
  onlyIgnored,
  onlyReference,
  // volume
  onlyChallengeKo,
  gteVolume,
  lteVolume,
  // sync date
  inPeriod,
  // duration
  gtRefDuration,
  gteDuration,
  lteDuration,
}

class ShowerFilters {
  final List<ShowerFilter> actives;
  int? lastShowers; // lastShowersCount
  DateTime? periodBegin; // inPeriod
  DateTime? periodEnd; // inPeriod
  double? volumeMin; // gteDuration / in liter or gal
  double? volumeMax; // lteVolume / in liter or gal
  int? durationMin; // gteDuration / in seconds
  int? durationMax; // lteDuration / in seconds
  int? durationRef; // gteRefDuration / in seconds

  ShowerFilters({
    required this.actives,
    this.lastShowers,
    this.periodBegin,
    this.periodEnd,
    this.volumeMin,
    this.volumeMax,
    this.durationMin,
    this.durationMax,
    this.durationRef,
  });

  void add(ShowerFilter filter) {
    if (!actives.contains(filter)) {
      actives.add(filter);
    }
  }

  void remove(ShowerFilter filter) {
    if (actives.contains(filter)) {
      actives.remove(filter);
    }
  }

  void setPeriod(DateTime? begin, DateTime? end) {
    add(ShowerFilter.inPeriod);
    periodBegin = begin;
    periodEnd = end;
  }

  void setVolumeMin(double? volume) {
    add(ShowerFilter.gteVolume);
    volumeMin = volume;
  }

  void setVolumeMax(double? volume) {
    add(ShowerFilter.lteVolume);
    volumeMax = volume;
  }

  void setDurationMin(int? durationInSeconds) {
    add(ShowerFilter.gteDuration);
    durationMin = durationInSeconds;
  }

  void setDurationMax(int? durationInSeconds) {
    add(ShowerFilter.lteDuration);
    durationMax = durationInSeconds;
  }

  void setDurationRef(int? durationInSeconds) {
    add(ShowerFilter.gtRefDuration);
    durationRef = durationInSeconds;
  }

  void setLastShowersCount(int? count) {
    if (count == null) {
      remove(ShowerFilter.lastShowersCount);
    } else {
      add(ShowerFilter.lastShowersCount);
      lastShowers = count;
    }
  }

  bool has(ShowerFilter filter) {
    return actives.contains(filter);
  }

  int count() {
    int activesCount = 0;

    for (var active in actives) {
      switch (active) {
        case ShowerFilter.gteVolume:
          if (volumeMin != null) {
            activesCount++;
          }
          break;
        case ShowerFilter.lteVolume:
          if (volumeMax != null) {
            activesCount++;
          }
          break;
        case ShowerFilter.gteDuration:
          if (durationMax != null) {
            activesCount++;
          }
          break;
        case ShowerFilter.lteDuration:
          if (durationMin != null) {
            activesCount++;
          }
          break;
        case ShowerFilter.gtRefDuration:
          if (durationRef != null) {
            activesCount++;
          }
          break;
        case ShowerFilter.inPeriod:
          if (periodBegin != null || periodEnd != null) {
            activesCount++;
          }
          break;
        case ShowerFilter.lastShowersCount:
          if (lastShowers != null) {
            activesCount++;
          }
          break;
        default:
          activesCount++;
          break;
      }
    }
    return activesCount;
  }

  List<Shower> filter(List<Shower> showers) {
    List<Shower> filteredShowers = List<Shower>.from(showers);

    if (actives.isNotEmpty) {
      // last showers count
      if (has(ShowerFilter.lastShowersCount) && lastShowers != null) {
        int start = max(0, filteredShowers.length - lastShowers!);
        filteredShowers = filteredShowers.sublist(start);
      }

      filteredShowers = filteredShowers.where((shower) {
        // user options
        final matchHideIgnored = has(ShowerFilter.hideIgnored)
            ? shower.isIgnored == false
            : true;
        final matchOnlyIgnored = has(ShowerFilter.onlyIgnored)
            ? shower.isIgnored == true
            : true;
        final matchOnlyReference = has(ShowerFilter.onlyReference)
            ? shower.isReference == true
            : true;

        // volume
        double? maxThresholdVolume = shower.threshold != null
            ? getThresholdsMaxVolume(thresholdsFromJson(shower.threshold)!)
            : null;
        final matchOnlyChallengeKO =
            has(ShowerFilter.onlyChallengeKo) && maxThresholdVolume != null
            ? shower.threshold != null && shower.volume > maxThresholdVolume
            : true;
        final matchGteVolume = has(ShowerFilter.gteVolume) && volumeMin != null
            ? shower.volume >= volumeMin!
            : true;
        final matchLteVolume = has(ShowerFilter.lteVolume) && volumeMax != null
            ? shower.volume <= volumeMax!
            : true;

        // sync date
        final matchInPeriodAfter =
            has(ShowerFilter.inPeriod) && periodBegin != null
            ? shower.date.isAfter(periodBegin!) ||
                  shower.date.isAtSameMomentAs(periodBegin!)
            : true;
        final matchInPeriodBefore =
            has(ShowerFilter.inPeriod) && periodEnd != null
            ? shower.date.isBefore(periodEnd!) ||
                  shower.date.isAtSameMomentAs(periodEnd!)
            : true;

        // duration
        final matchGtRefDuration =
            has(ShowerFilter.gtRefDuration) && durationRef != null
            ? shower.duration != null &&
                  shower.duration! > durationRef!.toDouble()
            : true;
        final matchGteDuration =
            has(ShowerFilter.gteDuration) && durationMin != null
            ? shower.duration != null &&
                  shower.duration! >= durationMin!.toDouble()
            : true;
        final matchLteDuration =
            has(ShowerFilter.lteDuration) && durationMax != null
            ? shower.duration != null &&
                  shower.duration! <= durationMax!.toDouble()
            : true;

        return matchHideIgnored &&
            matchOnlyIgnored &&
            matchOnlyReference &&
            matchOnlyChallengeKO &&
            matchGteVolume &&
            matchLteVolume &&
            matchInPeriodAfter &&
            matchInPeriodBefore &&
            matchGtRefDuration &&
            matchGteDuration &&
            matchLteDuration;
      }).toList();
    }

    return filteredShowers;
  }

  ShowerFilters copyWith({
    List<ShowerFilter>? actives,
    DateTime? periodBegin,
    DateTime? periodEnd,
    double? volumeMin,
    double? volumeMax,
    int? durationMin,
    int? durationMax,
    int? durationRef,
  }) {
    return ShowerFilters(
      actives: actives?.copy() ?? this.actives.copy(),
      periodBegin: periodBegin ?? this.periodBegin,
      periodEnd: periodEnd ?? this.periodEnd,
      volumeMin: volumeMin ?? this.volumeMin,
      volumeMax: volumeMax ?? this.volumeMax,
      durationMin: durationMin ?? this.durationMin,
      durationMax: durationMax ?? this.durationMax,
      durationRef: durationRef ?? this.durationRef,
    );
  }

  bool hasChanges(ShowerFilters other) {
    return !actives.isEqual(other.actives) ||
        periodBegin != other.periodBegin ||
        periodEnd != other.periodEnd ||
        volumeMin != other.volumeMin ||
        volumeMax != other.volumeMax ||
        durationRef != other.durationRef ||
        durationMin != other.durationMin ||
        durationMax != other.durationMax;
  }

  @override
  String toString() {
    List<String> activesLabel = [];
    for (ShowerFilter active in actives) {
      switch (active) {
        case ShowerFilter.gteVolume:
          if (volumeMin != null) {
            activesLabel.add('gteVolume<$volumeMin>');
          }
          break;
        case ShowerFilter.lteVolume:
          if (volumeMax != null) {
            activesLabel.add('lteVolume<$volumeMax>');
          }
          break;
        case ShowerFilter.gteDuration:
          if (durationMax != null) {
            activesLabel.add('gteDuration<$durationMax>');
          }
          break;
        case ShowerFilter.lteDuration:
          if (durationMin != null) {
            activesLabel.add('lteDuration<$durationMin>');
          }
          break;
        case ShowerFilter.gtRefDuration:
          if (durationRef != null) {
            activesLabel.add('gtRefDuration<$durationRef>');
          }
          break;
        case ShowerFilter.inPeriod:
          if (periodBegin != null || periodEnd != null) {
            activesLabel.add('inPeriod<$periodBegin-$periodEnd>');
          }
          break;
        case ShowerFilter.lastShowersCount:
          if (lastShowers != null) {
            activesLabel.add('lastShowersCount<$lastShowers>');
          }
          break;
        default:
          activesLabel.add(active.toString());
          break;
      }
    }

    String filters = (activesLabel.isEmpty)
        ? "no filter"
        : activesLabel.join(', ');

    return 'ShowerFilters($filters)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShowerFilters &&
        // Comparaison profonde de la liste (ordre et contenu)
        const ListEquality<ShowerFilter>().equals(other.actives, actives) &&
        other.lastShowers == lastShowers &&
        other.periodBegin == periodBegin &&
        other.periodEnd == periodEnd &&
        other.volumeMin == volumeMin &&
        other.volumeMax == volumeMax &&
        other.durationMin == durationMin &&
        other.durationMax == durationMax &&
        other.durationRef == durationRef;
  }

  @override
  int get hashCode {
    // On combine les hashCodes de tous les champs
    return Object.hash(
      Object.hashAll(actives), // Hash du contenu de la liste
      lastShowers,
      periodBegin,
      periodEnd,
      volumeMin,
      volumeMax,
      durationMin,
      durationMax,
      durationRef,
    );
  }
}
