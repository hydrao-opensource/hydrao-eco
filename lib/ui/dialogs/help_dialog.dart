import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/help/help_install_new_sh_fragment.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/help/help_remove_flow_restrictor_fragment.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/help/help_sh_not_detected_fragment.dart';
import 'package:hydrao_flutter_offline/ui/fragments/page/faq_fragment.dart';
import 'package:hydrao_flutter_offline/ui/fragments/page/legal_notice_fragment.dart';

enum HelpCase {
  installNewSh,
  shNotDetected,
  faq,
  legalNotice,
  removeFlowRestrictor,
}

Future<void> showHelpDialog({
  required BuildContext context,
  required HelpCase key,
  String? data,
  VoidCallback? onConfirm,
}) async {
  final t = AppLocalizations.of(context)!;

  String title = "Aide";
  Widget? content;
  switch (key) {
    case HelpCase.installNewSh:
      title = t.needHelpToInstall;
      content = HelpInstallNewShFragment(type: data!);
      break;
    case HelpCase.shNotDetected:
      title = t.helpShNotDetectedDialogTitle;
      content = HelpShNotDetectedFragment();
      break;
    case HelpCase.faq:
      title = t.faqDialogTitle;
      content = FaqFragment();
      break;
    case HelpCase.legalNotice:
      title = t.legalNotice;
      content = LegalNoticeFragment();
      break;
    case HelpCase.removeFlowRestrictor:
      title = t.helpRemoveFlowRestrictorDialogTitle;
      content = HelpRemoveFlowRestrictorFragment(type: data!);
      break;
  }

  appLogger.d("[HELP_DIALOG] build / key=$key");

  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: true, // ferme la popup si on tape à l’extérieur
    useSafeArea: true,
    builder: (ctx) {
      return AlertDialog(
        contentPadding: EdgeInsets.all(12),
        // titlePadding: EdgeInsets.only(top: 8, bottom: 2, left: 8, right: 8),
        actionsPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: Scrollbar(
          thumbVisibility: true,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
            child: SingleChildScrollView(child: content),
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(true);
              if (onConfirm != null) onConfirm();
            },
            child: Text(t.close),
          ),
        ],
      );
    },
  );

  if (result == null) {
    if (onConfirm != null) onConfirm();
  }
}
