import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrao_flutter_offline/core/form_fields.dart';
import 'package:hydrao_flutter_offline/core/form_validators.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/domains/form_domain.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/models/authentication.dart';
import 'package:hydrao_flutter_offline/providers.dart';
import 'package:hydrao_flutter_offline/theme.dart';

const _logTag = "[LOGIN_FORM] ";

enum Field { email, password, failed }

class LoginForm extends ConsumerStatefulWidget {
  final String? message;

  const LoginForm({super.key, this.message});

  @override
  ConsumerState<LoginForm> createState() => LoginFormState();
}

class LoginFormState extends ConsumerState<LoginForm> {
  String? email;
  String? password;
  late FormDomain<Authentication> formDomain;

  @override
  void initState() {
    super.initState();

    formDomain = ref.read(loginFormStateProvider.notifier);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onFieldChanged(Field field, dynamic value) {
    // if (!mounted) return;
    appLogger.d('$_logTag field "${field.toString()}" changed : $value');
    switch (field) {
      case Field.email:
        setState(() {
          email = value as String?;
        });
        break;
      case Field.password:
        setState(() {
          password = value as String?;
        });
        break;
      case Field.failed:
        break;
    }

    // update state
    Authentication? changes;
    if (email != null || password != null) {
      changes = Authentication(email, password);
    }
    if (changes != null) {
      formDomain.setChanges(changes);
    } else {
      formDomain.resetChanges();
    }

    // validate values
    var errors = _checkErrors();
    formDomain.updateErrors(errors);
  }

  Map<String, String> _checkErrors() {
    final t = AppLocalizations.of(context)!;

    Map<String, String> errors = {};

    // email required
    var required = validateRequired(t, email);
    if (required != null) {
      errors[Field.email.toString()] = required;
    }

    // password required
    required = validateRequired(t, password);
    if (required != null) {
      errors[Field.password.toString()] = required;
    }

    appLogger.d('$_logTag checkErrors : $errors');
    return errors;
  }

  @override
  Widget build(BuildContext context) {
    // final t = AppLocalizations.of(context)!;

    final failedError = formDomain.getFieldError(Field.failed.toString());

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.message != null)
          buildNoticePanel(
            widget.message!,
            Icons.info_outlined,
            AppTheme.textColor,
          ),
        if (widget.message != null) const SizedBox(height: 15),

        buildLoginPanel(),

        if (failedError != null) SizedBox(height: 15),
        if (failedError != null)
          buildNoticePanel(
            failedError,
            Icons.warning_rounded,
            AppTheme.textWarningColor,
          ),
      ],
    );
  }

  Widget buildLoginPanel() {
    final t = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      decoration: BoxDecoration(
        color: AppTheme.sectionBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          buildTextField(
            email,
            (newValue) {
              _onFieldChanged(Field.email, newValue);
            },
            label: t.loginFormEmailField,
            errorMessage: formDomain.getFieldError(Field.email.toString()),
            borderSide: BorderSide(color: Colors.black12),
            layoutVertical: true,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 12),
          buildTextField(
            password,
            (newValue) {
              _onFieldChanged(Field.password, newValue);
            },
            label: t.loginFormPasswordField,
            errorMessage: formDomain.getFieldError(Field.password.toString()),
            borderSide: BorderSide(color: Colors.black12),
            layoutVertical: true,
            keyboardType: TextInputType.visiblePassword,
            isPassword: true,
          ),
        ],
      ),
    );
  }

  Widget buildNoticePanel(String message, IconData icon, Color frontColor) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: AppTheme.sectionBackground,
        borderRadius: BorderRadius.circular(8),
        border: BoxBorder.all(color: frontColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: frontColor),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: frontColor, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
