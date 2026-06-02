import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/providers.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/confirm_dialog.dart';
import 'package:hydrao_flutter_offline/ui/fragments/page/global_settings_fragment.dart';
import 'package:hydrao_flutter_offline/ui/fragments/page/import_backup_fragment.dart';

const _logTag = "[CONFIGURE_APP_DIALOG] ";

/// Fonction pour afficher la dialog
Future<void> showConfigureAppDialog({
  required BuildContext context,
  Settings? settings,
  required Function onReset,
  required void Function(From from) onImportBackup,
  required Function onCreateBackup,
  required bool Function(AppSettingsCompanion changes) onSave,
}) async {
  await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return ProviderScope(
        child: ConfigureAppDialog(
          settings: settings,
          onReset: onReset,
          onSave: onSave,
          onCreateBackup: onCreateBackup,
          onImportBackup: onImportBackup,
        ),
      );
    },
  );
}

class ConfigureAppDialog extends ConsumerWidget {
  final Settings? settings;
  final bool Function(AppSettingsCompanion changes) onSave;
  final Function onReset;
  final void Function(From from) onImportBackup;
  final Function onCreateBackup;

  const ConfigureAppDialog({
    super.key,
    this.settings,
    required this.onReset,
    required this.onSave,
    required this.onCreateBackup,
    required this.onImportBackup,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final formState = ref.watch(settingsFormStateProvider);

    appLogger.d('$_logTag build');

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
      // for form state
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxDialogWidth = constraints.maxWidth;
          // si tu veux limiter encore (ex: max 500)
          final double dialogWidth = maxDialogWidth.clamp(0, 500.0);

          // appLogger.d('$LOG_TAG dialog max width=$dialogWidth');

          return AlertDialog(
            contentPadding: EdgeInsets.all(12),
            titlePadding: EdgeInsets.only(
              top: 12,
              bottom: 2,
              left: 8,
              right: 8,
            ),
            title: Text(t.configAppDialogTitle, textAlign: TextAlign.center),
            content: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: dialogWidth),
              child: Scrollbar(
                thumbVisibility:
                    true, // si tu veux qu'elle soit visible permanent, sinon retire cette ligne
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: dialogWidth,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GlobalSettingsFragment(
                            settings: settings,
                            canReset: true,
                            canBackup: true,
                            onReset: () {
                              onReset();
                              Navigator.of(context).pop();
                            },
                            onImportBackup: onImportBackup,
                            onCreateBackup: onCreateBackup,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
                    ? () {
                        if (onSave(formState.changes!) == true) {
                          Navigator.of(context).pop();
                        }
                      }
                    : null,
                child: Text(t.save),
              ),
            ],
          );
        },
      ),
    );
  }
}
