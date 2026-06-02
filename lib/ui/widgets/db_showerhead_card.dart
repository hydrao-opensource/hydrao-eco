import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hydrao_flutter_offline/constants.dart';
import 'package:hydrao_flutter_offline/conversions.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/models/learning_period.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';
import 'package:hydrao_flutter_offline/theme.dart';
import 'package:hydrao_flutter_offline/ui/widgets/threshold_horizontal.dart';
import 'package:hydrao_flutter_offline/utils.dart';

class DbShowerheadCard extends StatelessWidget {
  final Showerhead showerhead;
  final double thresholdMaxLiter;
  final String unit;
  final bool connected;
  final VoidCallback onShClicked;
  final VoidCallback onSettingsClicked;
  final double? averageShower;
  final int? countShowers;
  final int? countLearningShowers;

  const DbShowerheadCard({
    super.key,
    required this.showerhead,
    required this.unit,
    required this.connected,
    required this.thresholdMaxLiter,
    required this.onShClicked,
    required this.onSettingsClicked,
    this.averageShower,
    this.countShowers,
    this.countLearningShowers,
  });

  @override
  Widget build(BuildContext context) {
    // final t = AppLocalizations.of(context)!;

    final beginOrInLearningPeriod =
        showerhead.baselineStatus != null &&
        (showerhead.baselineStatus == LearningStatus.begin.toString() ||
            showerhead.baselineStatus == LearningStatus.learn.toString());

    Widget? statusWidget = buildStatusView(context);
    Widget synchroMessage = buildSynchroMessage(context);
    Widget syncView = Row(
      children: [
        // if (statusWidget != null) statusWidget,
        // if (statusWidget != null) SizedBox(width: 5),
        synchroMessage,
      ],
    );

    Widget thresholdsView = (beginOrInLearningPeriod)
        ? buildLearningPeriodView(context)
        : buildThresholdsView(context);

    final colorScheme = Theme.of(context).colorScheme;

    Widget shIcon = switch (showerhead.type) {
      "first" => _FirstVisual(),
      "cereus" => _CereusVisual(),
      "yucca" => _YuccaVisual(),
      "mixer" => _VernetVisual(),
      _ => _AloeVisual(),
    };

    // Widget? averageView;
    // if (averageShower != null && countShowers != null) {
    //   averageView = Column(
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     crossAxisAlignment: CrossAxisAlignment.end,
    //     children: [
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.end,
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         children: [
    //           // Text(
    //           //   'moy.',
    //           //   style: TextStyle(fontSize: 12, color: Colors.black38),
    //           // ),
    //           // SizedBox(width: 4),
    //           Text(
    //             averageShowerString!,
    //             style: TextStyle(
    //               fontSize: 30,
    //               height: 1,
    //               textBaseline: TextBaseline.alphabetic,
    //             ),
    //           ),
    //           SizedBox(width: 4),
    //           Text(unit, style: TextStyle(fontSize: 14, color: Colors.black45)),
    //         ],
    //       ),
    //       // SizedBox(height: 2),
    //       if (countShowers != null)
    //         Text(
    //           t.dbShowerheadCardOnShowers(countShowers ?? 0),
    //           style: TextStyle(
    //             fontSize: 11,
    //             color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
    //           ),
    //           textAlign: TextAlign.end,
    //         ),
    //     ],
    //   );
    // }

    Widget editView = IconButton(
      onPressed: () {
        // appLogger.d('$LOG_TAG settings clicked');
        onSettingsClicked();
      },
      visualDensity: VisualDensity.compact,
      icon: Icon(Icons.edit, size: 24, color: AppTheme.textColor),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        // constraints.maxWidth contient la largeur réelle utilisable ici
        double availableWidth = constraints.maxWidth;

        double optimalWidth = 400;
        double iconWidth = 170;
        double iconHeight = 80;
        double iconPourcent = availableWidth / optimalWidth;
        if (iconPourcent > 1.2) iconPourcent = 1.2;
        if (iconPourcent < 0.6) iconPourcent = 0.6;

        double textPaddingLeft = (65 * iconPourcent) + 5;

        double editWidth = 40;
        double textWidth = availableWidth - textPaddingLeft - 5 - editWidth;

        // print('$LOG_TAG textWidth=$textWidth, availableWidth=$availableWidth');

        return InkWell(
          onTap: onShClicked,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            // padding: const EdgeInsets.all(12),
            constraints: BoxConstraints(minHeight: 70),
            decoration: BoxDecoration(
              color: AppTheme.color.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(12),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black12,
              //     blurRadius: 4,
              //     offset: Offset(0, 2),
              //   ),
              // ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                // shower head image
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: SizedBox(
                    width:
                        iconWidth *
                        iconPourcent, // On définit l'espace RÉEL voulu
                    height: iconHeight * iconPourcent,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child:
                          shIcon, // Ce widget sera "scalé" visuellement à 70%
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: textPaddingLeft,
                    top: 5,
                    bottom: 5,
                    right: 5,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: textWidth,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: min(textWidth - 60, 130),
                                      ),
                                      child: Text(
                                        showerhead.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                              height: 1,
                                            ),
                                        softWrap: true,
                                        // overflow: TextOverflow
                                        //     .ellipsis, // tronquer si trop long
                                      ),
                                    ),
                                    if (statusWidget != null)
                                      SizedBox(width: 8),
                                    ?statusWidget,
                                  ],
                                ),
                                SizedBox(height: 4),
                                syncView,
                                SizedBox(height: 6),
                                // last_seen
                                if (showerhead.lastSeen != null)
                                  SizedBox(
                                    width: 160, // 🔥 largeur max
                                    child: AutoSizeText(
                                      formatRelative(
                                        context,
                                        showerhead.lastSeen!,
                                      ),
                                      maxLines: 1,
                                      minFontSize:
                                          8, // 🔥 taille min acceptable
                                      overflow: TextOverflow
                                          .ellipsis, // tronquer si trop long
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: colorScheme.primary,
                                          ),
                                    ),
                                  ),
                                if (showerhead.lastSeen != null)
                                  SizedBox(height: 4),
                                thresholdsView,
                              ],
                            ),
                          ),
                          Spacer(),
                          editView,
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget? buildStatusView(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    Widget? view;

    Color statusColor = getStatusColor().withValues(alpha: 0.3);
    Color frontColor = getTextColorForBackground(
      background: statusColor,
      textDark: AppTheme.textColor,
    );

    if (connected) {
      // animation + "in progress"
      view = Container(
        // width: 80,
        height: 20,
        decoration: BoxDecoration(
          color: statusColor,
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SpinKitDoubleBounce(color: frontColor, size: 12.0),
            // SizedBox(width: 4),
            // Text(
            //   "en cours",
            //   style: TextStyle(
            //     fontSize: 10,
            //     fontWeight: FontWeight.w400,
            //     color: frontColor,
            //   ),
            // ),
          ],
        ),
      );
    } else if (showerhead.lastSyncDate == null) {
      // circle grey with ?
      // statusWidget = Container(
      //   width: 20,
      //   height: 20,
      //   decoration: BoxDecoration(
      //     color: Colors.grey.shade100,
      //     shape: BoxShape.circle,
      //   ),
      //   padding: const EdgeInsets.all(1.0),
      //   child: Center(
      //     child: Text(
      //       "?",
      //       style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      //     ),
      //   ),
      // );
      view = null;
    } else if (showerhead.isLastSyncComplete == false) {
      // warning + "incomplete"
      view = Container(
        // width: 100,
        height: 20,
        decoration: BoxDecoration(
          color: statusColor,
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
        child: Row(
          children: [
            // Text(
            //   "!",
            //   style: TextStyle(
            //     fontSize: 10,
            //     fontWeight: FontWeight.w400,
            //     color: frontColor,
            //   ),
            // ),
            // SizedBox(width: 3),
            Text(
              t.dbShowerheadCardSyncPartial,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: frontColor,
              ),
            ),
          ],
        ),
      );
    } else if (showerhead.isLastSyncComplete == true) {
      // check + "up to date"
      view = Container(
        // width: 60,
        height: 20,
        decoration: BoxDecoration(
          color: statusColor,
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
        child: Row(
          // child: Icon(Icons.warning_amber, size: 11, color: Colors.black54),
          children: [
            // Icon(Icons.check, size: 12, color: frontColor),
            // SizedBox(width: 3),
            Text(
              t.dbShowerheadCardSynUpToDate,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: frontColor,
              ),
            ),
          ],
        ),
      );
    }

    return view;
  }

  Widget buildSynchroMessage(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    double fontSize = 12;
    Color statusColor = getStatusColor();

    TextStyle fontStyle = TextStyle(
      color: statusColor,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      height: 1,
    );

    Widget view = Text(
      t.dbShowerheadCardSyncToDo,
      style: TextStyle(color: statusColor, fontSize: fontSize),
    );

    bool hasShowers = countShowers != null && countShowers! > 0;

    if (showerhead.lastSyncDate != null) {
      var fixedAverageShower = (averageShower != null)
          ? getVolumeForUnit(averageShower!, unit)
          : null;
      var averageShowerString = fixedAverageShower != null
          ? formatVolume(fixedAverageShower)
          : null;

      view = Row(
        children: [
          if (!hasShowers) Text(t.dbShowerheadCardNoShower, style: fontStyle),
          if (hasShowers)
            Text(
              "${t.dbShowerheadCardOnShowers(countShowers!)} (",
              style: fontStyle,
            ),
          if (hasShowers && averageShowerString != null)
            Text(t.dbShowerheadCardAverageVol, style: fontStyle),
          if (hasShowers && averageShowerString != null) SizedBox(width: 2),
          if (hasShowers && averageShowerString != null)
            Text(averageShowerString, style: fontStyle),
          if (hasShowers && averageShowerString != null) SizedBox(width: 2),
          if (hasShowers && averageShowerString != null)
            Text(unit, style: fontStyle.copyWith(fontSize: 9)),
          if (hasShowers) Text(")", style: fontStyle),
        ],
      );
    }

    return view;
  }

  Color getStatusColor() {
    Color color = AppTheme.textColor.withValues(alpha: 0.5);

    if (showerhead.lastSyncDate != null) {
      if (connected) {
        color = AppTheme.color.darken(0.2);
      } else if (showerhead.isLastSyncComplete == false) {
        color = AppTheme.textWarningColor;
      } else if (showerhead.isLastSyncComplete == true) {
        color = Colors.green;
      }
    }

    return color;
  }

  Widget buildThresholdsView(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // thresholds
        SizedBox(
          width: 180,
          child: ThresholdHorizontal(
            thresholds: thresholdsFromJson(
              showerhead.getThresholdToShow() ??
                  AppConstants.shDefaultThresholds,
            )!,
            unit: unit,
            height: 20,
            maxLiter: thresholdMaxLiter,
            opacity: showerhead.hasThresholdRequest() ? 0.5 : 1,
            withIndicator: showerhead.hasThresholdRequest(),
          ),
        ),

        if (showerhead.hasThresholdRequest()) SizedBox(height: 5),
        if (showerhead.hasThresholdRequest())
          Text(
            t.dbShowerheadCardNewThresholds,
            style: TextStyle(
              color: AppTheme.textColor.withValues(alpha: 0.5),
              fontSize: 10,
              fontStyle: FontStyle.italic,
            ),
          ),
      ],
    );
  }

  Widget buildLearningPeriodView(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    bool inLearningPeriod =
        (showerhead.baselineStatus == LearningStatus.learn.toString());

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (inLearningPeriod)
          Icon(Icons.remove_red_eye, size: 18, color: AppTheme.color),
        if (inLearningPeriod) SizedBox(width: 4),
        if (inLearningPeriod)
          Text(
            t.dbShowerheadCardLearning,
            style: TextStyle(color: AppTheme.color, fontSize: 12),
          ),
        if (!inLearningPeriod)
          Expanded(
            child: Text(
              t.dbShowerheadCardLearningStart,
              style: TextStyle(color: AppTheme.color, fontSize: 12),
            ),
          ),
        if (countLearningShowers != null && countLearningShowers! > 0)
          SizedBox(width: 5),
        if (countLearningShowers != null && countLearningShowers! > 0)
          CircleAvatar(
            radius: 28 / 3,
            backgroundColor: AppTheme.color.withValues(alpha: 0.7),
            child: Text(
              countLearningShowers!.toString(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}

class _YuccaVisual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizedBox(
        height: 80,
        width: 180,
        child: Transform(
          transform: Matrix4.translationValues(-35, 10, 0)
            ..rotateZ(0.1)
            ..scaleByDouble(0.55, 0.55, 0.55, 1.0),
          child: SvgPicture.asset(
            "assets/images/yucca.svg",
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.25),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

class _VernetVisual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizedBox(
        height: 80,
        width: 180,
        child: Transform(
          transform: Matrix4.translationValues(100, 0, 0)
            //..rotateZ(0.30)
            ..scaleByDouble(0.6, 0.6, 0.6, 1.0),
          child: SvgPicture.asset(
            "assets/images/vernet_mixer.svg",
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.25),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

class _AloeVisual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizedBox(
        height: 70,
        width: 180,
        child: Transform(
          transform: Matrix4.translationValues(-90, 110, 0)
            ..rotateZ(-0.8)
            ..scaleByDouble(1.4, 1.4, 1.4, 1.0),
          child: SvgPicture.asset(
            "assets/images/aloe.svg",
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.25),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

class _FirstVisual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizedBox(
        height: 70,
        width: 180,
        child: Transform(
          transform: Matrix4.translationValues(-110, 130, 0)
            ..rotateZ(-0.8)
            ..scaleByDouble(1.7, 1.7, 1.7, 1.0),
          child: SvgPicture.asset(
            "assets/images/first.svg",
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.25),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

class _CereusVisual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizedBox(
        height: 80,
        width: 180,
        child: Transform(
          transform: Matrix4.translationValues(-40, -5, 0)
            ..rotateZ(0.3)
            ..scaleByDouble(0.8, 0.8, 0.8, 1.0),
          child: SvgPicture.asset(
            "assets/images/cereus.svg",
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.25),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
