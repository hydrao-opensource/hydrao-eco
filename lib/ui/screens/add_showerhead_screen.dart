import 'dart:async';

import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart' hide FormState;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrao_flutter_offline/core/app_lifecycle_tracker.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/domains/app_domain.dart';
import 'package:hydrao_flutter_offline/domains/app_state.dart';
import 'package:hydrao_flutter_offline/domains/form_domain.dart';
import 'package:hydrao_flutter_offline/domains/form_state.dart';
import 'package:hydrao_flutter_offline/domains/showerhead_domain.dart';
import 'package:hydrao_flutter_offline/domains/showerhead_state.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/models/learning_period.dart';
import 'package:hydrao_flutter_offline/models/showerhead_device.dart';
import 'package:hydrao_flutter_offline/providers.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/confirm_dialog.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/help_dialog.dart';
import 'package:hydrao_flutter_offline/ui/fragments/page/bluetooth_disabled_fragment.dart';
import 'package:hydrao_flutter_offline/ui/fragments/page/configure_showerhead_fragment.dart';
import 'package:hydrao_flutter_offline/ui/fragments/page/connecting_sh_fragment.dart';
import 'package:hydrao_flutter_offline/ui/fragments/page/install_new_sh_fragment.dart';
import 'package:hydrao_flutter_offline/ui/fragments/page/permissions_missing_fragment.dart';
import 'package:hydrao_flutter_offline/ui/fragments/page/scanning_sh_fragment.dart';
import 'package:hydrao_flutter_offline/ui/fragments/page/sh_connected_fragment.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

enum AddShowerheadStatus { install, scan, configure }

const _logTag = "[ADD_SHOWERHEAD_SCREEN] ";

class AddShowerheadScreen extends ConsumerStatefulWidget {
  const AddShowerheadScreen({super.key});

  @override
  ConsumerState<AddShowerheadScreen> createState() =>
      _AddShowerheadScreenState();
}

class _AddShowerheadScreenState extends ConsumerState<AddShowerheadScreen> {
  bool isScanPending = false;
  bool isDisposed = false;
  ShowerheadDomain? shDomain;
  ShowerheadsCompanion? newShowerhead;
  AppDomain? appDomain;
  FormDomain<ShowerheadsCompanion>? formDomain;
  AddShowerheadStatus screenStatus = AddShowerheadStatus.install;
  String shType = "aloe";
  bool _isLoading = true;
  final bool _autoConnect = true; //TODO
  bool _isPaused = false;
  late AppLifecycleTracker _lifecycleTracker;

  // --- life cycle methods

  @override
  void initState() {
    super.initState();

    WakelockPlus.enable();

    shDomain = ref.read(showerheadDomainProvider.notifier);
    appDomain = ref.read(appDomainProvider.notifier);
    formDomain = ref.read(shFormStateProvider.notifier);

    _lifecycleTracker = AppLifecycleTracker();
    _lifecycleTracker.listen(_handlePaused, _handleResumed);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadData();

      _updateUIForScreenStatus();

      shDomain?.watchAdapterState(
        () async {
          if (screenStatus != AddShowerheadStatus.scan) return;
          if (!isScanPending && newShowerhead == null) {
            appLogger.d('$_logTag startScan on BleState ON');
            await startScan();
          }
        },
        () async {
          // if (screenStatus != AddShowerheadStatus.scan) return;
          await shDomain?.setStateBluetoothDisabled();
        },
      );
    });
  }

  @override
  void dispose() {
    isDisposed = true;
    _lifecycleTracker.dispose();

    shDomain?.disconnect();
    shDomain?.stopScanning();
    shDomain?.stopWatchAdapterState();
    WakelockPlus.disable();

    super.dispose();
  }

  Future<void> _handleResumed(Duration? pauseDuration) async {
    appLogger.d('$_logTag handle app resumed');
    _isPaused = false;
    switch (screenStatus) {
      case AddShowerheadStatus.scan:
        startScan();
        break;
      case AddShowerheadStatus.install:
        break;
      case AddShowerheadStatus.configure:
        break;
    }
  }

  Future<void> _handlePaused() async {
    appLogger.d('$_logTag handle app paused / background');
    _isPaused = true;
    switch (screenStatus) {
      case AddShowerheadStatus.scan:
        await shDomain?.stopScanning();
        break;
      case AddShowerheadStatus.install:
        break;
      case AddShowerheadStatus.configure:
        break;
    }
  }

  // --- Domain logic

  Future<void> _connectDevice(
    ShowerheadDevice device, {
    bool forced = false,
  }) async {
    if (forced || _autoConnect) {
      await shDomain?.connectNewSh(device);
    }
  }

  Future<void> _loadData() async {
    if (!_isLoading) return;

    // final t = AppLocalizations.of(context)!;

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> startScan({bool restart = false}) async {
    if (screenStatus != AddShowerheadStatus.scan || newShowerhead != null) {
      return;
    }

    isScanPending = true;

    // to prevent quick restart scan
    await Future.delayed(const Duration(milliseconds: 200), () {});

    if (isDisposed) return;

    final current = ref.read(showerheadDomainProvider);
    if (current.status == BluetoothStatus.stopped) {
      appLogger.i(
        '$_logTag ${restart ? "restart" : "start"} search new showerhead',
      );
      await shDomain?.watchNewShowerheads(
        autoConnect: (ShowerheadDevice device) async {
          await _connectDevice(device);
        },
      );
    }
    isScanPending = false;
  }

  Future<void> _save() async {
    if (newShowerhead != null) {
      appLogger.i('$_logTag saving sh : name=${newShowerhead!.name}');

      // detect merge case here
      Showerhead? existingSh = checkExistingSh();

      final now = DateTime.now();
      ShowerheadsCompanion shToSave = (newShowerhead!.firstSeen.value == null)
          ? newShowerhead!.copyWith(firstSeen: Value(now), lastSeen: Value(now))
          : newShowerhead!;

      await appDomain?.saveShowerhead(shToSave);
      shDomain?.stopSoaping();
      if (_isMergeCase(existingSh)) {
        // remove previous sh with same uuid but different id (device replaced)
        await appDomain?.removeShowerhead(existingSh!.id, withShowers: false);
        appLogger.i('$_logTag sh merged');
      } else {
        appLogger.i('$_logTag sh saved');
      }
    }
  }

  // --- ui methods

  Future<void> changeScreenStatus(AddShowerheadStatus newStatus) async {
    if (mounted && screenStatus != newStatus) {
      if (newStatus == AddShowerheadStatus.configure && newShowerhead != null) {
        formDomain?.reset();
        final existingSh = checkExistingSh();
        if (existingSh != null) {
          newShowerhead = newShowerhead!.copyWith(
            name: Value(existingSh.name),
            previousFlow: Value(existingSh.previousFlow),
            thresholdRequest: Value(existingSh.thresholdRequest),
          );
        }
      }
      setState(() {
        appLogger.d('$_logTag changeScreenStatus $screenStatus => $newStatus');
        screenStatus = newStatus;
      });
      _updateUIForScreenStatus();
    }
  }

  void _updateUIForScreenStatus() {
    if (!mounted) return;

    final t = AppLocalizations.of(context)!;

    bool resetBackWarning = false;
    String? backButtonKey;
    void Function()? backButtonCallback;
    bool resetBottomButton = false;
    String? bottomButtonKey;
    String? bottomButtonText;
    void Function()? bottomButtonCallback;
    switch (screenStatus) {
      case AddShowerheadStatus.install:
        resetBackWarning = true;

        if (appDomain!.hasShowerheads()) {
          backButtonKey = "addShowerheadScreen.dashboardFromAddSh";
          backButtonCallback = () async {
            appDomain?.goToDashboard();
          };
        } else {
          backButtonKey = "addShowerheadScreen.settingsFromAddSh";
          backButtonCallback = () async {
            appDomain?.goToOnboarding();
          };
        }
        bottomButtonKey = "addShowerheadScreen.startScan";
        bottomButtonText = t.shInstalled;
        bottomButtonCallback = () async {
          await changeScreenStatus(AddShowerheadStatus.scan);
          appDomain?.hideBottomButton();
          await startScan();
        };
        break;
      case AddShowerheadStatus.scan:
        backButtonKey = "addShowerheadScreen.installFromScan";
        backButtonCallback = () async {
          if (newShowerhead == null ||
              await showConfirmDialog(
                    context: context,
                    message: t.addShBackWarningMessage,
                  ) ==
                  true) {
            changeScreenStatus(AddShowerheadStatus.install);
            shDomain?.stopSoaping();
          }
          await shDomain?.stopScanning();
          if (newShowerhead != null) {
            await shDomain?.disconnectShowerhead(newShowerhead!.id.value);
          }
          newShowerhead = null;
        };
        final btn = _scanBottomButton(t);
        bottomButtonKey = btn.key;
        bottomButtonText = btn.text;
        bottomButtonCallback = btn.callback;
        resetBottomButton = btn.reset;
        break;
      case AddShowerheadStatus.configure:
        resetBackWarning = true;

        // // init fake data only for tests
        // newShowerhead ??= ShowerheadsCompanion(
        //   id: Value(AppConstants.shFakeNewUuid), // inutile
        //   uuid: Value(AppConstants.shFakeNewUuid),
        //   fwVersion: Value(AppConstants.shFakeFwVersion),
        //   hwVersion: Value(AppConstants.shFakeHwVersion),
        //   threshold: Value(AppConstants.shDefaultThresholds),
        //   lastSyncMinIndex: Value(1),
        //   lastSyncMaxIndex: Value(35),
        // );
        backButtonKey = "addShowerheadScreen.installFromConfigure";
        backButtonCallback = () async {
          changeScreenStatus(AddShowerheadStatus.install);
          shDomain?.stopSoaping();
          newShowerhead = null;
          await shDomain?.stopScanning();
        };

        // bottomButtonKey = "addShowerheadScren.saveSh";
        // bottomButtonText = t.save;
        // bottomButtonCallback = null;
        break;
    }

    // appLogger.t(
    //   '$LOG_TAG SCREEN STATUS bottomKey=$bottomButtonKey, bottomCallback=$bottomButtonCallback, resetBottom=$resetBottomButton',
    // );

    appDomain?.updatePage(
      title: t.addShTitle,
      resetActions: true,
      resetBottomMenu: true,
      resetBackWarning: resetBackWarning,
      backButtonKey: backButtonKey,
      backButtonCallback: backButtonCallback,
      resetBottomButton: resetBottomButton,
      bottomButtonKey: bottomButtonKey,
      bottomButtonText: bottomButtonText,
      bottomButtonCallback: bottomButtonCallback,
    );
  }

  void _updateUIForStates(
    FormState<ShowerheadsCompanion> formState,
    AppState appState,
  ) {
    if (!mounted) return;

    final t = AppLocalizations.of(context)!;

    String? backButtomKey;
    void Function()? backButtonCallback;
    String? bottomButtonText;
    String? bottomButtonKey;
    void Function()? bottomButtonCallback;
    bool resetBottomButtonCallback = false;

    ShowerheadsCompanion? formChanges = formDomain?.getChanges();

    if (screenStatus == AddShowerheadStatus.configure) {
      // update if necessary newShowerhead from form changes
      List<String> formChangesKeys = [
        'name',
        'thresholdRequest',
        'previousFlow',
      ];
      if (formChanges != null &&
          !newShowerhead.equals(formChanges, keys: formChangesKeys)) {
        newShowerhead = newShowerhead?.mergeWith(formChanges);
      }

      // update screen back button
      appLogger.d('$_logTag update screen back button / changes=$formChanges');

      backButtomKey = (formChanges != null)
          ? "addShowerheadScreen.installFromConfigureWithConfirm"
          : "addShowerheadScreen.installFromConfigure";
      backButtonCallback = () async {
        bool canBack = true;
        if (formDomain!.needConfirmBeforeQuit()) {
          canBack = await showConfirmDialog(
            context: context,
            message: t.confirmCloseFormWithChanges,
          );
        }
        if (canBack == true) {
          changeScreenStatus(AddShowerheadStatus.install);
          newShowerhead = null;
          await shDomain?.stopScanning();
          shDomain?.stopSoaping();
        }
      };

      // update screen bottom button state
      final canSave = formDomain!.canSave();
      appLogger.d('$_logTag canSave=$canSave / errors=${formState.errors}');
      Showerhead? existingSh = checkExistingSh();
      bottomButtonText = _isMergeCase(existingSh) ? t.merge : t.save;
      bottomButtonKey = "addShowerheadScreen.saveSh";
      resetBottomButtonCallback = !canSave;
      bottomButtonCallback = canSave == true
          ? () async {
              // appLogger.t('$LOG_TAG try to save new showerhead');
              await _save();
            }
          : null;
      appLogger.t(
        '$_logTag CONFIGURE update bottom button key=$bottomButtonKey, callback=$bottomButtonCallback',
      );

      appDomain?.updatePage(
        backButtonKey: backButtomKey,
        backButtonCallback: backButtonCallback,
        bottomButtonKey: bottomButtonKey,
        bottomButtonText: bottomButtonText,
        bottomButtonCallback: bottomButtonCallback,
        resetBottomButtonCallback: resetBottomButtonCallback,
      );
    } else if (screenStatus == AddShowerheadStatus.scan) {
      final btn = _scanBottomButton(t);
      appDomain?.updatePage(
        resetBottomButton: btn.reset,
        bottomButtonKey: btn.key,
        bottomButtonText: btn.text,
        bottomButtonCallback: btn.callback,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final shState = ref.watch(showerheadDomainProvider);
    final appState = ref.watch(appDomainProvider);

    appLogger.d(
      '$_logTag build : screenStatus=$screenStatus / shState.status=${shState.status} / appState.status=${appState.status} / newSh=$newShowerhead',
    );

    ref.listen<FormState<ShowerheadsCompanion>>(shFormStateProvider, (_, _) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _updateUIForStates(
            ref.read(shFormStateProvider),
            ref.read(appDomainProvider),
          );
        }
      });
    });
    ref.listen<AppState>(appDomainProvider, (_, _) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _updateUIForStates(
            ref.read(shFormStateProvider),
            ref.read(appDomainProvider),
          );
        }
      });
    });

    // reactive behaviors
    ref.listen<ShowerheadState>(showerheadDomainProvider, (
      previous,
      next,
    ) async {
      if (isDisposed || screenStatus != AddShowerheadStatus.scan) return;

      appLogger.d(
        '$_logTag state previous=${previous?.status.toString()} / next=${next.status.toString()}',
      );

      if (_isPaused == true) return;
      if (next.status == BluetoothStatus.stopped) {
        if (newShowerhead != null) {
          // CASE : showerhead detected & connected & water stopped => configure new sh
          await changeScreenStatus(AddShowerheadStatus.configure);
        } else if (!isScanPending && newShowerhead == null) {
          // CASE : scan showerhead not started (after permissions / bluetooth OFF) => start scan
          await startScan(restart: true);
        }
      } else if (next.status == BluetoothStatus.connected) {
        // CASE : showerhead detected & connected => wait stop water
        newShowerhead = next.deviceToAdd?.copyWith(type: Value(shType));
        _updateUIForScreenStatus();
      }
    });

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // reactive view
    return Padding(
      padding: EdgeInsets.all(20),
      child: switch (screenStatus) {
        AddShowerheadStatus.install => InstallNewShFragment(
          type: shType,
          onTypeChanged: (newType) => shType = newType,
          onHelpTap: () =>
              appDomain?.showHelp(key: HelpCase.installNewSh, data: shType),
        ),
        AddShowerheadStatus.scan => switch (shState.status) {
          BluetoothStatus.stopped => const Center(
            child: CircularProgressIndicator(),
          ),

          BluetoothStatus.bluetoothChecking => const Center(
            child: CircularProgressIndicator(),
          ),

          BluetoothStatus.readyToScan => const Center(
            child: CircularProgressIndicator(),
          ),

          BluetoothStatus.permissionsMissing => PermissionsMissingFragment(),

          BluetoothStatus.bluetoothDisabled => BluetoothDisabledFragment(),

          BluetoothStatus.scanning => ScanningShFragment(
            message: t.addShScanningText,
            detectedDevices: [],
            onHelpTap: () => appDomain?.showHelp(key: HelpCase.shNotDetected),
          ),

          // BluetoothStatus.scanning => Center(
          //   child: ConnectingShFragment(message: t.addShConnectingText),
          // ),
          // BluetoothStatus.scanning => ShConnectedFragment(
          //   message: t.addShConnectedText,
          //   flow: 3.5,
          //   shType: "aloe",
          // ),
          BluetoothStatus.devicesDetected => ScanningShFragment(
            message: t.addShScanningText,
            detectedDevices: shState.detectedDevices,
            connectingDevice: shState.connectingDevice,
            onHelpTap: () => appDomain?.showHelp(key: HelpCase.shNotDetected),
            onDetectedDeviceTap: (device) async {
              appLogger.i('$_logTag detected device clicked : ${device.id}');
              await _connectDevice(device, forced: true);
            },
          ),

          BluetoothStatus.connecting => ConnectingShFragment(
            message: t.addShConnectingText,
          ),

          BluetoothStatus.connected => ShConnectedFragment(
            message: t.addShConnectedText,
            flow: newShowerhead?.liveFlow.value,
            shType: newShowerhead?.type.value,
          ),
        },
        AddShowerheadStatus.configure => Builder(builder: (_) {
          final existingSh = checkExistingSh();
          final sh = prepareNewShowerhead(existingSh: existingSh);
          if (sh == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ConfigureShowerheadForm(
            sh: sh,
            showers: appDomain!.getShowers(sh.id, notEmpty: true),
            existingShs: appState.showerheads ?? [],
            unit: appDomain!.getWaterUnit(),
            defaultName: appDomain!.getNewShowerheadName(
              Localizations.localeOf(context).toString(),
            ),
            usecase: _isMergeCase(existingSh) ? Usecase.merge : Usecase.add,
            onStopLearning: (LearningPeriod period) {},
            refreshShName: () => appDomain!.getNewShowerheadName(
              Localizations.localeOf(context).toString(),
            ),
          );
        }),
      },
    );
  }

  Showerhead? prepareNewShowerhead({Showerhead? existingSh}) {
    existingSh ??= checkExistingSh();

    if (newShowerhead == null) {
      final shState = ref.read(showerheadDomainProvider);
      newShowerhead = shState.deviceToAdd?.copyWith(type: Value(shType));
    }

    if (newShowerhead == null) return null;

    return Showerhead(
      id: newShowerhead!.id.value,
      name: existingSh != null ? existingSh.name : "",
      type: shType,
      indexCycleCount: existingSh != null ? existingSh.indexCycleCount : 0,
      uuid: newShowerhead!.uuid.value,
      fwVersion: newShowerhead!.fwVersion.value,
      hwVersion: newShowerhead!.hwVersion.value,
      threshold: newShowerhead!.threshold.value,
      lastSyncMinIndex: newShowerhead!.lastSyncMinIndex.value,
      lastSyncMaxIndex: newShowerhead!.lastSyncMaxIndex.value,
      lastRssi: newShowerhead!.lastRssi.value,
      lastSeen: newShowerhead!.lastSeen.value ?? DateTime.now(),
      liveFlow: newShowerhead!.liveFlow.value,

      // from existing
      firstSeen: existingSh?.firstSeen,
      previousFlow: existingSh?.previousFlow,
      isLastSyncComplete: existingSh?.isLastSyncComplete,
      lastSyncDate: existingSh?.lastSyncDate,
      liveVolume: existingSh?.liveVolume,
      liveDate: existingSh?.liveDate,
      liveDuration: existingSh?.liveDuration,
      liveTemperature: existingSh?.liveTemperature,
      thresholdRequest: existingSh?.thresholdRequest,
      calibration: existingSh?.calibration,
      baselineStatus: existingSh?.baselineStatus,
      baselineBeginIndex: existingSh?.baselineBeginIndex,
      baselineBeginDate: existingSh?.baselineBeginDate,
      baselineEndIndex: existingSh?.baselineEndIndex,
      baselineEndDate: existingSh?.baselineEndDate,
    );
  }

  ({bool reset, String? key, String? text, void Function()? callback})
  _scanBottomButton(AppLocalizations t) {
    if (newShowerhead != null) {
      return (
        reset: false,
        key: "addShowerheadScreen.startConfigure",
        text: t.toContinue,
        callback: () async {
          await shDomain?.stopScanning();
        },
      );
    }
    return (reset: true, key: null, text: null, callback: null);
  }

  Showerhead? checkExistingSh() {
    if (newShowerhead == null) return null;
    return appDomain!.getShowerheads().firstWhereOrNull(
      (dbSh) =>
          (dbSh.uuid == newShowerhead!.uuid.value &&
              dbSh.id != newShowerhead!.id.value) ||
          dbSh.id == newShowerhead!.id.value,
    );
  }

  // True only when the existing sh has a different id (device replaced, not re-added)
  bool _isMergeCase(Showerhead? existingSh) =>
      existingSh != null && existingSh.id != newShowerhead!.id.value;
}
