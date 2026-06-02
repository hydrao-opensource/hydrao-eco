import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/models/learning_period.dart';
import 'package:hydrao_flutter_offline/providers.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/confirm_dialog.dart';
import 'package:hydrao_flutter_offline/ui/fragments/page/finish_learning_period_fragment.dart';

const _logTag = "[STOP_LEARNING_PERIOD_DIALOG] ";

/// Fonction pour afficher la dialog
Future<void> showStopLearningPeriodDialog({
  required BuildContext context,
  required LearningPeriod learningPeriod,
  required String waterUnit,
  required void Function(LearningPeriod period) onStop,
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return ProviderScope(
        child: StopLearningPeriodDialog(
          onStop: onStop,
          waterUnit: waterUnit,
          learningPeriod: learningPeriod,
        ),
      );
    },
  );
}

class StopLearningPeriodDialog extends ConsumerWidget {
  final void Function(LearningPeriod period) onStop;
  final LearningPeriod learningPeriod;
  final String waterUnit;

  const StopLearningPeriodDialog({
    super.key,
    required this.onStop,
    required this.learningPeriod,
    required this.waterUnit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final formState = ref.watch(shLearningPeriodFormStateProvider);

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
      child: LayoutBuilder(
        builder: (context, constraints) {
          // final maxDialogWidth = constraints.maxWidth;
          // // si tu veux limiter encore (ex: max 500)
          // final double dialogWidth = maxDialogWidth.clamp(0, 500.0);

          // print('$LOG_TAG dialog max width=$dialogWidth');

          return AlertDialog(
            contentPadding: EdgeInsets.all(12),
            titlePadding: EdgeInsets.only(
              top: 12,
              bottom: 2,
              left: 8,
              right: 8,
            ),
            title: Text(
              t.stopLearningPeriodDialogTitle,
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FinishLearningPeriodFragment(
                    learningPeriod: learningPeriod,
                    waterUnit: waterUnit,
                  ),
                ],
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
                        onStop(formState.changes!);
                        Navigator.of(context).pop();
                      }
                    : null,
                child: Text(t.confirm),
              ),
            ],
          );
        },
      ),
    );
  }
}
