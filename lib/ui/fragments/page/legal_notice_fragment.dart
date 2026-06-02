import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/ui/widgets/custom_expansion_tile.dart';

class LegalNoticeFragment extends StatelessWidget {
  const LegalNoticeFragment({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    Map<String, String> sections = {
      t.legalNoticeSection1Title: t.legalNoticeSection1Text,
      t.legalNoticeSection2Title: t.legalNoticeSection2Text,
      t.legalNoticeSection3Title: t.legalNoticeSection3Text,
      t.legalNoticeSection4Title: t.legalNoticeSection4Text,
      t.legalNoticeSection5Title: t.legalNoticeSection5Text,
      t.legalNoticeSection6Title: t.legalNoticeSection6Text,
      t.legalNoticeSection7Title: t.legalNoticeSection7Text,
      t.legalNoticeSection8Title: t.legalNoticeSection8Text,
      t.legalNoticeSection9Title: t.legalNoticeSection9Text,
      t.legalNoticeSection10Title: t.legalNoticeSection10Text,
      t.legalNoticeSection11Title: t.legalNoticeSection11Text,
      t.legalNoticeSection12Title: t.legalNoticeSection12Text,
      t.legalNoticeSection13Title: t.legalNoticeSection13Text,
      t.legalNoticeSection14Title: t.legalNoticeSection14Text,
      t.legalNoticeSection15Title: t.legalNoticeSection15Text,
      t.legalNoticeSection16Title: t.legalNoticeSection16Text,
      t.legalNoticeSection17Title: t.legalNoticeSection17Text,
    };

    List<Widget> sectionsViews = [];
    for (var section in sections.entries) {
      sectionsViews.add(buildSection(section.key, section.value));
      sectionsViews.add(SizedBox(height: 10));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      // children: [Text(t.legalNoticeText)],
      children: sectionsViews,
    );
  }

  Widget buildSection(String title, String text) {
    return CustomExpansionTile(title: title, children: [Text(text)]);
  }
}
