import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrao_flutter_offline/core/app_lifecycle_tracker.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/domains/app_domain.dart';
import 'package:hydrao_flutter_offline/domains/showerhead_domain.dart';
import 'package:hydrao_flutter_offline/domains/showerhead_state.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/models/showerhead_device.dart';
import 'package:hydrao_flutter_offline/providers.dart';
import 'package:hydrao_flutter_offline/theme.dart';
import 'package:hydrao_flutter_offline/ui/widgets/click_tooltip.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

enum ScanStatus { scan, soaping }

const _logTag = "[SCAN_MONITOR] ";

class ScanMonitor extends ConsumerStatefulWidget {
  const ScanMonitor({super.key});

  @override
  ConsumerState<ScanMonitor> createState() => _ScanMonitorState();
}

class _ScanMonitorState extends ConsumerState<ScanMonitor> {
  bool isScanPending = false;
  bool isDisposed = false;
  ShowerheadDomain? shDomain;
  AppDomain? appDomain;
  ScanStatus screenStatus = ScanStatus.scan;
  bool _isPaused = false;
  late AppLifecycleTracker _lifecycleTracker;

  // --- life cycle methods

  @override
  void initState() {
    super.initState();

    WakelockPlus.enable();

    shDomain = ref.read(showerheadDomainProvider.notifier);
    appDomain = ref.read(appDomainProvider.notifier);

    _lifecycleTracker = AppLifecycleTracker();
    _lifecycleTracker.listen(_handlePaused, _handleResumed);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (isDisposed || !context.mounted) return;

      shDomain?.watchAdapterState(
        () async {
          if (!isScanPending) {
            appLogger.d('$_logTag startScan on BleState ON');
            await startScan();
          }
        },
        () async {
          if (isDisposed || !context.mounted) return;
          await shDomain?.setStateBluetoothDisabled();
        },
      );
    });
  }

  @override
  void dispose() {
    isDisposed = true;
    _lifecycleTracker.dispose();

    try {
      Future.microtask(() {
        shDomain?.disconnect();
        shDomain?.stopScanning();
        shDomain?.stopSoaping();
        shDomain?.stopWatchAdapterState();
      });

      WakelockPlus.disable();
    } catch (e) {
      // nothing to do ?
    }

    super.dispose();
  }

  Future<void> _handleResumed(Duration? pauseDuration) async {
    appLogger.d(
      '$_logTag handle app resumed after ${pauseDuration?.inSeconds} seconds',
    );
    _isPaused = false;
    switch (screenStatus) {
      case ScanStatus.scan:
        startScan();
        break;
      case ScanStatus.soaping:
        if (shDomain?.isSoapingRunning(pauseDuration?.inSeconds) == true) {
          // case soaping not finished => restart soaping for remaining time - pause time
          startSoaping(pauseDurationInSeconds: pauseDuration?.inSeconds);
        } else {
          // case soaping delay exceeded => stop soaping
          stopSoaping();
          startScan();
        }
        break;
    }
  }

  Future<void> _handlePaused() async {
    appLogger.d('$_logTag handle app paused / background');
    _isPaused = true;
    switch (screenStatus) {
      case ScanStatus.scan:
        await shDomain?.stopScanning();
        break;
      case ScanStatus.soaping:
        shDomain?.pauseSoaping();
        await shDomain?.stopScanning();
        break;
    }
  }

  // --- Domain logic

  void startSoaping({int? pauseDurationInSeconds}) {
    if (isDisposed == true || shDomain?.canStartSoaping() == false) return;

    appLogger.i('$_logTag soaping starting...');

    void onStop() {
      setState(() {
        screenStatus = ScanStatus.scan;
      });
      startScan();
    }

    shDomain?.startSoaping(
      onStop,
      pauseDurationInSeconds: pauseDurationInSeconds,
    );

    setState(() {
      screenStatus = ScanStatus.soaping;
      appLogger.i('$_logTag soaping started');
    });
  }

  void stopSoaping() {
    appLogger.i('$_logTag soaping stopping...');
    if (isDisposed == true) return;

    setState(() {
      shDomain?.stopSoaping();
      screenStatus = ScanStatus.scan;
      appLogger.i('$_logTag soaping stopped');
    });
  }

  Future<void> _connectDevice(ShowerheadDevice device) async {
    stopSoaping();
    await shDomain?.connectDbSh(device);
    // await shDomain?.connectNewSh(device); //TODO
  }

  Future<void> startScan({bool restart = false}) async {
    if (isDisposed || !context.mounted || isScanPending == true) return;
    isScanPending = true;

    // to prevent quick restart scan
    await Future.delayed(const Duration(milliseconds: 200), () {});

    if (isDisposed) return;

    final current = ref.read(showerheadDomainProvider);
    if (current.status == BluetoothStatus.stopped) {
      appLogger.i(
        '$_logTag ${restart ? "restart" : "start"} search known showerhead',
      );

      await shDomain?.watchKnownShowerheads(
        autoConnect: (ShowerheadDevice device) async {
          await _connectDevice(device);
        },
      );
      // await shDomain?.watchNewShowerheads(
      //   autoConnect: (ShowerheadDevice device) async {
      //     await _connectDevice(device);
      //   },
      // );
    }
    isScanPending = false;
  }

  // --- ui methods

  @override
  Widget build(BuildContext context) {
    if (isDisposed || !context.mounted) {
      return const Center(child: CircularProgressIndicator());
    }

    final t = AppLocalizations.of(context)!;

    final shState = ref.watch(showerheadDomainProvider);
    final appState = ref.watch(appDomainProvider);

    appLogger.d(
      '$_logTag build : screenStatus=$screenStatus / shState.status=${shState.status} / appState.status=${appState.status} / shState.soapingProgress=${shState.soapingProgress} / shState.lastConnectedDeviceId=${shState.lastConnectedDeviceId}',
    );

    // reactive behaviors
    if (!isDisposed) {
      ref.listen<ShowerheadState>(showerheadDomainProvider, (
        previous,
        next,
      ) async {
        appLogger.t(
          '$_logTag state previous=${previous?.status.toString()} / next=${next.status.toString()}',
        );
        if (_isPaused == true) return;

        if (next.status == BluetoothStatus.stopped) {
          if (!isScanPending) {
            await startScan(restart: true);
          }
          startSoaping();
        }
      });
    }

    double contentSize = 24;
    String? image;
    String? message;
    Widget? content;
    if (shState.soapingProgress == null) {
      switch (shState.status) {
        case BluetoothStatus.permissionsMissing:
          image = "assets/images/location_disabled.png";
          message = t.showerheadDetectionBlocked;
          break;
        case BluetoothStatus.bluetoothDisabled:
          image = "assets/images/bluetooth_disabled.png";
          message = t.bluetoothDisabled;
          break;
        case BluetoothStatus.scanning:
        case BluetoothStatus.devicesDetected:
          // image = "assets/images/showerhead_search_white_1c.png";
          image = 'assets/images/showerhead_searching.png';
          message = t.dashboardScanningText;
          break;
        case BluetoothStatus.connecting:
          image = "assets/images/connecting.png";
          message =
              "${shState.connectingDevice?.name ?? t.defaultShowerheadName} : ${t.addShConnectingText}";
          break;
        case BluetoothStatus.connected:
          image = "assets/images/showerhead_live_white_2d.png";
          message =
              "${shState.connectedDevice!.name} : ${t.dashboardLiveShowerInProgress}";
          break;
        default:
          break;
      }
    } else {
      image = "assets/images/soaping_white_1.png";
      message = t.dashboardSoapingInProgress;
    }

    if (image != null) {
      Widget imageView = Image.asset(
        image,
        width: contentSize,
        height: contentSize,
        fit: BoxFit.contain,
      );

      if (message != null) {
        content = ClickTooltip(
          message: message,
          displayDuration: Duration(seconds: 2),
          child: imageView,
        );
      } else {
        content = imageView;
      }
    }

    return content ??
        Center(
          child: SizedBox(
            width: contentSize,
            height: contentSize,
            child: CircularProgressIndicator(
              color: AppTheme.scanSectionTextColor,
            ),
          ),
        );
  }
}
