import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';
import 'package:hydrao_flutter_offline/utils.dart';

class HydraoBackup {
  final int schemaVersion;
  final Settings? settings;
  final List<Showerhead> showerheads;
  final List<Shower> showers;

  HydraoBackup({
    required this.schemaVersion,
    this.settings,
    required this.showerheads,
    required this.showers,
  });

  static HydraoBackup? fromJson(String json) {
    try {
      final Map<String, dynamic> data =
          jsonDecode(json) as Map<String, dynamic>;
      return HydraoBackup.fromJsonMap(data);
    } catch (e) {
      return null;
    }
  }

  static HydraoBackup? fromJsonMap(Map<String, dynamic> data) {
    final int schemaVersion = data['schemaVersion'] as int? ?? 1;

    // settings
    Settings? settings;
    final Map<dynamic, dynamic>? settingsData =
        data['settings'] as Map<dynamic, dynamic>?;
    if (settingsData != null) {
      Map<String, dynamic> settingsJson = Map<String, dynamic>.from(
        settingsData,
      );
      if (settingsJson.containsKey('countryCode')) {
        settings = Settings.fromJson(settingsJson);
      } else {
        settings = null;
      }
    }

    // showerheads
    List<Showerhead> showerheads = [];
    try {
      final List<dynamic> showerheadsRaw = data['showerheads'] as List<dynamic>;
      showerheads = showerheadsRaw.map((item) {
        Map<String, dynamic> data = Map<String, dynamic>.from(
          item as Map<dynamic, dynamic>,
        );
        // migration fixes
        // -- v4 -> v5
        data['baselineBeginIndex'] = (data['baselineBeginIndex'] != null)
            ? data['baselineBeginIndex']
            : null;
        data['baselineEndIndex'] = (data['baselineEndIndex'] != null)
            ? data['baselineEndIndex']
            : null;
        data['baselineStatus'] = (data['baselineStatus'] != null)
            ? data['baselineStatus']
            : null;
        data['baselineBeginDate'] = (data['baselineBeginDate'] != null)
            ? data['baselineBeginDate']
            : null;
        data['baselineEndDate'] = (data['baselineEndDate'] != null)
            ? data['baselineEndDate']
            : null;
        // -- v5 -> v6
        data['needResetVolume'] = (data['needResetVolume'] != null)
            ? data['needResetVolume']
            : null;
        // -- v6 -> v7
        data['lastRssi'] = (data['lastRssi'] != null) ? data['lastRssi'] : null;
        return Showerhead.fromJson(data);
      }).toList();
    } catch (e) {
      // nothing
    }

    // showers
    List<Shower> showers = [];
    try {
      final List<dynamic> showersRaw = data['showers'] as List<dynamic>;
      showers = showersRaw.map((item) {
        Map<String, dynamic> data = Map<String, dynamic>.from(
          item as Map<dynamic, dynamic>,
        );
        // migration fixes
        // -- v3 -> v4
        data['isIgnored'] = (data['isIgnored'] != null)
            ? data['isIgnored']
            : false;
        data['isReference'] = (data['isReference'] != null)
            ? data['isReference']
            : false;
        return Shower.fromJson(data);
      }).toList();
    } catch (e) {
      // nothing
    }

    return HydraoBackup(
      schemaVersion: schemaVersion,
      settings: settings,
      showerheads: showerheads,
      showers: showers,
    );
  }

  String toJson() {
    final List<Map<String, dynamic>> showersJson = showers
        .map((s) => sanitizeJson(s.toJson()))
        .toList();
    final List<Map<String, dynamic>> showerheadsJson = showerheads
        .map((s) => sanitizeJson(s.toJson()))
        .toList();

    Map<String, dynamic>? settingsJson;
    if (settings != null) {
      settingsJson = sanitizeJson(settings!.toJson());
    }

    // 3. prepare final json data structure
    final export = <String, dynamic>{
      'schemaVersion': schemaVersion,
      'showers': showersJson,
      'showerheads': showerheadsJson,
      'settings': settingsJson,
    };

    return jsonEncode(export);
  }

  bool hasShowerhead(String uuid) {
    Showerhead? sh = showerheads.firstWhereOrNull(
      (showerhead) => showerhead.uuid == uuid,
    );

    return sh != null;
  }

  HydraoBackupChanges compare(HydraoBackup local) {
    // --- showerheads & showers
    Map<String, ChangeStatus> shActions = {};
    List<Showerhead> showerheadsToImport = [];
    List<Shower> showersToImport = [];
    for (var backupSh in showerheads) {
      if (backupSh.uuid == null) continue;

      // check if new showers
      List<Shower> backupShowers = showers
          .where((shower) => shower.deviceId == backupSh.uuid)
          .toList();
      List<Shower> localShowers = local.showers
          .where((shower) => shower.deviceId == backupSh.uuid)
          .toList();
      for (var backupShower in backupShowers) {
        Shower? localShower = localShowers.firstWhereOrNull(
          (localShower) => localShower.id == backupShower.id,
        );
        if (localShower == null) {
          showersToImport.add(backupShower);
        }
      }

      // check if exist in local (on uuid)
      Showerhead? localSh = local.showerheads.firstWhereOrNull(
        (sh) => sh.uuid == backupSh.uuid,
      );
      if (localSh != null) {
        // CASE already exist

        // check changes and prepare merged sh
        Showerhead? changedSh;
        Showerhead mergedSh = localSh.copyWith();
        if (backupSh.name != localSh.name) {
          appLogger.d(
            '[BACKUP] ${backupSh.uuid} / name changed from ${localSh.name} to ${backupSh.name}',
          );
          changedSh = mergedSh = mergedSh.copyWith(name: backupSh.name);
        }
        if (backupSh.type != localSh.type) {
          appLogger.d(
            '[BACKUP] ${backupSh.uuid} / type changed from ${localSh.type} to ${backupSh.type}',
          );
          changedSh = mergedSh = mergedSh.copyWith(type: backupSh.type);
        }
        if (backupSh.refShowerDuration != null &&
            backupSh.refShowerDuration != localSh.refShowerDuration) {
          appLogger.d(
            '[BACKUP] ${backupSh.uuid} / refShowerDuration changed from ${localSh.refShowerDuration} to ${backupSh.refShowerDuration}',
          );
          changedSh = mergedSh = mergedSh.copyWith(
            refShowerDuration: Value(backupSh.refShowerDuration),
          );
        }
        if (backupSh.previousFlow != null &&
            backupSh.previousFlow != localSh.previousFlow) {
          appLogger.d(
            '[BACKUP] ${backupSh.uuid} / previousFlow changed from ${localSh.previousFlow} to ${backupSh.previousFlow}',
          );
          changedSh = mergedSh = mergedSh.copyWith(
            previousFlow: Value(backupSh.previousFlow),
          );
        }
        if (backupSh.firstSeen != null &&
            backupSh.firstSeen != localSh.firstSeen) {
          appLogger.d(
            '[BACKUP] ${backupSh.uuid} / firstSeen changed from ${localSh.firstSeen} to ${backupSh.firstSeen}',
          );
          changedSh = mergedSh = mergedSh.copyWith(
            firstSeen: Value(backupSh.firstSeen),
          );
        }

        if (backupSh.lastSyncMinIndex != localSh.lastSyncMinIndex ||
            backupSh.lastSyncMaxIndex != localSh.lastSyncMaxIndex) {
          // TODO => compute isLastSyncComplete from local & backup showers
        }

        if (changedSh != null) {
          // CASE update to sh
          shActions[backupSh.uuid!] = ChangeStatus.update;
          showerheadsToImport.add(mergedSh);
        } else {
          shActions[backupSh.uuid!] = ChangeStatus.noChange;
        }
      } else {
        // CASE not exist => NEW
        shActions[backupSh.uuid!] = ChangeStatus.insert;
        showerheadsToImport.add(backupSh);
      }
    }

    // --- settings
    AppSettingsCompanion? settingsChanges;
    ChangeStatus settingsStatus = ChangeStatus.noChange;
    if (local.settings == null && settings != null) {
      settingsChanges = settings!.toCompanion(false);
      settingsStatus = ChangeStatus.insert;
    } else if (local.settings != null && settings != null) {
      settingsChanges = settings!.getChangesFrom(local.settings);
      settingsStatus = (settingsChanges != null)
          ? ChangeStatus.update
          : ChangeStatus.noChange;
    }

    return HydraoBackupChanges(
      backup: this,
      shActions: shActions,
      showerheadsToImport: showerheadsToImport,
      showersToImport: showersToImport,
      settingsStatus: settingsStatus,
      settingsChanges: settingsChanges,
    );
  }
}

enum ChangeStatus { insert, update, noChange }

/// for summarize data to import (changes in input backup from local data)
class HydraoBackupChanges {
  final HydraoBackup backup;
  final Map<String, ChangeStatus>
  shActions; // uuid => status (only sh new, with changes, with new showers)
  final List<Showerhead> showerheadsToImport;
  final List<Shower> showersToImport;
  final ChangeStatus settingsStatus;
  final AppSettingsCompanion? settingsChanges;

  HydraoBackupChanges({
    required this.backup,
    required this.shActions,
    required this.showerheadsToImport,
    required this.showersToImport,
    required this.settingsStatus,
    this.settingsChanges,
  });

  int getShowerheadShowersCount(String uuid) {
    List<Shower> shShowers = showersToImport
        .where((shShower) => shShower.deviceId == uuid)
        .toList();

    return shShowers.length;
  }

  List<String> getShowerheadUuids() {
    List<String> uuids = [];

    for (var sh in showerheadsToImport) {
      if (sh.uuid != null && shActions[sh.uuid!] == ChangeStatus.insert) {
        uuids.add(sh.uuid!);
      }
    }

    return uuids;
  }

  List<String> getShowersUuids() {
    List<String> uuids = [];

    for (var shower in showersToImport) {
      if (!uuids.contains(shower.deviceId)) {
        uuids.add(shower.deviceId);
      }
    }

    return uuids;
  }

  String? getShowerheadName(String uuid) {
    Showerhead? sh = backup.showerheads.firstWhereOrNull(
      (showerhead) => showerhead.uuid == uuid,
    );

    return (sh != null) ? sh.name : null;
  }

  HydraoBackup? filter(
    bool withSettings,
    List<String>? showerheadUuids,
    List<String>? showerUuids,
  ) {
    Settings? filteredSettings = withSettings == true ? backup.settings : null;

    List<Showerhead> filteredShowerheads = showerheadUuids == null
        ? showerheadsToImport
        : [];

    if (showerheadUuids != null) {
      for (var uuid in showerheadUuids) {
        Showerhead? sh = showerheadsToImport.firstWhereOrNull(
          (showerhead) => showerhead.uuid == uuid,
        );

        if (sh != null) {
          filteredShowerheads.add(sh);
        }
      }
    }

    List<Shower> filteredShowers = showerheadUuids == null
        ? showersToImport
        : [];
    if (showerUuids != null) {
      for (var uuid in showerUuids) {
        List<Shower> shShowers = showersToImport
            .where((shShower) => shShower.deviceId == uuid)
            .toList();
        if (shShowers.isNotEmpty) {
          filteredShowers.addAll(shShowers);
        }
      }
    }

    return HydraoBackup(
      schemaVersion: backup.schemaVersion,
      settings: filteredSettings,
      showerheads: filteredShowerheads,
      showers: filteredShowers,
    );
  }
}
