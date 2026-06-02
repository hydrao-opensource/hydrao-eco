import 'package:hydrao_flutter_offline/models/showerhead_device.dart';
import 'package:hydrao_flutter_offline/repositories/ble/ble_adapter_state.dart';
import 'package:hydrao_flutter_offline/repositories/ble/ble_connection_state.dart';

abstract class IBleRepository {
  Stream<bool> get isScanning;
  Future<bool> checkPermissions();
  Future<bool> ensureBluetoothReady();
  List<String> getMissingPermissions();
  // Stream<List<ShowerheadDevice>> scanForDevices({
  //   int timeoutInSeconds,
  //   List<String>? namesFilter,
  // });
  Future<void> startScan({
    int timeoutInSeconds = 10,
    List<String>? namesFilter,
  });
  Future<void> stopScan();
  Stream<List<ShowerheadDevice>> detectedDevices();
  Future<void> connectToDevice(String deviceId);
  Future<void> disconnectDevice(String deviceId);
  Stream<BleConnectionState> connectionState(String deviceId);
  Future<bool> isCurrentlyConnected(String deviceId);
  Stream<BleAdapterState> adapterState();

  Future<List<int>> readCharacteristic(
    String deviceId,
    String characteristicUUID,
  );
  Future<void> writeCharacteristic(
    String deviceId,
    String characteristicUUID,
    List<int> value,
  );
}
