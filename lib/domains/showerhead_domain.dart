import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hydrao_flutter_offline/constants.dart';
import 'package:hydrao_flutter_offline/conversions.dart';
import 'package:hydrao_flutter_offline/core/debouncer.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/core/progress_timer.dart';
import 'package:hydrao_flutter_offline/domains/showerhead_state.dart';
import 'package:hydrao_flutter_offline/models/learning_period.dart';
import 'package:hydrao_flutter_offline/models/raw_live_shower.dart';
import 'package:hydrao_flutter_offline/models/raw_shower.dart';
import 'package:hydrao_flutter_offline/models/showerhead_device.dart';
import 'package:hydrao_flutter_offline/models/threshold.dart';
import 'package:hydrao_flutter_offline/repositories/ble/ble_adapter_state.dart';
import 'package:hydrao_flutter_offline/repositories/ble/ble_connection_state.dart';
import 'package:hydrao_flutter_offline/repositories/ble/ble_repository.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';
import 'package:hydrao_flutter_offline/utils.dart';

const _logTag = "[SHOWERHEAD_DOMAIN] ";

class ShowerheadDomain extends StateNotifier<ShowerheadState> {
  final BleRepository _bleRepository;
  final DbRepository _dbRepository;

  // ignore: cancel_subscriptions
  StreamSubscription<BleConnectionState>? _connectSub;
  // ignore: cancel_subscriptions
  StreamSubscription<BleAdapterState>? _adapterSub;
  // ignore: cancel_subscriptions
  StreamSubscription<BleAdapterState>? _adapterForScanSub;
  // ignore: cancel_subscriptions
  StreamSubscription<bool>? _scanningSub;
  // ignore: cancel_subscriptions
  StreamSubscription<List<ShowerheadDevice>>? _detectedDevicesSub;
  // ignore: cancel_subscriptions
  StreamSubscription<List<Showerhead>>? _dbShsSub;
  Map<String, Showerhead> _dbShsById = {};
  ProgressTimer? _autoConnectTimer;
  Debouncer<List<ShowerheadDevice>>? _devicesDebouncer;
  ProgressTimer? _soapingTimer;

  bool _startScanPending = false;
  bool _isStopping = false;
  bool _isWatchingPermissions = false;
  bool _isLiveRunning = false;
  String? _connectingDeviceId;
  String? _autoConnectDeviceId;

  ShowerheadDomain(this._bleRepository, this._dbRepository)
    : super(const ShowerheadState());

  /// cleaning before destroy
  @override
  Future<void> dispose() async {
    await stopScanning();
    await stopSoaping();

    super.dispose();
  }

  bool isStopped() {
    return state.status == BluetoothStatus.stopped;
  }

  Stream<List<Showerhead>> watchDbShowerheads() {
    return _dbRepository.watchShowerheads();
  }

  /// Start sh scan
  void watchAdapterState(
    Future<void> Function()? onBluetoothReady,
    Future<void> Function()? onBluetoothDisabled,
  ) async {
    await safeCancel(_adapterSub);

    _adapterSub = _bleRepository.adapterState().listen((adapterState) async {
      appLogger.t(
        '$_logTag adapter status changed : $adapterState (btStatus=${state.status})',
      );
      if (adapterState == BleAdapterState.off) {
        appLogger.d('$_logTag bluetooth OFF => case bluetoothDisabled');
        if (onBluetoothDisabled != null) {
          await onBluetoothDisabled();
        }
      } else if (adapterState == BleAdapterState.unauthorized) {
        appLogger.d(
          '$_logTag bluetooth UNAUTHORIZED (iOS) => case permissionsMissing',
        );
        await stopScanning(
          nextState: state.copyWith(
            status: BluetoothStatus.permissionsMissing,
            missingPermissions: ["bluetoothScan"],
          ),
        );
      } else if (adapterState == BleAdapterState.on ||
          adapterState == BleAdapterState.unknown) {
        if (state.status == BluetoothStatus.bluetoothDisabled ||
            state.status == BluetoothStatus.stopped ||
            state.status == BluetoothStatus.permissionsMissing) {
          appLogger.d(
            '$_logTag bluetooth READY => case callback onBluetoothReady',
          );
          state = state.copyWith(status: BluetoothStatus.stopped);
          // Appel du callback si défini
          if (onBluetoothReady != null) {
            await Future.delayed(const Duration(seconds: 1), () {});

            await onBluetoothReady();
          }
        }
      }
    });
  }

  void stopWatchAdapterState() async {
    await safeCancel(_adapterSub);
    _adapterSub = null;
  }

  Future<void> setStateBluetoothDisabled() async {
    await stopScanning(
      nextState: state.copyWith(status: BluetoothStatus.bluetoothDisabled),
    );
  }

  /// Scan avec filtrage et enrichissement des devices
  Future<void> scanAndFilterDevices({
    int? minRssi,
    bool onlyDb = false,
    bool onlyNew = false,
    void Function(ShowerheadDevice)? autoConnect,
  }) async {
    appLogger.d(
      '$_logTag scanAndFilterDevices called : status=${state.status}',
    );

    if (_isStopping) return;
    if (state.status == BluetoothStatus.bluetoothDisabled) return;

    // Check Adapter state
    var adapterState = await _bleRepository.adapterState().first;
    if (adapterState == BleAdapterState.off) {
      await stopScanning(
        nextState: state.copyWith(status: BluetoothStatus.bluetoothDisabled),
      );
      return;
    }

    await stopScanning(
      nextState: state.copyWith(status: BluetoothStatus.bluetoothChecking),
    );

    // Check permissions
    if (_isStopping) return;
    final granted = await _bleRepository.checkPermissions();
    if (!granted) {
      await stopScanning(
        nextState: state.copyWith(
          status: BluetoothStatus.permissionsMissing,
          missingPermissions: _bleRepository.getMissingPermissions(),
        ),
      );
      return;
    }
    if (adapterState == BleAdapterState.unauthorized) {
      // for iOS
      await stopScanning(
        nextState: state.copyWith(
          status: BluetoothStatus.permissionsMissing,
          missingPermissions: ["bluetoothScan"],
        ),
      );
      return;
    }
    appLogger.t('$_logTag scanAndFilterDevices after checkPermissions');

    appLogger.t('$_logTag scanAndFilterDevices after stopScanning');
    _startScanPending = true;

    // listen bluetooth adapter state to start scan whean ready
    _adapterForScanSub = _bleRepository.adapterState().listen((
      adapterState,
    ) async {
      if (_isStopping) return;

      if (adapterState == BleAdapterState.on &&
          state.status == BluetoothStatus.readyToScan &&
          _startScanPending == true) {
        appLogger.d('$_logTag starting initial scan');
        _startScanPending = false;
        await _bleRepository.startScan(
          namesFilter: [AppConstants.bleShowerheadName],
          timeoutInSeconds: AppConstants.bleScanTimeout,
        );
      }
    });
    appLogger.t('$_logTag scanAndFilterDevices after listenAdapterState');

    // Watch DB showerheads reactively so the inDb flag stays fresh during scan
    if (_isStopping) return;
    final dbCompleter = Completer<void>();
    await safeCancel(_dbShsSub);
    _dbShsSub = _dbRepository.watchShowerheads().listen((dbShs) {
      _dbShsById = {for (var sh in dbShs) sh.id: sh};
      if (!dbCompleter.isCompleted) dbCompleter.complete();
    });
    await dbCompleter.future;
    appLogger.t('$_logTag scanAndFilterDevices after retreiveDbShowerheads');

    // init debouncer for detected devices
    if (_devicesDebouncer != null) {
      _devicesDebouncer!.dispose();
      _devicesDebouncer = null;
    }
    _devicesDebouncer = Debouncer<List<ShowerheadDevice>>(
      duration: const Duration(seconds: 1),
      equals: (a, b) => const ListEquality<ShowerheadDevice>().equals(a, b),
      onDebounced: (stableDevices) {
        _onDetectedDevices(devices: stableDevices, autoConnect: autoConnect);
      },
    );

    // Listen detected devices
    if (_isStopping) return;
    _detectedDevicesSub = _bleRepository.detectedDevices().listen((
      scannedDevices,
    ) async {
      if (_isStopping) return;

      if (state.status != BluetoothStatus.scanning &&
          state.status != BluetoothStatus.devicesDetected) {
        return;
      }

      appLogger.t(
        '$_logTag on devices detected ${scannedDevices.length} : btStatus=${state.status}',
      );

      if (scannedDevices.isNotEmpty) {
        var filtered = scannedDevices.map((device) {
          final dbSh = _dbShsById[device.id];

          return device.copyWith(
            name: dbSh?.name,
            inDb: dbSh != null,
            type: dbSh?.type,
            lastSeen: dbSh?.lastSeen,
            thresholds: dbSh?.threshold,
          );
        }).toList();

        // apply filters
        if (minRssi != null) {
          filtered = filtered.where((d) => d.rssi >= minRssi).toList();
        }

        if (onlyDb) {
          filtered = filtered.where((d) => d.inDb).toList();
        }

        if (onlyNew) {
          filtered = filtered.where((d) => !d.inDb).toList();
        }

        // sort by distance (nearest first)
        filtered.sort((a, b) => b.rssi.compareTo(a.rssi));

        if (filtered.isNotEmpty) {
          appLogger.d('$_logTag Scanning : ${filtered.length} devices found');
          appLogger.d('$filtered');

          _devicesDebouncer!.update(List.unmodifiable(filtered));
        } else {
          appLogger.d('$_logTag Scanning : devices found but filtered out');
          _devicesDebouncer!.update(List.unmodifiable(filtered));
        }
      } else {
        _devicesDebouncer!.update(List.unmodifiable([]));
      }
    });
    appLogger.t('$_logTag scanAndFilterDevices after listenDetectedDevices');

    // Listen scanning status
    if (_isStopping) return;
    _scanningSub = _bleRepository.isScanning.listen((isScanning) async {
      if (_isStopping) return;
      if (_startScanPending) return;

      appLogger.t(
        '$_logTag scanning status changed : ${isScanning ? 'RUNNING' : 'STOPPED'} (current btStatus=${state.status}, nbDevicesFound=${state.detectedDevices.length})',
      );

      if (isScanning) {
        // Le scan vient de démarrer
        if (state.status == BluetoothStatus.readyToScan) {
          state = state.copyWith(status: BluetoothStatus.scanning);
        }
      } else {
        // Le scan vient de s'arrêter
        appLogger.d('$_logTag scanning stopped');

        // Attendre que le BLE stack se nettoie
        await Future.delayed(const Duration(milliseconds: 800), () {});

        // Vérifier si on doit relancer (seulement si pas en cours de connexion)
        if (state.status == BluetoothStatus.scanning ||
            state.status == BluetoothStatus.devicesDetected) {
          final adapterState = await _bleRepository.adapterState().first;
          if (adapterState == BleAdapterState.on) {
            try {
              appLogger.d('$_logTag auto-restart scan');
              await Future.delayed(
                Duration(milliseconds: 300),
                () {},
              ); // to limit detectedDevices empty on restart scan
              await _bleRepository.startScan(
                namesFilter: [AppConstants.bleShowerheadName],
                timeoutInSeconds: AppConstants.bleScanTimeout,
              );
            } catch (e) {
              appLogger.e('$_logTag re-start scan FAILED', error: e);
            }
          }
        }
      }
    });
    appLogger.t('$_logTag scanAndFilterDevices after listenIsScanning');

    if (_isStopping) return;
    state = state.copyWith(status: BluetoothStatus.readyToScan);

    // start scan if adapter was already ON at entry (listener only fires on transitions)
    if (_isStopping) return;
    if (adapterState == BleAdapterState.on && _startScanPending) {
      appLogger.d('$_logTag starting initial scan');
      try {
        _startScanPending = false;
        await _bleRepository.startScan(
          namesFilter: [AppConstants.bleShowerheadName],
          timeoutInSeconds: AppConstants.bleScanTimeout,
        );
      } catch (e) {
        appLogger.e('$_logTag start scan FAILED : $e');
      }
    }
  }

  Future<void> stopAutoConnect() async {
    // clean autoConnect
    _autoConnectTimer?.stop();
    _autoConnectTimer = null;
    _autoConnectDeviceId = null;
  }

  /// Méthode pour stopper proprement le scan
  Future<void> stopScanning({
    ShowerheadState? nextState,
    bool autoRestartScan = false,
  }) async {
    if (_isStopping == true) return;

    appLogger.d(
      '$_logTag stopScanning begin... => next status ${nextState?.status ?? BluetoothStatus.stopped}',
    );
    _isStopping = true;

    _startScanPending = false;
    _isLiveRunning = false;

    _devicesDebouncer?.dispose();
    _devicesDebouncer = null;
    await stopAutoConnect();
    await _cleanSubscriptions();
    _stopWatchPermissions();

    try {
      appLogger.t('$_logTag stopScanning / try stop scan');
      await _bleRepository.stopScan();

      // wait BLE stack finished
      await Future.delayed(const Duration(milliseconds: 200), () {});
    } catch (e) {
      // nothing to do
    }

    if (nextState?.status == BluetoothStatus.permissionsMissing &&
        Platform.isAndroid) {
      _watchPermissions(() async {
        // CASE : permissions ok
        await stopScanning();
      });
    }

    if (nextState?.status != BluetoothStatus.connecting) {
      String? deviceIdToDisconnect;
      if (_connectingDeviceId != null) {
        deviceIdToDisconnect = _connectingDeviceId;
      } else if (state.connectedDevice != null) {
        deviceIdToDisconnect = state.connectedDevice?.id;
      }

      if (deviceIdToDisconnect != null) {
        try {
          await _bleRepository.disconnectDevice(deviceIdToDisconnect);

          await Future.delayed(const Duration(milliseconds: 200), () {});
        } catch (e) {
          // nothing to do
        }
      }
      _connectingDeviceId = null;
    }

    _isStopping = false;

    // update state
    // appLogger.t('$LOG_TAG stopScanning / before update status');

    nextState ??= state.copyWith(status: BluetoothStatus.stopped);
    state = nextState;

    appLogger.d('$_logTag stopScanning end with new status=${state.status}');
  }

  void updateSoaping(double progress) {
    state = state.copyWith(soapingProgress: progress);
  }

  bool canStartSoaping() {
    return state.lastConnectedDeviceId != null && state.soapingProgress == null;
  }

  void startSoaping(VoidCallback onStop, {int? pauseDurationInSeconds}) {
    if (state.lastConnectedDeviceId == null || state.soapingProgress != null) {
      return;
    }

    int duration = AppConstants.soapingTimeInSeconds;

    if (_soapingTimer != null) {
      //FIXME : init with progress from remainingSeconds and not with duration = remainingSeconds
      final remaining = _soapingTimer!.remainingSeconds.toInt();
      duration = pauseDurationInSeconds == null
          ? remaining
          : (remaining - pauseDurationInSeconds).clamp(0, remaining);

      _soapingTimer?.stop();
    }

    _soapingTimer = ProgressTimer(
      durationInSeconds: duration,
      onProgress: (progress) {
        // appLogger.t(
        //   '$LOG_TAG update soaping progress : $progress / remaining seconds=${_soapingTimer?.remainingSeconds}',
        // );
        updateSoaping(progress);
      },
      onTimeout: () {
        stopSoaping();
        onStop();
      },
    );
    _soapingTimer?.start();
    updateSoaping(0);
    appLogger.d('$_logTag soaping started');
  }

  void pauseSoaping() {
    _soapingTimer?.pause();
    appLogger.d('$_logTag soaping paused');
  }

  bool isSoapingRunning(int? pauseDurationInSeconds) {
    if (_soapingTimer == null || _soapingTimer!.remainingSeconds == 0) {
      return false;
    }

    return pauseDurationInSeconds == null ||
        pauseDurationInSeconds < _soapingTimer!.remainingSeconds.toInt();
  }

  Future<void> stopSoaping({bool resetVolume = false}) async {
    _soapingTimer?.stop();
    _soapingTimer = null;

    if (state.lastConnectedDeviceId != null && resetVolume == true) {
      Showerhead? dbSh = await _dbRepository.getShowerhead(
        state.lastConnectedDeviceId!,
      );
      if (dbSh != null) {
        // -- indicates to sh to reset volume on next connection
        appLogger.w('$_logTag active need reset volume');
        await _dbRepository.saveShowerhead(
          ShowerheadsCompanion(
            // required data
            id: Value(dbSh.id),
            name: Value(dbSh.name),
            type: Value(dbSh.type),
            // updated fields
            needResetVolume: Value(true),
          ),
        );
      }
    }

    if (state.soapingProgress != null || state.lastConnectedDeviceId != null) {
      state = state.copyWith(resetSoaping: true);
    }

    appLogger.d('$_logTag soaping stopped');
  }

  Future<void> disconnect() async {
    if (state.status == BluetoothStatus.connected &&
        state.connectedDevice != null) {
      try {
        await _bleRepository.disconnectDevice(state.connectedDevice!.id);
      } catch (e) {
        appLogger.e('$_logTag disconnect device FAILED : $e');
      }
    }
  }

  /// connect to a new showerhead (for install)
  Future<void> connectNewSh(ShowerheadDevice newSh) async {
    ShowerheadsCompanion shCompanion;

    try {
      await stopAutoConnect();

      await _connectDevice(newSh);

      // await Future.delayed(const Duration(milliseconds: 300));

      var uuid = await _readUuid(newSh);
      var hwVersion = await _readHwVersion(newSh);
      var fwVersion = await _readFwVersion(newSh);
      var thresholds = await _readThresholds(newSh);
      var showersMinMax = await _readShowersMinMax(newSh);
      var calibration = await _readCalibration(newSh);

      if (thresholds == null) {
        List<HydraoThreshold> defaultThresholds = thresholdsFromJson(
          AppConstants.shDefaultThresholds,
        )!;
        // send default thresholds
        await _writeThresholds(newSh, defaultThresholds);

        thresholds = defaultThresholds;
      }

      // fix min & max index
      int? showersIdMin;
      int? showersIdMax;
      if (showersMinMax?.length == 2) {
        showersIdMin = showersMinMax?[0];
        showersIdMax = showersMinMax?[1];
      }
      if (showersIdMin == 0 && showersIdMax == 0) {
        // case NO SHOWERS
        showersIdMin = null;
        showersIdMax = null;
      } else if (showersIdMin == 0 &&
          showersIdMax != null &&
          showersIdMax > 0) {
        // case MIN = 0 => fix min to 1
        showersIdMin = 1;
      }

      // fix hwVersion
      int? fixedHwVersion = hwVersion != null ? int.tryParse(hwVersion) : null;

      // try to read live flow
      appLogger.d('$_logTag analyze flow from liveShower...');
      await Future.delayed(const Duration(seconds: 2), () {});

      int liveRetries = 0;
      var liveShower = await _readLiveShower(newSh);
      while (liveShower == null && liveRetries < 6) {
        await Future.delayed(const Duration(seconds: 2), () {});
        liveShower = await _readLiveShower(newSh);
        liveRetries++;
      }
      double? flow;
      if (liveShower != null && calibration != null) {
        flow = rawFlowToLitersByMinuteFlow(
          liveShower.flow,
          calibration,
          fixedHwVersion,
        );

        appLogger.d('$_logTag flow detected = $flow');
      } else {
        appLogger.d('$_logTag flow NOT DETECTED');
      }

      shCompanion = ShowerheadsCompanion.insert(
        id: newSh.id,
        type: "unknown",
        name: "unknown",
        fwVersion: Value(fwVersion),
        hwVersion: Value(fixedHwVersion),
        uuid: Value(uuid),
        threshold: Value(thresholdsToJson(thresholds)),
        lastSyncMinIndex: Value(showersIdMin),
        lastSyncMaxIndex: Value(showersIdMax),
        lastRssi: Value(newSh.rssi),
        calibration: Value(calibration),
        liveFlow: Value(flow),
      );

      _connectingDeviceId = null;
      state = state.copyWith(
        status: BluetoothStatus.connected,
        lastConnectedDeviceId: newSh.id,
        deviceToAdd: shCompanion,
      );
    } catch (e) {
      appLogger.e('$_logTag connectNewSh ${newSh.id} FAILED : $e');

      await stopScanning();
    }
  }

  /// connect to known showerhead (for config / live)
  Future<void> connectDbSh(ShowerheadDevice sh) async {
    try {
      final dbSh = await _dbRepository.getShowerhead(sh.id);
      if (dbSh == null) {
        appLogger.e(
          '$_logTag connect FAILED : showerhead ${sh.id} not exists in local DB',
        );
        return;
      }

      await stopAutoConnect();

      await _connectDevice(sh);

      await _runLiveShower(sh, dbSh);
    } catch (e) {
      appLogger.e('$_logTag connectKnownSh ${sh.id} FAILED : $e');

      await stopScanning();
    }
  }

  /// listen only to known showerheads
  Future<void> watchKnownShowerheads({
    void Function(ShowerheadDevice)? autoConnect,
  }) async {
    await scanAndFilterDevices(
      onlyDb: true,
      autoConnect: autoConnect,
      // minRssi: -80, // Règle métier : RSSI minimum
    );
  }

  /// listen only to unknown showerheads (for install)
  Future<void> watchNewShowerheads({
    void Function(ShowerheadDevice)? autoConnect,
  }) async {
    await scanAndFilterDevices(
      onlyNew: true,
      autoConnect: autoConnect,
      // minRssi: -80, // Règle métier : RSSI minimum
    );
  }

  Future<void> disconnectShowerhead(String deviceId) async {
    try {
      await _bleRepository.disconnectDevice(deviceId);
    } catch (e) {
      // nothing to do
    }
  }

  // --------------------------
  // --- PRIVATE METHODS
  // --------------------------

  Future<void> _watchPermissions(
    Future<void> Function() onPermissionsOk,
  ) async {
    if (_isWatchingPermissions) return;
    _isWatchingPermissions = true;
    while (_isWatchingPermissions) {
      await Future<void>.delayed(const Duration(seconds: 2));
      if (!_isWatchingPermissions) break;
      final granted = await _bleRepository.checkPermissions();
      if (granted) {
        _isWatchingPermissions = false;
        await onPermissionsOk();
      }
    }
  }

  void _stopWatchPermissions() {
    _isWatchingPermissions = false;
  }

  Future<void> _onDetectedDevices({
    required List<ShowerheadDevice> devices,
    void Function(ShowerheadDevice)? autoConnect,
  }) async {
    appLogger.t('$_logTag onDetectedDevices : devices=$devices');
    // manage autoConnect to nearest device
    if (autoConnect != null) {
      if (devices.length < 2) {
        await stopAutoConnect();

        if (devices.length == 1) {
          // CASE only one device detected => connect without timeout
          appLogger.d(
            '$_logTag onDetectedDevices / 1 device detected "${devices[0].id}" => autoConnecting...',
          );
          autoConnect(devices[0]);
        }
      } else {
        if ((_autoConnectDeviceId == null ||
                _autoConnectDeviceId != devices[0].id) ||
            (_autoConnectDeviceId == devices[0].id &&
                _autoConnectTimer?.isRunning == false)) {
          // CASE : many device detected => auto-connect to first nearest device after timeout
          _autoConnectDeviceId = devices[0].id;
          appLogger.d(
            '$_logTag onDetectedDevices / ${devices.length} devices detected => autoConnect to "$_autoConnectDeviceId" after ${AppConstants.bleAutoConnectAfterTimeout} seconds...',
          );

          _autoConnectTimer?.stop();

          _autoConnectTimer = ProgressTimer(
            durationInSeconds: AppConstants.bleAutoConnectAfterTimeout,
            onProgress: (progress) {
              final connectingDevice = state.detectedDevices
                  .firstWhereOrNull((d) => d.id == _autoConnectDeviceId)
                  ?.copyWith(autoConnectProgress: progress);
              if (connectingDevice != null) {
                state = state.copyWith(connectingDevice: connectingDevice);
              }
            },
            onTimeout: () {
              if (state.status == BluetoothStatus.devicesDetected) {
                final autoConnectDevice = state.detectedDevices
                    .firstWhereOrNull((d) => d.id == _autoConnectDeviceId);
                if (autoConnectDevice != null) {
                  appLogger.d(
                    '$_logTag auto connect to first sh $_autoConnectDeviceId after ${AppConstants.bleAutoConnectAfterTimeout} seconds',
                  );
                  appLogger.d(
                    '$_logTag onDetectedDevices / ${devices.length} devices detected => autoConnecting to "${autoConnectDevice.id}"...',
                  );
                  autoConnect(autoConnectDevice);
                }
              }
            },
          );
          _autoConnectTimer?.start();
        }
      }
    }

    // update state
    state = state.copyWith(
      status: devices.isNotEmpty
          ? BluetoothStatus.devicesDetected
          : BluetoothStatus.scanning,
      detectedDevices: devices,
    );
  }

  /// prepare connection to device
  Future<void> _connectDevice(ShowerheadDevice sh) async {
    //TODO check device in detected device or wait N second and recheck (restart scan case)
    await stopScanning(
      nextState: state.copyWith(
        status: BluetoothStatus.connecting,
        connectingDevice: sh.copyWith(connecting: true),
      ),
    );
    _connectingDeviceId = sh.id;

    await retry(
      "connectShowerhead ${sh.id} / ${sh.name}",
      () async {
        await _bleRepository.connectToDevice(
          sh.id,
          timeoutInSeconds: AppConstants.bleConnectTimeout,
        );
      },
      delayMs: 2000,
      shouldContinue: () {
        return state.status == BluetoothStatus.connecting;
      },
    );

    await safeCancel(_connectSub);
    _connectSub = _bleRepository.connectionState(sh.id).listen((
      connectionState,
    ) {
      switch (connectionState) {
        case BleConnectionState.connected:
          appLogger.d('$_logTag device #${sh.id} connected');
          break;
        case BleConnectionState.disconnected:
          appLogger.d(
            '$_logTag device #${sh.id} disconnected : currentStatus=${state.status}',
          );
          if (state.status == BluetoothStatus.connected ||
              state.status == BluetoothStatus.connecting) {
            state = state.copyWith(
              status: BluetoothStatus.stopped,
              detectedDevices: [],
              resetConnectedDevice: true,
            );
          }
          break;
        default:
          break;
      }
    });
  }

  Future<void> _cleanSubscriptions() async {
    appLogger.d('$_logTag _cleanSubscriptions called');

    await safeCancel(_adapterForScanSub);
    _adapterForScanSub = null;
    await safeCancel(_scanningSub);
    _scanningSub = null;
    await safeCancel(_detectedDevicesSub);
    _detectedDevicesSub = null;
    await safeCancel(_connectSub);
    _connectSub = null;
    await safeCancel(_dbShsSub);
    _dbShsSub = null;
  }

  // ---- DB actions

  Future<void> _updateShLive(Showerhead sh, RawLiveShower? liveShower) async {
    var flow = liveShower != null
        ? rawFlowToLitersByMinuteFlow(
            liveShower.flow,
            sh.getCalibration(),
            sh.hwVersion,
          )
        : null;
    if (flow != null && (flow.isNaN || flow.isInfinite)) {
      flow = null;
    }
    var liveShowerToUpdate = ShowerheadsCompanion(
      // required fields
      id: Value(sh.id),
      name: Value(sh.name),
      type: Value(sh.type),
      // updated fields
      liveDate: liveShower != null ? Value(DateTime.now()) : Value.absent(),
      liveDuration: liveShower != null && flow != null
          ? Value(computeDuration(liveShower.volume, flow))
          : Value(null),
      liveFlow: Value(flow),
      liveVolume: liveShower != null ? Value(liveShower.volume) : Value(0),
      liveTemperature: liveShower != null
          ? Value(rawTempToCelciusTemp(liveShower.temperature))
          : Value(null),
    );

    await _dbRepository.saveShowerhead(liveShowerToUpdate);

    appLogger.i(
      '$_logTag DB LIVE SHOWER UPDATED : volume=${liveShowerToUpdate.liveVolume.value} duration=${liveShowerToUpdate.liveDuration.value}',
    );
  }

  Future<void> _insertShShower(
    Showerhead sh,
    RawShower shower,
    List<HydraoThreshold>? currentThresholds,
  ) async {
    if (sh.uuid == null) {
      appLogger.e('$_logTag _insertShShower SKIPPED : showerhead uuid is null');
      return;
    }
    var flow = rawFlowToLitersByMinuteFlow(
      shower.flow,
      sh.getCalibration(),
      sh.hwVersion,
    );
    if (flow != null && (flow.isNaN || flow.isInfinite)) {
      flow = null;
    }

    // soaping time must not exceed limit
    var soapingTime = shower.soapingTime;
    if (soapingTime > AppConstants.shMaxSoapingTimeInSeconds) {
      soapingTime = AppConstants.shMaxSoapingTimeInSeconds;
    }

    var showerToInsert = ShowersCompanion(
      id: Value(shower.id),
      deviceId: Value(sh.uuid!),
      date: Value(DateTime.now()),
      volume: Value(shower.volume),
      flow: Value(flow),
      temperature: Value(rawTempToCelciusTemp(shower.temperature)),
      soapingTime: Value(soapingTime),
      duration: flow != null
          ? Value(computeDuration(shower.volume, flow))
          : Value(null),
      threshold: currentThresholds != null
          ? Value(thresholdsToJson(currentThresholds))
          : Value(null),
    );

    await _dbRepository.saveShower(showerToInsert);

    appLogger.i(
      '$_logTag DB SHOWER CREATED : id=${showerToInsert.id.value} volume=${showerToInsert.volume.value} duration=${showerToInsert.duration.value}',
    );
  }

  Future<void> _insertShEmptyShower(Showerhead sh, int showerId) async {
    if (sh.uuid == null) {
      appLogger.e('$_logTag _insertShEmptyShower SKIPPED : showerhead uuid is null');
      return;
    }
    var showerToInsert = ShowersCompanion(
      id: Value(showerId),
      deviceId: Value(sh.uuid!),
      date: Value(DateTime.now()),
      isEmpty: Value(true),
      volume: Value(0),
    );

    await _dbRepository.saveShower(showerToInsert);
  }

  // ---- Sync with device

  Future<void> _runLiveShower(ShowerheadDevice sh, Showerhead dbSh) async {
    _isLiveRunning = true;

    final (updatedDbSh, showersIdMin, showersIdMax, thresholds) =
        await _syncDeviceProps(sh, dbSh);
    dbSh = updatedDbSh;

    if (!_isLiveRunning) return;
    dbSh = await _applyThresholdPolicy(sh, dbSh, thresholds);

    if (!_isLiveRunning) return;
    dbSh = await _resetVolumeIfNeeded(sh, dbSh);

    appLogger.d('$_logTag reading first liveShower...');
    await _updateShLive(dbSh, await _readLiveShower(sh));

    if (!_isLiveRunning) return;
    if (showersIdMin != null && showersIdMax != null && showersIdMax > 0) {
      await _syncMissingShowers(sh, dbSh, showersIdMin, showersIdMax, thresholds);
    }

    state = state.copyWith(liveStatus: LiveStatus.live, resetLiveProgress: true);

    if (!_isLiveRunning) return;
    while (_isLiveRunning) {
      final liveShower = await _readLiveShower(sh);
      if (liveShower != null) await _updateShLive(dbSh, liveShower);
      await Future<void>.delayed(Duration(seconds: AppConstants.bleLiveTick));
    }
  }

  /// Lit les propriétés BLE, met à jour la DB et passe l'état en [connected].
  /// Retourne (dbSh mis à jour, idMin, idMax, seuils lus).
  Future<(Showerhead, int?, int?, List<HydraoThreshold>?)> _syncDeviceProps(
    ShowerheadDevice sh,
    Showerhead dbSh,
  ) async {
    final uuid = await _readUuid(sh);
    if (uuid != dbSh.uuid) {
      appLogger.e(
        '$_logTag DOUBLON same id/mac with different uuid : mac=${sh.id} DB_uuid=${dbSh.uuid} / BLE_uuid=$uuid',
      );
      //FIXME case iOS with false mac address...
    }

    final hwVersion = await _readHwVersion(sh);
    final fwVersion = await _readFwVersion(sh);
    final thresholds = await _readThresholds(sh);
    final showersMinMax = await _readShowersMinMax(sh);
    final calibration = await _readCalibration(sh);

    int? showersIdMin;
    int? showersIdMax;
    if (showersMinMax?.length == 2) {
      showersIdMin = showersMinMax![0];
      showersIdMax = showersMinMax[1];
    }
    if (showersIdMin == 0 && showersIdMax == 0) {
      showersIdMin = null;
      showersIdMax = null;
    } else if (showersIdMin == 0 && showersIdMax != null && showersIdMax > 0) {
      showersIdMin = 1;
    }

    final Value<String?> shThresholds =
        dbSh.baselineStatus == null &&
            thresholds != null &&
            thresholdsHasChanged(thresholdsFromJson(dbSh.threshold), thresholds)
        ? Value(thresholdsToJson(thresholds))
        : Value.absent();

    final int? parsedHwVersion = hwVersion != null ? int.tryParse(hwVersion) : null;
    final Value<int?> shHwVersion = hwVersion == null && dbSh.hwVersion != null
        ? Value(null)
        : parsedHwVersion != null && dbSh.hwVersion != parsedHwVersion
        ? Value(parsedHwVersion)
        : Value.absent();

    final Value<int?> baselineBeginIndex =
        dbSh.baselineStatus == LearningStatus.begin.toString()
        ? Value(showersIdMax)
        : Value.absent();

    await _dbRepository.saveShowerhead(
      ShowerheadsCompanion(
        id: Value(sh.id),
        name: Value(dbSh.name),
        type: Value(dbSh.type),
        lastSeen: Value(DateTime.now()),
        lastRssi: Value(sh.rssi),
        hwVersion: shHwVersion,
        fwVersion: dbSh.fwVersion != fwVersion ? Value(fwVersion) : Value.absent(),
        threshold: shThresholds,
        lastSyncMinIndex: dbSh.lastSyncMinIndex != showersIdMin
            ? Value(showersIdMin)
            : Value.absent(),
        lastSyncMaxIndex: dbSh.lastSyncMaxIndex != showersIdMax
            ? Value(showersIdMax)
            : Value.absent(),
        calibration: dbSh.calibration != calibration ? Value(calibration) : Value.absent(),
        baselineBeginIndex: baselineBeginIndex,
      ),
    );

    _connectingDeviceId = null;
    state = state.copyWith(
      status: BluetoothStatus.connected,
      connectedDevice: sh,
      connectedShowerhead: dbSh,
      lastConnectedDeviceId: sh.id,
    );

    return (dbSh, showersIdMin, showersIdMax, thresholds);
  }

  /// Envoie les seuils au device selon l'état du cycle d'apprentissage.
  Future<Showerhead> _applyThresholdPolicy(
    ShowerheadDevice sh,
    Showerhead dbSh,
    List<HydraoThreshold>? thresholds,
  ) async {
    List<HydraoThreshold>? thresholdToSend;
    bool hasNewBaselineStatus = false;
    String? newBaselineStatus;
    bool resetThresholdRequest = false;

    if (dbSh.baselineStatus == LearningStatus.begin.toString()) {
      newBaselineStatus = LearningStatus.learn.toString();
      hasNewBaselineStatus = true;
      thresholdToSend = thresholdsFromJson(AppConstants.shLearningThresholds);
    } else if (dbSh.baselineStatus == LearningStatus.end.toString()) {
      newBaselineStatus = null;
      hasNewBaselineStatus = true;
      if (dbSh.thresholdRequest != null) {
        thresholdToSend = thresholdsFromJson(dbSh.thresholdRequest);
        resetThresholdRequest = true;
      } else {
        thresholdToSend = thresholdsFromJson(dbSh.threshold);
      }
    } else if (dbSh.baselineStatus == null && dbSh.thresholdRequest != null) {
      thresholdToSend = thresholdsFromJson(dbSh.thresholdRequest);
      resetThresholdRequest = true;
    }

    final needChangeThresholds =
        thresholdToSend != null &&
        (thresholds == null || thresholdsHasChanged(thresholdToSend, thresholds));

    if (needChangeThresholds) {
      appLogger.i('$_logTag need to send new thresholds : $thresholdToSend');
      state = state.copyWith(liveStatus: LiveStatus.thresholds, liveProgress: 0.0);
      await _writeThresholds(sh, thresholdToSend);
      state = state.copyWith(liveStatus: LiveStatus.thresholds, liveProgress: 1.0);
    }

    if (needChangeThresholds || hasNewBaselineStatus) {
      final shUpdates = ShowerheadsCompanion(
        id: Value(sh.id),
        name: Value(dbSh.name),
        type: Value(dbSh.type),
        thresholdRequest: resetThresholdRequest ? Value(null) : Value.absent(),
        threshold: resetThresholdRequest
            ? Value(thresholdsToJson(thresholdToSend!))
            : Value.absent(),
        baselineStatus: hasNewBaselineStatus ? Value(newBaselineStatus) : Value.absent(),
      );
      await _dbRepository.saveShowerhead(shUpdates);
      dbSh = dbSh.copyWithCompanion(shUpdates);
    }

    return dbSh;
  }

  /// Réinitialise le volume si un savonnage a eu lieu.
  Future<Showerhead> _resetVolumeIfNeeded(
    ShowerheadDevice sh,
    Showerhead dbSh,
  ) async {
    if (dbSh.needResetVolume != true) return dbSh;

    appLogger.i('$_logTag need to reset volume after soaping');
    state = state.copyWith(liveStatus: LiveStatus.newShower, liveProgress: 0.0);

    await _resetVolume(sh);
    stopSoaping();

    final shUpdates = ShowerheadsCompanion(
      id: Value(sh.id),
      name: Value(dbSh.name),
      type: Value(dbSh.type),
      needResetVolume: Value(false),
    );
    await _dbRepository.saveShowerhead(shUpdates);
    dbSh = dbSh.copyWithCompanion(shUpdates);

    await Future<void>.delayed(const Duration(seconds: 1));
    state = state.copyWith(liveStatus: LiveStatus.newShower, liveProgress: 1.0);

    return dbSh;
  }

  /// Récupère les douches présentes sur le device mais absentes en DB.
  Future<void> _syncMissingShowers(
    ShowerheadDevice sh,
    Showerhead dbSh,
    int showersIdMin,
    int showersIdMax,
    List<HydraoThreshold>? thresholds,
  ) async {
    final showers = await _dbRepository.getShowers(shUuid: dbSh.uuid);
    //TODO manage shower id cycle if max < min
    final showerIdsToRetreive = await getShowerIdsToRetreive(
      dbSh,
      showersIdMin,
      showersIdMax,
      showers,
    );

    if (showerIdsToRetreive.isEmpty) return;

    appLogger.d('$_logTag try retreive showers : $showerIdsToRetreive');

    var shUpdates = ShowerheadsCompanion(
      id: Value(sh.id),
      name: Value(dbSh.name),
      type: Value(dbSh.type),
      lastSyncDate: Value(DateTime.now()),
      isLastSyncComplete: Value(false),
    );
    await _dbRepository.saveShowerhead(shUpdates);
    dbSh = dbSh.copyWithCompanion(shUpdates);

    final nbToRetreive = showerIdsToRetreive.length;
    var nbRetreived = 0;
    const liveEachNShowers = 5;
    var liveTick = 1;

    state = state.copyWith(liveStatus: LiveStatus.showers, liveProgress: 0.0);

    while (_isLiveRunning && showerIdsToRetreive.isNotEmpty) {
      final currentIndex = showerIdsToRetreive.removeAt(0);
      appLogger.d('$_logTag reading shower #$currentIndex...');

      final shower = await _readShower(sh, currentIndex);
      if (shower != null) {
        List<HydraoThreshold>? showerThresholds = thresholds;
        if (dbSh.baselineBeginIndex != null &&
            currentIndex > dbSh.baselineBeginIndex! &&
            (dbSh.baselineEndIndex == null ||
                currentIndex <= dbSh.baselineEndIndex!)) {
          showerThresholds = thresholdsFromJson(AppConstants.shLearningThresholds);
        }
        await _insertShShower(dbSh, shower, showerThresholds);
      } else {
        await _insertShEmptyShower(dbSh, currentIndex);
      }

      nbRetreived++;
      if (liveTick == liveEachNShowers) {
        state = state.copyWith(
          liveStatus: LiveStatus.showers,
          liveProgress: nbRetreived / nbToRetreive,
        );
        appLogger.d('$_logTag reading liveShower...');
        final liveShower = await _readLiveShower(sh);
        if (liveShower != null) await _updateShLive(dbSh, liveShower);
        liveTick = 1;
      } else {
        liveTick++;
      }
    }

    appLogger.i('$_logTag showersRetreived = $nbRetreived');

    await _dbRepository.saveShowerhead(
      ShowerheadsCompanion(
        id: Value(sh.id),
        name: Value(dbSh.name),
        type: Value(dbSh.type),
        lastSyncDate: Value(DateTime.now()),
        isLastSyncComplete: Value(true),
      ),
    );
  }

  Future<List<int>> getShowerIdsToRetreive(
    Showerhead dbSh,
    int showersIdMin,
    int showersIdMax,
    List<Shower> showers,
  ) async {
    List<int> showerIdsToRetreive = [];

    var showersIds = showers.map((s) => s.id).toSet();
    appLogger.d('$_logTag existing showers : $showersIds');

    showersIdMin = showersIdMin > 0 ? showersIdMin : 1;

    bool inLearning =
        dbSh.baselineStatus != null &&
        dbSh.baselineStatus == LearningStatus.learn.toString() &&
        dbSh.baselineBeginIndex != null;

    if (showersIdMax >= showersIdMin) {
      if (inLearning && dbSh.baselineBeginIndex! < showersIdMax) {
        // manage firstly reference showers
        for (
          var sid = dbSh.baselineBeginIndex! + 1;
          sid <= showersIdMax;
          sid++
        ) {
          if (!showersIds.contains(sid)) {
            showerIdsToRetreive.add(sid);
          }
        }
        showersIdMax = dbSh.baselineBeginIndex!;
      }

      // from <min> to <max>
      for (var sid = showersIdMin; sid <= showersIdMax; sid++) {
        if (!showersIds.contains(sid)) {
          showerIdsToRetreive.add(sid);
        }
      }
    } else {
      // Wrap-around case: range is [showersIdMin..65535] + [1..showersIdMax]
      int upperEnd = 65535;
      int lowerEnd = showersIdMax;

      if (inLearning &&
          dbSh.baselineBeginIndex! > showersIdMin &&
          dbSh.baselineBeginIndex! < upperEnd) {
        // baseline in upper segment: prioritize reference showers first
        for (var sid = dbSh.baselineBeginIndex! + 1; sid <= upperEnd; sid++) {
          if (!showersIds.contains(sid)) {
            showerIdsToRetreive.add(sid);
          }
        }
        upperEnd = dbSh.baselineBeginIndex!;
      }

      // upper segment [showersIdMin..upperEnd]
      for (var sid = showersIdMin; sid <= upperEnd; sid++) {
        if (!showersIds.contains(sid)) {
          showerIdsToRetreive.add(sid);
        }
      }

      if (inLearning &&
          dbSh.baselineBeginIndex! >= 1 &&
          dbSh.baselineBeginIndex! < lowerEnd) {
        // baseline in lower segment: prioritize reference showers first
        for (var sid = dbSh.baselineBeginIndex! + 1; sid <= lowerEnd; sid++) {
          if (!showersIds.contains(sid)) {
            showerIdsToRetreive.add(sid);
          }
        }
        lowerEnd = dbSh.baselineBeginIndex!;
      }

      // lower segment [1..lowerEnd]
      for (var sid = 1; sid <= lowerEnd; sid++) {
        if (!showersIds.contains(sid)) {
          showerIdsToRetreive.add(sid);
        }
      }
    }

    return showerIdsToRetreive;
  }

  Future<String?> _readUuid(ShowerheadDevice sh) async {
    final value = await _bleRepository.readCharacteristic(
      sh.id,
      AppConstants.bleReadUuid,
    );

    // clean value
    String uuid = "?-?-?-?-?";
    if (value.length == 16) {
      //Should be displayed 4b-2b-2b-2b-6b
      var listBuf = Uint8List.fromList(value).buffer.asByteData();
      List<String> parts = [];

      parts.add(
        listBuf.getUint32(0, Endian.little).toRadixString(16).padLeft(8, '0'),
      );
      parts.add(
        listBuf.getUint16(4, Endian.little).toRadixString(16).padLeft(4, '0'),
      );
      parts.add(
        listBuf.getUint16(6, Endian.little).toRadixString(16).padLeft(4, '0'),
      );
      parts.add(listBuf.getUint16(8, Endian.little).toRadixString(16).padLeft(4, '0'));
      parts.add(
        ((listBuf.getUint32(10, Endian.little)) +
                (listBuf.getUint16(14, Endian.little) << 32))
            .toRadixString(16)
            .padLeft(12, '0'),
      );

      uuid = parts.join('-');
      appLogger.t('$_logTag READ device UUID is on 16 bytes : $uuid');
      return uuid;
    } else if (value.length == 12) {
      final buf12 = Uint8List.fromList(value).buffer.asByteData();
      uuid = [
        buf12.getUint32(0, Endian.little).toRadixString(16).padLeft(8, '0'),
        buf12.getUint32(4, Endian.little).toRadixString(16).padLeft(8, '0'),
        buf12.getUint32(8, Endian.little).toRadixString(16).padLeft(8, '0'),
      ].join('-');
      appLogger.t(
        '$_logTag READ device UUID is on 12 bytes (legacy UUID) : $uuid',
      );
      return uuid;
    } else {
      appLogger.e('$_logTag ERROR: Wrong UUID size : ${value.length} bytes');
    }

    return null;
  }

  Future<String?> _readFwVersion(ShowerheadDevice sh) async {
    final value = await _bleRepository.readCharacteristic(
      sh.id,
      AppConstants.bleReadFirmware,
    );

    // clean value
    var version = const Utf8Decoder().convert(value).replaceAll('\x00', '').trim();
    appLogger.t('$_logTag READ fwVersion = $version');

    return version;
  }

  Future<String?> _readHwVersion(ShowerheadDevice sh) async {
    final value = await _bleRepository.readCharacteristic(
      sh.id,
      AppConstants.bleReadHardware,
    );

    // clean value
    if (value.isEmpty) {
      appLogger.e('$_logTag ERROR: Empty hardware version');
      return null;
    }
    var version = value[0].toString();
    appLogger.t('$_logTag READ HwVersion = $version');

    return version;
  }

  Future<void> _writeThresholds(
    ShowerheadDevice sh,
    List<HydraoThreshold> thresholds,
  ) async {
    if (thresholds.length < 4) {
      appLogger.e('$_logTag _writeThresholds : invalid thresholds count ${thresholds.length}');
      return;
    }
    List<int> data = [];

    for (int i = 0; i < 4; i++) {
      // Add liter
      data.add(thresholds[i].liter.toInt());

      // Add color
      final colorInt = int.tryParse(thresholds[i].color, radix: 16);
      if (colorInt == null) {
        appLogger.e('$_logTag _writeThresholds : invalid color "${thresholds[i].color}"');
        return;
      }
      final c = Color(colorInt);
      data.add((c.r * 255).round());
      data.add((c.g * 255).round());
      data.add((c.b * 255).round());
    }

    await _bleRepository.writeCharacteristic(
      sh.id,
      AppConstants.bleReadWriteThreshold,
      data,
    );
  }

  Future<void> _resetVolume(ShowerheadDevice sh) async {
    try {
      final Uint8List data = Uint8List(1);
      data[0] = 0x01;
      await _bleRepository.writeCharacteristic(
        sh.id,
        AppConstants.bleResetVolume,
        data.toList(),
      );
    } catch (e) {
      appLogger.t('$_logTag resetVolume error : $e');
      // the showerhead is resetted => sh reboot so exception ble received
    }
  }

  Future<List<HydraoThreshold>?> _readThresholds(ShowerheadDevice sh) async {
    final value = await _bleRepository.readCharacteristic(
      sh.id,
      AppConstants.bleReadWriteThreshold,
    );

    // clean value
    if (value.isEmpty) return null;
    if (value.length < 16) {
      appLogger.e('$_logTag ERROR: Wrong thresholds size : ${value.length} bytes');
      return null;
    }
    if (value.fold(0, (a, b) => a + b) == 0) {
      //threshold are not defined.
      return null;
    }
    var listBuf = Uint8List.fromList(value).buffer.asByteData();
    List<HydraoThreshold> thresholds = [];

    for (int i = 0; i < 4; i++) {
      StringBuffer br = StringBuffer();
      br.write(
        '${listBuf.getUint8(i * 4 + 1) < 16 ? '0' : ''}${listBuf.getUint8(i * 4 + 1).toRadixString(16)}',
      );
      br.write(
        '${listBuf.getUint8(i * 4 + 2) < 16 ? '0' : ''}${listBuf.getUint8(i * 4 + 2).toRadixString(16)}',
      );
      br.write(
        '${listBuf.getUint8(i * 4 + 3) < 16 ? '0' : ''}${listBuf.getUint8(i * 4 + 3).toRadixString(16)}',
      );

      var colorValue = br.toString().toUpperCase();
      var liter = listBuf.getUint8(i * 4);

      thresholds.add(
        HydraoThreshold(color: colorValue, liter: liter.toDouble()),
      );
    }

    appLogger.t('$_logTag READ Thresholds = $thresholds');

    return thresholds;
  }

  Future<List<int>?> _readShowersMinMax(ShowerheadDevice sh) async {
    final value = await _bleRepository.readCharacteristic(
      sh.id,
      AppConstants.bleReadHistoMinMax,
    );

    // clean value
    if (value.length < 4) {
      appLogger.e('$_logTag ERROR: Wrong showersMinMax size : ${value.length} bytes');
      return null;
    }
    var listBuf = Uint8List.fromList(value).buffer.asByteData();

    var min = listBuf.getUint16(0, Endian.little);
    var max = listBuf.getUint16(2, Endian.little);

    appLogger.t('$_logTag READ min = $min max = $max');

    return [min, max];
  }

  Future<int?> _readCalibration(ShowerheadDevice sh) async {
    final value = await _bleRepository.readCharacteristic(
      sh.id,
      AppConstants.bleReadWriteCalibration,
    );

    // clean value
    if (value.length < 2) {
      appLogger.e('$_logTag ERROR: Wrong calibration size : ${value.length} bytes');
      return null;
    }
    var listBuf = Uint8List.fromList(value).buffer.asByteData();
    int calibration = listBuf.getUint16(0, Endian.little);

    appLogger.t('$_logTag READ calibration = $calibration');

    return calibration;
  }

  Future<RawLiveShower?> _readLiveShower(ShowerheadDevice sh) async {
    // ask volume
    final volumeValue = await _bleRepository.readCharacteristic(
      sh.id,
      AppConstants.bleReadTotalLiter,
    );
    int liveLiter = (volumeValue.length < 3) ? 0 : volumeValue[2];

    if (liveLiter > 0) {
      // ask flow
      final flowValue = await _bleRepository.readCharacteristic(
        sh.id,
        AppConstants.bleReadFlow,
      );
      if (flowValue.length < 4) {
        appLogger.e('$_logTag ERROR: Wrong flow size : ${flowValue.length} bytes');
        return null;
      }
      var flowListBuf = Uint8List.fromList(flowValue).buffer.asByteData();
      var liveFlow = flowListBuf.getUint16(0, Endian.little);
      var liveAverageFlow = flowListBuf.getUint16(2, Endian.little);

      // ask temperature
      final tempValue = await _bleRepository.readCharacteristic(
        sh.id,
        AppConstants.bleReadTemperature,
      );
      if (tempValue.length < 4) {
        appLogger.e('$_logTag ERROR: Wrong temperature size : ${tempValue.length} bytes');
        return null;
      }
      var tempListBuf = Uint8List.fromList(tempValue).buffer.asByteData();
      var liveTemp = tempListBuf.getUint16(0, Endian.little);
      var liveAverageTemp = tempListBuf.getUint16(2, Endian.little);

      //FIXME faut-il récupérer le vmot, à quoi ça sert ?

      appLogger.t(
        '$_logTag READ liveShower : volume=$liveLiter, flow=$liveAverageFlow(instant=$liveFlow), temp=$liveAverageTemp(instant=$liveTemp)',
      );

      return RawLiveShower(
        volume: liveLiter,
        flow: liveAverageFlow,
        instantFlow: liveFlow,
        temperature: liveAverageTemp,
        instantTemperature: liveTemp,
      );
    } else {
      appLogger.d('$_logTag READ liveShower IGNORED : volume=0');
      return null;
    }
  }

  Future<RawShower?> _readShower(ShowerheadDevice sh, int showerIndex) async {
    // define which shower we need
    var writeListBuf = ByteData(2);
    writeListBuf.setUint16(0, showerIndex, Endian.little);
    await _bleRepository.writeCharacteristic(
      sh.id,
      AppConstants.bleWriteAskHisto,
      writeListBuf.buffer.asInt8List().toList(),
    );

    // ask shower
    final value = await _bleRepository.readCharacteristic(
      sh.id,
      AppConstants.bleReadHisto,
    );

    // clean value
    var listBuf = Uint8List.fromList(value).buffer.asByteData();

    if (value.length >= 6 && value.sublist(value.length - 6).every((b) => b == 0xFF)) {
      appLogger.e('$_logTag READ shower $showerIndex : UNREADABLE');
      return null;
    }

    int showerId = listBuf.getUint16(0, Endian.little);
    int litre = listBuf.getUint16(2, Endian.little);
    int? temp;
    int? flow;
    int? soapingTime;
    if (listBuf.lengthInBytes >= 7) {
      temp = listBuf.getUint8(4);
      flow = listBuf.getUint8(5);
      soapingTime = listBuf.getUint8(6);
    }

    if (litre > 0 && litre < 65535) {
      RawShower shower = RawShower(
        id: showerId,
        volume: litre,
        // date: DateTime.now(),
        flow: flow != null && flow > 0 ? (flow * 4) : null,
        soapingTime: soapingTime ?? 0,
        temperature: temp != null && temp > 0 ? temp : null,
      );
      appLogger.t(
        '$_logTag READ raw shower #$showerIndex : volume=$litre, flow=${shower.flow}, temp=${shower.temperature}, soapingTime=${shower.soapingTime}',
      );

      return shower;
    } else {
      appLogger.d('READ shower $showerIndex : CANCELED => volume = 0 or 65535');
      return null;
    }
  }
}
