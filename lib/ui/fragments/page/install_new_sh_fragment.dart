import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/constants.dart';
import 'package:hydrao_flutter_offline/core/form_fields.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/theme.dart';
import 'package:hydrao_flutter_offline/ui/widgets/help_incitation.dart';

// const _logTag = "[INSTALL_NEW_SH_FRAGMENT] ";

class InstallNewShFragment extends StatefulWidget {
  final String type;
  final VoidCallback? onHelpTap; // callback optionnel
  final void Function(String type)
  onTypeChanged; // callback to retreive type selected

  const InstallNewShFragment({
    super.key,
    required this.type,
    required this.onTypeChanged,
    this.onHelpTap,
  });

  @override
  State<InstallNewShFragment> createState() => _InstallNewShFragmentState();
}

class _InstallNewShFragmentState extends State<InstallNewShFragment> {
  String? type;

  void _notifyChange() {
    widget.onTypeChanged(type!);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    type ??= widget.type;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: AppTheme.sectionBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/install_showerhead.png',
                width: 180,
                height: 180,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 15),

              Text(
                t.installNewShText,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),

              Center(
                child: SizedBox(
                  width: 200,
                  child: buildDropdownField(
                    type,
                    AppConstants.getTypeLabels(t),
                    (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          type = newValue;
                        });
                        _notifyChange();
                      }
                    },
                    label: t.installNewShProduct,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        if (type != "mixer")
          HelpIncitation(message: t.needHelpToInstall, onTap: widget.onHelpTap),
      ],
    );
  }
}
