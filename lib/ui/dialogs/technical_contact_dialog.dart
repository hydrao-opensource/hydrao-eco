import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/models/support_message.dart';
import 'package:hydrao_flutter_offline/ui/fragments/page/technical_contact_fragment.dart';

const _logTag = "[CONTACT_US_DIALOG] ";

/// Fonction pour afficher la dialog
Future<void> showTechnicalContactDialog({
  required BuildContext context,
  required void Function(SupportMessage support) onSend,
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return ProviderScope(child: TechnicalContactDialog(onSend: onSend));
    },
  );
}

class TechnicalContactDialog extends ConsumerWidget {
  final void Function(SupportMessage support) onSend;

  const TechnicalContactDialog({super.key, required this.onSend});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    appLogger.d('$_logTag build');

    return PopScope<bool>(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, bool? result) async {
        if (didPop) return;

        // bool canClose = false;
        // if (formState.hasChanges()) {
        //   final result = await showConfirmDialog(
        //     context: context,
        //     message: t.confirmCloseFormWithChanges,
        //   );
        //   if (result) {
        //     canClose = true;
        //   }
        // } else {
        //   canClose = true;
        // }
        // if (canClose) {
        // close if possible
        if (context.mounted && Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
        // }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxDialogWidth = constraints.maxWidth;
          // si tu veux limiter encore (ex: max 500)
          final double dialogWidth = maxDialogWidth.clamp(0, 500.0);

          // print('$LOG_TAG dialog max width=$dialogWidth');

          return AlertDialog(
            contentPadding: EdgeInsets.all(12),
            titlePadding: EdgeInsets.only(
              top: 12,
              bottom: 2,
              left: 8,
              right: 8,
            ),
            title: Text(t.contactUsDialogTitle, textAlign: TextAlign.center),
            content: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: dialogWidth),
              child: SingleChildScrollView(
                child: SizedBox(
                  width: dialogWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [TechnicalContactFragment(onSend: onSend)],
                  ),
                ),
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              TextButton(
                onPressed: () async {
                  // final shouldClose = formState.hasChanges()
                  //     ? await showConfirmDialog(
                  //         context: context,
                  //         message: t.confirmCloseFormWithChanges,
                  //       )
                  //     : true;

                  if ( /*shouldClose && */ context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                child: Text(t.close),
              ),
            ],
          );
        },
      ),
    );
  }
}
