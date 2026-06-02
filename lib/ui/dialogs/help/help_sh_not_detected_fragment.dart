import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/theme.dart';
import 'package:hydrao_flutter_offline/ui/widgets/custom_expansion_tile.dart';

class HelpShNotDetectedFragment extends StatelessWidget {
  const HelpShNotDetectedFragment({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    Map<String, List<String>> sections = {
      t.helpShNotDetectedNeedShowerSectionTitle: [
        t.helpShNotDetectedNeedShowerWaterText,
        t.helpShNotDetectedNeedShowerLightsText,
      ],
      t.helpShNotDetectedBleSectionTitle: [
        t.helpShNotDetectedBleCompatibilityText,
        t.helpShNotDetectedBleServiceText,
        t.helpShNotDetectedBlePermissionText,
        t.helpShNotDetectedBleRangeText,
      ],
      t.helpShNotDetectedConflictSectionTitle: [
        t.helpShNotDetectedConflictOnlyOneDevieText,
        t.helpShNotDetectedConflictGateway,
      ],
    };

    List<Widget> sectionsViews = [];

    for (var sectionEntry in sections.entries) {
      sectionsViews.add(
        buildCheckSection(sectionEntry.key, sectionEntry.value),
      );
      sectionsViews.add(SizedBox(height: 12));
    }

    return Column(mainAxisSize: MainAxisSize.min, children: sectionsViews);
  }

  Widget buildCheckSection(String title, List<String> checks) {
    List<Widget> checkViews = [];
    for (var check in checks) {
      checkViews.add(
        Text(
          check,
          textAlign: TextAlign.start,
          style: TextStyle(color: AppTheme.textColor),
        ),
      );
      checkViews.add(SizedBox(height: 15));
    }

    return CustomExpansionTile(
      expandable: false,
      expanded: true,
      globalPadding: 12,
      title: title,
      contentAlignement: CrossAxisAlignment.start,
      children: checkViews,
    );
  }
}
