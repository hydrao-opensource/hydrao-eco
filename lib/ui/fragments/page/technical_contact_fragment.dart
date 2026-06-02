import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/domains/form_domain.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/models/support_message.dart';
import 'package:hydrao_flutter_offline/providers.dart';
import 'package:hydrao_flutter_offline/theme.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/contact_form_dialog.dart';
import 'package:hydrao_flutter_offline/ui/widgets/custom_expansion_tile.dart';
import 'package:hydrao_flutter_offline/ui/widgets/labeled_checkbox.dart';

const _logTag = "[TECHNICAL_CONTACT_FRAGMENT] ";

enum Field { message, withTechData, withUserData }

class TechnicalContactFragment extends ConsumerStatefulWidget {
  final void Function(SupportMessage support) onSend;

  const TechnicalContactFragment({super.key, required this.onSend});

  @override
  ConsumerState<TechnicalContactFragment> createState() =>
      _ContactUsFragmentState();
}

class _ContactUsFragmentState extends ConsumerState<TechnicalContactFragment> {
  String? message;
  bool withTechData = true;
  bool withUserData = false;
  late FormDomain<SupportMessage> formDomain;
  bool stateInitialized = false;

  @override
  void initState() {
    super.initState();

    formDomain = ref.read(contactUsFormStateProvider.notifier);
  }

  void onFieldChanged(Field field, dynamic value) {
    // if (!mounted) return;

    appLogger.d('$_logTag field "${field.toString()}" changed : $value');

    setState(() {
      switch (field) {
        case Field.message:
          setState(() {
            if (value != null && (value as String).isEmpty) {
              value = null;
            }
            message = value as String;
          });
          break;
        case Field.withTechData:
          setState(() {
            withTechData = value as bool;
          });
          break;
        case Field.withUserData:
          setState(() {
            withUserData = value as bool;
          });
          break;
      }

      // update state
      formDomain.setChanges(
        SupportMessage(
          message ?? "",
          withTechData: withTechData,
          withUserData: withUserData,
        ),
      );

      // validate values
      var errors = _checkErrors();
      formDomain.updateErrors(errors);
    });
  }

  Map<String, String> _checkErrors() {
    // final t = AppLocalizations.of(context)!;

    Map<String, String> errors = {};

    // no error in this form
    // final required = validateRequired(t, message);
    // if (required != null) {
    //   errors[Field.message.toString()] = required;
    // }

    if (!withTechData && !withUserData) {
      errors['MinContent'] = "At least one data must be shared";
    }

    return errors;
  }

  @override
  Widget build(BuildContext context) {
    appLogger.d('$_logTag build');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (stateInitialized == false) {
        formDomain.setChanges(
          SupportMessage(
            message ?? "",
            withTechData: withTechData,
            withUserData: withUserData,
          ),
        );
        formDomain.updateErrors({});
        stateInitialized = true;
      }
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildFirstContactSection(),
        SizedBox(height: 12),
        buildTechContactSection(),
      ],
    );
  }

  Widget buildFirstContactSection() {
    final t = AppLocalizations.of(context)!;

    return CustomExpansionTile(
      title: t.contactUsNeedHelpSection,
      expanded: true,
      children: [
        Text(
          t.contactUsNeedHelpText,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
          onPressed: () async {
            showContactFormDialog(context: context);
          },
          child: Text(t.begin),
        ),
      ],
    );
  }

  Widget buildTechContactSection() {
    final t = AppLocalizations.of(context)!;

    final formState = ref.watch(contactUsFormStateProvider);

    return CustomExpansionTile(
      title: t.contactUsSupportNeedDataSection,
      children: [
        Text(
          t.contactUsSupportNeedDataText,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 12),
        buildMessageInput(),
        const SizedBox(height: 12),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
          onPressed: formState.isValid()
              ? () async {
                  widget.onSend(formState.changes!);
                  Navigator.of(context).pop();
                }
              : null,
          child: Text(t.send),
        ),
      ],
    );
  }

  Widget buildMessageInput() {
    final t = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 5),
      child: Column(
        children: [
          // buildTextAreaField(
          //   message,
          //   (String? newValue) {
          //     onFieldChanged(Field.message, newValue);
          //   },
          //   minLines: 8,
          //   hintText: t.contactUsMessageHint,
          //   errorMessage: formDomain.getFieldError(Field.message.toString()),
          // ),
          // SizedBox(height: 8),
          LabeledCheckbox(
            value: withTechData,
            label: Text(
              t.contactUsAllowShareTechData,
              style: TextStyle(color: AppTheme.textColor),
            ),
            onChanged: (newValue) {
              onFieldChanged(Field.withTechData, newValue);
            },
          ),
          SizedBox(height: 8),
          LabeledCheckbox(
            value: withUserData,
            label: Text(
              t.contactUsAllowShareUserData,
              style: TextStyle(color: AppTheme.textColor),
            ),
            onChanged: (newValue) {
              onFieldChanged(Field.withUserData, newValue);
            },
          ),
        ],
      ),
    );
  }
}
