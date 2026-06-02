import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/ui/fragments/page/create_backup_fragment.dart';

Future<void> showCreateBackupDialog({
  required BuildContext context,
  required File backupFile,
  required VoidCallback onShare,
}) async {
  final t = AppLocalizations.of(context)!;

  appLogger.d('[CREATE_BACKUP_DIALOG] build');

  await showDialog<bool>(
    context: context,
    barrierDismissible: true, // ferme la popup si on tape à l’extérieur
    builder: (ctx) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          t.createBackupDialogTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: CreateBackupFragment(
            backupFile: backupFile,
            onShareTap: onShare,
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
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
