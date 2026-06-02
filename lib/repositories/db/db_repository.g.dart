// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_repository.dart';

// ignore_for_file: type=lint
class $ShowerheadsTable extends Showerheads
    with TableInfo<$ShowerheadsTable, Showerhead> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShowerheadsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstSeenMeta = const VerificationMeta(
    'firstSeen',
  );
  @override
  late final GeneratedColumn<DateTime> firstSeen = GeneratedColumn<DateTime>(
    'first_seen',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSeenMeta = const VerificationMeta(
    'lastSeen',
  );
  @override
  late final GeneratedColumn<DateTime> lastSeen = GeneratedColumn<DateTime>(
    'last_seen',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastRssiMeta = const VerificationMeta(
    'lastRssi',
  );
  @override
  late final GeneratedColumn<int> lastRssi = GeneratedColumn<int>(
    'last_rssi',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isLastSyncCompleteMeta =
      const VerificationMeta('isLastSyncComplete');
  @override
  late final GeneratedColumn<bool> isLastSyncComplete = GeneratedColumn<bool>(
    'is_last_sync_complete',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_last_sync_complete" IN (0, 1))',
    ),
  );
  static const VerificationMeta _lastSyncMinIndexMeta = const VerificationMeta(
    'lastSyncMinIndex',
  );
  @override
  late final GeneratedColumn<int> lastSyncMinIndex = GeneratedColumn<int>(
    'last_sync_min_index',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSyncMaxIndexMeta = const VerificationMeta(
    'lastSyncMaxIndex',
  );
  @override
  late final GeneratedColumn<int> lastSyncMaxIndex = GeneratedColumn<int>(
    'last_sync_max_index',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSyncDateMeta = const VerificationMeta(
    'lastSyncDate',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncDate = GeneratedColumn<DateTime>(
    'last_sync_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _indexCycleCountMeta = const VerificationMeta(
    'indexCycleCount',
  );
  @override
  late final GeneratedColumn<int> indexCycleCount = GeneratedColumn<int>(
    'index_cycle_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(0),
  );
  static const VerificationMeta _baselineBeginIndexMeta =
      const VerificationMeta('baselineBeginIndex');
  @override
  late final GeneratedColumn<int> baselineBeginIndex = GeneratedColumn<int>(
    'baseline_begin_index',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _baselineEndIndexMeta = const VerificationMeta(
    'baselineEndIndex',
  );
  @override
  late final GeneratedColumn<int> baselineEndIndex = GeneratedColumn<int>(
    'baseline_end_index',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _baselineStatusMeta = const VerificationMeta(
    'baselineStatus',
  );
  @override
  late final GeneratedColumn<String> baselineStatus = GeneratedColumn<String>(
    'baseline_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _baselineBeginDateMeta = const VerificationMeta(
    'baselineBeginDate',
  );
  @override
  late final GeneratedColumn<DateTime> baselineBeginDate =
      GeneratedColumn<DateTime>(
        'baseline_begin_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _baselineEndDateMeta = const VerificationMeta(
    'baselineEndDate',
  );
  @override
  late final GeneratedColumn<DateTime> baselineEndDate =
      GeneratedColumn<DateTime>(
        'baseline_end_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _liveVolumeMeta = const VerificationMeta(
    'liveVolume',
  );
  @override
  late final GeneratedColumn<int> liveVolume = GeneratedColumn<int>(
    'live_volume',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _liveTemperatureMeta = const VerificationMeta(
    'liveTemperature',
  );
  @override
  late final GeneratedColumn<double> liveTemperature = GeneratedColumn<double>(
    'live_temperature',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _liveFlowMeta = const VerificationMeta(
    'liveFlow',
  );
  @override
  late final GeneratedColumn<double> liveFlow = GeneratedColumn<double>(
    'live_flow',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _liveDurationMeta = const VerificationMeta(
    'liveDuration',
  );
  @override
  late final GeneratedColumn<double> liveDuration = GeneratedColumn<double>(
    'live_duration',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _liveDateMeta = const VerificationMeta(
    'liveDate',
  );
  @override
  late final GeneratedColumn<DateTime> liveDate = GeneratedColumn<DateTime>(
    'live_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _thresholdRequestMeta = const VerificationMeta(
    'thresholdRequest',
  );
  @override
  late final GeneratedColumn<String> thresholdRequest = GeneratedColumn<String>(
    'threshold_request',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _needResetVolumeMeta = const VerificationMeta(
    'needResetVolume',
  );
  @override
  late final GeneratedColumn<bool> needResetVolume = GeneratedColumn<bool>(
    'need_reset_volume',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("need_reset_volume" IN (0, 1))',
    ),
  );
  static const VerificationMeta _hwVersionMeta = const VerificationMeta(
    'hwVersion',
  );
  @override
  late final GeneratedColumn<int> hwVersion = GeneratedColumn<int>(
    'hw_version',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fwVersionMeta = const VerificationMeta(
    'fwVersion',
  );
  @override
  late final GeneratedColumn<String> fwVersion = GeneratedColumn<String>(
    'fw_version',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thresholdMeta = const VerificationMeta(
    'threshold',
  );
  @override
  late final GeneratedColumn<String> threshold = GeneratedColumn<String>(
    'threshold',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _calibrationMeta = const VerificationMeta(
    'calibration',
  );
  @override
  late final GeneratedColumn<int> calibration = GeneratedColumn<int>(
    'calibration',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _previousFlowMeta = const VerificationMeta(
    'previousFlow',
  );
  @override
  late final GeneratedColumn<double> previousFlow = GeneratedColumn<double>(
    'previous_flow',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _refShowerDurationMeta = const VerificationMeta(
    'refShowerDuration',
  );
  @override
  late final GeneratedColumn<int> refShowerDuration = GeneratedColumn<int>(
    'ref_shower_duration',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    firstSeen,
    lastSeen,
    lastRssi,
    isLastSyncComplete,
    lastSyncMinIndex,
    lastSyncMaxIndex,
    lastSyncDate,
    indexCycleCount,
    baselineBeginIndex,
    baselineEndIndex,
    baselineStatus,
    baselineBeginDate,
    baselineEndDate,
    liveVolume,
    liveTemperature,
    liveFlow,
    liveDuration,
    liveDate,
    name,
    type,
    thresholdRequest,
    needResetVolume,
    hwVersion,
    fwVersion,
    threshold,
    uuid,
    calibration,
    previousFlow,
    refShowerDuration,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'showerheads';
  @override
  VerificationContext validateIntegrity(
    Insertable<Showerhead> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('first_seen')) {
      context.handle(
        _firstSeenMeta,
        firstSeen.isAcceptableOrUnknown(data['first_seen']!, _firstSeenMeta),
      );
    }
    if (data.containsKey('last_seen')) {
      context.handle(
        _lastSeenMeta,
        lastSeen.isAcceptableOrUnknown(data['last_seen']!, _lastSeenMeta),
      );
    }
    if (data.containsKey('last_rssi')) {
      context.handle(
        _lastRssiMeta,
        lastRssi.isAcceptableOrUnknown(data['last_rssi']!, _lastRssiMeta),
      );
    }
    if (data.containsKey('is_last_sync_complete')) {
      context.handle(
        _isLastSyncCompleteMeta,
        isLastSyncComplete.isAcceptableOrUnknown(
          data['is_last_sync_complete']!,
          _isLastSyncCompleteMeta,
        ),
      );
    }
    if (data.containsKey('last_sync_min_index')) {
      context.handle(
        _lastSyncMinIndexMeta,
        lastSyncMinIndex.isAcceptableOrUnknown(
          data['last_sync_min_index']!,
          _lastSyncMinIndexMeta,
        ),
      );
    }
    if (data.containsKey('last_sync_max_index')) {
      context.handle(
        _lastSyncMaxIndexMeta,
        lastSyncMaxIndex.isAcceptableOrUnknown(
          data['last_sync_max_index']!,
          _lastSyncMaxIndexMeta,
        ),
      );
    }
    if (data.containsKey('last_sync_date')) {
      context.handle(
        _lastSyncDateMeta,
        lastSyncDate.isAcceptableOrUnknown(
          data['last_sync_date']!,
          _lastSyncDateMeta,
        ),
      );
    }
    if (data.containsKey('index_cycle_count')) {
      context.handle(
        _indexCycleCountMeta,
        indexCycleCount.isAcceptableOrUnknown(
          data['index_cycle_count']!,
          _indexCycleCountMeta,
        ),
      );
    }
    if (data.containsKey('baseline_begin_index')) {
      context.handle(
        _baselineBeginIndexMeta,
        baselineBeginIndex.isAcceptableOrUnknown(
          data['baseline_begin_index']!,
          _baselineBeginIndexMeta,
        ),
      );
    }
    if (data.containsKey('baseline_end_index')) {
      context.handle(
        _baselineEndIndexMeta,
        baselineEndIndex.isAcceptableOrUnknown(
          data['baseline_end_index']!,
          _baselineEndIndexMeta,
        ),
      );
    }
    if (data.containsKey('baseline_status')) {
      context.handle(
        _baselineStatusMeta,
        baselineStatus.isAcceptableOrUnknown(
          data['baseline_status']!,
          _baselineStatusMeta,
        ),
      );
    }
    if (data.containsKey('baseline_begin_date')) {
      context.handle(
        _baselineBeginDateMeta,
        baselineBeginDate.isAcceptableOrUnknown(
          data['baseline_begin_date']!,
          _baselineBeginDateMeta,
        ),
      );
    }
    if (data.containsKey('baseline_end_date')) {
      context.handle(
        _baselineEndDateMeta,
        baselineEndDate.isAcceptableOrUnknown(
          data['baseline_end_date']!,
          _baselineEndDateMeta,
        ),
      );
    }
    if (data.containsKey('live_volume')) {
      context.handle(
        _liveVolumeMeta,
        liveVolume.isAcceptableOrUnknown(data['live_volume']!, _liveVolumeMeta),
      );
    }
    if (data.containsKey('live_temperature')) {
      context.handle(
        _liveTemperatureMeta,
        liveTemperature.isAcceptableOrUnknown(
          data['live_temperature']!,
          _liveTemperatureMeta,
        ),
      );
    }
    if (data.containsKey('live_flow')) {
      context.handle(
        _liveFlowMeta,
        liveFlow.isAcceptableOrUnknown(data['live_flow']!, _liveFlowMeta),
      );
    }
    if (data.containsKey('live_duration')) {
      context.handle(
        _liveDurationMeta,
        liveDuration.isAcceptableOrUnknown(
          data['live_duration']!,
          _liveDurationMeta,
        ),
      );
    }
    if (data.containsKey('live_date')) {
      context.handle(
        _liveDateMeta,
        liveDate.isAcceptableOrUnknown(data['live_date']!, _liveDateMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('threshold_request')) {
      context.handle(
        _thresholdRequestMeta,
        thresholdRequest.isAcceptableOrUnknown(
          data['threshold_request']!,
          _thresholdRequestMeta,
        ),
      );
    }
    if (data.containsKey('need_reset_volume')) {
      context.handle(
        _needResetVolumeMeta,
        needResetVolume.isAcceptableOrUnknown(
          data['need_reset_volume']!,
          _needResetVolumeMeta,
        ),
      );
    }
    if (data.containsKey('hw_version')) {
      context.handle(
        _hwVersionMeta,
        hwVersion.isAcceptableOrUnknown(data['hw_version']!, _hwVersionMeta),
      );
    }
    if (data.containsKey('fw_version')) {
      context.handle(
        _fwVersionMeta,
        fwVersion.isAcceptableOrUnknown(data['fw_version']!, _fwVersionMeta),
      );
    }
    if (data.containsKey('threshold')) {
      context.handle(
        _thresholdMeta,
        threshold.isAcceptableOrUnknown(data['threshold']!, _thresholdMeta),
      );
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    }
    if (data.containsKey('calibration')) {
      context.handle(
        _calibrationMeta,
        calibration.isAcceptableOrUnknown(
          data['calibration']!,
          _calibrationMeta,
        ),
      );
    }
    if (data.containsKey('previous_flow')) {
      context.handle(
        _previousFlowMeta,
        previousFlow.isAcceptableOrUnknown(
          data['previous_flow']!,
          _previousFlowMeta,
        ),
      );
    }
    if (data.containsKey('ref_shower_duration')) {
      context.handle(
        _refShowerDurationMeta,
        refShowerDuration.isAcceptableOrUnknown(
          data['ref_shower_duration']!,
          _refShowerDurationMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Showerhead map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Showerhead(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      firstSeen: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}first_seen'],
      ),
      lastSeen: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_seen'],
      ),
      lastRssi: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_rssi'],
      ),
      isLastSyncComplete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_last_sync_complete'],
      ),
      lastSyncMinIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_sync_min_index'],
      ),
      lastSyncMaxIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_sync_max_index'],
      ),
      lastSyncDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_date'],
      ),
      indexCycleCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}index_cycle_count'],
      )!,
      baselineBeginIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}baseline_begin_index'],
      ),
      baselineEndIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}baseline_end_index'],
      ),
      baselineStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}baseline_status'],
      ),
      baselineBeginDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}baseline_begin_date'],
      ),
      baselineEndDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}baseline_end_date'],
      ),
      liveVolume: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}live_volume'],
      ),
      liveTemperature: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}live_temperature'],
      ),
      liveFlow: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}live_flow'],
      ),
      liveDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}live_duration'],
      ),
      liveDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}live_date'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      thresholdRequest: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}threshold_request'],
      ),
      needResetVolume: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}need_reset_volume'],
      ),
      hwVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hw_version'],
      ),
      fwVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fw_version'],
      ),
      threshold: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}threshold'],
      ),
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      ),
      calibration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calibration'],
      ),
      previousFlow: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}previous_flow'],
      ),
      refShowerDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ref_shower_duration'],
      ),
    );
  }

  @override
  $ShowerheadsTable createAlias(String alias) {
    return $ShowerheadsTable(attachedDatabase, alias);
  }
}

class Showerhead extends DataClass implements Insertable<Showerhead> {
  final String id;
  final DateTime? firstSeen;
  final DateTime? lastSeen;
  final int? lastRssi;
  final bool? isLastSyncComplete;
  final int? lastSyncMinIndex;
  final int? lastSyncMaxIndex;
  final DateTime? lastSyncDate;
  final int indexCycleCount;
  final int? baselineBeginIndex;
  final int? baselineEndIndex;
  final String? baselineStatus;
  final DateTime? baselineBeginDate;
  final DateTime? baselineEndDate;
  final int? liveVolume;
  final double? liveTemperature;
  final double? liveFlow;
  final double? liveDuration;
  final DateTime? liveDate;
  final String name;
  final String type;
  final String? thresholdRequest;
  final bool? needResetVolume;
  final int? hwVersion;
  final String? fwVersion;
  final String? threshold;
  final String? uuid;
  final int? calibration;
  final double? previousFlow;
  final int? refShowerDuration;
  const Showerhead({
    required this.id,
    this.firstSeen,
    this.lastSeen,
    this.lastRssi,
    this.isLastSyncComplete,
    this.lastSyncMinIndex,
    this.lastSyncMaxIndex,
    this.lastSyncDate,
    required this.indexCycleCount,
    this.baselineBeginIndex,
    this.baselineEndIndex,
    this.baselineStatus,
    this.baselineBeginDate,
    this.baselineEndDate,
    this.liveVolume,
    this.liveTemperature,
    this.liveFlow,
    this.liveDuration,
    this.liveDate,
    required this.name,
    required this.type,
    this.thresholdRequest,
    this.needResetVolume,
    this.hwVersion,
    this.fwVersion,
    this.threshold,
    this.uuid,
    this.calibration,
    this.previousFlow,
    this.refShowerDuration,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || firstSeen != null) {
      map['first_seen'] = Variable<DateTime>(firstSeen);
    }
    if (!nullToAbsent || lastSeen != null) {
      map['last_seen'] = Variable<DateTime>(lastSeen);
    }
    if (!nullToAbsent || lastRssi != null) {
      map['last_rssi'] = Variable<int>(lastRssi);
    }
    if (!nullToAbsent || isLastSyncComplete != null) {
      map['is_last_sync_complete'] = Variable<bool>(isLastSyncComplete);
    }
    if (!nullToAbsent || lastSyncMinIndex != null) {
      map['last_sync_min_index'] = Variable<int>(lastSyncMinIndex);
    }
    if (!nullToAbsent || lastSyncMaxIndex != null) {
      map['last_sync_max_index'] = Variable<int>(lastSyncMaxIndex);
    }
    if (!nullToAbsent || lastSyncDate != null) {
      map['last_sync_date'] = Variable<DateTime>(lastSyncDate);
    }
    map['index_cycle_count'] = Variable<int>(indexCycleCount);
    if (!nullToAbsent || baselineBeginIndex != null) {
      map['baseline_begin_index'] = Variable<int>(baselineBeginIndex);
    }
    if (!nullToAbsent || baselineEndIndex != null) {
      map['baseline_end_index'] = Variable<int>(baselineEndIndex);
    }
    if (!nullToAbsent || baselineStatus != null) {
      map['baseline_status'] = Variable<String>(baselineStatus);
    }
    if (!nullToAbsent || baselineBeginDate != null) {
      map['baseline_begin_date'] = Variable<DateTime>(baselineBeginDate);
    }
    if (!nullToAbsent || baselineEndDate != null) {
      map['baseline_end_date'] = Variable<DateTime>(baselineEndDate);
    }
    if (!nullToAbsent || liveVolume != null) {
      map['live_volume'] = Variable<int>(liveVolume);
    }
    if (!nullToAbsent || liveTemperature != null) {
      map['live_temperature'] = Variable<double>(liveTemperature);
    }
    if (!nullToAbsent || liveFlow != null) {
      map['live_flow'] = Variable<double>(liveFlow);
    }
    if (!nullToAbsent || liveDuration != null) {
      map['live_duration'] = Variable<double>(liveDuration);
    }
    if (!nullToAbsent || liveDate != null) {
      map['live_date'] = Variable<DateTime>(liveDate);
    }
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || thresholdRequest != null) {
      map['threshold_request'] = Variable<String>(thresholdRequest);
    }
    if (!nullToAbsent || needResetVolume != null) {
      map['need_reset_volume'] = Variable<bool>(needResetVolume);
    }
    if (!nullToAbsent || hwVersion != null) {
      map['hw_version'] = Variable<int>(hwVersion);
    }
    if (!nullToAbsent || fwVersion != null) {
      map['fw_version'] = Variable<String>(fwVersion);
    }
    if (!nullToAbsent || threshold != null) {
      map['threshold'] = Variable<String>(threshold);
    }
    if (!nullToAbsent || uuid != null) {
      map['uuid'] = Variable<String>(uuid);
    }
    if (!nullToAbsent || calibration != null) {
      map['calibration'] = Variable<int>(calibration);
    }
    if (!nullToAbsent || previousFlow != null) {
      map['previous_flow'] = Variable<double>(previousFlow);
    }
    if (!nullToAbsent || refShowerDuration != null) {
      map['ref_shower_duration'] = Variable<int>(refShowerDuration);
    }
    return map;
  }

  ShowerheadsCompanion toCompanion(bool nullToAbsent) {
    return ShowerheadsCompanion(
      id: Value(id),
      firstSeen: firstSeen == null && nullToAbsent
          ? const Value.absent()
          : Value(firstSeen),
      lastSeen: lastSeen == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSeen),
      lastRssi: lastRssi == null && nullToAbsent
          ? const Value.absent()
          : Value(lastRssi),
      isLastSyncComplete: isLastSyncComplete == null && nullToAbsent
          ? const Value.absent()
          : Value(isLastSyncComplete),
      lastSyncMinIndex: lastSyncMinIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncMinIndex),
      lastSyncMaxIndex: lastSyncMaxIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncMaxIndex),
      lastSyncDate: lastSyncDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncDate),
      indexCycleCount: Value(indexCycleCount),
      baselineBeginIndex: baselineBeginIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(baselineBeginIndex),
      baselineEndIndex: baselineEndIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(baselineEndIndex),
      baselineStatus: baselineStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(baselineStatus),
      baselineBeginDate: baselineBeginDate == null && nullToAbsent
          ? const Value.absent()
          : Value(baselineBeginDate),
      baselineEndDate: baselineEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(baselineEndDate),
      liveVolume: liveVolume == null && nullToAbsent
          ? const Value.absent()
          : Value(liveVolume),
      liveTemperature: liveTemperature == null && nullToAbsent
          ? const Value.absent()
          : Value(liveTemperature),
      liveFlow: liveFlow == null && nullToAbsent
          ? const Value.absent()
          : Value(liveFlow),
      liveDuration: liveDuration == null && nullToAbsent
          ? const Value.absent()
          : Value(liveDuration),
      liveDate: liveDate == null && nullToAbsent
          ? const Value.absent()
          : Value(liveDate),
      name: Value(name),
      type: Value(type),
      thresholdRequest: thresholdRequest == null && nullToAbsent
          ? const Value.absent()
          : Value(thresholdRequest),
      needResetVolume: needResetVolume == null && nullToAbsent
          ? const Value.absent()
          : Value(needResetVolume),
      hwVersion: hwVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(hwVersion),
      fwVersion: fwVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(fwVersion),
      threshold: threshold == null && nullToAbsent
          ? const Value.absent()
          : Value(threshold),
      uuid: uuid == null && nullToAbsent ? const Value.absent() : Value(uuid),
      calibration: calibration == null && nullToAbsent
          ? const Value.absent()
          : Value(calibration),
      previousFlow: previousFlow == null && nullToAbsent
          ? const Value.absent()
          : Value(previousFlow),
      refShowerDuration: refShowerDuration == null && nullToAbsent
          ? const Value.absent()
          : Value(refShowerDuration),
    );
  }

  factory Showerhead.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Showerhead(
      id: serializer.fromJson<String>(json['id']),
      firstSeen: serializer.fromJson<DateTime?>(json['firstSeen']),
      lastSeen: serializer.fromJson<DateTime?>(json['lastSeen']),
      lastRssi: serializer.fromJson<int?>(json['lastRssi']),
      isLastSyncComplete: serializer.fromJson<bool?>(
        json['isLastSyncComplete'],
      ),
      lastSyncMinIndex: serializer.fromJson<int?>(json['lastSyncMinIndex']),
      lastSyncMaxIndex: serializer.fromJson<int?>(json['lastSyncMaxIndex']),
      lastSyncDate: serializer.fromJson<DateTime?>(json['lastSyncDate']),
      indexCycleCount: serializer.fromJson<int>(json['indexCycleCount']),
      baselineBeginIndex: serializer.fromJson<int?>(json['baselineBeginIndex']),
      baselineEndIndex: serializer.fromJson<int?>(json['baselineEndIndex']),
      baselineStatus: serializer.fromJson<String?>(json['baselineStatus']),
      baselineBeginDate: serializer.fromJson<DateTime?>(
        json['baselineBeginDate'],
      ),
      baselineEndDate: serializer.fromJson<DateTime?>(json['baselineEndDate']),
      liveVolume: serializer.fromJson<int?>(json['liveVolume']),
      liveTemperature: serializer.fromJson<double?>(json['liveTemperature']),
      liveFlow: serializer.fromJson<double?>(json['liveFlow']),
      liveDuration: serializer.fromJson<double?>(json['liveDuration']),
      liveDate: serializer.fromJson<DateTime?>(json['liveDate']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      thresholdRequest: serializer.fromJson<String?>(json['thresholdRequest']),
      needResetVolume: serializer.fromJson<bool?>(json['needResetVolume']),
      hwVersion: serializer.fromJson<int?>(json['hwVersion']),
      fwVersion: serializer.fromJson<String?>(json['fwVersion']),
      threshold: serializer.fromJson<String?>(json['threshold']),
      uuid: serializer.fromJson<String?>(json['uuid']),
      calibration: serializer.fromJson<int?>(json['calibration']),
      previousFlow: serializer.fromJson<double?>(json['previousFlow']),
      refShowerDuration: serializer.fromJson<int?>(json['refShowerDuration']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'firstSeen': serializer.toJson<DateTime?>(firstSeen),
      'lastSeen': serializer.toJson<DateTime?>(lastSeen),
      'lastRssi': serializer.toJson<int?>(lastRssi),
      'isLastSyncComplete': serializer.toJson<bool?>(isLastSyncComplete),
      'lastSyncMinIndex': serializer.toJson<int?>(lastSyncMinIndex),
      'lastSyncMaxIndex': serializer.toJson<int?>(lastSyncMaxIndex),
      'lastSyncDate': serializer.toJson<DateTime?>(lastSyncDate),
      'indexCycleCount': serializer.toJson<int>(indexCycleCount),
      'baselineBeginIndex': serializer.toJson<int?>(baselineBeginIndex),
      'baselineEndIndex': serializer.toJson<int?>(baselineEndIndex),
      'baselineStatus': serializer.toJson<String?>(baselineStatus),
      'baselineBeginDate': serializer.toJson<DateTime?>(baselineBeginDate),
      'baselineEndDate': serializer.toJson<DateTime?>(baselineEndDate),
      'liveVolume': serializer.toJson<int?>(liveVolume),
      'liveTemperature': serializer.toJson<double?>(liveTemperature),
      'liveFlow': serializer.toJson<double?>(liveFlow),
      'liveDuration': serializer.toJson<double?>(liveDuration),
      'liveDate': serializer.toJson<DateTime?>(liveDate),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'thresholdRequest': serializer.toJson<String?>(thresholdRequest),
      'needResetVolume': serializer.toJson<bool?>(needResetVolume),
      'hwVersion': serializer.toJson<int?>(hwVersion),
      'fwVersion': serializer.toJson<String?>(fwVersion),
      'threshold': serializer.toJson<String?>(threshold),
      'uuid': serializer.toJson<String?>(uuid),
      'calibration': serializer.toJson<int?>(calibration),
      'previousFlow': serializer.toJson<double?>(previousFlow),
      'refShowerDuration': serializer.toJson<int?>(refShowerDuration),
    };
  }

  Showerhead copyWith({
    String? id,
    Value<DateTime?> firstSeen = const Value.absent(),
    Value<DateTime?> lastSeen = const Value.absent(),
    Value<int?> lastRssi = const Value.absent(),
    Value<bool?> isLastSyncComplete = const Value.absent(),
    Value<int?> lastSyncMinIndex = const Value.absent(),
    Value<int?> lastSyncMaxIndex = const Value.absent(),
    Value<DateTime?> lastSyncDate = const Value.absent(),
    int? indexCycleCount,
    Value<int?> baselineBeginIndex = const Value.absent(),
    Value<int?> baselineEndIndex = const Value.absent(),
    Value<String?> baselineStatus = const Value.absent(),
    Value<DateTime?> baselineBeginDate = const Value.absent(),
    Value<DateTime?> baselineEndDate = const Value.absent(),
    Value<int?> liveVolume = const Value.absent(),
    Value<double?> liveTemperature = const Value.absent(),
    Value<double?> liveFlow = const Value.absent(),
    Value<double?> liveDuration = const Value.absent(),
    Value<DateTime?> liveDate = const Value.absent(),
    String? name,
    String? type,
    Value<String?> thresholdRequest = const Value.absent(),
    Value<bool?> needResetVolume = const Value.absent(),
    Value<int?> hwVersion = const Value.absent(),
    Value<String?> fwVersion = const Value.absent(),
    Value<String?> threshold = const Value.absent(),
    Value<String?> uuid = const Value.absent(),
    Value<int?> calibration = const Value.absent(),
    Value<double?> previousFlow = const Value.absent(),
    Value<int?> refShowerDuration = const Value.absent(),
  }) => Showerhead(
    id: id ?? this.id,
    firstSeen: firstSeen.present ? firstSeen.value : this.firstSeen,
    lastSeen: lastSeen.present ? lastSeen.value : this.lastSeen,
    lastRssi: lastRssi.present ? lastRssi.value : this.lastRssi,
    isLastSyncComplete: isLastSyncComplete.present
        ? isLastSyncComplete.value
        : this.isLastSyncComplete,
    lastSyncMinIndex: lastSyncMinIndex.present
        ? lastSyncMinIndex.value
        : this.lastSyncMinIndex,
    lastSyncMaxIndex: lastSyncMaxIndex.present
        ? lastSyncMaxIndex.value
        : this.lastSyncMaxIndex,
    lastSyncDate: lastSyncDate.present ? lastSyncDate.value : this.lastSyncDate,
    indexCycleCount: indexCycleCount ?? this.indexCycleCount,
    baselineBeginIndex: baselineBeginIndex.present
        ? baselineBeginIndex.value
        : this.baselineBeginIndex,
    baselineEndIndex: baselineEndIndex.present
        ? baselineEndIndex.value
        : this.baselineEndIndex,
    baselineStatus: baselineStatus.present
        ? baselineStatus.value
        : this.baselineStatus,
    baselineBeginDate: baselineBeginDate.present
        ? baselineBeginDate.value
        : this.baselineBeginDate,
    baselineEndDate: baselineEndDate.present
        ? baselineEndDate.value
        : this.baselineEndDate,
    liveVolume: liveVolume.present ? liveVolume.value : this.liveVolume,
    liveTemperature: liveTemperature.present
        ? liveTemperature.value
        : this.liveTemperature,
    liveFlow: liveFlow.present ? liveFlow.value : this.liveFlow,
    liveDuration: liveDuration.present ? liveDuration.value : this.liveDuration,
    liveDate: liveDate.present ? liveDate.value : this.liveDate,
    name: name ?? this.name,
    type: type ?? this.type,
    thresholdRequest: thresholdRequest.present
        ? thresholdRequest.value
        : this.thresholdRequest,
    needResetVolume: needResetVolume.present
        ? needResetVolume.value
        : this.needResetVolume,
    hwVersion: hwVersion.present ? hwVersion.value : this.hwVersion,
    fwVersion: fwVersion.present ? fwVersion.value : this.fwVersion,
    threshold: threshold.present ? threshold.value : this.threshold,
    uuid: uuid.present ? uuid.value : this.uuid,
    calibration: calibration.present ? calibration.value : this.calibration,
    previousFlow: previousFlow.present ? previousFlow.value : this.previousFlow,
    refShowerDuration: refShowerDuration.present
        ? refShowerDuration.value
        : this.refShowerDuration,
  );
  Showerhead copyWithCompanion(ShowerheadsCompanion data) {
    return Showerhead(
      id: data.id.present ? data.id.value : this.id,
      firstSeen: data.firstSeen.present ? data.firstSeen.value : this.firstSeen,
      lastSeen: data.lastSeen.present ? data.lastSeen.value : this.lastSeen,
      lastRssi: data.lastRssi.present ? data.lastRssi.value : this.lastRssi,
      isLastSyncComplete: data.isLastSyncComplete.present
          ? data.isLastSyncComplete.value
          : this.isLastSyncComplete,
      lastSyncMinIndex: data.lastSyncMinIndex.present
          ? data.lastSyncMinIndex.value
          : this.lastSyncMinIndex,
      lastSyncMaxIndex: data.lastSyncMaxIndex.present
          ? data.lastSyncMaxIndex.value
          : this.lastSyncMaxIndex,
      lastSyncDate: data.lastSyncDate.present
          ? data.lastSyncDate.value
          : this.lastSyncDate,
      indexCycleCount: data.indexCycleCount.present
          ? data.indexCycleCount.value
          : this.indexCycleCount,
      baselineBeginIndex: data.baselineBeginIndex.present
          ? data.baselineBeginIndex.value
          : this.baselineBeginIndex,
      baselineEndIndex: data.baselineEndIndex.present
          ? data.baselineEndIndex.value
          : this.baselineEndIndex,
      baselineStatus: data.baselineStatus.present
          ? data.baselineStatus.value
          : this.baselineStatus,
      baselineBeginDate: data.baselineBeginDate.present
          ? data.baselineBeginDate.value
          : this.baselineBeginDate,
      baselineEndDate: data.baselineEndDate.present
          ? data.baselineEndDate.value
          : this.baselineEndDate,
      liveVolume: data.liveVolume.present
          ? data.liveVolume.value
          : this.liveVolume,
      liveTemperature: data.liveTemperature.present
          ? data.liveTemperature.value
          : this.liveTemperature,
      liveFlow: data.liveFlow.present ? data.liveFlow.value : this.liveFlow,
      liveDuration: data.liveDuration.present
          ? data.liveDuration.value
          : this.liveDuration,
      liveDate: data.liveDate.present ? data.liveDate.value : this.liveDate,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      thresholdRequest: data.thresholdRequest.present
          ? data.thresholdRequest.value
          : this.thresholdRequest,
      needResetVolume: data.needResetVolume.present
          ? data.needResetVolume.value
          : this.needResetVolume,
      hwVersion: data.hwVersion.present ? data.hwVersion.value : this.hwVersion,
      fwVersion: data.fwVersion.present ? data.fwVersion.value : this.fwVersion,
      threshold: data.threshold.present ? data.threshold.value : this.threshold,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      calibration: data.calibration.present
          ? data.calibration.value
          : this.calibration,
      previousFlow: data.previousFlow.present
          ? data.previousFlow.value
          : this.previousFlow,
      refShowerDuration: data.refShowerDuration.present
          ? data.refShowerDuration.value
          : this.refShowerDuration,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Showerhead(')
          ..write('id: $id, ')
          ..write('firstSeen: $firstSeen, ')
          ..write('lastSeen: $lastSeen, ')
          ..write('lastRssi: $lastRssi, ')
          ..write('isLastSyncComplete: $isLastSyncComplete, ')
          ..write('lastSyncMinIndex: $lastSyncMinIndex, ')
          ..write('lastSyncMaxIndex: $lastSyncMaxIndex, ')
          ..write('lastSyncDate: $lastSyncDate, ')
          ..write('indexCycleCount: $indexCycleCount, ')
          ..write('baselineBeginIndex: $baselineBeginIndex, ')
          ..write('baselineEndIndex: $baselineEndIndex, ')
          ..write('baselineStatus: $baselineStatus, ')
          ..write('baselineBeginDate: $baselineBeginDate, ')
          ..write('baselineEndDate: $baselineEndDate, ')
          ..write('liveVolume: $liveVolume, ')
          ..write('liveTemperature: $liveTemperature, ')
          ..write('liveFlow: $liveFlow, ')
          ..write('liveDuration: $liveDuration, ')
          ..write('liveDate: $liveDate, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('thresholdRequest: $thresholdRequest, ')
          ..write('needResetVolume: $needResetVolume, ')
          ..write('hwVersion: $hwVersion, ')
          ..write('fwVersion: $fwVersion, ')
          ..write('threshold: $threshold, ')
          ..write('uuid: $uuid, ')
          ..write('calibration: $calibration, ')
          ..write('previousFlow: $previousFlow, ')
          ..write('refShowerDuration: $refShowerDuration')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    firstSeen,
    lastSeen,
    lastRssi,
    isLastSyncComplete,
    lastSyncMinIndex,
    lastSyncMaxIndex,
    lastSyncDate,
    indexCycleCount,
    baselineBeginIndex,
    baselineEndIndex,
    baselineStatus,
    baselineBeginDate,
    baselineEndDate,
    liveVolume,
    liveTemperature,
    liveFlow,
    liveDuration,
    liveDate,
    name,
    type,
    thresholdRequest,
    needResetVolume,
    hwVersion,
    fwVersion,
    threshold,
    uuid,
    calibration,
    previousFlow,
    refShowerDuration,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Showerhead &&
          other.id == this.id &&
          other.firstSeen == this.firstSeen &&
          other.lastSeen == this.lastSeen &&
          other.lastRssi == this.lastRssi &&
          other.isLastSyncComplete == this.isLastSyncComplete &&
          other.lastSyncMinIndex == this.lastSyncMinIndex &&
          other.lastSyncMaxIndex == this.lastSyncMaxIndex &&
          other.lastSyncDate == this.lastSyncDate &&
          other.indexCycleCount == this.indexCycleCount &&
          other.baselineBeginIndex == this.baselineBeginIndex &&
          other.baselineEndIndex == this.baselineEndIndex &&
          other.baselineStatus == this.baselineStatus &&
          other.baselineBeginDate == this.baselineBeginDate &&
          other.baselineEndDate == this.baselineEndDate &&
          other.liveVolume == this.liveVolume &&
          other.liveTemperature == this.liveTemperature &&
          other.liveFlow == this.liveFlow &&
          other.liveDuration == this.liveDuration &&
          other.liveDate == this.liveDate &&
          other.name == this.name &&
          other.type == this.type &&
          other.thresholdRequest == this.thresholdRequest &&
          other.needResetVolume == this.needResetVolume &&
          other.hwVersion == this.hwVersion &&
          other.fwVersion == this.fwVersion &&
          other.threshold == this.threshold &&
          other.uuid == this.uuid &&
          other.calibration == this.calibration &&
          other.previousFlow == this.previousFlow &&
          other.refShowerDuration == this.refShowerDuration);
}

class ShowerheadsCompanion extends UpdateCompanion<Showerhead> {
  final Value<String> id;
  final Value<DateTime?> firstSeen;
  final Value<DateTime?> lastSeen;
  final Value<int?> lastRssi;
  final Value<bool?> isLastSyncComplete;
  final Value<int?> lastSyncMinIndex;
  final Value<int?> lastSyncMaxIndex;
  final Value<DateTime?> lastSyncDate;
  final Value<int> indexCycleCount;
  final Value<int?> baselineBeginIndex;
  final Value<int?> baselineEndIndex;
  final Value<String?> baselineStatus;
  final Value<DateTime?> baselineBeginDate;
  final Value<DateTime?> baselineEndDate;
  final Value<int?> liveVolume;
  final Value<double?> liveTemperature;
  final Value<double?> liveFlow;
  final Value<double?> liveDuration;
  final Value<DateTime?> liveDate;
  final Value<String> name;
  final Value<String> type;
  final Value<String?> thresholdRequest;
  final Value<bool?> needResetVolume;
  final Value<int?> hwVersion;
  final Value<String?> fwVersion;
  final Value<String?> threshold;
  final Value<String?> uuid;
  final Value<int?> calibration;
  final Value<double?> previousFlow;
  final Value<int?> refShowerDuration;
  final Value<int> rowid;
  const ShowerheadsCompanion({
    this.id = const Value.absent(),
    this.firstSeen = const Value.absent(),
    this.lastSeen = const Value.absent(),
    this.lastRssi = const Value.absent(),
    this.isLastSyncComplete = const Value.absent(),
    this.lastSyncMinIndex = const Value.absent(),
    this.lastSyncMaxIndex = const Value.absent(),
    this.lastSyncDate = const Value.absent(),
    this.indexCycleCount = const Value.absent(),
    this.baselineBeginIndex = const Value.absent(),
    this.baselineEndIndex = const Value.absent(),
    this.baselineStatus = const Value.absent(),
    this.baselineBeginDate = const Value.absent(),
    this.baselineEndDate = const Value.absent(),
    this.liveVolume = const Value.absent(),
    this.liveTemperature = const Value.absent(),
    this.liveFlow = const Value.absent(),
    this.liveDuration = const Value.absent(),
    this.liveDate = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.thresholdRequest = const Value.absent(),
    this.needResetVolume = const Value.absent(),
    this.hwVersion = const Value.absent(),
    this.fwVersion = const Value.absent(),
    this.threshold = const Value.absent(),
    this.uuid = const Value.absent(),
    this.calibration = const Value.absent(),
    this.previousFlow = const Value.absent(),
    this.refShowerDuration = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShowerheadsCompanion.insert({
    required String id,
    this.firstSeen = const Value.absent(),
    this.lastSeen = const Value.absent(),
    this.lastRssi = const Value.absent(),
    this.isLastSyncComplete = const Value.absent(),
    this.lastSyncMinIndex = const Value.absent(),
    this.lastSyncMaxIndex = const Value.absent(),
    this.lastSyncDate = const Value.absent(),
    this.indexCycleCount = const Value.absent(),
    this.baselineBeginIndex = const Value.absent(),
    this.baselineEndIndex = const Value.absent(),
    this.baselineStatus = const Value.absent(),
    this.baselineBeginDate = const Value.absent(),
    this.baselineEndDate = const Value.absent(),
    this.liveVolume = const Value.absent(),
    this.liveTemperature = const Value.absent(),
    this.liveFlow = const Value.absent(),
    this.liveDuration = const Value.absent(),
    this.liveDate = const Value.absent(),
    required String name,
    required String type,
    this.thresholdRequest = const Value.absent(),
    this.needResetVolume = const Value.absent(),
    this.hwVersion = const Value.absent(),
    this.fwVersion = const Value.absent(),
    this.threshold = const Value.absent(),
    this.uuid = const Value.absent(),
    this.calibration = const Value.absent(),
    this.previousFlow = const Value.absent(),
    this.refShowerDuration = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       type = Value(type);
  static Insertable<Showerhead> custom({
    Expression<String>? id,
    Expression<DateTime>? firstSeen,
    Expression<DateTime>? lastSeen,
    Expression<int>? lastRssi,
    Expression<bool>? isLastSyncComplete,
    Expression<int>? lastSyncMinIndex,
    Expression<int>? lastSyncMaxIndex,
    Expression<DateTime>? lastSyncDate,
    Expression<int>? indexCycleCount,
    Expression<int>? baselineBeginIndex,
    Expression<int>? baselineEndIndex,
    Expression<String>? baselineStatus,
    Expression<DateTime>? baselineBeginDate,
    Expression<DateTime>? baselineEndDate,
    Expression<int>? liveVolume,
    Expression<double>? liveTemperature,
    Expression<double>? liveFlow,
    Expression<double>? liveDuration,
    Expression<DateTime>? liveDate,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? thresholdRequest,
    Expression<bool>? needResetVolume,
    Expression<int>? hwVersion,
    Expression<String>? fwVersion,
    Expression<String>? threshold,
    Expression<String>? uuid,
    Expression<int>? calibration,
    Expression<double>? previousFlow,
    Expression<int>? refShowerDuration,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstSeen != null) 'first_seen': firstSeen,
      if (lastSeen != null) 'last_seen': lastSeen,
      if (lastRssi != null) 'last_rssi': lastRssi,
      if (isLastSyncComplete != null)
        'is_last_sync_complete': isLastSyncComplete,
      if (lastSyncMinIndex != null) 'last_sync_min_index': lastSyncMinIndex,
      if (lastSyncMaxIndex != null) 'last_sync_max_index': lastSyncMaxIndex,
      if (lastSyncDate != null) 'last_sync_date': lastSyncDate,
      if (indexCycleCount != null) 'index_cycle_count': indexCycleCount,
      if (baselineBeginIndex != null)
        'baseline_begin_index': baselineBeginIndex,
      if (baselineEndIndex != null) 'baseline_end_index': baselineEndIndex,
      if (baselineStatus != null) 'baseline_status': baselineStatus,
      if (baselineBeginDate != null) 'baseline_begin_date': baselineBeginDate,
      if (baselineEndDate != null) 'baseline_end_date': baselineEndDate,
      if (liveVolume != null) 'live_volume': liveVolume,
      if (liveTemperature != null) 'live_temperature': liveTemperature,
      if (liveFlow != null) 'live_flow': liveFlow,
      if (liveDuration != null) 'live_duration': liveDuration,
      if (liveDate != null) 'live_date': liveDate,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (thresholdRequest != null) 'threshold_request': thresholdRequest,
      if (needResetVolume != null) 'need_reset_volume': needResetVolume,
      if (hwVersion != null) 'hw_version': hwVersion,
      if (fwVersion != null) 'fw_version': fwVersion,
      if (threshold != null) 'threshold': threshold,
      if (uuid != null) 'uuid': uuid,
      if (calibration != null) 'calibration': calibration,
      if (previousFlow != null) 'previous_flow': previousFlow,
      if (refShowerDuration != null) 'ref_shower_duration': refShowerDuration,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShowerheadsCompanion copyWith({
    Value<String>? id,
    Value<DateTime?>? firstSeen,
    Value<DateTime?>? lastSeen,
    Value<int?>? lastRssi,
    Value<bool?>? isLastSyncComplete,
    Value<int?>? lastSyncMinIndex,
    Value<int?>? lastSyncMaxIndex,
    Value<DateTime?>? lastSyncDate,
    Value<int>? indexCycleCount,
    Value<int?>? baselineBeginIndex,
    Value<int?>? baselineEndIndex,
    Value<String?>? baselineStatus,
    Value<DateTime?>? baselineBeginDate,
    Value<DateTime?>? baselineEndDate,
    Value<int?>? liveVolume,
    Value<double?>? liveTemperature,
    Value<double?>? liveFlow,
    Value<double?>? liveDuration,
    Value<DateTime?>? liveDate,
    Value<String>? name,
    Value<String>? type,
    Value<String?>? thresholdRequest,
    Value<bool?>? needResetVolume,
    Value<int?>? hwVersion,
    Value<String?>? fwVersion,
    Value<String?>? threshold,
    Value<String?>? uuid,
    Value<int?>? calibration,
    Value<double?>? previousFlow,
    Value<int?>? refShowerDuration,
    Value<int>? rowid,
  }) {
    return ShowerheadsCompanion(
      id: id ?? this.id,
      firstSeen: firstSeen ?? this.firstSeen,
      lastSeen: lastSeen ?? this.lastSeen,
      lastRssi: lastRssi ?? this.lastRssi,
      isLastSyncComplete: isLastSyncComplete ?? this.isLastSyncComplete,
      lastSyncMinIndex: lastSyncMinIndex ?? this.lastSyncMinIndex,
      lastSyncMaxIndex: lastSyncMaxIndex ?? this.lastSyncMaxIndex,
      lastSyncDate: lastSyncDate ?? this.lastSyncDate,
      indexCycleCount: indexCycleCount ?? this.indexCycleCount,
      baselineBeginIndex: baselineBeginIndex ?? this.baselineBeginIndex,
      baselineEndIndex: baselineEndIndex ?? this.baselineEndIndex,
      baselineStatus: baselineStatus ?? this.baselineStatus,
      baselineBeginDate: baselineBeginDate ?? this.baselineBeginDate,
      baselineEndDate: baselineEndDate ?? this.baselineEndDate,
      liveVolume: liveVolume ?? this.liveVolume,
      liveTemperature: liveTemperature ?? this.liveTemperature,
      liveFlow: liveFlow ?? this.liveFlow,
      liveDuration: liveDuration ?? this.liveDuration,
      liveDate: liveDate ?? this.liveDate,
      name: name ?? this.name,
      type: type ?? this.type,
      thresholdRequest: thresholdRequest ?? this.thresholdRequest,
      needResetVolume: needResetVolume ?? this.needResetVolume,
      hwVersion: hwVersion ?? this.hwVersion,
      fwVersion: fwVersion ?? this.fwVersion,
      threshold: threshold ?? this.threshold,
      uuid: uuid ?? this.uuid,
      calibration: calibration ?? this.calibration,
      previousFlow: previousFlow ?? this.previousFlow,
      refShowerDuration: refShowerDuration ?? this.refShowerDuration,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (firstSeen.present) {
      map['first_seen'] = Variable<DateTime>(firstSeen.value);
    }
    if (lastSeen.present) {
      map['last_seen'] = Variable<DateTime>(lastSeen.value);
    }
    if (lastRssi.present) {
      map['last_rssi'] = Variable<int>(lastRssi.value);
    }
    if (isLastSyncComplete.present) {
      map['is_last_sync_complete'] = Variable<bool>(isLastSyncComplete.value);
    }
    if (lastSyncMinIndex.present) {
      map['last_sync_min_index'] = Variable<int>(lastSyncMinIndex.value);
    }
    if (lastSyncMaxIndex.present) {
      map['last_sync_max_index'] = Variable<int>(lastSyncMaxIndex.value);
    }
    if (lastSyncDate.present) {
      map['last_sync_date'] = Variable<DateTime>(lastSyncDate.value);
    }
    if (indexCycleCount.present) {
      map['index_cycle_count'] = Variable<int>(indexCycleCount.value);
    }
    if (baselineBeginIndex.present) {
      map['baseline_begin_index'] = Variable<int>(baselineBeginIndex.value);
    }
    if (baselineEndIndex.present) {
      map['baseline_end_index'] = Variable<int>(baselineEndIndex.value);
    }
    if (baselineStatus.present) {
      map['baseline_status'] = Variable<String>(baselineStatus.value);
    }
    if (baselineBeginDate.present) {
      map['baseline_begin_date'] = Variable<DateTime>(baselineBeginDate.value);
    }
    if (baselineEndDate.present) {
      map['baseline_end_date'] = Variable<DateTime>(baselineEndDate.value);
    }
    if (liveVolume.present) {
      map['live_volume'] = Variable<int>(liveVolume.value);
    }
    if (liveTemperature.present) {
      map['live_temperature'] = Variable<double>(liveTemperature.value);
    }
    if (liveFlow.present) {
      map['live_flow'] = Variable<double>(liveFlow.value);
    }
    if (liveDuration.present) {
      map['live_duration'] = Variable<double>(liveDuration.value);
    }
    if (liveDate.present) {
      map['live_date'] = Variable<DateTime>(liveDate.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (thresholdRequest.present) {
      map['threshold_request'] = Variable<String>(thresholdRequest.value);
    }
    if (needResetVolume.present) {
      map['need_reset_volume'] = Variable<bool>(needResetVolume.value);
    }
    if (hwVersion.present) {
      map['hw_version'] = Variable<int>(hwVersion.value);
    }
    if (fwVersion.present) {
      map['fw_version'] = Variable<String>(fwVersion.value);
    }
    if (threshold.present) {
      map['threshold'] = Variable<String>(threshold.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (calibration.present) {
      map['calibration'] = Variable<int>(calibration.value);
    }
    if (previousFlow.present) {
      map['previous_flow'] = Variable<double>(previousFlow.value);
    }
    if (refShowerDuration.present) {
      map['ref_shower_duration'] = Variable<int>(refShowerDuration.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShowerheadsCompanion(')
          ..write('id: $id, ')
          ..write('firstSeen: $firstSeen, ')
          ..write('lastSeen: $lastSeen, ')
          ..write('lastRssi: $lastRssi, ')
          ..write('isLastSyncComplete: $isLastSyncComplete, ')
          ..write('lastSyncMinIndex: $lastSyncMinIndex, ')
          ..write('lastSyncMaxIndex: $lastSyncMaxIndex, ')
          ..write('lastSyncDate: $lastSyncDate, ')
          ..write('indexCycleCount: $indexCycleCount, ')
          ..write('baselineBeginIndex: $baselineBeginIndex, ')
          ..write('baselineEndIndex: $baselineEndIndex, ')
          ..write('baselineStatus: $baselineStatus, ')
          ..write('baselineBeginDate: $baselineBeginDate, ')
          ..write('baselineEndDate: $baselineEndDate, ')
          ..write('liveVolume: $liveVolume, ')
          ..write('liveTemperature: $liveTemperature, ')
          ..write('liveFlow: $liveFlow, ')
          ..write('liveDuration: $liveDuration, ')
          ..write('liveDate: $liveDate, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('thresholdRequest: $thresholdRequest, ')
          ..write('needResetVolume: $needResetVolume, ')
          ..write('hwVersion: $hwVersion, ')
          ..write('fwVersion: $fwVersion, ')
          ..write('threshold: $threshold, ')
          ..write('uuid: $uuid, ')
          ..write('calibration: $calibration, ')
          ..write('previousFlow: $previousFlow, ')
          ..write('refShowerDuration: $refShowerDuration, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShowersTable extends Showers with TableInfo<$ShowersTable, Shower> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShowersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isEmptyMeta = const VerificationMeta(
    'isEmpty',
  );
  @override
  late final GeneratedColumn<bool> isEmpty = GeneratedColumn<bool>(
    'is_empty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_empty" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isReferenceMeta = const VerificationMeta(
    'isReference',
  );
  @override
  late final GeneratedColumn<bool> isReference = GeneratedColumn<bool>(
    'is_reference',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_reference" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isIgnoredMeta = const VerificationMeta(
    'isIgnored',
  );
  @override
  late final GeneratedColumn<bool> isIgnored = GeneratedColumn<bool>(
    'is_ignored',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_ignored" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _volumeMeta = const VerificationMeta('volume');
  @override
  late final GeneratedColumn<int> volume = GeneratedColumn<int>(
    'volume',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _temperatureMeta = const VerificationMeta(
    'temperature',
  );
  @override
  late final GeneratedColumn<double> temperature = GeneratedColumn<double>(
    'temperature',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _flowMeta = const VerificationMeta('flow');
  @override
  late final GeneratedColumn<double> flow = GeneratedColumn<double>(
    'flow',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<double> duration = GeneratedColumn<double>(
    'duration',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _soapingTimeMeta = const VerificationMeta(
    'soapingTime',
  );
  @override
  late final GeneratedColumn<int> soapingTime = GeneratedColumn<int>(
    'soaping_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thresholdMeta = const VerificationMeta(
    'threshold',
  );
  @override
  late final GeneratedColumn<String> threshold = GeneratedColumn<String>(
    'threshold',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    deviceId,
    isEmpty,
    isReference,
    isIgnored,
    volume,
    temperature,
    flow,
    duration,
    date,
    soapingTime,
    threshold,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'showers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Shower> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('is_empty')) {
      context.handle(
        _isEmptyMeta,
        isEmpty.isAcceptableOrUnknown(data['is_empty']!, _isEmptyMeta),
      );
    }
    if (data.containsKey('is_reference')) {
      context.handle(
        _isReferenceMeta,
        isReference.isAcceptableOrUnknown(
          data['is_reference']!,
          _isReferenceMeta,
        ),
      );
    }
    if (data.containsKey('is_ignored')) {
      context.handle(
        _isIgnoredMeta,
        isIgnored.isAcceptableOrUnknown(data['is_ignored']!, _isIgnoredMeta),
      );
    }
    if (data.containsKey('volume')) {
      context.handle(
        _volumeMeta,
        volume.isAcceptableOrUnknown(data['volume']!, _volumeMeta),
      );
    } else if (isInserting) {
      context.missing(_volumeMeta);
    }
    if (data.containsKey('temperature')) {
      context.handle(
        _temperatureMeta,
        temperature.isAcceptableOrUnknown(
          data['temperature']!,
          _temperatureMeta,
        ),
      );
    }
    if (data.containsKey('flow')) {
      context.handle(
        _flowMeta,
        flow.isAcceptableOrUnknown(data['flow']!, _flowMeta),
      );
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('soaping_time')) {
      context.handle(
        _soapingTimeMeta,
        soapingTime.isAcceptableOrUnknown(
          data['soaping_time']!,
          _soapingTimeMeta,
        ),
      );
    }
    if (data.containsKey('threshold')) {
      context.handle(
        _thresholdMeta,
        threshold.isAcceptableOrUnknown(data['threshold']!, _thresholdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, deviceId};
  @override
  Shower map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Shower(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      isEmpty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_empty'],
      )!,
      isReference: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_reference'],
      )!,
      isIgnored: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_ignored'],
      )!,
      volume: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}volume'],
      )!,
      temperature: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}temperature'],
      ),
      flow: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}flow'],
      ),
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}duration'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      soapingTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}soaping_time'],
      ),
      threshold: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}threshold'],
      ),
    );
  }

  @override
  $ShowersTable createAlias(String alias) {
    return $ShowersTable(attachedDatabase, alias);
  }
}

class Shower extends DataClass implements Insertable<Shower> {
  final int id;
  final String deviceId;
  final bool isEmpty;
  final bool isReference;
  final bool isIgnored;
  final int volume;
  final double? temperature;
  final double? flow;
  final double? duration;
  final DateTime date;
  final int? soapingTime;
  final String? threshold;
  const Shower({
    required this.id,
    required this.deviceId,
    required this.isEmpty,
    required this.isReference,
    required this.isIgnored,
    required this.volume,
    this.temperature,
    this.flow,
    this.duration,
    required this.date,
    this.soapingTime,
    this.threshold,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['device_id'] = Variable<String>(deviceId);
    map['is_empty'] = Variable<bool>(isEmpty);
    map['is_reference'] = Variable<bool>(isReference);
    map['is_ignored'] = Variable<bool>(isIgnored);
    map['volume'] = Variable<int>(volume);
    if (!nullToAbsent || temperature != null) {
      map['temperature'] = Variable<double>(temperature);
    }
    if (!nullToAbsent || flow != null) {
      map['flow'] = Variable<double>(flow);
    }
    if (!nullToAbsent || duration != null) {
      map['duration'] = Variable<double>(duration);
    }
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || soapingTime != null) {
      map['soaping_time'] = Variable<int>(soapingTime);
    }
    if (!nullToAbsent || threshold != null) {
      map['threshold'] = Variable<String>(threshold);
    }
    return map;
  }

  ShowersCompanion toCompanion(bool nullToAbsent) {
    return ShowersCompanion(
      id: Value(id),
      deviceId: Value(deviceId),
      isEmpty: Value(isEmpty),
      isReference: Value(isReference),
      isIgnored: Value(isIgnored),
      volume: Value(volume),
      temperature: temperature == null && nullToAbsent
          ? const Value.absent()
          : Value(temperature),
      flow: flow == null && nullToAbsent ? const Value.absent() : Value(flow),
      duration: duration == null && nullToAbsent
          ? const Value.absent()
          : Value(duration),
      date: Value(date),
      soapingTime: soapingTime == null && nullToAbsent
          ? const Value.absent()
          : Value(soapingTime),
      threshold: threshold == null && nullToAbsent
          ? const Value.absent()
          : Value(threshold),
    );
  }

  factory Shower.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Shower(
      id: serializer.fromJson<int>(json['id']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      isEmpty: serializer.fromJson<bool>(json['isEmpty']),
      isReference: serializer.fromJson<bool>(json['isReference']),
      isIgnored: serializer.fromJson<bool>(json['isIgnored']),
      volume: serializer.fromJson<int>(json['volume']),
      temperature: serializer.fromJson<double?>(json['temperature']),
      flow: serializer.fromJson<double?>(json['flow']),
      duration: serializer.fromJson<double?>(json['duration']),
      date: serializer.fromJson<DateTime>(json['date']),
      soapingTime: serializer.fromJson<int?>(json['soapingTime']),
      threshold: serializer.fromJson<String?>(json['threshold']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'deviceId': serializer.toJson<String>(deviceId),
      'isEmpty': serializer.toJson<bool>(isEmpty),
      'isReference': serializer.toJson<bool>(isReference),
      'isIgnored': serializer.toJson<bool>(isIgnored),
      'volume': serializer.toJson<int>(volume),
      'temperature': serializer.toJson<double?>(temperature),
      'flow': serializer.toJson<double?>(flow),
      'duration': serializer.toJson<double?>(duration),
      'date': serializer.toJson<DateTime>(date),
      'soapingTime': serializer.toJson<int?>(soapingTime),
      'threshold': serializer.toJson<String?>(threshold),
    };
  }

  Shower copyWith({
    int? id,
    String? deviceId,
    bool? isEmpty,
    bool? isReference,
    bool? isIgnored,
    int? volume,
    Value<double?> temperature = const Value.absent(),
    Value<double?> flow = const Value.absent(),
    Value<double?> duration = const Value.absent(),
    DateTime? date,
    Value<int?> soapingTime = const Value.absent(),
    Value<String?> threshold = const Value.absent(),
  }) => Shower(
    id: id ?? this.id,
    deviceId: deviceId ?? this.deviceId,
    isEmpty: isEmpty ?? this.isEmpty,
    isReference: isReference ?? this.isReference,
    isIgnored: isIgnored ?? this.isIgnored,
    volume: volume ?? this.volume,
    temperature: temperature.present ? temperature.value : this.temperature,
    flow: flow.present ? flow.value : this.flow,
    duration: duration.present ? duration.value : this.duration,
    date: date ?? this.date,
    soapingTime: soapingTime.present ? soapingTime.value : this.soapingTime,
    threshold: threshold.present ? threshold.value : this.threshold,
  );
  Shower copyWithCompanion(ShowersCompanion data) {
    return Shower(
      id: data.id.present ? data.id.value : this.id,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      isEmpty: data.isEmpty.present ? data.isEmpty.value : this.isEmpty,
      isReference: data.isReference.present
          ? data.isReference.value
          : this.isReference,
      isIgnored: data.isIgnored.present ? data.isIgnored.value : this.isIgnored,
      volume: data.volume.present ? data.volume.value : this.volume,
      temperature: data.temperature.present
          ? data.temperature.value
          : this.temperature,
      flow: data.flow.present ? data.flow.value : this.flow,
      duration: data.duration.present ? data.duration.value : this.duration,
      date: data.date.present ? data.date.value : this.date,
      soapingTime: data.soapingTime.present
          ? data.soapingTime.value
          : this.soapingTime,
      threshold: data.threshold.present ? data.threshold.value : this.threshold,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Shower(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('isEmpty: $isEmpty, ')
          ..write('isReference: $isReference, ')
          ..write('isIgnored: $isIgnored, ')
          ..write('volume: $volume, ')
          ..write('temperature: $temperature, ')
          ..write('flow: $flow, ')
          ..write('duration: $duration, ')
          ..write('date: $date, ')
          ..write('soapingTime: $soapingTime, ')
          ..write('threshold: $threshold')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    deviceId,
    isEmpty,
    isReference,
    isIgnored,
    volume,
    temperature,
    flow,
    duration,
    date,
    soapingTime,
    threshold,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Shower &&
          other.id == this.id &&
          other.deviceId == this.deviceId &&
          other.isEmpty == this.isEmpty &&
          other.isReference == this.isReference &&
          other.isIgnored == this.isIgnored &&
          other.volume == this.volume &&
          other.temperature == this.temperature &&
          other.flow == this.flow &&
          other.duration == this.duration &&
          other.date == this.date &&
          other.soapingTime == this.soapingTime &&
          other.threshold == this.threshold);
}

class ShowersCompanion extends UpdateCompanion<Shower> {
  final Value<int> id;
  final Value<String> deviceId;
  final Value<bool> isEmpty;
  final Value<bool> isReference;
  final Value<bool> isIgnored;
  final Value<int> volume;
  final Value<double?> temperature;
  final Value<double?> flow;
  final Value<double?> duration;
  final Value<DateTime> date;
  final Value<int?> soapingTime;
  final Value<String?> threshold;
  final Value<int> rowid;
  const ShowersCompanion({
    this.id = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.isEmpty = const Value.absent(),
    this.isReference = const Value.absent(),
    this.isIgnored = const Value.absent(),
    this.volume = const Value.absent(),
    this.temperature = const Value.absent(),
    this.flow = const Value.absent(),
    this.duration = const Value.absent(),
    this.date = const Value.absent(),
    this.soapingTime = const Value.absent(),
    this.threshold = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShowersCompanion.insert({
    required int id,
    required String deviceId,
    this.isEmpty = const Value.absent(),
    this.isReference = const Value.absent(),
    this.isIgnored = const Value.absent(),
    required int volume,
    this.temperature = const Value.absent(),
    this.flow = const Value.absent(),
    this.duration = const Value.absent(),
    required DateTime date,
    this.soapingTime = const Value.absent(),
    this.threshold = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       deviceId = Value(deviceId),
       volume = Value(volume),
       date = Value(date);
  static Insertable<Shower> custom({
    Expression<int>? id,
    Expression<String>? deviceId,
    Expression<bool>? isEmpty,
    Expression<bool>? isReference,
    Expression<bool>? isIgnored,
    Expression<int>? volume,
    Expression<double>? temperature,
    Expression<double>? flow,
    Expression<double>? duration,
    Expression<DateTime>? date,
    Expression<int>? soapingTime,
    Expression<String>? threshold,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviceId != null) 'device_id': deviceId,
      if (isEmpty != null) 'is_empty': isEmpty,
      if (isReference != null) 'is_reference': isReference,
      if (isIgnored != null) 'is_ignored': isIgnored,
      if (volume != null) 'volume': volume,
      if (temperature != null) 'temperature': temperature,
      if (flow != null) 'flow': flow,
      if (duration != null) 'duration': duration,
      if (date != null) 'date': date,
      if (soapingTime != null) 'soaping_time': soapingTime,
      if (threshold != null) 'threshold': threshold,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShowersCompanion copyWith({
    Value<int>? id,
    Value<String>? deviceId,
    Value<bool>? isEmpty,
    Value<bool>? isReference,
    Value<bool>? isIgnored,
    Value<int>? volume,
    Value<double?>? temperature,
    Value<double?>? flow,
    Value<double?>? duration,
    Value<DateTime>? date,
    Value<int?>? soapingTime,
    Value<String?>? threshold,
    Value<int>? rowid,
  }) {
    return ShowersCompanion(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      isEmpty: isEmpty ?? this.isEmpty,
      isReference: isReference ?? this.isReference,
      isIgnored: isIgnored ?? this.isIgnored,
      volume: volume ?? this.volume,
      temperature: temperature ?? this.temperature,
      flow: flow ?? this.flow,
      duration: duration ?? this.duration,
      date: date ?? this.date,
      soapingTime: soapingTime ?? this.soapingTime,
      threshold: threshold ?? this.threshold,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (isEmpty.present) {
      map['is_empty'] = Variable<bool>(isEmpty.value);
    }
    if (isReference.present) {
      map['is_reference'] = Variable<bool>(isReference.value);
    }
    if (isIgnored.present) {
      map['is_ignored'] = Variable<bool>(isIgnored.value);
    }
    if (volume.present) {
      map['volume'] = Variable<int>(volume.value);
    }
    if (temperature.present) {
      map['temperature'] = Variable<double>(temperature.value);
    }
    if (flow.present) {
      map['flow'] = Variable<double>(flow.value);
    }
    if (duration.present) {
      map['duration'] = Variable<double>(duration.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (soapingTime.present) {
      map['soaping_time'] = Variable<int>(soapingTime.value);
    }
    if (threshold.present) {
      map['threshold'] = Variable<String>(threshold.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShowersCompanion(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('isEmpty: $isEmpty, ')
          ..write('isReference: $isReference, ')
          ..write('isIgnored: $isIgnored, ')
          ..write('volume: $volume, ')
          ..write('temperature: $temperature, ')
          ..write('flow: $flow, ')
          ..write('duration: $duration, ')
          ..write('date: $date, ')
          ..write('soapingTime: $soapingTime, ')
          ..write('threshold: $threshold, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, Settings> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _countryCodeMeta = const VerificationMeta(
    'countryCode',
  );
  @override
  late final GeneratedColumn<String> countryCode = GeneratedColumn<String>(
    'country_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _minShowerLiterMeta = const VerificationMeta(
    'minShowerLiter',
  );
  @override
  late final GeneratedColumn<int> minShowerLiter = GeneratedColumn<int>(
    'min_shower_liter',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(AppConstants.minShowerLiter),
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _waterUnitMeta = const VerificationMeta(
    'waterUnit',
  );
  @override
  late final GeneratedColumn<String> waterUnit = GeneratedColumn<String>(
    'water_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _waterPriceMeta = const VerificationMeta(
    'waterPrice',
  );
  @override
  late final GeneratedColumn<double> waterPrice = GeneratedColumn<double>(
    'water_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _energyPriceMeta = const VerificationMeta(
    'energyPrice',
  );
  @override
  late final GeneratedColumn<double> energyPrice = GeneratedColumn<double>(
    'energy_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heatingEnergyMeta = const VerificationMeta(
    'heatingEnergy',
  );
  @override
  late final GeneratedColumn<double> heatingEnergy = GeneratedColumn<double>(
    'heating_energy',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nbPeopleMeta = const VerificationMeta(
    'nbPeople',
  );
  @override
  late final GeneratedColumn<int> nbPeople = GeneratedColumn<int>(
    'nb_people',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statsNbShowersMeta = const VerificationMeta(
    'statsNbShowers',
  );
  @override
  late final GeneratedColumn<int> statsNbShowers = GeneratedColumn<int>(
    'stats_nb_showers',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    countryCode,
    minShowerLiter,
    currencyCode,
    waterUnit,
    waterPrice,
    energyPrice,
    heatingEnergy,
    nbPeople,
    statsNbShowers,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Settings> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('country_code')) {
      context.handle(
        _countryCodeMeta,
        countryCode.isAcceptableOrUnknown(
          data['country_code']!,
          _countryCodeMeta,
        ),
      );
    }
    if (data.containsKey('min_shower_liter')) {
      context.handle(
        _minShowerLiterMeta,
        minShowerLiter.isAcceptableOrUnknown(
          data['min_shower_liter']!,
          _minShowerLiterMeta,
        ),
      );
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    }
    if (data.containsKey('water_unit')) {
      context.handle(
        _waterUnitMeta,
        waterUnit.isAcceptableOrUnknown(data['water_unit']!, _waterUnitMeta),
      );
    }
    if (data.containsKey('water_price')) {
      context.handle(
        _waterPriceMeta,
        waterPrice.isAcceptableOrUnknown(data['water_price']!, _waterPriceMeta),
      );
    }
    if (data.containsKey('energy_price')) {
      context.handle(
        _energyPriceMeta,
        energyPrice.isAcceptableOrUnknown(
          data['energy_price']!,
          _energyPriceMeta,
        ),
      );
    }
    if (data.containsKey('heating_energy')) {
      context.handle(
        _heatingEnergyMeta,
        heatingEnergy.isAcceptableOrUnknown(
          data['heating_energy']!,
          _heatingEnergyMeta,
        ),
      );
    }
    if (data.containsKey('nb_people')) {
      context.handle(
        _nbPeopleMeta,
        nbPeople.isAcceptableOrUnknown(data['nb_people']!, _nbPeopleMeta),
      );
    }
    if (data.containsKey('stats_nb_showers')) {
      context.handle(
        _statsNbShowersMeta,
        statsNbShowers.isAcceptableOrUnknown(
          data['stats_nb_showers']!,
          _statsNbShowersMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Settings map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Settings(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      countryCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country_code'],
      ),
      minShowerLiter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_shower_liter'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      ),
      waterUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}water_unit'],
      ),
      waterPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}water_price'],
      ),
      energyPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}energy_price'],
      ),
      heatingEnergy: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}heating_energy'],
      ),
      nbPeople: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nb_people'],
      ),
      statsNbShowers: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stats_nb_showers'],
      ),
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class Settings extends DataClass implements Insertable<Settings> {
  final int id;
  final String? countryCode;
  final int minShowerLiter;
  final String? currencyCode;
  final String? waterUnit;
  final double? waterPrice;
  final double? energyPrice;
  final double? heatingEnergy;
  final int? nbPeople;
  final int? statsNbShowers;
  const Settings({
    required this.id,
    this.countryCode,
    required this.minShowerLiter,
    this.currencyCode,
    this.waterUnit,
    this.waterPrice,
    this.energyPrice,
    this.heatingEnergy,
    this.nbPeople,
    this.statsNbShowers,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || countryCode != null) {
      map['country_code'] = Variable<String>(countryCode);
    }
    map['min_shower_liter'] = Variable<int>(minShowerLiter);
    if (!nullToAbsent || currencyCode != null) {
      map['currency_code'] = Variable<String>(currencyCode);
    }
    if (!nullToAbsent || waterUnit != null) {
      map['water_unit'] = Variable<String>(waterUnit);
    }
    if (!nullToAbsent || waterPrice != null) {
      map['water_price'] = Variable<double>(waterPrice);
    }
    if (!nullToAbsent || energyPrice != null) {
      map['energy_price'] = Variable<double>(energyPrice);
    }
    if (!nullToAbsent || heatingEnergy != null) {
      map['heating_energy'] = Variable<double>(heatingEnergy);
    }
    if (!nullToAbsent || nbPeople != null) {
      map['nb_people'] = Variable<int>(nbPeople);
    }
    if (!nullToAbsent || statsNbShowers != null) {
      map['stats_nb_showers'] = Variable<int>(statsNbShowers);
    }
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      countryCode: countryCode == null && nullToAbsent
          ? const Value.absent()
          : Value(countryCode),
      minShowerLiter: Value(minShowerLiter),
      currencyCode: currencyCode == null && nullToAbsent
          ? const Value.absent()
          : Value(currencyCode),
      waterUnit: waterUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(waterUnit),
      waterPrice: waterPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(waterPrice),
      energyPrice: energyPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(energyPrice),
      heatingEnergy: heatingEnergy == null && nullToAbsent
          ? const Value.absent()
          : Value(heatingEnergy),
      nbPeople: nbPeople == null && nullToAbsent
          ? const Value.absent()
          : Value(nbPeople),
      statsNbShowers: statsNbShowers == null && nullToAbsent
          ? const Value.absent()
          : Value(statsNbShowers),
    );
  }

  factory Settings.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Settings(
      id: serializer.fromJson<int>(json['id']),
      countryCode: serializer.fromJson<String?>(json['countryCode']),
      minShowerLiter: serializer.fromJson<int>(json['minShowerLiter']),
      currencyCode: serializer.fromJson<String?>(json['currencyCode']),
      waterUnit: serializer.fromJson<String?>(json['waterUnit']),
      waterPrice: serializer.fromJson<double?>(json['waterPrice']),
      energyPrice: serializer.fromJson<double?>(json['energyPrice']),
      heatingEnergy: serializer.fromJson<double?>(json['heatingEnergy']),
      nbPeople: serializer.fromJson<int?>(json['nbPeople']),
      statsNbShowers: serializer.fromJson<int?>(json['statsNbShowers']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'countryCode': serializer.toJson<String?>(countryCode),
      'minShowerLiter': serializer.toJson<int>(minShowerLiter),
      'currencyCode': serializer.toJson<String?>(currencyCode),
      'waterUnit': serializer.toJson<String?>(waterUnit),
      'waterPrice': serializer.toJson<double?>(waterPrice),
      'energyPrice': serializer.toJson<double?>(energyPrice),
      'heatingEnergy': serializer.toJson<double?>(heatingEnergy),
      'nbPeople': serializer.toJson<int?>(nbPeople),
      'statsNbShowers': serializer.toJson<int?>(statsNbShowers),
    };
  }

  Settings copyWith({
    int? id,
    Value<String?> countryCode = const Value.absent(),
    int? minShowerLiter,
    Value<String?> currencyCode = const Value.absent(),
    Value<String?> waterUnit = const Value.absent(),
    Value<double?> waterPrice = const Value.absent(),
    Value<double?> energyPrice = const Value.absent(),
    Value<double?> heatingEnergy = const Value.absent(),
    Value<int?> nbPeople = const Value.absent(),
    Value<int?> statsNbShowers = const Value.absent(),
  }) => Settings(
    id: id ?? this.id,
    countryCode: countryCode.present ? countryCode.value : this.countryCode,
    minShowerLiter: minShowerLiter ?? this.minShowerLiter,
    currencyCode: currencyCode.present ? currencyCode.value : this.currencyCode,
    waterUnit: waterUnit.present ? waterUnit.value : this.waterUnit,
    waterPrice: waterPrice.present ? waterPrice.value : this.waterPrice,
    energyPrice: energyPrice.present ? energyPrice.value : this.energyPrice,
    heatingEnergy: heatingEnergy.present
        ? heatingEnergy.value
        : this.heatingEnergy,
    nbPeople: nbPeople.present ? nbPeople.value : this.nbPeople,
    statsNbShowers: statsNbShowers.present
        ? statsNbShowers.value
        : this.statsNbShowers,
  );
  Settings copyWithCompanion(AppSettingsCompanion data) {
    return Settings(
      id: data.id.present ? data.id.value : this.id,
      countryCode: data.countryCode.present
          ? data.countryCode.value
          : this.countryCode,
      minShowerLiter: data.minShowerLiter.present
          ? data.minShowerLiter.value
          : this.minShowerLiter,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      waterUnit: data.waterUnit.present ? data.waterUnit.value : this.waterUnit,
      waterPrice: data.waterPrice.present
          ? data.waterPrice.value
          : this.waterPrice,
      energyPrice: data.energyPrice.present
          ? data.energyPrice.value
          : this.energyPrice,
      heatingEnergy: data.heatingEnergy.present
          ? data.heatingEnergy.value
          : this.heatingEnergy,
      nbPeople: data.nbPeople.present ? data.nbPeople.value : this.nbPeople,
      statsNbShowers: data.statsNbShowers.present
          ? data.statsNbShowers.value
          : this.statsNbShowers,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Settings(')
          ..write('id: $id, ')
          ..write('countryCode: $countryCode, ')
          ..write('minShowerLiter: $minShowerLiter, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('waterUnit: $waterUnit, ')
          ..write('waterPrice: $waterPrice, ')
          ..write('energyPrice: $energyPrice, ')
          ..write('heatingEnergy: $heatingEnergy, ')
          ..write('nbPeople: $nbPeople, ')
          ..write('statsNbShowers: $statsNbShowers')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    countryCode,
    minShowerLiter,
    currencyCode,
    waterUnit,
    waterPrice,
    energyPrice,
    heatingEnergy,
    nbPeople,
    statsNbShowers,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Settings &&
          other.id == this.id &&
          other.countryCode == this.countryCode &&
          other.minShowerLiter == this.minShowerLiter &&
          other.currencyCode == this.currencyCode &&
          other.waterUnit == this.waterUnit &&
          other.waterPrice == this.waterPrice &&
          other.energyPrice == this.energyPrice &&
          other.heatingEnergy == this.heatingEnergy &&
          other.nbPeople == this.nbPeople &&
          other.statsNbShowers == this.statsNbShowers);
}

class AppSettingsCompanion extends UpdateCompanion<Settings> {
  final Value<int> id;
  final Value<String?> countryCode;
  final Value<int> minShowerLiter;
  final Value<String?> currencyCode;
  final Value<String?> waterUnit;
  final Value<double?> waterPrice;
  final Value<double?> energyPrice;
  final Value<double?> heatingEnergy;
  final Value<int?> nbPeople;
  final Value<int?> statsNbShowers;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.countryCode = const Value.absent(),
    this.minShowerLiter = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.waterUnit = const Value.absent(),
    this.waterPrice = const Value.absent(),
    this.energyPrice = const Value.absent(),
    this.heatingEnergy = const Value.absent(),
    this.nbPeople = const Value.absent(),
    this.statsNbShowers = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.countryCode = const Value.absent(),
    this.minShowerLiter = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.waterUnit = const Value.absent(),
    this.waterPrice = const Value.absent(),
    this.energyPrice = const Value.absent(),
    this.heatingEnergy = const Value.absent(),
    this.nbPeople = const Value.absent(),
    this.statsNbShowers = const Value.absent(),
  });
  static Insertable<Settings> custom({
    Expression<int>? id,
    Expression<String>? countryCode,
    Expression<int>? minShowerLiter,
    Expression<String>? currencyCode,
    Expression<String>? waterUnit,
    Expression<double>? waterPrice,
    Expression<double>? energyPrice,
    Expression<double>? heatingEnergy,
    Expression<int>? nbPeople,
    Expression<int>? statsNbShowers,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (countryCode != null) 'country_code': countryCode,
      if (minShowerLiter != null) 'min_shower_liter': minShowerLiter,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (waterUnit != null) 'water_unit': waterUnit,
      if (waterPrice != null) 'water_price': waterPrice,
      if (energyPrice != null) 'energy_price': energyPrice,
      if (heatingEnergy != null) 'heating_energy': heatingEnergy,
      if (nbPeople != null) 'nb_people': nbPeople,
      if (statsNbShowers != null) 'stats_nb_showers': statsNbShowers,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<String?>? countryCode,
    Value<int>? minShowerLiter,
    Value<String?>? currencyCode,
    Value<String?>? waterUnit,
    Value<double?>? waterPrice,
    Value<double?>? energyPrice,
    Value<double?>? heatingEnergy,
    Value<int?>? nbPeople,
    Value<int?>? statsNbShowers,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      countryCode: countryCode ?? this.countryCode,
      minShowerLiter: minShowerLiter ?? this.minShowerLiter,
      currencyCode: currencyCode ?? this.currencyCode,
      waterUnit: waterUnit ?? this.waterUnit,
      waterPrice: waterPrice ?? this.waterPrice,
      energyPrice: energyPrice ?? this.energyPrice,
      heatingEnergy: heatingEnergy ?? this.heatingEnergy,
      nbPeople: nbPeople ?? this.nbPeople,
      statsNbShowers: statsNbShowers ?? this.statsNbShowers,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (countryCode.present) {
      map['country_code'] = Variable<String>(countryCode.value);
    }
    if (minShowerLiter.present) {
      map['min_shower_liter'] = Variable<int>(minShowerLiter.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (waterUnit.present) {
      map['water_unit'] = Variable<String>(waterUnit.value);
    }
    if (waterPrice.present) {
      map['water_price'] = Variable<double>(waterPrice.value);
    }
    if (energyPrice.present) {
      map['energy_price'] = Variable<double>(energyPrice.value);
    }
    if (heatingEnergy.present) {
      map['heating_energy'] = Variable<double>(heatingEnergy.value);
    }
    if (nbPeople.present) {
      map['nb_people'] = Variable<int>(nbPeople.value);
    }
    if (statsNbShowers.present) {
      map['stats_nb_showers'] = Variable<int>(statsNbShowers.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('countryCode: $countryCode, ')
          ..write('minShowerLiter: $minShowerLiter, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('waterUnit: $waterUnit, ')
          ..write('waterPrice: $waterPrice, ')
          ..write('energyPrice: $energyPrice, ')
          ..write('heatingEnergy: $heatingEnergy, ')
          ..write('nbPeople: $nbPeople, ')
          ..write('statsNbShowers: $statsNbShowers')
          ..write(')'))
        .toString();
  }
}

abstract class _$DbRepository extends GeneratedDatabase {
  _$DbRepository(QueryExecutor e) : super(e);
  $DbRepositoryManager get managers => $DbRepositoryManager(this);
  late final $ShowerheadsTable showerheads = $ShowerheadsTable(this);
  late final $ShowersTable showers = $ShowersTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    showerheads,
    showers,
    appSettings,
  ];
}

typedef $$ShowerheadsTableCreateCompanionBuilder =
    ShowerheadsCompanion Function({
      required String id,
      Value<DateTime?> firstSeen,
      Value<DateTime?> lastSeen,
      Value<int?> lastRssi,
      Value<bool?> isLastSyncComplete,
      Value<int?> lastSyncMinIndex,
      Value<int?> lastSyncMaxIndex,
      Value<DateTime?> lastSyncDate,
      Value<int> indexCycleCount,
      Value<int?> baselineBeginIndex,
      Value<int?> baselineEndIndex,
      Value<String?> baselineStatus,
      Value<DateTime?> baselineBeginDate,
      Value<DateTime?> baselineEndDate,
      Value<int?> liveVolume,
      Value<double?> liveTemperature,
      Value<double?> liveFlow,
      Value<double?> liveDuration,
      Value<DateTime?> liveDate,
      required String name,
      required String type,
      Value<String?> thresholdRequest,
      Value<bool?> needResetVolume,
      Value<int?> hwVersion,
      Value<String?> fwVersion,
      Value<String?> threshold,
      Value<String?> uuid,
      Value<int?> calibration,
      Value<double?> previousFlow,
      Value<int?> refShowerDuration,
      Value<int> rowid,
    });
typedef $$ShowerheadsTableUpdateCompanionBuilder =
    ShowerheadsCompanion Function({
      Value<String> id,
      Value<DateTime?> firstSeen,
      Value<DateTime?> lastSeen,
      Value<int?> lastRssi,
      Value<bool?> isLastSyncComplete,
      Value<int?> lastSyncMinIndex,
      Value<int?> lastSyncMaxIndex,
      Value<DateTime?> lastSyncDate,
      Value<int> indexCycleCount,
      Value<int?> baselineBeginIndex,
      Value<int?> baselineEndIndex,
      Value<String?> baselineStatus,
      Value<DateTime?> baselineBeginDate,
      Value<DateTime?> baselineEndDate,
      Value<int?> liveVolume,
      Value<double?> liveTemperature,
      Value<double?> liveFlow,
      Value<double?> liveDuration,
      Value<DateTime?> liveDate,
      Value<String> name,
      Value<String> type,
      Value<String?> thresholdRequest,
      Value<bool?> needResetVolume,
      Value<int?> hwVersion,
      Value<String?> fwVersion,
      Value<String?> threshold,
      Value<String?> uuid,
      Value<int?> calibration,
      Value<double?> previousFlow,
      Value<int?> refShowerDuration,
      Value<int> rowid,
    });

class $$ShowerheadsTableFilterComposer
    extends Composer<_$DbRepository, $ShowerheadsTable> {
  $$ShowerheadsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get firstSeen => $composableBuilder(
    column: $table.firstSeen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSeen => $composableBuilder(
    column: $table.lastSeen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastRssi => $composableBuilder(
    column: $table.lastRssi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLastSyncComplete => $composableBuilder(
    column: $table.isLastSyncComplete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastSyncMinIndex => $composableBuilder(
    column: $table.lastSyncMinIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastSyncMaxIndex => $composableBuilder(
    column: $table.lastSyncMaxIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncDate => $composableBuilder(
    column: $table.lastSyncDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get indexCycleCount => $composableBuilder(
    column: $table.indexCycleCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baselineBeginIndex => $composableBuilder(
    column: $table.baselineBeginIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baselineEndIndex => $composableBuilder(
    column: $table.baselineEndIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baselineStatus => $composableBuilder(
    column: $table.baselineStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get baselineBeginDate => $composableBuilder(
    column: $table.baselineBeginDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get baselineEndDate => $composableBuilder(
    column: $table.baselineEndDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get liveVolume => $composableBuilder(
    column: $table.liveVolume,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get liveTemperature => $composableBuilder(
    column: $table.liveTemperature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get liveFlow => $composableBuilder(
    column: $table.liveFlow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get liveDuration => $composableBuilder(
    column: $table.liveDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get liveDate => $composableBuilder(
    column: $table.liveDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thresholdRequest => $composableBuilder(
    column: $table.thresholdRequest,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needResetVolume => $composableBuilder(
    column: $table.needResetVolume,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hwVersion => $composableBuilder(
    column: $table.hwVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fwVersion => $composableBuilder(
    column: $table.fwVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get threshold => $composableBuilder(
    column: $table.threshold,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get calibration => $composableBuilder(
    column: $table.calibration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get previousFlow => $composableBuilder(
    column: $table.previousFlow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get refShowerDuration => $composableBuilder(
    column: $table.refShowerDuration,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ShowerheadsTableOrderingComposer
    extends Composer<_$DbRepository, $ShowerheadsTable> {
  $$ShowerheadsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get firstSeen => $composableBuilder(
    column: $table.firstSeen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSeen => $composableBuilder(
    column: $table.lastSeen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastRssi => $composableBuilder(
    column: $table.lastRssi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLastSyncComplete => $composableBuilder(
    column: $table.isLastSyncComplete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastSyncMinIndex => $composableBuilder(
    column: $table.lastSyncMinIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastSyncMaxIndex => $composableBuilder(
    column: $table.lastSyncMaxIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncDate => $composableBuilder(
    column: $table.lastSyncDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get indexCycleCount => $composableBuilder(
    column: $table.indexCycleCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baselineBeginIndex => $composableBuilder(
    column: $table.baselineBeginIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baselineEndIndex => $composableBuilder(
    column: $table.baselineEndIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baselineStatus => $composableBuilder(
    column: $table.baselineStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get baselineBeginDate => $composableBuilder(
    column: $table.baselineBeginDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get baselineEndDate => $composableBuilder(
    column: $table.baselineEndDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get liveVolume => $composableBuilder(
    column: $table.liveVolume,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get liveTemperature => $composableBuilder(
    column: $table.liveTemperature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get liveFlow => $composableBuilder(
    column: $table.liveFlow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get liveDuration => $composableBuilder(
    column: $table.liveDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get liveDate => $composableBuilder(
    column: $table.liveDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thresholdRequest => $composableBuilder(
    column: $table.thresholdRequest,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needResetVolume => $composableBuilder(
    column: $table.needResetVolume,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hwVersion => $composableBuilder(
    column: $table.hwVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fwVersion => $composableBuilder(
    column: $table.fwVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get threshold => $composableBuilder(
    column: $table.threshold,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get calibration => $composableBuilder(
    column: $table.calibration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get previousFlow => $composableBuilder(
    column: $table.previousFlow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get refShowerDuration => $composableBuilder(
    column: $table.refShowerDuration,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShowerheadsTableAnnotationComposer
    extends Composer<_$DbRepository, $ShowerheadsTable> {
  $$ShowerheadsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get firstSeen =>
      $composableBuilder(column: $table.firstSeen, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSeen =>
      $composableBuilder(column: $table.lastSeen, builder: (column) => column);

  GeneratedColumn<int> get lastRssi =>
      $composableBuilder(column: $table.lastRssi, builder: (column) => column);

  GeneratedColumn<bool> get isLastSyncComplete => $composableBuilder(
    column: $table.isLastSyncComplete,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastSyncMinIndex => $composableBuilder(
    column: $table.lastSyncMinIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastSyncMaxIndex => $composableBuilder(
    column: $table.lastSyncMaxIndex,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncDate => $composableBuilder(
    column: $table.lastSyncDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get indexCycleCount => $composableBuilder(
    column: $table.indexCycleCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get baselineBeginIndex => $composableBuilder(
    column: $table.baselineBeginIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get baselineEndIndex => $composableBuilder(
    column: $table.baselineEndIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get baselineStatus => $composableBuilder(
    column: $table.baselineStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get baselineBeginDate => $composableBuilder(
    column: $table.baselineBeginDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get baselineEndDate => $composableBuilder(
    column: $table.baselineEndDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get liveVolume => $composableBuilder(
    column: $table.liveVolume,
    builder: (column) => column,
  );

  GeneratedColumn<double> get liveTemperature => $composableBuilder(
    column: $table.liveTemperature,
    builder: (column) => column,
  );

  GeneratedColumn<double> get liveFlow =>
      $composableBuilder(column: $table.liveFlow, builder: (column) => column);

  GeneratedColumn<double> get liveDuration => $composableBuilder(
    column: $table.liveDuration,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get liveDate =>
      $composableBuilder(column: $table.liveDate, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get thresholdRequest => $composableBuilder(
    column: $table.thresholdRequest,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get needResetVolume => $composableBuilder(
    column: $table.needResetVolume,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hwVersion =>
      $composableBuilder(column: $table.hwVersion, builder: (column) => column);

  GeneratedColumn<String> get fwVersion =>
      $composableBuilder(column: $table.fwVersion, builder: (column) => column);

  GeneratedColumn<String> get threshold =>
      $composableBuilder(column: $table.threshold, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<int> get calibration => $composableBuilder(
    column: $table.calibration,
    builder: (column) => column,
  );

  GeneratedColumn<double> get previousFlow => $composableBuilder(
    column: $table.previousFlow,
    builder: (column) => column,
  );

  GeneratedColumn<int> get refShowerDuration => $composableBuilder(
    column: $table.refShowerDuration,
    builder: (column) => column,
  );
}

class $$ShowerheadsTableTableManager
    extends
        RootTableManager<
          _$DbRepository,
          $ShowerheadsTable,
          Showerhead,
          $$ShowerheadsTableFilterComposer,
          $$ShowerheadsTableOrderingComposer,
          $$ShowerheadsTableAnnotationComposer,
          $$ShowerheadsTableCreateCompanionBuilder,
          $$ShowerheadsTableUpdateCompanionBuilder,
          (
            Showerhead,
            BaseReferences<_$DbRepository, $ShowerheadsTable, Showerhead>,
          ),
          Showerhead,
          PrefetchHooks Function()
        > {
  $$ShowerheadsTableTableManager(_$DbRepository db, $ShowerheadsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShowerheadsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShowerheadsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShowerheadsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime?> firstSeen = const Value.absent(),
                Value<DateTime?> lastSeen = const Value.absent(),
                Value<int?> lastRssi = const Value.absent(),
                Value<bool?> isLastSyncComplete = const Value.absent(),
                Value<int?> lastSyncMinIndex = const Value.absent(),
                Value<int?> lastSyncMaxIndex = const Value.absent(),
                Value<DateTime?> lastSyncDate = const Value.absent(),
                Value<int> indexCycleCount = const Value.absent(),
                Value<int?> baselineBeginIndex = const Value.absent(),
                Value<int?> baselineEndIndex = const Value.absent(),
                Value<String?> baselineStatus = const Value.absent(),
                Value<DateTime?> baselineBeginDate = const Value.absent(),
                Value<DateTime?> baselineEndDate = const Value.absent(),
                Value<int?> liveVolume = const Value.absent(),
                Value<double?> liveTemperature = const Value.absent(),
                Value<double?> liveFlow = const Value.absent(),
                Value<double?> liveDuration = const Value.absent(),
                Value<DateTime?> liveDate = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> thresholdRequest = const Value.absent(),
                Value<bool?> needResetVolume = const Value.absent(),
                Value<int?> hwVersion = const Value.absent(),
                Value<String?> fwVersion = const Value.absent(),
                Value<String?> threshold = const Value.absent(),
                Value<String?> uuid = const Value.absent(),
                Value<int?> calibration = const Value.absent(),
                Value<double?> previousFlow = const Value.absent(),
                Value<int?> refShowerDuration = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShowerheadsCompanion(
                id: id,
                firstSeen: firstSeen,
                lastSeen: lastSeen,
                lastRssi: lastRssi,
                isLastSyncComplete: isLastSyncComplete,
                lastSyncMinIndex: lastSyncMinIndex,
                lastSyncMaxIndex: lastSyncMaxIndex,
                lastSyncDate: lastSyncDate,
                indexCycleCount: indexCycleCount,
                baselineBeginIndex: baselineBeginIndex,
                baselineEndIndex: baselineEndIndex,
                baselineStatus: baselineStatus,
                baselineBeginDate: baselineBeginDate,
                baselineEndDate: baselineEndDate,
                liveVolume: liveVolume,
                liveTemperature: liveTemperature,
                liveFlow: liveFlow,
                liveDuration: liveDuration,
                liveDate: liveDate,
                name: name,
                type: type,
                thresholdRequest: thresholdRequest,
                needResetVolume: needResetVolume,
                hwVersion: hwVersion,
                fwVersion: fwVersion,
                threshold: threshold,
                uuid: uuid,
                calibration: calibration,
                previousFlow: previousFlow,
                refShowerDuration: refShowerDuration,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime?> firstSeen = const Value.absent(),
                Value<DateTime?> lastSeen = const Value.absent(),
                Value<int?> lastRssi = const Value.absent(),
                Value<bool?> isLastSyncComplete = const Value.absent(),
                Value<int?> lastSyncMinIndex = const Value.absent(),
                Value<int?> lastSyncMaxIndex = const Value.absent(),
                Value<DateTime?> lastSyncDate = const Value.absent(),
                Value<int> indexCycleCount = const Value.absent(),
                Value<int?> baselineBeginIndex = const Value.absent(),
                Value<int?> baselineEndIndex = const Value.absent(),
                Value<String?> baselineStatus = const Value.absent(),
                Value<DateTime?> baselineBeginDate = const Value.absent(),
                Value<DateTime?> baselineEndDate = const Value.absent(),
                Value<int?> liveVolume = const Value.absent(),
                Value<double?> liveTemperature = const Value.absent(),
                Value<double?> liveFlow = const Value.absent(),
                Value<double?> liveDuration = const Value.absent(),
                Value<DateTime?> liveDate = const Value.absent(),
                required String name,
                required String type,
                Value<String?> thresholdRequest = const Value.absent(),
                Value<bool?> needResetVolume = const Value.absent(),
                Value<int?> hwVersion = const Value.absent(),
                Value<String?> fwVersion = const Value.absent(),
                Value<String?> threshold = const Value.absent(),
                Value<String?> uuid = const Value.absent(),
                Value<int?> calibration = const Value.absent(),
                Value<double?> previousFlow = const Value.absent(),
                Value<int?> refShowerDuration = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShowerheadsCompanion.insert(
                id: id,
                firstSeen: firstSeen,
                lastSeen: lastSeen,
                lastRssi: lastRssi,
                isLastSyncComplete: isLastSyncComplete,
                lastSyncMinIndex: lastSyncMinIndex,
                lastSyncMaxIndex: lastSyncMaxIndex,
                lastSyncDate: lastSyncDate,
                indexCycleCount: indexCycleCount,
                baselineBeginIndex: baselineBeginIndex,
                baselineEndIndex: baselineEndIndex,
                baselineStatus: baselineStatus,
                baselineBeginDate: baselineBeginDate,
                baselineEndDate: baselineEndDate,
                liveVolume: liveVolume,
                liveTemperature: liveTemperature,
                liveFlow: liveFlow,
                liveDuration: liveDuration,
                liveDate: liveDate,
                name: name,
                type: type,
                thresholdRequest: thresholdRequest,
                needResetVolume: needResetVolume,
                hwVersion: hwVersion,
                fwVersion: fwVersion,
                threshold: threshold,
                uuid: uuid,
                calibration: calibration,
                previousFlow: previousFlow,
                refShowerDuration: refShowerDuration,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ShowerheadsTableProcessedTableManager =
    ProcessedTableManager<
      _$DbRepository,
      $ShowerheadsTable,
      Showerhead,
      $$ShowerheadsTableFilterComposer,
      $$ShowerheadsTableOrderingComposer,
      $$ShowerheadsTableAnnotationComposer,
      $$ShowerheadsTableCreateCompanionBuilder,
      $$ShowerheadsTableUpdateCompanionBuilder,
      (
        Showerhead,
        BaseReferences<_$DbRepository, $ShowerheadsTable, Showerhead>,
      ),
      Showerhead,
      PrefetchHooks Function()
    >;
typedef $$ShowersTableCreateCompanionBuilder =
    ShowersCompanion Function({
      required int id,
      required String deviceId,
      Value<bool> isEmpty,
      Value<bool> isReference,
      Value<bool> isIgnored,
      required int volume,
      Value<double?> temperature,
      Value<double?> flow,
      Value<double?> duration,
      required DateTime date,
      Value<int?> soapingTime,
      Value<String?> threshold,
      Value<int> rowid,
    });
typedef $$ShowersTableUpdateCompanionBuilder =
    ShowersCompanion Function({
      Value<int> id,
      Value<String> deviceId,
      Value<bool> isEmpty,
      Value<bool> isReference,
      Value<bool> isIgnored,
      Value<int> volume,
      Value<double?> temperature,
      Value<double?> flow,
      Value<double?> duration,
      Value<DateTime> date,
      Value<int?> soapingTime,
      Value<String?> threshold,
      Value<int> rowid,
    });

class $$ShowersTableFilterComposer
    extends Composer<_$DbRepository, $ShowersTable> {
  $$ShowersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEmpty => $composableBuilder(
    column: $table.isEmpty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isReference => $composableBuilder(
    column: $table.isReference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isIgnored => $composableBuilder(
    column: $table.isIgnored,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get volume => $composableBuilder(
    column: $table.volume,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get flow => $composableBuilder(
    column: $table.flow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get soapingTime => $composableBuilder(
    column: $table.soapingTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get threshold => $composableBuilder(
    column: $table.threshold,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ShowersTableOrderingComposer
    extends Composer<_$DbRepository, $ShowersTable> {
  $$ShowersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEmpty => $composableBuilder(
    column: $table.isEmpty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isReference => $composableBuilder(
    column: $table.isReference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isIgnored => $composableBuilder(
    column: $table.isIgnored,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get volume => $composableBuilder(
    column: $table.volume,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get flow => $composableBuilder(
    column: $table.flow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get soapingTime => $composableBuilder(
    column: $table.soapingTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get threshold => $composableBuilder(
    column: $table.threshold,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShowersTableAnnotationComposer
    extends Composer<_$DbRepository, $ShowersTable> {
  $$ShowersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<bool> get isEmpty =>
      $composableBuilder(column: $table.isEmpty, builder: (column) => column);

  GeneratedColumn<bool> get isReference => $composableBuilder(
    column: $table.isReference,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isIgnored =>
      $composableBuilder(column: $table.isIgnored, builder: (column) => column);

  GeneratedColumn<int> get volume =>
      $composableBuilder(column: $table.volume, builder: (column) => column);

  GeneratedColumn<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => column,
  );

  GeneratedColumn<double> get flow =>
      $composableBuilder(column: $table.flow, builder: (column) => column);

  GeneratedColumn<double> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get soapingTime => $composableBuilder(
    column: $table.soapingTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get threshold =>
      $composableBuilder(column: $table.threshold, builder: (column) => column);
}

class $$ShowersTableTableManager
    extends
        RootTableManager<
          _$DbRepository,
          $ShowersTable,
          Shower,
          $$ShowersTableFilterComposer,
          $$ShowersTableOrderingComposer,
          $$ShowersTableAnnotationComposer,
          $$ShowersTableCreateCompanionBuilder,
          $$ShowersTableUpdateCompanionBuilder,
          (Shower, BaseReferences<_$DbRepository, $ShowersTable, Shower>),
          Shower,
          PrefetchHooks Function()
        > {
  $$ShowersTableTableManager(_$DbRepository db, $ShowersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShowersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShowersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShowersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<bool> isEmpty = const Value.absent(),
                Value<bool> isReference = const Value.absent(),
                Value<bool> isIgnored = const Value.absent(),
                Value<int> volume = const Value.absent(),
                Value<double?> temperature = const Value.absent(),
                Value<double?> flow = const Value.absent(),
                Value<double?> duration = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int?> soapingTime = const Value.absent(),
                Value<String?> threshold = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShowersCompanion(
                id: id,
                deviceId: deviceId,
                isEmpty: isEmpty,
                isReference: isReference,
                isIgnored: isIgnored,
                volume: volume,
                temperature: temperature,
                flow: flow,
                duration: duration,
                date: date,
                soapingTime: soapingTime,
                threshold: threshold,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int id,
                required String deviceId,
                Value<bool> isEmpty = const Value.absent(),
                Value<bool> isReference = const Value.absent(),
                Value<bool> isIgnored = const Value.absent(),
                required int volume,
                Value<double?> temperature = const Value.absent(),
                Value<double?> flow = const Value.absent(),
                Value<double?> duration = const Value.absent(),
                required DateTime date,
                Value<int?> soapingTime = const Value.absent(),
                Value<String?> threshold = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShowersCompanion.insert(
                id: id,
                deviceId: deviceId,
                isEmpty: isEmpty,
                isReference: isReference,
                isIgnored: isIgnored,
                volume: volume,
                temperature: temperature,
                flow: flow,
                duration: duration,
                date: date,
                soapingTime: soapingTime,
                threshold: threshold,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ShowersTableProcessedTableManager =
    ProcessedTableManager<
      _$DbRepository,
      $ShowersTable,
      Shower,
      $$ShowersTableFilterComposer,
      $$ShowersTableOrderingComposer,
      $$ShowersTableAnnotationComposer,
      $$ShowersTableCreateCompanionBuilder,
      $$ShowersTableUpdateCompanionBuilder,
      (Shower, BaseReferences<_$DbRepository, $ShowersTable, Shower>),
      Shower,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<String?> countryCode,
      Value<int> minShowerLiter,
      Value<String?> currencyCode,
      Value<String?> waterUnit,
      Value<double?> waterPrice,
      Value<double?> energyPrice,
      Value<double?> heatingEnergy,
      Value<int?> nbPeople,
      Value<int?> statsNbShowers,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<String?> countryCode,
      Value<int> minShowerLiter,
      Value<String?> currencyCode,
      Value<String?> waterUnit,
      Value<double?> waterPrice,
      Value<double?> energyPrice,
      Value<double?> heatingEnergy,
      Value<int?> nbPeople,
      Value<int?> statsNbShowers,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$DbRepository, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minShowerLiter => $composableBuilder(
    column: $table.minShowerLiter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get waterUnit => $composableBuilder(
    column: $table.waterUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get waterPrice => $composableBuilder(
    column: $table.waterPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get energyPrice => $composableBuilder(
    column: $table.energyPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heatingEnergy => $composableBuilder(
    column: $table.heatingEnergy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nbPeople => $composableBuilder(
    column: $table.nbPeople,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get statsNbShowers => $composableBuilder(
    column: $table.statsNbShowers,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$DbRepository, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minShowerLiter => $composableBuilder(
    column: $table.minShowerLiter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get waterUnit => $composableBuilder(
    column: $table.waterUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get waterPrice => $composableBuilder(
    column: $table.waterPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get energyPrice => $composableBuilder(
    column: $table.energyPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heatingEnergy => $composableBuilder(
    column: $table.heatingEnergy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nbPeople => $composableBuilder(
    column: $table.nbPeople,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get statsNbShowers => $composableBuilder(
    column: $table.statsNbShowers,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$DbRepository, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minShowerLiter => $composableBuilder(
    column: $table.minShowerLiter,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get waterUnit =>
      $composableBuilder(column: $table.waterUnit, builder: (column) => column);

  GeneratedColumn<double> get waterPrice => $composableBuilder(
    column: $table.waterPrice,
    builder: (column) => column,
  );

  GeneratedColumn<double> get energyPrice => $composableBuilder(
    column: $table.energyPrice,
    builder: (column) => column,
  );

  GeneratedColumn<double> get heatingEnergy => $composableBuilder(
    column: $table.heatingEnergy,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nbPeople =>
      $composableBuilder(column: $table.nbPeople, builder: (column) => column);

  GeneratedColumn<int> get statsNbShowers => $composableBuilder(
    column: $table.statsNbShowers,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$DbRepository,
          $AppSettingsTable,
          Settings,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            Settings,
            BaseReferences<_$DbRepository, $AppSettingsTable, Settings>,
          ),
          Settings,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$DbRepository db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> countryCode = const Value.absent(),
                Value<int> minShowerLiter = const Value.absent(),
                Value<String?> currencyCode = const Value.absent(),
                Value<String?> waterUnit = const Value.absent(),
                Value<double?> waterPrice = const Value.absent(),
                Value<double?> energyPrice = const Value.absent(),
                Value<double?> heatingEnergy = const Value.absent(),
                Value<int?> nbPeople = const Value.absent(),
                Value<int?> statsNbShowers = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                countryCode: countryCode,
                minShowerLiter: minShowerLiter,
                currencyCode: currencyCode,
                waterUnit: waterUnit,
                waterPrice: waterPrice,
                energyPrice: energyPrice,
                heatingEnergy: heatingEnergy,
                nbPeople: nbPeople,
                statsNbShowers: statsNbShowers,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> countryCode = const Value.absent(),
                Value<int> minShowerLiter = const Value.absent(),
                Value<String?> currencyCode = const Value.absent(),
                Value<String?> waterUnit = const Value.absent(),
                Value<double?> waterPrice = const Value.absent(),
                Value<double?> energyPrice = const Value.absent(),
                Value<double?> heatingEnergy = const Value.absent(),
                Value<int?> nbPeople = const Value.absent(),
                Value<int?> statsNbShowers = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                countryCode: countryCode,
                minShowerLiter: minShowerLiter,
                currencyCode: currencyCode,
                waterUnit: waterUnit,
                waterPrice: waterPrice,
                energyPrice: energyPrice,
                heatingEnergy: heatingEnergy,
                nbPeople: nbPeople,
                statsNbShowers: statsNbShowers,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$DbRepository,
      $AppSettingsTable,
      Settings,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (Settings, BaseReferences<_$DbRepository, $AppSettingsTable, Settings>),
      Settings,
      PrefetchHooks Function()
    >;

class $DbRepositoryManager {
  final _$DbRepository _db;
  $DbRepositoryManager(this._db);
  $$ShowerheadsTableTableManager get showerheads =>
      $$ShowerheadsTableTableManager(_db, _db.showerheads);
  $$ShowersTableTableManager get showers =>
      $$ShowersTableTableManager(_db, _db.showers);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
