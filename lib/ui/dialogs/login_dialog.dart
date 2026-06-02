import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/domains/form_domain.dart';
import 'package:hydrao_flutter_offline/domains/user_state.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/models/authentication.dart';
import 'package:hydrao_flutter_offline/providers.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/confirm_dialog.dart';
import 'package:hydrao_flutter_offline/ui/fragments/page/login_form_fragment.dart';

const _logTag = "[LOGIN_DIALOG] ";

/// Fonction pour afficher la dialog
Future<void> showLoginDialog({
  required BuildContext context,
  String? message,
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return ProviderScope(child: LoginDialog(message: message));
    },
  );
}

class LoginDialog extends ConsumerWidget {
  final String? message;

  const LoginDialog({super.key, this.message});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final formState = ref.watch(loginFormStateProvider);
    final FormDomain<Authentication> formDomain = ref.watch(
      loginFormStateProvider.notifier,
    );
    final userState = ref.watch(userDomainProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userState.authStatus == AuthStatus.logged) {
        Navigator.of(context).pop();
      }
      if (userState.authFailed == true) {
        formDomain.updateErrors({
          Field.failed.toString(): t.loginFormFailMessage,
        });
        ref.watch(userDomainProvider.notifier).clearAuthFailed();
      }
    });

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
          final maxDialogWidth = constraints.maxWidth;
          final double dialogWidth = maxDialogWidth.clamp(0, 500.0);

          // hauteur max pour la PARTIE CONTENU (les tabs + scroll),
          // on laisse le reste pour le titre + les actions
          final screenHeight = MediaQuery.of(context).size.height;
          var contentHeight = screenHeight * 0.7; // ajuste 0.5 / 0.7 si tu veux

          contentHeight = min(contentHeight, 350);

          return AlertDialog(
            contentPadding: EdgeInsets.all(12),
            actionsPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            title: Text(t.loginDialogTitle, textAlign: TextAlign.center),
            content: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: dialogWidth),
              child: SizedBox(
                width: dialogWidth,
                height: contentHeight, // 🔑 hauteur bornée du contenu
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
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
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [LoginForm(message: message)],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
                onPressed:
                    userState.authStatus != AuthStatus.logging &&
                        formState.isValid() &&
                        formState.hasChanges() == true
                    ? () async {
                        final authentication = formDomain.getChanges();
                        await ref
                            .watch(userDomainProvider.notifier)
                            .login(
                              authentication!.email!,
                              authentication.password!,
                            );
                      }
                    : null,
                child: userState.authStatus != AuthStatus.logging
                    ? Text(t.login)
                    : Text(t.connecting),
              ),
            ],
          );
        },
      ),
    );
  }
}
