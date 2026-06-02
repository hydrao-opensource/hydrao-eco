import 'dart:async';

import 'package:hydrao_flutter_offline/models/showerhead_device.dart';
import 'package:hydrao_flutter_offline/repositories/ble/ble_adapter_state.dart';
import 'package:hydrao_flutter_offline/repositories/ble/ble_connection_state.dart';
import 'package:hydrao_flutter_offline/repositories/ble/iface_ble_repository.dart';

class MockBleRepository implements IBleRepository {
  bool permissionsGranted = true;
  bool bluetoothEnabled = true;
  List<String> missing = [];

  final _devicesController =
      StreamController<List<ShowerheadDevice>>.broadcast();
  final _connectionStates = <String, StreamController<BleConnectionState>>{};
  final _adapterState = StreamController<BleAdapterState>.broadcast();
  final _isScanning = StreamController<bool>.broadcast();

  @override
  Future<bool> checkPermissions() async => permissionsGranted;

  @override
  Future<bool> ensureBluetoothReady() async => bluetoothEnabled;

  @override
  List<String> getMissingPermissions() => missing;

  @override
  Future<void> stopScan() async {
    _devicesController.add([]);
  }

  @override
  Future<void> connectToDevice(String deviceId) async {
    _getConnectionStream(deviceId).add(BleConnectionState.connected);
  }

  @override
  Future<void> disconnectDevice(String deviceId) async {
    _getConnectionStream(deviceId).add(BleConnectionState.disconnected);
  }

  @override
  Stream<BleConnectionState> connectionState(String deviceId) {
    return _getConnectionStream(deviceId).stream;
  }

  @override
  Stream<BleAdapterState> adapterState() {
    _adapterState.add(BleAdapterState.on);
    return _adapterState.stream;
  }

  StreamController<BleConnectionState> _getConnectionStream(String deviceId) {
    return _connectionStates.putIfAbsent(
      deviceId,
      () => StreamController<BleConnectionState>.broadcast(),
    );
  }

  @override
  Stream<List<ShowerheadDevice>> detectedDevices() {
    // simulation : envoie 2 devices puis rien
    Future.delayed(const Duration(milliseconds: 200), () {
      _devicesController.add([
        ShowerheadDevice(id: '1', name: 'FakeDevice1', rssi: -50),
        ShowerheadDevice(id: '2', name: 'FakeDevice2', rssi: -70),
      ]);
    });
    return _devicesController.stream;
  }

  @override
  Future<bool> isCurrentlyConnected(String deviceId) async {
    return true;
  }

  @override
  Stream<bool> get isScanning => _isScanning.stream;

  @override
  Future<void> startScan({
    int timeoutInSeconds = 10,
    List<String>? namesFilter,
  }) async {
    _isScanning.add(true);
  }

  @override
  Future<List<int>> readCharacteristic(
    String deviceId,
    String characteristicUUID,
  ) {
    // TODO: implement readCharacteristic
    throw UnimplementedError();
  }

  @override
  Future<void> writeCharacteristic(
    String deviceId,
    String characteristicUUID,
    List<int> value,
  ) {
    // TODO: implement writeCharacteristic
    throw UnimplementedError();
  }
}
