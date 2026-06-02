import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/models/backup.dart';
import 'package:hydrao_flutter_offline/providers.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/confirm_dialog.dart';
import 'package:hydrao_flutter_offline/ui/fragments/page/import_backup_fragment.dart';

const _logTag = "[IMPORT_BACKUP_DIALOG] ";

/// Fonction pour afficher la dialog
Future<void> showImportBackupDialog({
  required BuildContext context,
  required HydraoBackup localData,
  required From from,
  required void Function(HydraoBackup backup) onBackupImport,
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return ProviderScope(
        child: ImportBackupDialog(
          onBackupImport: onBackupImport,
          localData: localData,
          from: from,
        ),
      );
    },
  );
}

class ImportBackupDialog extends ConsumerWidget {
  final void Function(HydraoBackup backup) onBackupImport;
  final HydraoBackup localData;
  final From from;

  const ImportBackupDialog({
    super.key,
    required this.onBackupImport,
    required this.localData,
    required this.from,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final formState = ref.watch(backupFormStateProvider);

    appLogger.d("$_logTag build");

    return PopScope<bool>(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, bool? result) async {
        if (didPop) return;

        bool canClose = false;
        if (formState.hasChanges()) {
          final result = await showConfirmDialog(
            context: context,
            message: t.confirmCloseFormWithChanges,
          );
          if (result) {
            canClose = true;
          }
        } else {
          canClose = true;
        }
        if (canClose) {
          // close if possible
          if (context.mounted && Navigator.canPop(context)) {
            Navigator.of(context).pop();
          }
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          // final maxDialogWidth = constraints.maxWidth;
          // si tu veux limiter encore (ex: max 500)
          // final double dialogWidth = maxDialogWidth.clamp(0, 500.0);

          // appLogger.d('$LOG_TAG dialog max width=$dialogWidth');

          return AlertDialog(
            contentPadding: EdgeInsets.all(12),
            titlePadding: EdgeInsets.only(
              top: 12,
              bottom: 2,
              left: 8,
              right: 8,
            ),
            title: Text(t.importBackupDialogTitle, textAlign: TextAlign.center),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [ImportBackupForm(localData: localData, from: from)],
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              TextButton(
                onPressed: () async {
                  final shouldClose = formState.hasChanges()
                      ? await showConfirmDialog(
                          context: context,
                          message: t.confirmCloseFormWithChanges,
                        )
                      : true;

                  if (shouldClose && context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                child: Text(t.close),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: formState.isValid() && formState.hasChanges() == true
                    ? () async {
                        onBackupImport(formState.changes!);
                        Navigator.of(context).pop();
                      }
                    : null,
                child: Text(t.import),
              ),
            ],
          );
        },
      ),
    );
  }
}
