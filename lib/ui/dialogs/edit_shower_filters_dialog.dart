import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/models/shower_filters.dart';
import 'package:hydrao_flutter_offline/providers.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';
import 'package:hydrao_flutter_offline/theme.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/confirm_dialog.dart';
import 'package:hydrao_flutter_offline/ui/fragments/page/shower_filters_fragment.dart';

const _logTag = "[EDIT_SHOWER_FILTERS_DIALOG] ";

/// Fonction pour afficher la dialog
Future<void> showEditShowerFiltersDialog({
  required BuildContext context,
  required Showerhead sh,
  required ShowerFilters filters,
  required String waterUnit,
  required void Function(ShowerFilters changes) onSave,
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return ProviderScope(
        child: EditShowerFiltersDialog(
          sh: sh,
          filters: filters,
          onSave: onSave,
          waterUnit: waterUnit,
        ),
      );
    },
  );
}

class EditShowerFiltersDialog extends ConsumerWidget {
  final Showerhead sh;
  final ShowerFilters filters;
  final void Function(ShowerFilters changes) onSave;
  final String waterUnit;

  const EditShowerFiltersDialog({
    super.key,
    required this.sh,
    required this.filters,
    required this.onSave,
    required this.waterUnit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final formState = ref.watch(showerFiltersStateProvider);

    bool hasActiveFilters =
        (formState.changes != null && formState.changes!.count() > 0) ||
        (formState.changes == null && filters.count() > 0);

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

          appLogger.d('$_logTag dialog max width=$dialogWidth');

          return AlertDialog(
            title: Text(
              t.showerFiltersDialogTitle,
              textAlign: TextAlign.center,
            ),
            contentPadding: EdgeInsets.all(12),
            titlePadding: EdgeInsets.only(
              top: 12,
              bottom: 2,
              left: 8,
              right: 8,
            ),
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
                          ShowerFiltersFragment(
                            filters: filters,
                            waterUnit: waterUnit,
                            sh: sh,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (hasActiveFilters)
                    TextButton(
                      onPressed: () async {
                        if (context.mounted) {
                          onSave(ShowerFilters(actives: []));
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(
                        t.erase,
                        style: TextStyle(color: AppTheme.textWarningColor),
                      ),
                    ),
                  if (hasActiveFilters) Spacer(),
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
                    onPressed:
                        formState.isValid() && formState.hasChanges() == true
                        ? () {
                            onSave(formState.changes!);
                            Navigator.of(context).pop();
                          }
                        : null,
                    child: Text(t.filter),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
