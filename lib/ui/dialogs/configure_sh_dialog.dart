import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/models/learning_period.dart';
import 'package:hydrao_flutter_offline/providers.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/confirm_dialog.dart';
import 'package:hydrao_flutter_offline/ui/fragments/page/configure_showerhead_fragment.dart';

const _logTag = "[CONFIGURE_SH_DIALOG] ";

/// Fonction pour afficher la dialog
Future<void> showConfigureShDialog({
  required BuildContext context,
  required String shId,
  required Future<bool> Function(ShowerheadsCompanion changes) onSave,
  required VoidCallback onDelete,
  required void Function(LearningPeriod period) onStopLearning,
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return ProviderScope(
        child: ConfigureShDialog(
          shId: shId,
          onSave: onSave,
          onDelete: onDelete,
          onStopLearning: onStopLearning,
        ),
      );
    },
  );
}

class ConfigureShDialog extends ConsumerWidget {
  final String shId;
  final Future<bool> Function(ShowerheadsCompanion changes) onSave;
  final VoidCallback onDelete;
  final void Function(LearningPeriod period) onStopLearning;

  const ConfigureShDialog({
    super.key,
    required this.shId,
    required this.onDelete,
    required this.onSave,
    required this.onStopLearning,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final appDomain = ref.read(appDomainProvider.notifier);
    final appState = ref.watch(appDomainProvider);
    final formState = ref.watch(shFormStateProvider);

    final sh = appDomain.getShowerhead(shId);

    if (sh == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted && Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      });
      return const SizedBox.shrink();
    }

    appLogger.d('$_logTag build');

    return PopScope<bool>(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, bool? result) async {
        if (didPop) return;

        bool canClose = !formState.hasChanges();
        if (!canClose) {
          canClose = await showConfirmDialog(
            context: context,
            message: t.confirmCloseFormWithChanges,
          );
        }
        if (canClose && context.mounted && Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxDialogWidth = constraints.maxWidth;
          final double dialogWidth = maxDialogWidth.clamp(0.0, 500.0);

          // hauteur max pour la PARTIE CONTENU (les tabs + scroll),
          // on laisse le reste pour le titre + les actions
          final screenHeight = MediaQuery.sizeOf(context).height;
          final contentHeight =
              screenHeight * 0.8; // ajuste 0.5 / 0.7 si tu veux

          return AlertDialog(
            contentPadding: EdgeInsets.all(12),
            titlePadding: EdgeInsets.only(top: 8, bottom: 2, left: 8, right: 8),
            actionsPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            title: Text(sh.name, textAlign: TextAlign.center),
            content: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: dialogWidth),
              child: SizedBox(
                width: dialogWidth,
                height: contentHeight,
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 4,
                        bottom: 4,
                        right: 15,
                        left: 4,
                      ),
                      child: ConfigureShowerheadForm(
                        unit: appDomain.getWaterUnit(),
                        sh: sh,
                        showers: appDomain.getShowers(
                          shId,
                          notEmpty: true,
                        ),
                        existingShs: appState.showerheads ?? [],
                        canDelete: true,
                        onDelete: () {
                          onDelete();
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                        onStopLearning: onStopLearning,
                        usecase: Usecase.edit,
                        refreshShName: () =>
                            appDomain.getNewShowerheadName(
                              Localizations.localeOf(context).toString(),
                            ),
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
                onPressed: formState.isValid() && formState.hasChanges()
                    ? () async {
                        final saved = await onSave(formState.changes!);
                        // ignore: use_build_context_synchronously
                        if (saved && context.mounted) {
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
