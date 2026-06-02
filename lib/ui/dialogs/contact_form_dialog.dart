import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/ui/fragments/page/form_contact_us_fragment.dart';

Future<void> showContactFormDialog({required BuildContext context}) async {
  final t = AppLocalizations.of(context)!;

  appLogger.d("[CONTACT_FORM_DIALOG] build");

  await showDialog<bool>(
    context: context,
    barrierDismissible: false, // ferme la popup si on tape à l’extérieur
    useSafeArea: true,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setState) {
          // IMPORTANT : Utiliser le context du Builder pour capter les insets
          final double keyboardHeight = MediaQuery.of(
            context,
          ).viewInsets.bottom;
          final double screenHeight = MediaQuery.of(context).size.height;

          return AlertDialog(
            contentPadding: EdgeInsets.all(12),
            // titlePadding: EdgeInsets.only(top: 8, bottom: 2, left: 8, right: 8),
            actionsPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              t.formContactUsDialogTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            // On désactive le scroll interne de la dialog pour laisser la WebView gérer
            scrollable: false,
            content: AnimatedContainer(
              // Pour une transition fluide quand le clavier sort
              duration: const Duration(milliseconds: 200),
              width: MediaQuery.of(context).size.width * 0.9,
              // On calcule la hauteur : Écran - Clavier - Marges (AppBar/Padding)
              // Si keyboardHeight > 0, la hauteur diminue automatiquement
              height: keyboardHeight > 0
                  ? screenHeight - keyboardHeight - 100
                  : 500,
              child: Column(
                children: [Expanded(child: FormContactUsFragment())],
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
            ], // Hauteur par défaut clavier fermé
          );
        },
      );
    },
  );
}
