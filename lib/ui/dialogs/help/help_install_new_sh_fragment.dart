import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/theme.dart';

class HelpInstallNewShFragment extends StatelessWidget {
  final String type;

  const HelpInstallNewShFragment({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    // final t = AppLocalizations.of(context)!;

    Widget content;
    switch (type) {
      case 'aloe':
      case 'cereus':
        content = buildAloe(context);
        break;
      case 'yucca':
        content = buildYucca(context);
        break;
      default:
        content = Container();
        break;
    }

    return content;
  }

  Widget buildAloe(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Column(
      children: [
        buildStepSection(t.instAloe1, "assets/images/inst_aloe_1.svg"),
        // SizedBox(height: 12),
        // buildStepSection(t.instAloe2, "assets/images/inst_aloe_2.svg"),
        SizedBox(height: 12),
        buildStepSection(t.instAloe3, "assets/images/inst_aloe_3.svg"),
      ],
    );
  }

  Widget buildYucca(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Column(
      children: [
        buildStepSection(t.instYucca1, "assets/images/inst_yucca_1.svg"),
        SizedBox(height: 12),
        buildStepSection(t.instYucca2, "assets/images/inst_yucca_2.svg"),
        SizedBox(height: 12),
        buildStepSection(t.instYucca3, "assets/images/inst_yucca_3.svg"),
      ],
    );
  }

  Widget buildStepSection(String title, String image) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.sectionBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      width: double.infinity,
      child: Column(
        children: [
          SvgPicture.asset(image, width: 150),
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
