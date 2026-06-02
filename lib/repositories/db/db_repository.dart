import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:hydrao_flutter_offline/builders/generate_merge/companion_merge_annotation.dart';
import 'package:hydrao_flutter_offline/constants.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/models/backup.dart';
import 'package:hydrao_flutter_offline/repositories/db/migrations/runner.dart';
import 'package:path_provider/path_provider.dart';

part 'db_repository.g.dart'; // ← obligatoire pour la génération
part 'db_repository.merge.g.dart'; // généré par ton builder

const _logTag = "[DB_REPOSITORY] ";

@DriftDatabase(tables: [Showerheads, Showers, AppSettings])
class DbRepository extends _$DbRepository {
  DbRepository() : super(_openConnection());

  @override
  int get schemaVersion => 7;

  // --- SHOWERHEADS

  /// watch changes on shwoerheads
  Stream<List<Showerhead>> watchShowerheads() => select(showerheads).watch();

  Future<List<Showerhead>> getShowerheads() {
    final query = select(showerheads);
    return query.get();
  }

  /// retreive one showerhead directly
  Future<Showerhead?> getShowerhead(String deviceId) => (select(
    showerheads,
  )..where((sh) => sh.id.equals(deviceId))).getSingleOrNull();

  /// add or update a showerhead
  Future<void> saveShowerhead(ShowerheadsCompanion sh) =>
      into(showerheads).insertOnConflictUpdate(sh);

  /// remove a showerhead
  Future<void> deleteShowerhead(String deviceId) =>
      (delete(showerheads)..where((sh) => sh.id.equals(deviceId))).go();

  // --- SHOWERS

  /// watch changes on showers of a showerhead
  Stream<List<Shower>> watchShowers({String? shUuid}) {
    final query = select(showers);
    if (shUuid != null) {
      query.where((shower) => shower.deviceId.equals(shUuid));
    }
    query.orderBy([(shower) => OrderingTerm.desc(shower.date)]);
    return query.watch();
  }

  Future<List<Shower>> getShowers({String? shUuid}) {
    final query = select(showers);
    if (shUuid != null) {
      query.where((shower) => shower.deviceId.equals(shUuid));
    }
    query.orderBy([(shower) => OrderingTerm.desc(shower.date)]);
    return query.get();
  }

  /// add shower (insert only)
  Future<void> saveShower(ShowersCompanion shower) =>
      into(showers).insertOnConflictUpdate(shower);

  /// remove all showers of a showerhead
  Future<void> deleteShowerheadShowers(String shUuid) =>
      (delete(showers)..where((shower) => shower.deviceId.equals(shUuid))).go();

  // --- SETTINGS

  /// watch changes on settings
  Stream<Settings?> watchSettings() => select(appSettings).watchSingleOrNull();

  /// retreive the only row of settings
  Future<Settings?> getSettings() => select(appSettings).getSingleOrNull();

  /// add or update settings
  Future<void> saveSettings(AppSettingsCompanion newSettings) =>
      into(appSettings).insertOnConflictUpdate(newSettings);

  // --- GLOBAL

  /// remove all data without drop tables
  Future<void> clearAllData() async {
    final tables = allTables;
    for (final table in tables) {
      await delete(table).go();
    }
  }

  Future<HydraoBackup> exportAllData() async {
    final allShowers = await select(showers).get();
    final allShowerheads = await select(showerheads).get();
    final allSettings = await select(appSettings).getSingleOrNull();

    HydraoBackup backup = HydraoBackup(
      schemaVersion: schemaVersion,
      showerheads: allShowerheads,
      showers: allShowers,
      settings: allSettings,
    );

    return backup;
  }

  Future<void> importAllDataFromJson(HydraoBackup backup) async {
    if (backup.schemaVersion != schemaVersion) {
      //TODO warning or Exception ???
      appLogger.w(
        '$_logTag importAllDataFromJson WARNING : exportDbVersion=${backup.schemaVersion} / currentDbVersion=$schemaVersion',
      );
    }

    await transaction(() async {
      // Optionnel : vider les tables avant import
      // await db.delete(db.showers).go();
      // await db.delete(db.showerheads).go();

      // 1. import settings
      if (backup.settings != null) {
        into(
          appSettings,
        ).insertOnConflictUpdate(backup.settings!.toCompanion(true));
      }

      // 2. import showerheads first (because needed by showers)
      if (backup.showerheads.isNotEmpty) {
        await batch((batch) {
          batch.insertAllOnConflictUpdate(
            showerheads,
            backup.showerheads.map((row) => row.toCompanion(true)).toList(),
          );
        });
      }

      // 3. import showers
      if (backup.showers.isNotEmpty) {
        await batch((batch) {
          batch.insertAllOnConflictUpdate(
            showers,
            backup.showers.map((row) => row.toCompanion(true)).toList(),
          );
        });
      }
    });
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll(); // crée toutes les tables pour la première fois
    },
    onUpgrade: (m, from, to) async {
      await runMigrations(m, this, from, to);
    },
    beforeOpen: (details) async {
      // optionnel : nettoyage ou actions avant ouverture
    },
  );
}

// --- generic methods for companion objects
extension CompanionEquals<T> on UpdateCompanion<T>? {
  bool equals(UpdateCompanion<T>? other, {List<String>? keys}) {
    final a = this;
    final b = other;

    if (a == null && b == null) return true;
    if (a == null || b == null) return false;

    final mapA = a.toColumns(false);
    final mapB = b.toColumns(false);

    // Si même structure mais aucun changement
    if (mapA.isEmpty && mapB.isEmpty) return true;

    // Optionnellement filtrer les clés à comparer
    final keysToCompare = keys ?? mapA.keys.toList();

    for (final key in keysToCompare) {
      if (!mapB.containsKey(key)) return false;
      if (mapA[key] != mapB[key]) return false;
    }

    return true;
  }
}

// ---

@CompanionMerge()
@DataClassName('Showerhead')
class Showerheads extends Table {
  TextColumn get id => text()(); // mac address detected by ble
  // usage / synchro
  DateTimeColumn get firstSeen => dateTime().nullable()();
  DateTimeColumn get lastSeen => dateTime().nullable()();
  IntColumn get lastRssi => integer().nullable()();
  BoolColumn get isLastSyncComplete => boolean().nullable()();
  IntColumn get lastSyncMinIndex => integer().nullable()();
  IntColumn get lastSyncMaxIndex => integer().nullable()();
  DateTimeColumn get lastSyncDate => dateTime().nullable()();
  IntColumn get indexCycleCount => integer().withDefault(
    Constant(0),
  )(); // to manage shower index after 65535
  // learning period
  IntColumn get baselineBeginIndex => integer().nullable()();
  IntColumn get baselineEndIndex => integer().nullable()();
  TextColumn get baselineStatus => text().nullable()();
  DateTimeColumn get baselineBeginDate => dateTime().nullable()();
  DateTimeColumn get baselineEndDate => dateTime().nullable()();
  // live shower data
  IntColumn get liveVolume => integer().nullable()();
  RealColumn get liveTemperature => real().nullable()();
  RealColumn get liveFlow => real().nullable()();
  RealColumn get liveDuration => real().nullable()();
  DateTimeColumn get liveDate => dateTime().nullable()();
  // initial configuration
  TextColumn get name => text()();
  TextColumn get type => text()();
  // settings to send
  TextColumn get thresholdRequest => text().nullable()();
  BoolColumn get needResetVolume => boolean().nullable()();
  // BLE data from sh
  IntColumn get hwVersion => integer().nullable()();
  TextColumn get fwVersion => text().nullable()();
  TextColumn get threshold => text().nullable()();
  TextColumn get uuid => text().nullable()();
  IntColumn get calibration => integer().nullable()();
  // savings configuration
  RealColumn get previousFlow => real().nullable()();
  IntColumn get refShowerDuration => integer().nullable()();

  // Inutile ?
  // DateTimeColumn get baselineStart => dateTime().nullable()();
  // DateTimeColumn get baselineStop => dateTime().nullable()();
  // IntColumn get baselineMinIndex => integer()();
  // IntColumn get baselineMaxIndex => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

extension ShowerheadExtensions on Showerhead {
  int get showersCount => lastSyncMinIndex != null && lastSyncMaxIndex != null
      ? lastSyncMaxIndex! - lastSyncMinIndex!
      : 0;

  bool hasThresholdRequest() => thresholdRequest != null;
  String? getThresholdToShow() => thresholdRequest ?? threshold;

  int getCalibration() => calibration != null && calibration! > 0
      ? calibration!
      : AppConstants.calibration;

  bool liveIsRecent() {
    if (liveDate == null) return false;
    final now = DateTime.now();
    final duration = now.difference(liveDate!);

    return duration.inSeconds.toInt() < 10;
  }

  ShowerheadsCompanion? getChangesFrom(Showerhead previous) {
    var changes = const ShowerheadsCompanion();

    void applyIfChanged<T>(
      T current,
      T previousValue,
      ShowerheadsCompanion Function(Value<T>) setter,
    ) {
      if (current != previousValue) {
        changes = setter(Value(current));
      }
    }

    applyIfChanged(name, previous.name, (v) => changes.copyWith(name: v));

    applyIfChanged(
      thresholdRequest,
      previous.thresholdRequest,
      (v) => changes.copyWith(thresholdRequest: v),
    );
    applyIfChanged(
      previousFlow,
      previous.previousFlow,
      (v) => changes.copyWith(previousFlow: v),
    );

    // learning period
    applyIfChanged(
      baselineEndIndex,
      previous.baselineEndIndex,
      (v) => changes.copyWith(baselineEndIndex: v),
    );
    applyIfChanged(
      baselineBeginIndex,
      previous.baselineBeginIndex,
      (v) => changes.copyWith(baselineBeginIndex: v),
    );
    applyIfChanged(
      baselineStatus,
      previous.baselineStatus,
      (v) => changes.copyWith(baselineStatus: v),
    );
    applyIfChanged(
      baselineBeginDate,
      previous.baselineBeginDate,
      (v) => changes.copyWith(baselineBeginDate: v),
    );
    applyIfChanged(
      refShowerDuration,
      previous.refShowerDuration,
      (v) => changes.copyWith(refShowerDuration: v),
    );

    //TODO other editable fields

    // add required fields
    return changes == const ShowerheadsCompanion()
        ? null
        : changes.copyWith(id: Value(previous.id), type: Value(previous.type));
  }
}

@CompanionMerge()
@DataClassName('Shower')
class Showers extends Table {
  IntColumn get id => integer()();
  TextColumn get deviceId => text()();
  BoolColumn get isEmpty => boolean().withDefault(
    const Constant(false),
  )(); // for shower index without data
  BoolColumn get isReference => boolean().withDefault(
    const Constant(false),
  )(); // for savings  (configured by user)
  BoolColumn get isIgnored => boolean().withDefault(
    const Constant(false),
  )(); // for average volume (configured by user)
  IntColumn get volume => integer()();
  RealColumn get temperature => real().nullable()();
  RealColumn get flow => real().nullable()();
  RealColumn get duration => real().nullable()();
  DateTimeColumn get date => dateTime()();
  IntColumn get soapingTime => integer().nullable()();
  TextColumn get threshold => text().nullable()();

  // Inutile ?
  // BoolColumn get isBaseline => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id, deviceId};
}

extension ShowerExtensions on Shower {}

@CompanionMerge()
@DataClassName('Settings')
class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();

  // ui
  TextColumn get countryCode => text().nullable()();
  IntColumn get minShowerLiter =>
      integer().withDefault(const Constant(AppConstants.minShowerLiter))();
  TextColumn get currencyCode => text().nullable()();
  TextColumn get waterUnit => text().nullable()();

  // savings
  RealColumn get waterPrice => real().nullable()();
  RealColumn get energyPrice => real().nullable()();
  RealColumn get heatingEnergy => real().nullable()();
  IntColumn get nbPeople => integer().nullable()();
  IntColumn get statsNbShowers => integer().nullable()();
}

extension SettingsExtensions on Settings {
  AppSettingsCompanion? getChangesFrom(Settings? previous) {
    var changes = const AppSettingsCompanion();

    void applyIfChanged<T>(
      T current,
      T previousValue,
      AppSettingsCompanion Function(Value<T>) setter,
    ) {
      if (current != previousValue) {
        changes = setter(Value(current));
      }
    }

    applyIfChanged(
      countryCode,
      previous?.countryCode,
      (v) => changes.copyWith(countryCode: v),
    );

    if (previous != null) {
      applyIfChanged(
        minShowerLiter,
        previous.minShowerLiter,
        (v) => changes.copyWith(minShowerLiter: v),
      );
    } else {
      changes.copyWith(minShowerLiter: Value(minShowerLiter));
    }

    applyIfChanged(
      currencyCode,
      previous?.currencyCode,
      (v) => changes.copyWith(currencyCode: v),
    );
    applyIfChanged(
      waterUnit,
      previous?.waterUnit,
      (v) => changes.copyWith(waterUnit: v),
    );
    applyIfChanged(
      waterPrice,
      previous?.waterPrice,
      (v) => changes.copyWith(waterPrice: v),
    );
    applyIfChanged(
      energyPrice,
      previous?.energyPrice,
      (v) => changes.copyWith(energyPrice: v),
    );
    applyIfChanged(
      heatingEnergy,
      previous?.heatingEnergy,
      (v) => changes.copyWith(heatingEnergy: v),
    );

    //TODO
    // nbPeople
    // statsNbShowers

    return changes == const AppSettingsCompanion()
        ? null
        : changes.copyWith(id: Value(1));
  }
}

QueryExecutor _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File('${dbFolder.path}/hydrao.sqlite'); // <-- ici
    return NativeDatabase(file);
  });
}
