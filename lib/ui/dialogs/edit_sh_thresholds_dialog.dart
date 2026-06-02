import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/constants.dart';
import 'package:hydrao_flutter_offline/conversions.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/models/threshold.dart';
import 'package:hydrao_flutter_offline/theme.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/confirm_dialog.dart';
import 'package:hydrao_flutter_offline/ui/widgets/threshold_selector/threshold_selector.dart';

const _logTag = "[EDIT_SH_THRESHOLDS_DIALOG] ";

/// Fonction pour afficher la dialog
Future<void> showEditShThresholdsDialog(
  BuildContext context,
  List<HydraoThreshold> thresholds,
  String unit,
  void Function(List<HydraoThreshold> changes) onSave,
) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return EditShThresholdsDialog(
        thresholds: thresholds,
        unit: unit,
        onSave: onSave,
      );
    },
  );
}

class EditShThresholdsDialog extends StatefulWidget {
  final List<HydraoThreshold> thresholds;
  final String unit;
  final void Function(List<HydraoThreshold> changes) onSave;

  const EditShThresholdsDialog({
    super.key,
    required this.thresholds,
    required this.unit,
    required this.onSave,
  });

  @override
  // ignore: library_private_types_in_public_api
  _EditShThresholdsDialogState createState() => _EditShThresholdsDialogState();
}

class _EditShThresholdsDialogState extends State<EditShThresholdsDialog> {
  late List<HydraoThreshold> _currentThresholds;

  @override
  void initState() {
    super.initState();

    _currentThresholds = widget.thresholds.map((t) => t).toList();
  }

  bool _hasChanges() {
    return thresholdsHasChanged(widget.thresholds, _currentThresholds);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    appLogger.d('$_logTag build / _currentThresholds=$_currentThresholds');

    List<HydraoThreshold> defaultThresholds = thresholdsFromJson(
      AppConstants.shDefaultThresholds,
    )!;

    return PopScope<bool>(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, bool? result) async {
        if (didPop) return;

        bool canClose = false;
        if (_hasChanges() == true) {
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
          final maxDialogWidth = constraints.maxWidth;
          // si tu veux limiter encore (ex: max 500)
          final double dialogWidth = maxDialogWidth.clamp(0, 500.0);

          appLogger.d('$_logTag dialog max width=$dialogWidth');

          return AlertDialog(
            title: Text(
              t.editShThresholdsDialogTitle,
              textAlign: TextAlign.center,
            ),
            content: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: dialogWidth),
              child: SingleChildScrollView(
                child: SizedBox(
                  width: dialogWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ThresholdSelector(
                        width: 280,
                        height: 350,
                        thresholds: _currentThresholds,
                        unit: widget.unit,
                        onChange: (newThresholds) {
                          setState(() {
                            _currentThresholds = newThresholds;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // reset thresholds
                  if (thresholdsHasChanged(
                    _currentThresholds,
                    defaultThresholds,
                  ))
                    TextButton(
                      onPressed: () async {
                        if (context.mounted) {
                          setState(() {
                            _currentThresholds = defaultThresholds
                                .map((t) => t)
                                .toList();
                            appLogger.d(
                              "$_logTag reset thresholds : $_currentThresholds",
                            );
                          });
                        }
                      },
                      child: Text(
                        t.reset,
                        style: TextStyle(color: AppTheme.textWarningColor),
                      ),
                    ),
                  TextButton(
                    onPressed: () async {
                      final shouldClose = _hasChanges() == true
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
                    onPressed: _hasChanges() == true
                        ? () async {
                            widget.onSave(_currentThresholds);
                            Navigator.of(context).pop();
                          }
                        : null,
                    child: Text(t.save),
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
