import 'dart:async';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrao_flutter_offline/constants.dart';
import 'package:hydrao_flutter_offline/conversions.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/domains/app_domain.dart';
import 'package:hydrao_flutter_offline/domains/app_state.dart';
import 'package:hydrao_flutter_offline/domains/showerhead_domain.dart';
import 'package:hydrao_flutter_offline/domains/showerhead_state.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/models/learning_period.dart';
import 'package:hydrao_flutter_offline/models/savings_stats.dart';
import 'package:hydrao_flutter_offline/models/showerhead_device.dart';
import 'package:hydrao_flutter_offline/providers.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';
import 'package:hydrao_flutter_offline/theme.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/configure_sh_dialog.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/help_dialog.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/savings_details_dialog.dart';
import 'package:hydrao_flutter_offline/ui/fragments/menu_fragment.dart';
import 'package:hydrao_flutter_offline/ui/fragments/partial/partial_bluetooth_disabled_fragment.dart';
import 'package:hydrao_flutter_offline/ui/fragments/partial/partial_connecting_sh_fragment.dart';
import 'package:hydrao_flutter_offline/ui/fragments/partial/partial_detected_sh_fragment.dart';
import 'package:hydrao_flutter_offline/ui/fragments/partial/partial_live_shower_fragment.dart';
import 'package:hydrao_flutter_offline/ui/fragments/partial/partial_permissions_missing_fragment.dart';
import 'package:hydrao_flutter_offline/ui/fragments/partial/partial_scanning_sh_fragment.dart';
import 'package:hydrao_flutter_offline/ui/fragments/partial/partial_soaping_fragment.dart';
import 'package:hydrao_flutter_offline/ui/widgets/custom_expansion_tile.dart';
import 'package:hydrao_flutter_offline/ui/widgets/db_showerhead_card.dart';
import 'package:hydrao_flutter_offline/ui/widgets/savings_stats_widget.dart';
import 'package:hydrao_flutter_offline/utils.dart';

const _logTag = "[DASHBOARD_SCREEN] ";

class DashboardScreen extends ConsumerStatefulWidget {
  final double availableHeight;
  const DashboardScreen({super.key, required this.availableHeight});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  late ShowerheadDomain shDomain;
  late AppDomain appDomain;

  // --- life cycle methods

  @override
  void initState() {
    super.initState();

    shDomain = ref.read(showerheadDomainProvider.notifier);
    appDomain = ref.read(appDomainProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _updateUI();
    });
  }

  // --- Domain logic

  Future<void> _connectDevice(ShowerheadDevice device) async {
    shDomain.stopSoaping();
    await shDomain.connectDbSh(device);
  }

  Future<void> startScan({bool restart = false}) async {
    if (!mounted) return;

    // prevent quick restart scan
    await Future<void>.delayed(const Duration(milliseconds: 200));

    if (!mounted) return;

    final current = ref.read(showerheadDomainProvider);
    if (current.status == BluetoothStatus.stopped) {
      appLogger.i(
        '$_logTag ${restart ? "restart" : "start"} search known showerhead',
      );

      await shDomain.watchKnownShowerheads(
        autoConnect: (ShowerheadDevice device) async {
          await _connectDevice(device);
        },
      );
    }
  }

  Future<void> saveSh(ShowerheadsCompanion changes) async {
    if (!mounted) return;

    appLogger.i('$_logTag saving sh...');
    await appDomain.saveShowerhead(changes);

    ref.read(showerheadTabSelectedProvider.notifier).state = 0;
    appLogger.i('$_logTag Sh saved');
  }

  Future<void> deleteSh(Showerhead sh) async {
    if (!mounted) return;

    final shName = appDomain.getShowerheadName(sh.id) ?? sh.name;
    appLogger.i('$_logTag deleting sh "$shName"...');
    await shDomain.disconnectShowerhead(sh.id);
    await appDomain.removeShowerhead(sh.id);

    ref.read(showerheadTabSelectedProvider.notifier).state = 0;

    // ignore: use_build_context_synchronously
    if (context.mounted && Navigator.canPop(context)) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }

    appLogger.i('$_logTag Sh deleted !');
  }

  Future<void> _showConfigureShDialog(Showerhead sh) async {
    await showConfigureShDialog(
      context: context,
      shId: sh.id,
      onSave: (ShowerheadsCompanion changes) async {
        await saveSh(
          changes.copyWith(
            id: drift.Value(sh.id),
            name: drift.Value(
              changes.name.present ? changes.name.value : sh.name,
            ),
            type: drift.Value(sh.type),
          ),
        );
        return true;
      },
      onDelete: () async {
        await deleteSh(sh);
      },
      onStopLearning: (LearningPeriod period) async {
        appLogger.i('$_logTag stop learning period : ${period.getShowerIds()}');
        await appDomain.stopLearningPeriodForShowerhead(
          sh.id,
          period.getShowerIds(),
          period.applyThresholds ? period.getNewThresholds() : null,
        );
        // ignore: use_build_context_synchronously
        if (context.mounted && Navigator.canPop(context)) {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
        }
      },
    );
  }

  // --- ui methods

  void _updateUI() {
    if (!mounted) return;

    appDomain.updatePage(
      resetTitle: true,
      resetBgColor: true,
      resetActions: true,
      resetBottomButton: true,
      resetBackButton: true,
      bottomMenu: Menu.dashboard,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appDomainProvider);
    final shState = ref.watch(showerheadDomainProvider);

    if (kDebugMode) {
      appLogger.d(
        '$_logTag build : shState.status=${shState.status} / appState.status=${appState.status}',
      );
    }

    final globalSavings = appDomain.getGlobalSavings();

    Widget? savingsSection;
    if (globalSavings.savedTotalMoney > 0) {
      savingsSection = buildSavingsSection(globalSavings);
    }

    return SizedBox(
      height: widget.availableHeight,
      child: Column(
        children: [
          buildListenSection(shState),
          ?savingsSection,
          Expanded(child: buildShowerheadsSection(appState, shState)),
        ],
      ),
    );
  }

  Widget buildListenSection(ShowerheadState shState) {
    final t = AppLocalizations.of(context)!;

    Widget content;

    if (shState.soapingProgress == null) {
      content = switch (shState.status) {
        BluetoothStatus.stopped ||
        BluetoothStatus.bluetoothChecking => Center(
          child: CircularProgressIndicator(
            color: AppTheme.scanSectionTextColor,
          ),
        ),
        BluetoothStatus.permissionsMissing =>
          PartialPermissionsMissingFragment(),
        BluetoothStatus.bluetoothDisabled => PartialBluetoothDisabledFragment(),
        BluetoothStatus.readyToScan => const Center(
          child: CircularProgressIndicator(),
        ),
        BluetoothStatus.scanning => PartialScanningShFragment(
          title: t.dashboardScanningText,
          message: t.dashboardScanningShStoreShowers,
          onHelpTap: () => appDomain.showHelp(key: HelpCase.shNotDetected),
        ),
        BluetoothStatus.devicesDetected => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PartialScanningShFragment(
              title: t.dashboardScanningText,
              message: t.dashboardScanningShStoreShowers,
              onHelpTap: () => appDomain.showHelp(key: HelpCase.shNotDetected),
            ),
            if (shState.detectedDevices.length > 1)
              Padding(
                padding: EdgeInsetsGeometry.only(
                  left: 10.0,
                  right: 10.0,
                  top: 10,
                  bottom: 5,
                ),
                child: PartialDetectedShFragment(
                  connectingDevice: shState.connectingDevice,
                  detectedDevices: shState.detectedDevices,
                  backgroundColor: Colors.white.withValues(alpha: 0.5),
                  onDeviceClicked: (device) async {
                    appLogger.i(
                      '$_logTag detected device clicked : ${device.id}',
                    );
                    await _connectDevice(device);
                  },
                ),
              ),
          ],
        ),
        BluetoothStatus.connecting => shState.connectingDevice == null
            ? const Center(child: CircularProgressIndicator())
            : PartialConnectingShFragment(
                name:
                    appDomain.getShowerheadName(shState.connectingDevice!.id) ??
                    t.defaultShowerheadName,
              ),
        BluetoothStatus.connected => shState.connectedDevice == null
            ? const Center(child: CircularProgressIndicator())
            : PartialLiveShowerFragment(
                shName:
                    appDomain.getShowerheadName(shState.connectedDevice!.id) ??
                    t.defaultShowerheadName,
                message: switch (shState.liveStatus) {
                  null => "",
                  LiveStatus.thresholds => t.dashboardLiveSendThresholds,
                  LiveStatus.showers => t.dashboardLiveSyncShowers,
                  LiveStatus.live => t.dashboardLiveShowerInProgress,
                  LiveStatus.newShower => t.dashboardLiveResetVolume,
                },
                thresholds: thresholdsFromJson(
                  appDomain.getShowerheadThresholds(
                        shState.connectedDevice!.id,
                      ) ??
                      AppConstants.shDefaultThresholds,
                ) ??
                    thresholdsFromJson(AppConstants.shDefaultThresholds)!,
                showVolume: appDomain.isShowerheadLiveRecent(
                  shState.connectedDevice!.id,
                ),
                volume: appDomain.getShowerheadLiveVolume(
                  shState.connectedDevice!.id,
                ),
                unit: appDomain.getWaterUnit(),
                progress: shState.liveProgress,
              ),
      };
    } else {
      content = PartialSoapingFragment(
        shName:
            appDomain.getShowerheadName(shState.lastConnectedDeviceId ?? '') ??
            t.defaultShowerheadName,
        progress: shState.soapingProgress!,
        onFinishTap: () async {
          shDomain.stopSoaping(resetVolume: true);
          await startScan(restart: true);
        },
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 120),
        decoration: BoxDecoration(
          color: AppTheme.scanSectionBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: content,
      ),
    );
  }

  Widget buildSavingsSection(SavingsStats savings) {
    final t = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 15.0, vertical: 6.0),
      child: CustomExpansionTile(
        title: t.dashboardSavingSectionTitle,
        onTitleHelpClicked: () {
          showSavingsDetailsDialog(
            context: context,
            stats: savings,
            details: t.dashboardSavingSectionDescription,
            waterUnit: appDomain.getWaterUnit(),
            currency: appDomain.getCurrency(),
          );
        },
        expanded: true,
        expandable: false,
        globalPadding: 12,
        trailingButton: Row(
          children: [
            Text(
              formatMoney(
                getCurrencyFromSymbol(
                  savings.savedTotalMoney,
                  appDomain.getCurrency(),
                ),
              ),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
            SizedBox(width: 4),
            Text(
              appDomain.getCurrency(),
              style: TextStyle(fontSize: 14, color: Colors.black54, height: 1),
            ),
          ],
        ),
        contentAlignement: CrossAxisAlignment.start,
        children: [
          SavingsStatsWidget(
            stats: savings,
            currency: appDomain.getCurrency(),
            waterUnit: appDomain.getWaterUnit(),
          ),
        ],
      ),
    );
  }

  Widget buildShowerheadsSection(AppState appState, ShowerheadState shState) {
    final t = AppLocalizations.of(context)!;

    Widget? addButton;
    if (shState.status != BluetoothStatus.connected &&
        shState.status != BluetoothStatus.connecting) {
      addButton = InkWell(
        onTap: () {
          appLogger.i('$_logTag go to add showerhead screen');
          appDomain.goToAddShowerhead();
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 1,
          ), // zone cliquable maîtrisée
          child: Icon(
            Icons.add_circle,
            size: 24,
            color: AppTheme.sectionTitleColor,
          ),
        ),
      );
    }

    List<Widget> cards = [];

    for (var sh in appDomain.getShowerheads()) {
      int countLearningShowers = 0;
      if (sh.baselineStatus != null &&
          sh.baselineBeginIndex != null &&
          (sh.baselineStatus == LearningStatus.begin.toString() ||
              sh.baselineStatus == LearningStatus.learn.toString())) {
        countLearningShowers =
            appDomain.getShowers(sh.id, gtIndex: sh.baselineBeginIndex).length;
      }
      cards.add(
        DbShowerheadCard(
          showerhead: sh,
          unit: appDomain.getWaterUnit(),
          thresholdMaxLiter: appDomain.getThresholdMaxLiter(),
          connected:
              shState.status == BluetoothStatus.connected &&
              shState.connectedDevice?.id == sh.id,
          onShClicked: () async {
            ref.read(statisticsShSelectedProvider.notifier).state = sh.id;
            appDomain.goToStatistics();
          },
          onSettingsClicked: () async {
            appLogger.i("show configure SH dialog for ${sh.name}");
            await _showConfigureShDialog(sh);
          },
          averageShower: appDomain.getShowerheadAverageShower(sh.id),
          countShowers: appDomain.getShowers(sh.id, gteMinVolume: true).length,
          countLearningShowers: countLearningShowers,
        ),
      );
    }

    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 15.0, vertical: 6.0),
      child: CustomExpansionTile(
        backgroundColor: Colors.white,
        globalPadding: 10,
        expanded: true,
        expandable: false,
        contentScrollable: true,
        title: t.dashboardShowerheadsSectionTitle(
          appState.showerheads?.length ?? 0,
        ),
        trailingButton: addButton,
        children: cards,
      ),
    );
  }
}
