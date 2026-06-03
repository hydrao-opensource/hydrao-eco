import 'dart:async';
import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:hydrao_flutter_offline/constants.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/models/showerhead_device.dart';
import 'package:hydrao_flutter_offline/repositories/ble/ble_adapter_state.dart';
import 'package:hydrao_flutter_offline/repositories/ble/ble_connection_state.dart';
import 'package:hydrao_flutter_offline/repositories/ble/iface_ble_repository.dart';
import 'package:hydrao_flutter_offline/utils.dart';
import 'package:permission_handler/permission_handler.dart';

const _logTag = "[BLE_REPOSITORY] ";

// Timeout applied to each individual BLE read/write operation.
const _operationTimeout = Duration(seconds: 10);

class BleRepository implements IBleRepository {
  // --- life cycle methods

  List<String> _missingPermissions = [];
  // Serializes concurrent checkPermissions() calls: all callers share the
  // in-flight Future so only one native permission dialog session is active.
  Future<bool>? _ongoingPermissionCheck;

  @override
  Stream<bool> get isScanning => FlutterBluePlus.isScanning;

  @override
  List<String> getMissingPermissions() {
    return List.unmodifiable(_missingPermissions);
  }

  @override
  Future<bool> ensureBluetoothReady() async {
    final adapterState = await FlutterBluePlus.adapterState.first;
    appLogger.d(
      '$_logTag bluetooth adaptater state = ${adapterState.toString()}',
    );
    return adapterState == BluetoothAdapterState.on ||
        adapterState == BluetoothAdapterState.unknown; // iOS
  }

  @override
  Future<bool> checkPermissions() {
    return _ongoingPermissionCheck ??= _doCheckPermissions().whenComplete(() {
      _ongoingPermissionCheck = null;
    });
  }

  Future<bool> _doCheckPermissions() async {
    _missingPermissions = [];
    final Map<String, Permission> permissions = {};

    if (Platform.isAndroid) {
      permissions['bluetoothScan'] = Permission.bluetoothScan;
      permissions['bluetoothConnect'] = Permission.bluetoothConnect;

      final locationStatus = await Permission.locationWhenInUse.status;
      if (locationStatus.isDenied || locationStatus.isPermanentlyDenied) {
        permissions["locationWhenInUse"] = Permission.locationWhenInUse;
      }
    } else if (Platform.isIOS) {
      return true;
    } else {
      return true;
    }

    // Request all permissions in one native call to avoid
    // "A request for permissions is already running" on Android.
    final statuses = await permissions.values.toList().request();
    for (final entry in permissions.entries) {
      if (statuses[entry.value]?.isGranted != true) {
        _missingPermissions.add(entry.key);
      }
    }

    return _missingPermissions.isEmpty;
  }

  @override
  Future<void> startScan({
    int timeoutInSeconds = 10,
    List<String>? namesFilter,
  }) async {
    final granted = await checkPermissions();
    if (!granted) {
      throw Exception('Missing BLE Permissions');
    }
    if (FlutterBluePlus.isScanningNow) {
      appLogger.w(
        '$_logTag startScan called while scan already running — ignored',
      );
      return;
    }

    final List<String> withNames = (namesFilter != null) ? namesFilter : [];

    await FlutterBluePlus.startScan(
      timeout: Duration(seconds: timeoutInSeconds),
      withNames: withNames,
    );
  }

  // FIX(P4): stream direct — élimine l'overhead du générateur async*
  @override
  Stream<List<ShowerheadDevice>> detectedDevices() =>
      FlutterBluePlus.scanResults.map(
        (results) => results
            .map(
              (r) => ShowerheadDevice(id: r.device.remoteId.str, rssi: r.rssi),
            )
            .toList(),
      );

  @override
  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
  }

  @override
  Future<void> connectToDevice(
    String deviceId, {
    int timeoutInSeconds = 10,
  }) async {
    final device = BluetoothDevice.fromId(deviceId);
    final isScanning = await FlutterBluePlus.isScanning.first;
    if (isScanning) {
      try {
        await stopScan(); // for compatibility with some devices
        await Future.delayed(Duration(milliseconds: 100), () {});
      } catch (e) {
        // nothing to do
      }
    }

    final deviceState = await device.connectionState.first;
    if (deviceState != BluetoothConnectionState.disconnected) {
      try {
        await device.disconnect();
        await Future.delayed(Duration(milliseconds: 100), () {});
      } catch (e) {
        // nothing to do
      }
    }
    _characteristics = null;
    _characteristicsDeviceId = null;
    await device.connect(
      autoConnect: false,
      timeout: Duration(seconds: timeoutInSeconds),
    );
  }

  @override
  Future<void> disconnectDevice(String deviceId) async {
    final device = BluetoothDevice.fromId(deviceId);
    _characteristics = null;
    _characteristicsDeviceId = null;
    await device.disconnect();
  }

  @override
  Stream<BleAdapterState> adapterState() {
    return FlutterBluePlus.adapterState.map((s) {
      switch (s) {
        case BluetoothAdapterState.unknown:
          return BleAdapterState.unknown;
        case BluetoothAdapterState.unavailable:
          return BleAdapterState.unavailable;
        case BluetoothAdapterState.unauthorized:
          return BleAdapterState.unauthorized;
        case BluetoothAdapterState.turningOn:
          return BleAdapterState.turningOn;
        case BluetoothAdapterState.on:
          return BleAdapterState.on;
        case BluetoothAdapterState.turningOff:
          return BleAdapterState.turningOff;
        case BluetoothAdapterState.off:
          return BleAdapterState.off;
      }
    });
  }

  @override
  Stream<BleConnectionState> connectionState(String deviceId) {
    final device = BluetoothDevice.fromId(deviceId);

    return device.connectionState.map((s) {
      switch (s) {
        case BluetoothConnectionState.connected:
          return BleConnectionState.connected;
        case BluetoothConnectionState.disconnected:
          return BleConnectionState.disconnected;
        default:
          return BleConnectionState.inProgress;
      }
    });
  }

  @override
  Future<bool> isCurrentlyConnected(String deviceId) async {
    final device = BluetoothDevice.fromId(deviceId);
    final connectionState = await device.connectionState.first;
    return connectionState == BluetoothConnectionState.connected;
  }

  // --- device operations

  List<BluetoothCharacteristic>? _characteristics;
  // FIX(P2): on mémorise le deviceId pour invalider le cache si l'appareil change
  String? _characteristicsDeviceId;
  final _queue = <Future<dynamic> Function()>[];
  bool _isProcessing = false;

  void clearWaitingOperations() {
    _queue.clear();
    // FIX(P1): ne pas toucher à _isProcessing — la boucle while dans _processQueue
    // détecte elle-même que la queue est vide et se termine proprement,
    // évitant deux boucles concurrentes si clearWaitingOperations est appelé
    // pendant qu'une opération est en cours.
  }

  @override
  Future<List<int>> readCharacteristic(
    String deviceId,
    String characteristicUUID,
  ) async {
    BluetoothCharacteristic? characteristic = await _findCharacteristicForUUID(
      deviceId,
      characteristicUUID,
    );
    if (characteristic == null) {
      throw Exception(
        '_findCharacteristicForUUID for $characteristicUUID FAILED',
      );
    }

    return _addOperation(() {
      return characteristic.read();
    });
  }

  /// write a characteristic (use queue)
  @override
  Future<void> writeCharacteristic(
    String deviceId,
    String characteristicUUID,
    List<int> value, {
    bool withoutResponse = false,
  }) async {
    // FIX(P0): null-check avant la fermeture — évite le crash `!` à l'intérieur de la queue
    BluetoothCharacteristic? characteristic = await _findCharacteristicForUUID(
      deviceId,
      characteristicUUID,
    );
    if (characteristic == null) {
      throw Exception(
        '_findCharacteristicForUUID for $characteristicUUID FAILED',
      );
    }

    return _addOperation(() {
      return characteristic.write(value, withoutResponse: withoutResponse);
    });
  }

  Future<BluetoothCharacteristic?> _findCharacteristicForUUID(
    String deviceId,
    String characteristicUUID,
  ) async {
    // FIX(P2): invalider le cache si le deviceId a changé
    if (_characteristics == null || _characteristicsDeviceId != deviceId) {
      await retry(
        "_getServiceCharacteristics",
        () async {
          await _getServiceCharacteristics(deviceId);
        },
        shouldContinue: () async {
          return await isCurrentlyConnected(deviceId);
        },
      );
    }
    if (_characteristics != null) {
      // FIX(P1): forEach au lieu de map — map est paresseux, les logs n'étaient jamais exécutés
      // _characteristics?.forEach((c) {
      // appLogger.d('$_logTag CHARACTERISTIC : ${c.toString()}');
      // });
      try {
        return _characteristics?.firstWhere(
          (c) => c.uuid.toString().toLowerCase() == characteristicUUID,
        );
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// discover hydrao showerhead bluetooth characteristics
  Future<void> _getServiceCharacteristics(
    String deviceId, {
    String serviceUuid = AppConstants.bleServiceUuid,
  }) async {
    final device = BluetoothDevice.fromId(deviceId);

    try {
      List<BluetoothService>? services = await device.discoverServices();
      BluetoothService? hydraoService = services.firstWhere(
        (s) => s.uuid.toString().toLowerCase() == serviceUuid,
      );

      appLogger.d(
        '$_logTag hydrao service found : ${hydraoService.toString()}',
      );

      _characteristics = hydraoService.characteristics;
      _characteristicsDeviceId = deviceId;
    } catch (e) {
      appLogger.e('$_logTag _getServiceCharacteristics FAILED : $e');
      _characteristics = null;
      _characteristicsDeviceId = null;
    }
  }

  Future<T> _addOperation<T>(Future<T> Function() operation) {
    final completer = Completer<T>();
    _queue.add(() async {
      try {
        // FIX(P3): timeout pour éviter un blocage infini si l'appareil devient non-réactif
        final result = await operation().timeout(_operationTimeout);
        completer.complete(result);
      } on TimeoutException catch (e) {
        appLogger.e("$_logTag BLE operation timed out: $e");
        completer.completeError(e);
      } catch (e, stack) {
        appLogger.e("$_logTag BLE operation failed: $e : $stack");
        completer.completeError(e);
      }
    });
    _processQueue();
    return completer.future;
  }

  void _processQueue() async {
    if (_isProcessing || _queue.isEmpty) return;
    _isProcessing = true;

    while (_queue.isNotEmpty) {
      final op = _queue.removeAt(0);
      await op();
      await Future.delayed(Duration(milliseconds: 50), () {});
    }

    _isProcessing = false;
  }
}
