import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/theme.dart';
import 'package:hydrao_flutter_offline/ui/widgets/animated_sequence.dart';
import 'package:hydrao_flutter_offline/ui/widgets/help_incitation.dart';

class PartialScanningShFragment extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onHelpTap; // callback optionnel
  final double verticalPadding;

  const PartialScanningShFragment({
    super.key,
    required this.title,
    required this.message,
    this.onHelpTap,
    this.verticalPadding = 20,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        // constraints.maxWidth contient la largeur réelle utilisable ici
        double availableWidth = constraints.maxWidth;
        double animationSize = 75;
        double helpSize = 0; // 45
        double spacing = 15;
        double textWidth = availableWidth - animationSize - spacing - helpSize;

        return Padding(
          padding: EdgeInsets.only(top: 6, bottom: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  AnimatedSequenceWidget(
                    width: animationSize,
                    height: animationSize,
                    imagePaths: [
                      "assets/images/showerhead_search_white_1a.png",
                      "assets/images/showerhead_search_white_1b.png",
                      "assets/images/showerhead_search_white_1c.png",
                    ],
                    duration: Duration(milliseconds: 800),
                  ),
                ],
              ),

              const SizedBox(width: 15),
              ConstrainedBox(
                // 👇 garantit au moins la hauteur de l’écran
                constraints: BoxConstraints(
                  maxHeight: 160,
                  maxWidth: textWidth,
                ),
                // SizedBox(
                //   width: textWidth,
                //   height: 130,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppTheme.scanSectionTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.start,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                    SizedBox(height: 6),
                    Text(
                      message,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                        color: AppTheme.scanSectionTextColor,
                      ),
                      textAlign: TextAlign.start,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                    HelpIncitation(
                      message: t.iNeedHelp,
                      onTap: onHelpTap,
                      iconSize: 20,
                      fontSize: 14,
                      padding: EdgeInsets.only(top: 10, right: 10),
                      color: Colors.white,
                      iconOnRight: false,
                      icon: Icons.help_outline,
                      alignement: MainAxisAlignment.center,
                      textExpand: false,
                    ),
                  ],
                ),
              ),

              // HelpButton(
              //   onTap: onHelpTap,
              //   iconColor: AppTheme.scanSectionTextColor,
              //   size: helpSize,
              // ),
            ],
          ),
        );
      },
    );
  }
}
