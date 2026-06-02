import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/models/savings_stats.dart';
import 'package:hydrao_flutter_offline/theme.dart';
import 'package:hydrao_flutter_offline/ui/fragments/page/savings_details_fragment.dart';

const _logTag = "[SAVINGS_DETAILS_DIALOG] ";

Future<void> showSavingsDetailsDialog({
  required BuildContext context,
  required SavingsStats stats,
  required String waterUnit,
  required String currency,
  String? details,
}) async {
  final t = AppLocalizations.of(context)!;

  appLogger.d("$_logTag build");

  await showDialog<bool>(
    context: context,
    barrierDismissible: true, // ferme la popup si on tape à l’extérieur
    builder: (ctx) {
      return AlertDialog(
        contentPadding: EdgeInsets.all(12),
        // titlePadding: EdgeInsets.only(top: 8, bottom: 2, left: 8, right: 8),
        actionsPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Column(
          children: [
            Text(
              t.savingsDetailsDialogTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (details != null) SizedBox(height: 6),
            if (details != null)
              Text(
                details,
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  color: AppTheme.textColor.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
        content: Scrollbar(
          thumbVisibility: true,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
            child: SingleChildScrollView(
              child: SavingsDetailsFragment(
                stats: stats,
                waterUnit: waterUnit,
                currency: currency,
              ),
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(true);
            },
            child: Text(t.close),
          ),
        ],
      );
    },
  );
}
