import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/help_dialog.dart';
import 'package:hydrao_flutter_offline/ui/fragments/menu_fragment.dart';

enum AppStatus {
  splashscreen,
  onboarding,
  dashboard,
  addShowerhead,
  statistics,
  more,
}

class AppState {
  final String? title;
  final Color? backgroundColor;
  final List<Widget>? pageActions;
  final AppStatus status;
  final HelpCase? help;
  final String? helpData;
  final String? backButtonKey;
  final VoidCallback? backButtonCallback;
  final String? bottomButtonKey;
  final String? bottomButtonText;
  final VoidCallback? bottomButtonCallback;
  final Menu? bottomMenu;
  final Settings? settings;
  final List<Showerhead>? showerheads;
  final List<Shower>? showers;
  final String? backWarning;

  const AppState({
    this.title,
    this.pageActions,
    this.status = AppStatus.splashscreen,
    this.help,
    this.helpData,
    this.backButtonKey,
    this.backButtonCallback,
    this.bottomButtonKey,
    this.bottomButtonText,
    this.bottomButtonCallback,
    this.bottomMenu,
    this.settings,
    this.showerheads,
    this.showers,
    this.backgroundColor,
    this.backWarning,
  });

  AppState copyWith({
    String? title,
    List<Widget>? pageActions,
    AppStatus? status,
    HelpCase? help,
    String? helpData,
    String? backButtonKey,
    VoidCallback? backButtonCallback,
    Menu? bottomMenu,
    String? bottomButtonKey,
    String? bottomButtonText,
    VoidCallback? bottomButtonCallback,
    Settings? settings,
    List<Showerhead>? showerheads,
    List<Shower>? showers,
    Color? backgroundColor,
    String? backWarning,
    bool resetTitle = false,
    bool resetHelp = false,
    bool resetBottomButton = false,
    bool resetBottomButtonCallback = false,
    bool resetBottomMenu = false,
    bool resetBackButton = false,
    bool resetSettings = false,
    bool resetBackgroundColor = false,
    bool resetBackWarning = false,
  }) {
    return AppState(
      title: resetTitle ? null : title ?? this.title,
      pageActions: pageActions ?? this.pageActions,
      status: status ?? this.status,
      help: resetHelp ? null : help ?? this.help,
      helpData: resetHelp ? null : helpData ?? this.helpData,
      backButtonKey: resetBackButton
          ? null
          : backButtonKey ?? this.backButtonKey,
      backButtonCallback: resetBackButton
          ? null
          : backButtonCallback ?? this.backButtonCallback,
      bottomButtonKey: resetBottomButton
          ? null
          : bottomButtonKey ?? this.bottomButtonKey,
      bottomButtonText: resetBottomButton
          ? null
          : bottomButtonText ?? this.bottomButtonText,
      bottomButtonCallback: resetBottomButtonCallback
          ? null
          : bottomButtonCallback ?? this.bottomButtonCallback,
      bottomMenu: resetBottomMenu ? null : bottomMenu ?? this.bottomMenu,
      settings: resetSettings ? null : settings ?? this.settings,
      showerheads: showerheads ?? this.showerheads,
      showers: showers ?? this.showers,
      backgroundColor: resetBackgroundColor
          ? null
          : backgroundColor ?? this.backgroundColor,
      backWarning: resetBackWarning ? null : backWarning ?? this.backWarning,
    );
  }

  @override
  String toString() {
    return 'AppState(title: $title, status: $status, backgroundColor: $backgroundColor, pageActions: ${pageActions?.length ?? 0} widgets, help: $help, helpData: $helpData, backButtonKey: $backButtonKey, bottomButtonText: $bottomButtonText, bottomButtonCallback: ${bottomButtonCallback != null
        ? 'Present'
        : (backButtonKey != null)
        ? 'grisé'
        : 'masqué'}, bottomMenu: ${bottomMenu != null ? 'Present' : 'null'}, showerheadsCount: ${showerheads?.length ?? 0}, showersCount: ${showers?.length ?? 0}, backWarning: $backWarning)';
  }
}
