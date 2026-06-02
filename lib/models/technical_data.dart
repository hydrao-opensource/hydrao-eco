import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class TechnicalData {
  final String appVersion;
  final String appBuild;
  final String? deviceId;
  final String osName;
  final String osVersion;
  final String deviceName;
  final String deviceVersion;

  TechnicalData({
    required this.appVersion,
    required this.appBuild,
    this.deviceId,
    required this.osName,
    required this.osVersion,
    required this.deviceName,
    required this.deviceVersion,
  });

  static Future<TechnicalData> init() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceName = "Unknown";
    String deviceVersion = "Unknown";
    String osName = "Unknown";
    String osVersion = "Unknown";
    String? deviceId;

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceName = androidInfo.manufacturer;
      deviceVersion = androidInfo.model;
      osName = 'Android';
      osVersion = androidInfo.version.release;
      deviceId = androidInfo.id;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceName = iosInfo.name;
      deviceVersion = iosInfo.model;
      osName = 'iOS';
      osVersion = iosInfo.systemVersion;
      deviceId = iosInfo.identifierForVendor;
    }

    return TechnicalData(
      appVersion: packageInfo.version,
      appBuild: packageInfo.buildNumber,
      osName: osName,
      osVersion: osVersion,
      deviceName: deviceName,
      deviceVersion: deviceVersion,
      deviceId: deviceId,
    );
  }

  String getApp() {
    return '$appVersion (build: $appBuild)';
  }

  String getDevice() {
    return '$deviceName $deviceVersion';
  }

  String getOs() {
    return '$osName $osVersion';
  }
}
