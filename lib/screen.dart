import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/domains/app_domain.dart';
import 'package:hydrao_flutter_offline/domains/app_state.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/models/backup.dart';
import 'package:hydrao_flutter_offline/providers.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/configure_app_dialog.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/confirm_dialog.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/create_backup_dialog.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/help_dialog.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/import_backup_dialog.dart';
import 'package:hydrao_flutter_offline/ui/fragments/menu_fragment.dart';
import 'package:hydrao_flutter_offline/ui/fragments/page/import_backup_fragment.dart';
import 'package:hydrao_flutter_offline/ui/fragments/page/splashscreen_fragment.dart';
import 'package:hydrao_flutter_offline/ui/screens/add_showerhead_screen.dart';
import 'package:hydrao_flutter_offline/ui/screens/dashboard_screen.dart';
import 'package:hydrao_flutter_offline/ui/screens/more_screen.dart';
import 'package:hydrao_flutter_offline/ui/screens/onboarding_screen.dart';
import 'package:hydrao_flutter_offline/ui/screens/statistics_screen.dart';

const _logTag = "[APP_SCREEN] ";

class AppScreen extends ConsumerStatefulWidget {
  const AppScreen({super.key});

  @override
  ConsumerState<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends ConsumerState<AppScreen> {
  bool isDisposed = false;
  late AppDomain appDomain;
  bool helpShowed = false;
  late ScrollController _scrollController;
  bool _hasScroll = false;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    // _scrollController.addListener(updateHasScroll);

    appDomain = ref.read(appDomainProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      appDomain.watch(
        refreshStatus: true, // for PROD = true, for DEV can be false
      );
      // appDomain?.goToAddShowerhead();
      // appDomain?.goToDashboard();
    });
  }

  @override
  Future<void> dispose() async {
    isDisposed = true;

    await appDomain.dispose();
    // _scrollController.removeListener(updateHasScroll);
    _scrollController.dispose();

    super.dispose();
  }

  Future<void> resetApp() async {
    appLogger.i('$_logTag resetting app...');
    await appDomain.resetApp();
    appLogger.i('$_logTag App resetted !');
  }

  Future<void> saveAppSettings(AppSettingsCompanion changes) async {
    appLogger.i('$_logTag saving app settings...');
    await appDomain.saveSettings(changes);
    appLogger.i('$_logTag App settings saved');
  }

  Future<void> _showConfigureAppDialog() async {
    await showConfigureAppDialog(
      context: context,
      settings: appDomain.getSettings(),
      onReset: () async {
        await resetApp();
      },
      onSave: (AppSettingsCompanion changes) {
        saveAppSettings(changes);
        return true;
      },
      onCreateBackup: () async {
        File? backupFile = await appDomain.backupApp();
        if (mounted) {
          appLogger.i(
            '$_logTag show create backup dialog / file=${backupFile.path}',
          );

          showCreateBackupDialog(
            context: context,
            backupFile: backupFile,
            onShare: () {
              if (!context.mounted) return;
              appDomain.shareBackup(context, backupFile);
            },
          );
        }
      },
      onImportBackup: (From from) async {
        appLogger.i('$_logTag show import backup dialog : from=$from');
        if (!context.mounted) return;
        await showImportBackupDialog(
          // ignore: use_build_context_synchronously
          context: context,
          from: from,
          localData: await appDomain.getLocalBackup(),
          onBackupImport: (HydraoBackup backupToSave) {
            appLogger.i('$_logTag importing backup... : $backupToSave');
            appDomain.importBackup(backupToSave);
            appLogger.i('$_logTag backup imported');

            // close app setting dialog
            if (context.mounted && Navigator.canPop(context)) {
              Navigator.of(context).pop();
            }
          },
        );
      },
    );
  }

  void updateHasScroll() {
    if (!_scrollController.hasClients) return;

    final newValue = _scrollController.position.maxScrollExtent > 0;
    if (newValue != _hasScroll) {
      setState(() => _hasScroll = newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final appState = ref.watch(appDomainProvider);

    appLogger.d(
      '$_logTag build : state.status=${appState.status} / state.bottomButton=${appState.bottomButtonText}',
    );

    // reactive behaviors
    ref.listen<AppState>(appDomainProvider, (previous, next) async {
      if (isDisposed) return;

      if (next.help != null && helpShowed == false) {
        helpShowed = true;
        await showHelpDialog(
          context: context,
          key: next.help!,
          data: next.helpData,
          onConfirm: () {
            appDomain.hideHelp();
            helpShowed = false;
          },
        );
      }
    });

    final double systemBottom = MediaQuery.of(context).viewPadding.bottom;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    // reactive view
    return PopScope<bool>(
      canPop: false, // bloque le pop par défaut
      onPopInvokedWithResult: (bool didPop, bool? result) async {
        if (didPop) return;
        final appState = ref.read(appDomainProvider);

        if (appState.help != null) {
          // CASE Help Dialog open
          appLogger.d('$_logTag back asked => close help dialog');
          Navigator.of(context).pop(true);
          return;
        }

        if (appState.backButtonCallback != null) {
          appLogger.d('$_logTag back asked => domain back called');
          if (appState.backWarning != null) {
            final result = await showConfirmDialog(
              context: context,
              message: appState.backWarning!,
            );
            if (result) {
              appState.backButtonCallback!();
            }
            appDomain.removeBackWarning();
          } else {
            appState.backButtonCallback!();
          }

          return;
        }
        if (context.mounted && Navigator.canPop(context)) {
          appLogger.d('$_logTag back asked => navigator back called');
          if (appState.backWarning != null) {
            final result = await showConfirmDialog(
              context: context,
              message: appState.backWarning!,
            );
            if (result && context.mounted) {
              Navigator.of(context).pop();
            }
            appDomain.removeBackWarning();
          } else {
            Navigator.of(context).pop();
          }
          return;
        } else {
          // appLogger.d('$LOG_TAG back asked => system back called');
          appLogger.i('$_logTag exiting application...');

          final result = await showConfirmDialog(
            context: context,
            message: t.confirmCloseApp,
          );
          if (result) {
            await SystemNavigator.pop();
            appLogger.i('$_logTag application exited!');
          } else {
            appLogger.i('$_logTag application not existed : CANCELLED');
          }
        }
      },
      child: Scaffold(
        backgroundColor: appState.backgroundColor,
        resizeToAvoidBottomInset: true,
        appBar: appState.title != null
            ? AppBar(
                title: Text(
                  appState.title == null
                      ? t.defaultScreenTitle
                      : appState.title!,
                ),
                actions: appState.pageActions ?? [],
                leading: appState.backButtonCallback == null
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: appState.backButtonCallback,
                      ),
              )
            : null,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: switch (appState.status) {
            AppStatus.splashscreen => const SplashscreenFragment(),
            _ => SafeArea(
              top: true, // Protège le haut (batterie, notch)
              bottom: false, // Ne protège pas le bas (barre home iOS)
              child: Padding(
                padding: EdgeInsets.only(right: /*_hasScroll ? 10 : */ 0),
                child: NotificationListener<ScrollMetricsNotification>(
                  onNotification: (notification) {
                    // updateHasScroll();
                    return true; // Empêche la propagation si nécessaire
                  },
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double maxHeight = constraints.maxHeight;

                      return Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: ConstrainedBox(
                            // 👇 garantit au moins la hauteur de l’écran
                            constraints: BoxConstraints(minHeight: maxHeight),
                            child: switch (appState.status) {
                              AppStatus.onboarding => const OnboardingScreen(),
                              AppStatus.addShowerhead =>
                                const AddShowerheadScreen(),
                              AppStatus.dashboard => DashboardScreen(
                                availableHeight: maxHeight,
                              ),
                              AppStatus.statistics => StatisticsScreen(
                                availableHeight: maxHeight,
                              ),
                              AppStatus.more => const MoreScreen(),
                              _ => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          },
        ),
        bottomNavigationBar: appState.bottomButtonText == null
            ? appState.bottomMenu == null
                  ? null
                  : Padding(
                      padding: EdgeInsets.only(
                        bottom:
                            (keyboardHeight > 0
                                ? keyboardHeight
                                : systemBottom) +
                            15,
                        left: 0,
                        right: 0,
                        top: 15,
                      ),
                      child: MenuFragment(
                        selected: appState.bottomMenu!,
                        onSettingsClicked: () {
                          _showConfigureAppDialog();
                        },
                        onMenuChanged: (Menu newMenu) {
                          switch (newMenu) {
                            case Menu.dashboard:
                              appDomain.goToDashboard();
                              break;
                            case Menu.statistics:
                              // detect if more than one sh
                              if (appState.showerheads != null) {
                                if (appState.showerheads!.length > 1) {
                                  ref
                                          .read(
                                            statisticsShSelectedProvider
                                                .notifier,
                                          )
                                          .state =
                                      null;
                                } else if (appState.showerheads!.length == 1) {
                                  ref
                                      .read(
                                        statisticsShSelectedProvider.notifier,
                                      )
                                      .state = appState
                                      .showerheads![0]
                                      .id;
                                }
                              }

                              appDomain.goToStatistics();
                              break;
                            case Menu.more:
                              appDomain.goToMore();
                              break;
                          }
                        },
                      ),
                    )
            : Padding(
                padding: EdgeInsets.only(
                  bottom:
                      (keyboardHeight > 0 ? keyboardHeight : systemBottom) + 16,
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                child: SizedBox(
                  width: double.infinity, // prend toute la largeur disponible
                  height: 56, // hauteur classique d’un gros bouton
                  child: ElevatedButton(
                    onPressed: appState.bottomButtonCallback,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60), // arrondi
                      ),
                    ),
                    child: Text(
                      appState.bottomButtonText!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // floatingActionButton: FloatingActionButton(
                //   onPressed: () => appDomain?.goToInitSettings(),
                //   child: const Icon(Icons.arrow_right),
                // ),
              ),
      ),
    );
  }
}
