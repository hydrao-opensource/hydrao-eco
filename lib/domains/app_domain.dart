import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hydrao_flutter_offline/constants.dart';
import 'package:hydrao_flutter_offline/conversions.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/domains/app_state.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/models/backup.dart';
import 'package:hydrao_flutter_offline/models/learning_period.dart';
import 'package:hydrao_flutter_offline/models/savings_stats.dart';
import 'package:hydrao_flutter_offline/models/support_message.dart';
import 'package:hydrao_flutter_offline/models/technical_data.dart';
import 'package:hydrao_flutter_offline/models/threshold.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/help_dialog.dart';
import 'package:hydrao_flutter_offline/ui/fragments/menu_fragment.dart';
import 'package:hydrao_flutter_offline/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

const _logTag = "[APP_DOMAIN] ";

class AppDomain extends StateNotifier<AppState> {
  final DbRepository _dbRepository;

  StreamSubscription<List<Showerhead>>? _showerheadsSub;
  StreamSubscription<List<Shower>>? _showersSub;
  StreamSubscription<Settings?>? _settingsSub;

  // --- life cycle methods

  AppDomain(this._dbRepository) : super(const AppState());

  @override
  Future<void> dispose() async {
    await stopWatch();

    super.dispose();
  }

  /// Méthode de mise à jour groupée (Transaction)
  /// Permet de modifier plusieurs éléments et de ne notifier Riverpod qu'une seule fois.
  void updatePage({
    String? title,
    bool resetTitle = false,
    Color? bgColor,
    bool resetBgColor = false,
    List<Widget>? actions,
    bool resetActions = false,
    HelpCase? help,
    String? helpData,
    bool resetHelp = false,
    String? bottomButtonKey,
    String? bottomButtonText,
    VoidCallback? bottomButtonCallback,
    bool resetBottomButtonCallback = false,
    bool resetBottomButton = false,
    Menu? bottomMenu,
    bool resetBottomMenu = false,
    String? backButtonKey,
    VoidCallback? backButtonCallback,
    bool resetBackButton = false,
    String? backWarning,
    bool resetBackWarning = false,
  }) {
    bool needRefresh = false;
    List<String> changes = [];

    // 1. On travaille sur une copie locale
    var newState = state;

    // --- Title
    if (resetTitle) {
      if (newState.title != null) {
        newState = newState.copyWith(resetTitle: true);
        needRefresh = true;
        changes.add('resetTitle');
      }
    } else if (title != null && newState.title != title) {
      newState = newState.copyWith(title: title);
      needRefresh = true;
      changes.add('title');
    }

    // --- Background Color
    if (resetBgColor) {
      if (newState.backgroundColor != null) {
        newState = newState.copyWith(resetBackgroundColor: true);
        needRefresh = true;
        changes.add('resetBgColor');
      }
    } else if (bgColor != null && newState.backgroundColor != bgColor) {
      newState = newState.copyWith(backgroundColor: bgColor);
      needRefresh = true;
      changes.add('bgColor');
    }

    // --- Page Actions
    if (resetActions) {
      if (newState.pageActions != null && newState.pageActions!.isNotEmpty) {
        newState = newState.copyWith(pageActions: []);
        needRefresh = true;
        changes.add('resetActions');
      }
    } else if (actions != null) {
      newState = newState.copyWith(pageActions: actions);
      needRefresh = true;
      changes.add('actions');
    }

    // --- Help Dialog
    if (resetHelp) {
      if (newState.help != null || state.helpData != null) {
        newState = newState.copyWith(resetHelp: true);
        needRefresh = true;
        changes.add('resetHelp');
      }
    } else if (help != null) {
      newState = newState.copyWith(help: help, helpData: helpData);
      needRefresh = true;
      changes.add('help');
    }

    // --- Bottom Button
    if (resetBottomButton) {
      if (newState.bottomButtonKey != null) {
        newState = newState.copyWith(
          resetBottomButton: true,
          resetBottomButtonCallback: true,
        );
        needRefresh = true;
        changes.add('resetBottomButton');
      }
    } else if (bottomButtonKey != null) {
      if (resetBottomButtonCallback && newState.bottomButtonCallback != null) {
        newState = newState.copyWith(resetBottomButtonCallback: true);
        needRefresh = true;
        changes.add('resetBottomButtonCallback');
      }
      if (newState.bottomButtonKey != bottomButtonKey ||
          (newState.bottomButtonCallback == null &&
              bottomButtonCallback != null)) {
        newState = newState.copyWith(
          bottomButtonCallback: bottomButtonCallback,
        );
        needRefresh = true;
        changes.add('bottomButtonCallback');
      }
      if (newState.bottomButtonKey != bottomButtonKey ||
          (bottomButtonText != null &&
              newState.bottomButtonText != bottomButtonText)) {
        // appLogger.d(
        //   "$LOG_TAG bottomButtonKey old=${newState.bottomButtonKey} / new=$bottomButtonKey",
        // );
        // appLogger.d(
        //   "$LOG_TAG bottomButtonText old=${newState.bottomButtonText} / new=$bottomButtonText",
        // );
        newState = newState.copyWith(
          bottomButtonKey: bottomButtonKey,
          bottomButtonText: bottomButtonText ?? newState.bottomButtonText,
        );
        needRefresh = true;
        changes.add('resetBottomKey & Text');
      }
    }

    // --- Bottom Menu
    if (resetBottomMenu) {
      if (newState.bottomMenu != null) {
        newState = newState.copyWith(resetBottomMenu: true);
        needRefresh = true;
        changes.add('resetBottomMenu');
      }
    } else if (bottomMenu != null && newState.bottomMenu != bottomMenu) {
      newState = newState.copyWith(bottomMenu: bottomMenu);
      needRefresh = true;
      changes.add('bottomMenu');
    }

    // --- Back Button
    if (resetBackButton) {
      if (newState.backButtonCallback != null) {
        newState = newState.copyWith(resetBackButton: true);
        needRefresh = true;
        changes.add('resetBackButton');
      }
    } else if (backButtonKey != null &&
        newState.backButtonKey != backButtonKey) {
      newState = newState.copyWith(
        backButtonKey: backButtonKey,
        backButtonCallback: backButtonCallback,
      );
      needRefresh = true;
      changes.add('backButton');
    }

    // --- Back Warning
    if (resetBackWarning) {
      if (newState.backWarning != null) {
        newState = newState.copyWith(resetBackWarning: true);
        needRefresh = true;
        changes.add('resetBackWarning');
      }
    } else if (backWarning != null && newState.backWarning != backWarning) {
      newState = newState.copyWith(backWarning: backWarning);
      needRefresh = true;
      changes.add('backWarning');
    }

    // 2. Assignation UNIQUE : un seul rebuild déclenché
    if (needRefresh) {
      appLogger.d('$_logTag state changed from updatePage : $changes');
      state = newState;
    }
  }

  // --- Vos méthodes individuelles appellent maintenant la méthode groupée ---

  void setTitle(String title) => updatePage(title: title);
  void resetTitle() => updatePage(resetTitle: true);

  void setBackgroundColor(Color bgColor) => updatePage(bgColor: bgColor);
  void resetBackgroundColor() => updatePage(resetBgColor: true);

  void setPageActions(List<Widget> actions) => updatePage(actions: actions);
  void resetPageActions() => updatePage(resetActions: true);

  void showHelp({required HelpCase key, String? data}) =>
      updatePage(help: key, helpData: data);
  void hideHelp() => updatePage(resetHelp: true);

  void showBottomButton(String key, String text, VoidCallback? callback) =>
      updatePage(
        bottomButtonKey: key,
        bottomButtonText: text,
        bottomButtonCallback: callback,
      );

  void hideBottomButton() => updatePage(resetBottomButton: true);

  void showBottomMenu(Menu menu) => updatePage(bottomMenu: menu);
  void hideBottomMenu() => updatePage(resetBottomMenu: true);

  void showBackButton(String key, VoidCallback callback) =>
      updatePage(backButtonKey: key, backButtonCallback: callback);

  void hideBackButton() => updatePage(resetBackButton: true);

  void addBackWarning(String message) => updatePage(backWarning: message);

  void removeBackWarning() => updatePage(resetBackWarning: true);

  // ---  navigation methods

  void goToAddShowerhead() =>
      state = state.copyWith(status: AppStatus.addShowerhead);

  void goToDashboard() => state = state.copyWith(status: AppStatus.dashboard);

  void goToStatistics() => state = state.copyWith(status: AppStatus.statistics);

  void goToMore() => state = state.copyWith(status: AppStatus.more);

  void goToOnboarding() => state = state.copyWith(status: AppStatus.onboarding);

  Future<void> watch({bool refreshStatus = true}) async {
    await _showerheadsSub?.cancel();
    _showerheadsSub = _dbRepository.watchShowerheads().listen((showerheads) {
      appLogger.d(
        '$_logTag DB showerheads watch changed : ${showerheads.length} FOUND / stateStatus=${state.status}',
      );
      if (refreshStatus) {
        var fromStatuses = [
          AppStatus.splashscreen,
          AppStatus.onboarding,
          AppStatus.addShowerhead,
        ];

        var dashboardStatuses = [
          AppStatus.dashboard,
          AppStatus.statistics,
          AppStatus.more,
        ];
        if (fromStatuses.contains(state.status) && showerheads.isNotEmpty) {
          state = state.copyWith(status: AppStatus.dashboard, help: null);
        } else if (dashboardStatuses.contains(state.status) &&
            showerheads.isEmpty) {
          state = state.copyWith(status: AppStatus.addShowerhead, help: null);
        }
      }

      // if (showerheads.isEmpty) {
      //   showerheads = _makeMockShowerheads();
      // }
      state = state.copyWith(showerheads: _orderedShowerheads(showerheads));
    });

    await _showersSub?.cancel();
    _showersSub = _dbRepository.watchShowers().listen((showers) {
      appLogger.d(
        '$_logTag DB showers watch changed : ${showers.length} FOUND / stateStatus=${state.status}',
      );

      state = state.copyWith(showers: showers);
    });

    await _settingsSub?.cancel();
    _settingsSub = _dbRepository.watchSettings().listen((settings) {
      appLogger.d(
        '$_logTag DB settings watch changed : ${settings != null ? "EXISTS" : "NOT EXISTS"}',
      );
      if (settings != null) {
        state = state.copyWith(settings: settings);
        if (refreshStatus) {
          var fromStatuses = [AppStatus.splashscreen, AppStatus.onboarding];
          if (fromStatuses.contains(state.status)) {
            state = state.copyWith(status: AppStatus.addShowerhead, help: null);
          }
        }
      } else {
        if (refreshStatus) {
          state = state.copyWith(
            status: AppStatus.onboarding,
            help: null,
            resetSettings: true,
          );
        } else {
          state = state.copyWith(resetSettings: true);
        }
      }
    });
  }

  Future<void> stopWatch() async {
    await safeCancel(_showerheadsSub);
    await safeCancel(_showersSub);
    await safeCancel(_settingsSub);
  }

  // --- settings methods

  Settings? getSettings() {
    return state.settings;
  }

  Future<void> saveSettings(AppSettingsCompanion newSettings) async {
    return await _dbRepository.saveSettings(newSettings);
  }

  String getWaterUnit() {
    Settings settings = state.settings ?? _getDefaultSettings();

    return settings.waterUnit ?? _getDefaultSettings().waterUnit!;
  }

  String getWaterPriceUnit() {
    Settings settings = state.settings ?? _getDefaultSettings();

    String currencySymbol = getCurrency();
    String volumePriceUnit = getWaterUnitForPrice(settings.waterUnit!);

    return "$currencySymbol/$volumePriceUnit";
  }

  String getTemperatureUnit() {
    String waterUnit = getWaterUnit();

    return (waterUnit == AppConstants.symbolGallon)
        ? AppConstants.symbolFahrenheit
        : AppConstants.symbolCelcius;
  }

  String getCurrency() {
    Settings settings = state.settings ?? _getDefaultSettings();

    return currencySymbol[settings.currencyCode] ??
        currencySymbol[AppConstants.defaultCountryCode]!;
  }

  String formatPrice(double price) {
    Settings settings = state.settings ?? _getDefaultSettings();
    String currencyCode = settings.currencyCode ?? _getDefaultSettings().currencyCode!;

    String formattedPrice = price.toStringAsFixed(1);
    String currency = getCurrency();

    if (currencyCode == "EUR") {
      return "$formattedPrice $currency";
    } else {
      return "$currency$formattedPrice";
    }
  }

  Settings _getDefaultSettings() {
    String defaultCountryCode = "FR";
    CountrySettings countrySettings =
        AppConstants.getCountrySettingsFromCountryCode(defaultCountryCode);

    return Settings(
      id: 1,
      minShowerLiter: AppConstants.minShowerLiter,
      heatingEnergy: AppConstants.heatingEnergy,
      countryCode: defaultCountryCode,
      currencyCode: countrySettings.currencyIsoCode,
      waterUnit: countrySettings.volumeUnit,
      energyPrice: countrySettings.defaultKWhPrice,
      waterPrice: countrySettings.defaultWaterPrice,
    );
  }

  SavingsParams getSavingsParams() {
    Settings settings = state.settings ?? _getDefaultSettings();
    CountrySettings countrySettings =
        AppConstants.getCountrySettingsFromCountryCode(settings.countryCode);

    return SavingsParams(
      waterPrice: settings.waterPrice ?? countrySettings.defaultWaterPrice,
      energyPrice: settings.energyPrice ?? countrySettings.defaultKWhPrice,
      heatingEnergy: settings.heatingEnergy ?? AppConstants.heatingEnergy,
    );
  }

  // --- showerheads methods

  String getNewShowerheadName(String locale) {
    List<String> shNames = getShowerheadNames();

    return AppConstants.getNextShName(locale, shNames.toSet());
  }

  List<Showerhead> getShowerheads() {
    return state.showerheads ?? [];
  }

  List<String> getShowerheadNames() {
    return state.showerheads?.map((sh) => sh.name).toList() ?? [];
  }

  bool hasShowerheads() {
    return state.showerheads?.isNotEmpty ?? false;
  }

  List<Showerhead> _orderedShowerheads(List<Showerhead> showerheads) {
    showerheads.sort((a, b) {
      final la = a.lastSeen;
      final lb = b.lastSeen;

      // Cas 1 : les deux sont null → égal
      if (la == null && lb == null) return 0;

      // Cas 2 : a.lastSeen est null → a va après b
      if (la == null) return 1;

      // Cas 3 : b.lastSeen est null → b va après a
      if (lb == null) return -1;

      // Cas 4 : les deux dates existent → tri décroissant (le plus récent d'abord)
      return lb.compareTo(la);
    });

    return showerheads;
  }

  int getShowerheadsCount() {
    return state.showerheads?.length ?? 0;
  }

  Showerhead? getShowerhead(String bleId) {
    return state.showerheads?.firstWhereOrNull((sh) => sh.id == bleId);
  }

  Showerhead? getShowerheadByUuid(String uuid) {
    return state.showerheads?.firstWhereOrNull((sh) => sh.uuid == uuid);
  }

  String? getShowerheadName(String bleId) {
    final sh = getShowerhead(bleId);

    return sh?.name;
  }

  String? getShowerheadThresholds(String bleId) {
    final sh = getShowerhead(bleId);

    return sh?.getThresholdToShow();
  }

  bool hasShowerheadThresholdsRequest(String bleId) {
    final sh = getShowerhead(bleId);

    return sh?.hasThresholdRequest() ?? false;
  }

  bool isShowerheadLiveRecent(String bleId) {
    final sh = getShowerhead(bleId);

    return sh?.liveIsRecent() ?? false;
  }

  int? getShowerheadLiveVolume(String bleId) {
    final sh = getShowerhead(bleId);

    return sh?.liveVolume;
  }

  double getThresholdMaxLiter() {
    final allThresholds = state.showerheads
        ?.where((sh) => sh.threshold != null)
        .expand((sh) => thresholdsFromJson(sh.threshold)!)
        .toList();

    if (allThresholds == null || allThresholds.isEmpty) {
      return AppConstants.shDefaultThresholdMaxLiter;
    }

    return allThresholds.map((t) => t.liter).reduce((a, b) => a > b ? a : b);
  }

  Future<void> saveShowerhead(ShowerheadsCompanion sh) async {
    await _dbRepository.saveShowerhead(sh);

    List<Showerhead> newShowerheads = await _dbRepository.getShowerheads();
    state = state.copyWith(showerheads: _orderedShowerheads(newShowerheads));
  }

  /// delete db showerhead
  Future<bool> removeShowerhead(
    String deviceId, {
    bool withShowers = true,
  }) async {
    try {
      var sh = await _dbRepository.getShowerhead(deviceId);
      if (sh != null) {
        await _dbRepository.deleteShowerhead(deviceId);
        if (sh.uuid != null && withShowers) {
          await _dbRepository.deleteShowerheadShowers(sh.uuid!);
        }

        List<Showerhead> newShowerheads = await _dbRepository.getShowerheads();
        state = state.copyWith(
          showerheads: _orderedShowerheads(newShowerheads),
        );
      }
    } catch (e) {
      appLogger.e('$_logTag remove showerhead $deviceId FAILED : $e');
      return false;
    }
    return true;
  }

  // Future<bool> startLearningPeriodForShowerhead(String deviceId) async {
  //   Showerhead? sh = getShowerhead(deviceId);
  //   if (sh == null) return false;

  //   // - start learning period
  //   ShowerheadsCompanion shUpdates = sh.toCompanion(false);
  //   shUpdates = shUpdates.copyWith(
  //     baselineEndIndex: null,
  //     baselineBeginIndex: null,
  //     baselineStatus: Value(LearningStatus.BEGIN.toString()),
  //     baselineEndDate: Value(null),
  //     baselineBeginDate: Value(DateTime.now()),
  //     // refShowerDuration: Value(AppConstants.refShowerDuration),
  //   );
  //   await saveShowerhead(shUpdates);

  //   return true;
  // }

  Future<bool> stopLearningPeriodForShowerhead(
    String deviceId,
    List<int> showerIds,
    List<HydraoThreshold>? newThresholds,
  ) async {
    Showerhead? sh = getShowerhead(deviceId);
    if (sh == null) return false;

    if (showerIds.isEmpty) {
      return await cancelLearningPeriodForShowerhead(deviceId);
    }

    // clean isReference on all showers
    await resetShowerheadRefShowers(deviceId);

    // update showers with isReference = true
    double durationSum = 0;
    List<Shower> shShowers = getShowers(deviceId, notEmpty: true);
    final matchedShowers = showerIds
        .map((id) => shShowers.firstWhereOrNull((s) => s.id == id))
        .whereType<Shower>()
        .toList();

    for (final shower in matchedShowers) {
      if (shower.duration != null) durationSum += shower.duration!;
    }

    await Future.wait(
      matchedShowers
          .where((s) => !s.isReference)
          .map((s) => _dbRepository.saveShower(
                s.toCompanion(false).copyWith(isReference: Value(true)),
              )),
    );
    if (matchedShowers.any((s) => !s.isReference)) {
      final newShowers = await _dbRepository.getShowers();
      state = state.copyWith(showers: newShowers);
    }

    // compute refShowerDuration from reference showers
    int refDurationInSeconds =
        sh.refShowerDuration ?? AppConstants.refShowerDuration;
    if (durationSum > 0) {
      refDurationInSeconds = (durationSum / showerIds.length).round();
    }

    // update showerhead
    ShowerheadsCompanion shUpdates = sh.toCompanion(false);
    shUpdates = shUpdates.copyWith(
      baselineEndIndex: Value(sh.lastSyncMaxIndex),
      baselineStatus: Value(LearningStatus.end.toString()),
      baselineEndDate: Value(DateTime.now()),
      thresholdRequest: newThresholds != null
          ? Value(thresholdsToJson(newThresholds))
          : Value.absent(),
      refShowerDuration: Value(refDurationInSeconds),
    );
    await saveShowerhead(shUpdates);

    return true;
  }

  Future<bool> cancelLearningPeriodForShowerhead(String deviceId) async {
    Showerhead? sh = getShowerhead(deviceId);
    if (sh == null) return false;

    // int refDurationInSeconds = AppConstants.refShowerDuration;

    String? newBaselineStatus =
        sh.baselineStatus == LearningStatus.learn.toString()
        ? LearningStatus.end.toString()
        : null;

    ShowerheadsCompanion shUpdates = sh.toCompanion(false);
    shUpdates = shUpdates.copyWith(
      baselineStatus: Value(newBaselineStatus),
      baselineBeginDate: Value(null),
      baselineEndDate: Value(null),
      // refShowerDuration: Value(refDurationInSeconds),
    );

    await saveShowerhead(shUpdates);

    return true;
  }

  Future<void> resetShowerheadRefShowers(String deviceId) async {
    List<Shower> refShowers = getShowers(deviceId, isReference: true);
    await Future.wait(refShowers.map((refShower) =>
      _dbRepository.saveShower(
        refShower.toCompanion(false).copyWith(isReference: Value(false)),
      ),
    ));

    List<Shower> newShowers = await _dbRepository.getShowers();
    state = state.copyWith(showers: newShowers);
  }

  Future<void> updateShowerheadRefDuration(String deviceId) async {
    var sh = await _dbRepository.getShowerhead(deviceId);
    if (sh == null) return;

    double durationSum = 0;

    List<Shower> refShowers = getShowers(deviceId, isReference: true);
    for (var refShower in refShowers) {
      if (refShower.duration != null) {
        // appLogger.d(
        //   '$LOG_TAG updateShowerheadRefDuration / shower #${refShower.id} duration=${refShower.duration}',
        // );
        durationSum = durationSum + refShower.duration!;
      }
    }

    // appLogger.d(
    //   '$LOG_TAG updateShowerheadRefDuration / durationSum=$durationSum count=${refShowers.length}',
    // );

    int refDurationInSeconds = AppConstants.refShowerDuration;
    if (durationSum > 0) {
      refDurationInSeconds = (durationSum / refShowers.length).round();
    }

    if (sh.refShowerDuration != refDurationInSeconds) {
      // appLogger.d(
      //   '$LOG_TAG updateShowerheadRefDuration / need refresh sh ref duration : ${sh.refShowerDuration} => $refDurationInSeconds',
      // );

      await saveShowerhead(
        sh
            .toCompanion(false)
            .copyWith(refShowerDuration: Value(refDurationInSeconds)),
      );

      // force state refresh
      List<Showerhead> newShowerheads = await _dbRepository.getShowerheads();
      state = state.copyWith(showerheads: _orderedShowerheads(newShowerheads));
    }
  }

  // --- showers methods

  List<Shower> getShowers(
    String bleShId, {
    bool notEmpty = false,
    bool gteMinVolume = false,
    int? gtIndex,
    bool? isIgnored,
    bool? isReference,
  }) {
    final sh = getShowerhead(bleShId);
    final minVolume =
        state.settings?.minShowerLiter ?? AppConstants.minShowerLiter;

    List<Shower> showers = [];

    if (sh != null && state.showers != null && state.showers!.isNotEmpty) {
      showers = state.showers!.where((shower) {
        final matchSh = shower.deviceId == sh.uuid;
        final matchNotEmpty = (notEmpty == true)
            ? shower.isEmpty == false
            : true;
        final matchGteMinVolume = (gteMinVolume == true)
            ? shower.isEmpty == false && shower.volume >= minVolume
            : true;
        final matchIsIgnore = (isIgnored != null)
            ? shower.isIgnored == isIgnored
            : true;
        final matchIsReference = (isReference != null)
            ? shower.isReference == isReference
            : true;
        final matchGtIndex = (gtIndex != null) ? shower.id > gtIndex : true;

        return matchSh &&
            matchGteMinVolume &&
            matchNotEmpty &&
            matchIsReference &&
            matchIsIgnore &&
            matchGtIndex;
      }).toList();
    }

    // sort showers by date + showerId
    showers.sort(
      (a, b) => a.date.compareTo(b.date) != 0
          ? a.date.compareTo(b.date)
          : a.id.compareTo(b.id),
    );

    return showers;
  }

  double? getShowerheadAverageShower(String bleShId) {
    List<Shower> showers = getShowers(
      bleShId,
      gteMinVolume: true,
      isIgnored: false,
    );
    // appLogger.d('$LOG_TAG showers : ${showers.length}');

    return getAverageVolumeFromShowers(showers);
  }

  double getShowerheadMoneySavings(String bleShId) {
    final sh = getShowerhead(bleShId);
    if (sh == null) return 0.0;

    List<Shower> showers = getShowers(bleShId, gteMinVolume: true);

    SavingsStats savings = SavingsStats.from(sh, showers, getSavingsParams());

    return savings.savedTotalMoney;
  }

  SavingsStats getShowerheadSavingsStats(String bleShId) {
    //TODO manage period filter

    final sh = getShowerhead(bleShId);
    if (sh == null) return SavingsStats.none();

    //TODO manage period filter
    List<Shower> showers = getShowers(bleShId, gteMinVolume: true);

    return SavingsStats.from(sh, showers, getSavingsParams());
  }

  Future<void> updateShower(ShowersCompanion changes) async {
    await _dbRepository.saveShower(changes);

    // force state refresh
    List<Shower> newShowers = await _dbRepository.getShowers();
    state = state.copyWith(showers: newShowers);
  }

  // --- global methods

  double getMoneySavings() {
    double moneySavings = 0;

    state.showerheads?.forEach((sh) {
      moneySavings += getShowerheadMoneySavings(sh.id);
    });

    return moneySavings;
  }

  SavingsStats getGlobalSavings() {
    //TODO manage period filter

    SavingsStats globalSavings = SavingsStats.none();

    state.showerheads?.forEach((sh) {
      //TODO manage period filter
      globalSavings = globalSavings.add(getShowerheadSavingsStats(sh.id));
    });

    return globalSavings;
  }

  Future<void> resetApp() async {
    await _dbRepository.clearAllData();
  }

  Future<HydraoBackup> getLocalBackup() async {
    return await _dbRepository.exportAllData();
  }

  Future<File> backupApp() async {
    HydraoBackup localData = await getLocalBackup();

    final jsonString = localData.toJson();

    final dir = await getApplicationDocumentsDirectory();

    // Date au format YYYY-MM-DD
    final now = DateTime.now();
    final dayString =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final String backupPrefix = AppConstants.prefixBackupFile;
    final filePath = '${dir.path}/${backupPrefix}_$dayString.json';
    final file = File(filePath);

    await file.writeAsString(jsonString, flush: true);

    return file;
  }

  Future<void> shareBackup(BuildContext context, File? backupFile) async {
    backupFile ??= await backupApp();
    if (!context.mounted) return;

    final t = AppLocalizations.of(context)!;

    // 1. Préparation de l'origine (Sécurité iPad/Tablettes)
    final renderObject = context.findRenderObject();
    final box = renderObject is RenderBox ? renderObject : null;
    final sharePositionOrigin = box != null
        ? box.localToGlobal(Offset.zero) & box.size
        : null;

    // 2. Appel de la nouvelle API avec ShareParams
    await SharePlus.instance.share(
      ShareParams(
        text: t.shareBackupMessage,
        subject: t.shareBackupSubject,
        files: [XFile(backupFile.path)],
        sharePositionOrigin: sharePositionOrigin,
      ),
    );
  }

  Future<void> importBackup(HydraoBackup backup) async {
    await _dbRepository.importAllDataFromJson(backup);
  }

  Future<void> sendSupportMessage(
    AppLocalizations t,
    SupportMessage support,
  ) async {
    String fullMessage = support.message;
    List<String>? attachements = [];
    // List<XFile>? files = [];

    if (support.withTechData) {
      // prepare technical infos
      List<String> technicalInfos = [];
      TechnicalData technicalData = await TechnicalData.init();
      technicalInfos.add('------------------------------');
      technicalInfos.add("Application : ${technicalData.getApp()}");
      technicalInfos.add("OS : ${technicalData.getOs()}");
      technicalInfos.add("Device : ${technicalData.getDevice()}");

      fullMessage += '\n';
      fullMessage += '\n';
      fullMessage += '\n';
      fullMessage += technicalInfos.join('\n');

      File? logFile = await getLogFileForSharing();
      if (logFile != null) {
        attachements.add(logFile.absolute.path);
        // files.add(XFile(logFile.absolute.path));
      }

      File? oldFilePath = await getOldLogFileForSharing();
      if (oldFilePath != null) {
        attachements.add(oldFilePath.path);
        // files.add(XFile(oldFilePath.path));
      }

      // File? zipLogFile = await createLogsZip();
      // if (zipLogFile != null) {
      //   attachements.add(zipLogFile.path);
      //   files.add(XFile(zipLogFile.path));
      // }
    }

    if (support.withUserData) {
      File backupFile = await backupApp();
      attachements.add(backupFile.path);
      // files.add(XFile(backupFile.path));
    }

    String subject = '[${t.defaultScreenTitle}] ${t.iNeedHelp}';

    // send message to mailer
    final Email email = Email(
      body: fullMessage,
      subject: subject,
      recipients: [AppConstants.contactUsEmail],
      attachmentPaths: attachements,
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }

  // --- private methods

  /// generate some showerheads for tests only
  // List<Showerhead> _makeMockShowerheads() {
  //   List<Showerhead> showerheads = [];

  //   // MOCK DATA
  //   showerheads.add(
  //     Showerhead(
  //       id: AppConstants.shFakeOldUuid,
  //       name: "Old UUID",
  //       type: "aloe",
  //       threshold: AppConstants.shFakeThresholds1,
  //       indexCycleCount: 0,
  //     ),
  //   );
  //   showerheads.add(
  //     Showerhead(
  //       id: AppConstants.shFakeNewUuid,
  //       name: "New UUID",
  //       type: "yucca",
  //       threshold: AppConstants.shFakeThresholds2,
  //       indexCycleCount: 0,
  //     ),
  //   );

  //   return showerheads;
  // }
}
