import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/domains/app_domain.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/models/support_message.dart';
import 'package:hydrao_flutter_offline/providers.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';
import 'package:hydrao_flutter_offline/theme.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/help_dialog.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/technical_contact_dialog.dart';
import 'package:hydrao_flutter_offline/ui/fragments/menu_fragment.dart';
import 'package:package_info_plus/package_info_plus.dart';

const _logTag = "[MORE_SCREEN] ";

class MoreScreen extends ConsumerStatefulWidget {
  const MoreScreen({super.key});

  @override
  ConsumerState<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends ConsumerState<MoreScreen> {
  bool isDisposed = false;
  AppDomain? appDomain;
  bool _isLoading = true;
  String? appVersion;

  // --- life cycle methods

  @override
  void initState() {
    super.initState();

    appDomain = ref.read(appDomainProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadData();

      _updateUIForScreenStatus();
    });
  }

  @override
  void dispose() {
    isDisposed = true;

    // try {

    // } catch (e) {
    //   // nothing to do ?
    // }

    super.dispose();
  }

  // --- Domain logic

  Future<void> _loadData() async {
    if (!_isLoading) return;

    // final t = AppLocalizations.of(context)!;

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // --- ui methods

  void _updateUIForScreenStatus() {
    if (!mounted) return;

    appDomain?.updatePage(
      resetTitle: true,
      resetBgColor: true,
      resetActions: true,
      resetBottomButton: true,
      resetBackButton: true,
      bottomMenu: Menu.more,
    );
  }

  Future<void> resetApp() async {
    appLogger.i('$_logTag resetting app...');
    await appDomain?.resetApp();
    appLogger.i('$_logTag App resetted !');
  }

  Future<void> saveAppSettings(AppSettingsCompanion changes) async {
    appLogger.i('$_logTag saving app settings...');
    await appDomain?.saveSettings(changes);
    appLogger.i('$_logTag App settings saved');
  }

  @override
  Widget build(BuildContext context) {
    if (isDisposed || !context.mounted) {
      return const Center(child: CircularProgressIndicator());
    }

    final t = AppLocalizations.of(context)!;

    appLogger.d('$_logTag build');

    // final appState = ref.watch(appDomainProvider);

    if (_isLoading || appDomain == null) {
      return const Center(child: CircularProgressIndicator());
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (appVersion == null) {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        setState(() {
          appVersion = packageInfo.version;
        });
        appLogger.i('$_logTag app version = $appVersion');
      }
    });

    // reactive view
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        buildMenuItem(t.moreScreenFaqMenuItem, () {
          showHelpDialog(context: context, key: HelpCase.faq);
        }),
        buildMenuItem(t.moreScreenLegalNoticeMenuItem, () {
          showHelpDialog(context: context, key: HelpCase.legalNotice);
        }),
        // buildMenuItem("Zoho Form", () {
        //   showContactFormDialog(context: context);
        // }),
        buildMenuItem(t.moreScreenContactUsMenuItem, () {
          appLogger.i('$_logTag show technical contact dialog');
          showTechnicalContactDialog(
            context: context,
            onSend: (SupportMessage support) async {
              appLogger.i('$_logTag sending message... $support');
              await appDomain?.sendSupportMessage(t, support);
              appLogger.i('$_logTag message sended !');
            },
          );
        }),
        if (appVersion != null)
          Text(
            appVersion!,
            style: TextStyle(
              color: AppTheme.textColor.withValues(alpha: 0.5),
              fontSize: 13,
            ),
          ),
      ],
    );
  }

  Widget buildMenuItem(
    String label,
    VoidCallback onTap, {
    Color? bgColor,
    Color? frontColor,
  }) {
    // Définition des couleurs par défaut si null
    final background = bgColor ?? Colors.white;
    final foreground =
        frontColor ?? AppTheme.textColor; // Gris foncé proche de l'image

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(
          20,
        ), // Coins très arrondis comme sur l'image
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: foreground,
                      fontSize: 16, // Texte assez grand comme sur le visuel
                      fontWeight: FontWeight.w700, // Bold prononcé
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: foreground,
                  size: 24, // Icône large pour correspondre à l'image
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
