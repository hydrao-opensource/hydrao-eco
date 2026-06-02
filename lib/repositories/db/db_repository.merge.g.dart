// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_repository.dart';

// **************************************************************************
// CompanionMergeGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

extension ShowerheadsCompanionMerge on ShowerheadsCompanion {
  /// Merge ce companion avec un autre
  /// Les valeurs présentes dans [other] écrasent celles de this
  ShowerheadsCompanion mergeWith(ShowerheadsCompanion other) {
    return ShowerheadsCompanion(
      id: other.id.present ? other.id : id,
      firstSeen: other.firstSeen.present ? other.firstSeen : firstSeen,
      lastSeen: other.lastSeen.present ? other.lastSeen : lastSeen,
      lastRssi: other.lastRssi.present ? other.lastRssi : lastRssi,
      isLastSyncComplete: other.isLastSyncComplete.present
          ? other.isLastSyncComplete
          : isLastSyncComplete,
      lastSyncMinIndex: other.lastSyncMinIndex.present
          ? other.lastSyncMinIndex
          : lastSyncMinIndex,
      lastSyncMaxIndex: other.lastSyncMaxIndex.present
          ? other.lastSyncMaxIndex
          : lastSyncMaxIndex,
      lastSyncDate: other.lastSyncDate.present
          ? other.lastSyncDate
          : lastSyncDate,
      indexCycleCount: other.indexCycleCount.present
          ? other.indexCycleCount
          : indexCycleCount,
      baselineBeginIndex: other.baselineBeginIndex.present
          ? other.baselineBeginIndex
          : baselineBeginIndex,
      baselineEndIndex: other.baselineEndIndex.present
          ? other.baselineEndIndex
          : baselineEndIndex,
      baselineStatus: other.baselineStatus.present
          ? other.baselineStatus
          : baselineStatus,
      baselineBeginDate: other.baselineBeginDate.present
          ? other.baselineBeginDate
          : baselineBeginDate,
      baselineEndDate: other.baselineEndDate.present
          ? other.baselineEndDate
          : baselineEndDate,
      liveVolume: other.liveVolume.present ? other.liveVolume : liveVolume,
      liveTemperature: other.liveTemperature.present
          ? other.liveTemperature
          : liveTemperature,
      liveFlow: other.liveFlow.present ? other.liveFlow : liveFlow,
      liveDuration: other.liveDuration.present
          ? other.liveDuration
          : liveDuration,
      liveDate: other.liveDate.present ? other.liveDate : liveDate,
      name: other.name.present ? other.name : name,
      type: other.type.present ? other.type : type,
      thresholdRequest: other.thresholdRequest.present
          ? other.thresholdRequest
          : thresholdRequest,
      needResetVolume: other.needResetVolume.present
          ? other.needResetVolume
          : needResetVolume,
      hwVersion: other.hwVersion.present ? other.hwVersion : hwVersion,
      fwVersion: other.fwVersion.present ? other.fwVersion : fwVersion,
      threshold: other.threshold.present ? other.threshold : threshold,
      uuid: other.uuid.present ? other.uuid : uuid,
      calibration: other.calibration.present ? other.calibration : calibration,
      previousFlow: other.previousFlow.present
          ? other.previousFlow
          : previousFlow,
      refShowerDuration: other.refShowerDuration.present
          ? other.refShowerDuration
          : refShowerDuration,
    );
  }

  /// Merge ce companion avec plusieurs autres
  /// Les companions sont appliqués dans l'ordre
  ShowerheadsCompanion mergeAll(List<ShowerheadsCompanion> others) {
    var result = this;
    for (final other in others) {
      result = result.mergeWith(other);
    }
    return result;
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

extension ShowersCompanionMerge on ShowersCompanion {
  /// Merge ce companion avec un autre
  /// Les valeurs présentes dans [other] écrasent celles de this
  ShowersCompanion mergeWith(ShowersCompanion other) {
    return ShowersCompanion(
      id: other.id.present ? other.id : id,
      deviceId: other.deviceId.present ? other.deviceId : deviceId,
      isEmpty: other.isEmpty.present ? other.isEmpty : isEmpty,
      isReference: other.isReference.present ? other.isReference : isReference,
      isIgnored: other.isIgnored.present ? other.isIgnored : isIgnored,
      volume: other.volume.present ? other.volume : volume,
      temperature: other.temperature.present ? other.temperature : temperature,
      flow: other.flow.present ? other.flow : flow,
      duration: other.duration.present ? other.duration : duration,
      date: other.date.present ? other.date : date,
      soapingTime: other.soapingTime.present ? other.soapingTime : soapingTime,
      threshold: other.threshold.present ? other.threshold : threshold,
    );
  }

  /// Merge ce companion avec plusieurs autres
  /// Les companions sont appliqués dans l'ordre
  ShowersCompanion mergeAll(List<ShowersCompanion> others) {
    var result = this;
    for (final other in others) {
      result = result.mergeWith(other);
    }
    return result;
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

extension AppSettingsCompanionMerge on AppSettingsCompanion {
  /// Merge ce companion avec un autre
  /// Les valeurs présentes dans [other] écrasent celles de this
  AppSettingsCompanion mergeWith(AppSettingsCompanion other) {
    return AppSettingsCompanion(
      id: other.id.present ? other.id : id,
      countryCode: other.countryCode.present ? other.countryCode : countryCode,
      minShowerLiter: other.minShowerLiter.present
          ? other.minShowerLiter
          : minShowerLiter,
      currencyCode: other.currencyCode.present
          ? other.currencyCode
          : currencyCode,
      waterUnit: other.waterUnit.present ? other.waterUnit : waterUnit,
      waterPrice: other.waterPrice.present ? other.waterPrice : waterPrice,
      energyPrice: other.energyPrice.present ? other.energyPrice : energyPrice,
      heatingEnergy: other.heatingEnergy.present
          ? other.heatingEnergy
          : heatingEnergy,
      nbPeople: other.nbPeople.present ? other.nbPeople : nbPeople,
      statsNbShowers: other.statsNbShowers.present
          ? other.statsNbShowers
          : statsNbShowers,
    );
  }

  /// Merge ce companion avec plusieurs autres
  /// Les companions sont appliqués dans l'ordre
  AppSettingsCompanion mergeAll(List<AppSettingsCompanion> others) {
    var result = this;
    for (final other in others) {
      result = result.mergeWith(other);
    }
    return result;
  }
}
