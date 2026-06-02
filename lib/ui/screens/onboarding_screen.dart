import 'package:flutter/material.dart' hide FormState;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/domains/app_domain.dart';
import 'package:hydrao_flutter_offline/domains/app_state.dart';
import 'package:hydrao_flutter_offline/domains/form_domain.dart';
import 'package:hydrao_flutter_offline/domains/form_state.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/models/backup.dart';
import 'package:hydrao_flutter_offline/providers.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';
import 'package:hydrao_flutter_offline/theme.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/import_backup_dialog.dart';
import 'package:hydrao_flutter_offline/ui/fragments/page/global_settings_fragment.dart';
import 'package:hydrao_flutter_offline/ui/fragments/page/import_backup_fragment.dart';
import 'package:hydrao_flutter_offline/ui/fragments/page/welcome_fragment.dart';

enum OnboardingStatus { welcome, configure }

const _logTag = "[ONBOARDING_SCREEN] ";
const _saveButtonKey = "onboardingScreen.save";

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late AppDomain appDomain;
  late FormDomain<AppSettingsCompanion> formDomain;
  OnboardingStatus screenStatus = OnboardingStatus.welcome;
  AppSettingsCompanion? _settingsToSave;

  // --- life cycle methods

  @override
  void initState() {
    super.initState();

    appDomain = ref.read(appDomainProvider.notifier);
    formDomain = ref.read(settingsFormStateProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateUIForScreenStatus();
      _updateUIForAppState(ref.read(appDomainProvider));
    });
  }

  // --- ui methods

  void changeScreenStatus(OnboardingStatus newStatus) {
    if (mounted && screenStatus != newStatus) {
      setState(() {
        screenStatus = newStatus;
      });
      _updateUIForScreenStatus();
    }
  }

  Future<void> _save() async {
    if (_settingsToSave != null) {
      appLogger.i(
        '$_logTag saving config : waterPrice=${_settingsToSave!.waterPrice}',
      );

      await appDomain.saveSettings(_settingsToSave!);
      appLogger.i('settings saved');
    }
  }

  void _updateUIForScreenStatus() {
    if (!mounted) return;

    final t = AppLocalizations.of(context)!;

    String? title;
    bool resetTitle = false;
    bool resetBgColor = false;
    Color? bgColor;
    bool resetBackButton = false;
    String? backButtonKey;
    void Function()? backButtonCallback;
    String? bottomButtonKey;
    String? bottomButtonText;
    void Function()? bottomButtonCallback;
    bool resetBottomButtonCallback = false;

    switch (screenStatus) {
      case OnboardingStatus.welcome:
        resetTitle = true;
        resetBackButton = true;
        bgColor = AppTheme.scanSectionBackground;
        bottomButtonKey = "onboardingScreen.begin";
        bottomButtonText = t.begin.toUpperCase();
        bottomButtonCallback = () {
          changeScreenStatus(OnboardingStatus.configure);
        };
        break;
      case OnboardingStatus.configure:
        title = t.configAppScreenTitle;
        resetBgColor = true;
        backButtonKey = "onboardingScreen.login";
        backButtonCallback = () {
          changeScreenStatus(OnboardingStatus.welcome);
        };
        bottomButtonKey = _saveButtonKey;
        bottomButtonText = t.save;
        resetBottomButtonCallback = true;
        break;
    }

    appDomain.updatePage(
      resetTitle: resetTitle,
      title: title,
      resetActions: true,
      resetBottomMenu: true,
      resetBackButton: resetBackButton,
      backButtonKey: backButtonKey,
      backButtonCallback: backButtonCallback,
      resetBgColor: resetBgColor,
      bgColor: bgColor,
      bottomButtonKey: bottomButtonKey,
      bottomButtonText: bottomButtonText,
      bottomButtonCallback: bottomButtonCallback,
      resetBottomButtonCallback: resetBottomButtonCallback,
    );
  }

  void _updateUIForAppState(AppState appState) {
    if (screenStatus == OnboardingStatus.welcome && appState.settings != null) {
      changeScreenStatus(OnboardingStatus.configure);
    }
  }

  void _updateUIForFormState(FormState<AppSettingsCompanion> formState) {
    if (screenStatus == OnboardingStatus.configure) {
      final formChanges = formDomain.getChanges();
      if (!_settingsToSave.equals(formChanges)) {
        _settingsToSave = formChanges;
      }

      final canSave = formDomain.canSave();

      appDomain.updatePage(
        bottomButtonKey: _saveButtonKey,
        bottomButtonCallback: canSave ? _save : null,
        resetBottomButtonCallback: !canSave,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    appLogger.d('$_logTag build');

    ref.listen(appDomainProvider, (_, next) => _updateUIForAppState(next));
    ref.listen(
      settingsFormStateProvider,
      (_, next) => _updateUIForFormState(next),
    );

    return switch (screenStatus) {
      OnboardingStatus.welcome => Center(child: WelcomeFragment()),
      OnboardingStatus.configure => Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: GlobalSettingsFragment(
            onImportBackup: (From from) async {
              appLogger.i('$_logTag show import backup dialog : from=$from');
              final localData = await appDomain.getLocalBackup();
              if (!context.mounted) return;
              showImportBackupDialog(
                context: context,
                from: from,
                localData: localData,
                onBackupImport: (HydraoBackup backupToSave) {
                  appLogger.i('$_logTag importing backup... $backupToSave');
                  appDomain.importBackup(backupToSave);
                  appLogger.i('$_logTag backup imported');
                },
              );
            },
          ),
        ),
      ),
    };
  }
}
