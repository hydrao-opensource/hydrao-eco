import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/theme.dart';

class HelpRemoveFlowRestrictorFragment extends StatelessWidget {
  final String type;

  const HelpRemoveFlowRestrictorFragment({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Column(
      children: [
        buildStepSection(t.helpRemoveFlowRestrictorDialogIssuesSection, null),
        if (type == "aloe") SizedBox(height: 8),
        if (type == "aloe")
          buildStepSection(
            t.helpRemoveFlowRestrictorDialogRemoveSection,
            "assets/images/remove_flow_restrictor.svg",
          ),
      ],
    );
  }

  Widget buildStepSection(String title, String? image) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.sectionBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      width: double.infinity,
      child: Column(
        children: [
          if (image != null) SvgPicture.asset(image, width: 150),
          SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textColor),
          ),
        ],
      ),
    );
  }
}
