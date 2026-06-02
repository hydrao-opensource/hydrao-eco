import 'package:hydrao_flutter_offline/models/showerhead_device.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';

enum BluetoothStatus {
  stopped,
  bluetoothChecking,
  permissionsMissing,
  bluetoothDisabled,
  readyToScan,
  scanning,
  devicesDetected,
  connecting,
  connected,
}

enum LiveStatus { thresholds, showers, live, newShower }

class ShowerheadState {
  final BluetoothStatus status;
  final List<String> missingPermissions; // ex: ["bluetoothScan", "location"]
  final bool? bluetoothDisabled;
  final List<ShowerheadDevice> detectedDevices;
  final ShowerheadDevice? connectedDevice; // logic version of connected device
  final ShowerheadDevice?
  connectingDevice; // logic version of connecting device with autoConnect data
  final Showerhead? connectedShowerhead; // db version of connected device
  final ShowerheadsCompanion? deviceToAdd;
  final LiveStatus? liveStatus;
  final double? liveProgress; // between 0 and 1

  // for soaping
  final String? lastConnectedDeviceId;
  final double?
  soapingProgress; // null => no soaping, 0 - 1 soaping duration pourcent

  const ShowerheadState({
    this.status = BluetoothStatus.stopped,
    this.missingPermissions = const [],
    this.detectedDevices = const [],
    this.bluetoothDisabled,
    this.connectingDevice,
    this.connectedDevice,
    this.connectedShowerhead,
    this.deviceToAdd,
    this.liveStatus,
    this.liveProgress,
    this.lastConnectedDeviceId,
    this.soapingProgress,
  });

  ShowerheadState copyWith({
    BluetoothStatus? status,
    List<String>? missingPermissions,
    bool? bluetoothDisabled,
    List<ShowerheadDevice>? detectedDevices,
    ShowerheadDevice? connectedDevice,
    ShowerheadDevice? connectingDevice,
    Showerhead? connectedShowerhead,
    ShowerheadsCompanion? deviceToAdd,
    LiveStatus? liveStatus,
    double? liveProgress,
    String? lastConnectedDeviceId,
    double? soapingProgress,
    bool resetDeviceToAdd = false,
    bool resetConnectedDevice = false,
    bool resetConnectingDevice = false,
    bool resetLiveProgress = false,
    bool resetSoaping = false,
  }) {
    return ShowerheadState(
      status: status ?? this.status,
      missingPermissions: missingPermissions ?? this.missingPermissions,
      bluetoothDisabled: bluetoothDisabled ?? this.bluetoothDisabled,
      detectedDevices: detectedDevices ?? this.detectedDevices,
      connectingDevice: resetConnectingDevice
          ? null
          : connectingDevice ?? connectingDevice,
      connectedDevice: resetConnectedDevice
          ? null
          : connectedDevice ?? this.connectedDevice,
      connectedShowerhead: resetConnectedDevice
          ? null
          : connectedShowerhead ?? this.connectedShowerhead,
      deviceToAdd: resetDeviceToAdd ? null : deviceToAdd ?? this.deviceToAdd,
      liveStatus: liveStatus ?? this.liveStatus,
      liveProgress: resetLiveProgress
          ? null
          : liveProgress ?? this.liveProgress,
      lastConnectedDeviceId: resetSoaping
          ? null
          : lastConnectedDeviceId ?? this.lastConnectedDeviceId,
      soapingProgress: resetSoaping
          ? null
          : soapingProgress ?? this.soapingProgress,
    );
  }
}
