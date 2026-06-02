import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/constants.dart';
import 'package:hydrao_flutter_offline/conversions.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/models/savings_stats.dart';
import 'package:hydrao_flutter_offline/theme.dart';
import 'package:hydrao_flutter_offline/ui/widgets/custom_expansion_tile.dart';
import 'package:hydrao_flutter_offline/utils.dart';

class SavingsDetailsFragment extends StatefulWidget {
  final SavingsStats stats;
  final String? details;
  final String waterUnit;
  final String currency;
  const SavingsDetailsFragment({
    super.key,
    required this.stats,
    required this.waterUnit,
    required this.currency,
    this.details,
  });

  @override
  State<SavingsDetailsFragment> createState() => _SavingsDetailsFragmentState();
}

class _SavingsDetailsFragmentState extends State<SavingsDetailsFragment> {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomExpansionTile(
          title: t.savingsDetailsDialogCompareSection,
          expandable: false,
          expanded: true,
          headerPadding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
          children: [buildBars(context)],
        ),
        SizedBox(height: 10),
        CustomExpansionTile(
          title: t.savingsDetailsDialogConsumptionSection,
          expandable: false,
          expanded: true,
          globalPadding: 5,
          trailingButton: Padding(
            padding: EdgeInsets.only(right: 10),
            child: Text(t.shStatisticsCountShowers(widget.stats.showersCount)),
          ),
          headerPadding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
          children: [buildStats(context)],
        ),
      ],
    );
  }

  Widget buildBars(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    double oldShBarWidth = 250;
    double savingBarWidth = (widget.stats.savingPourcent > 0)
        ? oldShBarWidth * widget.stats.savingPourcent
        : 0;
    double hydraoBarWidth = oldShBarWidth - savingBarWidth;
    double barHeight = 25;

    return Container(
      decoration: BoxDecoration(
        border: BoxBorder.fromLTRB(
          left: BorderSide(
            color: AppTheme.textColor.withValues(alpha: 0.5),
            width: 2,
          ),
        ),
      ),
      width: oldShBarWidth + 5,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: _buildBar(
                oldShBarWidth,
                barHeight,
                AppTheme.textColor.withValues(alpha: 0.1),
                t.savingsDetailsDialogOldShowerhead,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: _buildBar(
                hydraoBarWidth,
                barHeight,
                AppTheme.color.withValues(alpha: 0.2),
                t.savingsDetailsDialogHydrao,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStats(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    Color oldColor = AppTheme.textColor.withValues(alpha: 0.4);
    Color hydraoColor = AppTheme.color.darken(0.1);
    Color savingColor = Colors.green.shade700;

    double iconWidth = 40;
    double columnWidth = 240 / 3;
    double textWidth = columnWidth - 10;

    return Column(
      children: [
        // headers
        _buildStatRow(
          SizedBox.shrink(),
          Text(
            t.savingsDetailsDialogOldShowerheadHeader,
            style: TextStyle(color: oldColor),
          ),
          Text(
            t.savingsDetailsDialogHydrao,
            style: TextStyle(color: hydraoColor),
          ),
          Text(
            t.savingsDetailsDialogSavingsHeader,
            style: TextStyle(color: savingColor),
          ),
          iconWidth,
          columnWidth,
        ),
        SizedBox(height: 15),
        _buildStatRow(
          SizedBox.shrink(),
          _buildVolume(widget.stats.oldTotalVolume, textWidth, color: oldColor),
          _buildVolume(
            widget.stats.usedWaterVolume,
            textWidth,
            color: hydraoColor,
          ),
          _buildVolume(
            widget.stats.savedWaterVolume,
            textWidth,
            color: savingColor,
          ),
          iconWidth,
          columnWidth,
        ),
        SizedBox(height: 10),
        _buildStatRow(
          Icon(Icons.water_drop, size: iconWidth - 10),
          _buildMoney(
            widget.stats.oldWaterMoney,
            textWidth,
            oldColor.withValues(alpha: 0.1),
          ),
          _buildMoney(
            widget.stats.usedWaterMoney,
            textWidth,
            hydraoColor.withValues(alpha: 0.2),
          ),
          _buildMoney(
            widget.stats.savedWaterMoney,
            textWidth,
            savingColor.withValues(alpha: 0.2),
          ),
          iconWidth,
          columnWidth,
        ),
        SizedBox(height: 25),
        _buildStatRow(
          SizedBox.shrink(),
          _buildEnergy(
            widget.stats.oldEnergyQuantity,
            textWidth,
            color: oldColor,
          ),
          _buildEnergy(
            widget.stats.usedEnergyQuantity,
            textWidth,
            color: hydraoColor,
          ),
          _buildEnergy(
            widget.stats.savedEnergyQuantity,
            textWidth,
            color: savingColor,
          ),
          iconWidth,
          columnWidth,
        ),
        SizedBox(height: 10),
        _buildStatRow(
          Icon(Icons.bolt, size: iconWidth - 10),
          _buildMoney(
            widget.stats.oldEnergyMoney,
            textWidth,
            oldColor.withValues(alpha: 0.1),
          ),
          _buildMoney(
            widget.stats.usedEnergyMoney,
            textWidth,
            hydraoColor.withValues(alpha: 0.2),
          ),
          _buildMoney(
            widget.stats.savedEnergyMoney,
            textWidth,
            savingColor.withValues(alpha: 0.2),
          ),
          iconWidth,
          columnWidth,
        ),

        SizedBox(height: 15),
      ],
    );
  }

  Widget _buildStatRow(
    Widget icon,
    Widget old,
    Widget hydrao,
    Widget saving,
    double iconWidth,
    double columnWidth,
  ) {
    return Row(
      children: [
        SizedBox(
          width: iconWidth,
          child: Center(child: icon),
        ),
        SizedBox(
          width: columnWidth,
          child: Center(child: old),
        ),
        SizedBox(
          width: columnWidth,
          child: Center(child: hydrao),
        ),
        SizedBox(
          width: columnWidth,
          child: Center(child: saving),
        ),
      ],
    );
  }

  Widget _buildBar(double width, double height, Color bgColor, String text) {
    Color textColor = getTextColorForBackground(background: bgColor);
    TextStyle textStyle = TextStyle(color: textColor);
    double horizontalPadding = 8;

    // calculer si le texte rentre dans la bar ou s'il faut le mettre après...
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 250);

    bool textOutside = textPainter.width > (width - (horizontalPadding * 2));

    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadiusDirectional.only(
              topEnd: Radius.circular(4),
              bottomEnd: Radius.circular(4),
            ),
          ),
          width: width,
          height: height,
          child: (textOutside == true)
              ? null
              : Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 3,
                  ),
                  child: Text(text, style: textStyle),
                ),
        ),
        if (textOutside == true) SizedBox(width: 8),
        if (textOutside == true)
          Text(text, style: TextStyle(color: AppTheme.textColor)),
      ],
    );
  }

  Widget _buildVolume(
    double? volume,
    double width, {
    double fontSize = 16,
    Color? color,
  }) {
    Color frontColor = color ?? AppTheme.textColor;

    double fixedVolume = volume ?? 0;
    String fixedWaterUnit = widget.waterUnit;
    if (fixedVolume > 1000 && fixedWaterUnit == AppConstants.symbolLiter) {
      fixedVolume = fixedVolume / 1000;
      fixedWaterUnit = AppConstants.symbolCubicMeter;
    }

    return SizedBox(
      width: width, // On contraint la largeur maximale
      child: FittedBox(
        fit: BoxFit.scaleDown, // Réduit la taille seulement si ça dépasse
        alignment: Alignment.center, // Aligne à gauche dans l'espace disponible
        child: Row(
          mainAxisSize: MainAxisSize.min,
          // Aligne les enfants sur leur ligne de base de texte
          crossAxisAlignment: CrossAxisAlignment.baseline,
          // Indique quel type de baseline utiliser (alphabetic est le standard)
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              formatVolume(getVolumeForUnit(fixedVolume, fixedWaterUnit)),
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: frontColor,
                height: 1,
              ),
            ),
            SizedBox(width: 3),
            Text(
              fixedWaterUnit,
              style: TextStyle(
                fontSize: fontSize * 0.7,
                color: frontColor.withValues(alpha: 0.5),
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnergy(
    double? quantity,
    double width, {
    double fontSize = 16,
    Color? color,
  }) {
    Color frontColor = color ?? AppTheme.textColor;

    return SizedBox(
      width: width, // On contraint la largeur maximale
      child: FittedBox(
        fit: BoxFit.scaleDown, // Réduit la taille seulement si ça dépasse
        alignment: Alignment.center, // Aligne à gauche dans l'espace disponible
        child: Row(
          mainAxisSize: MainAxisSize.min,
          // Aligne les enfants sur leur ligne de base de texte
          crossAxisAlignment: CrossAxisAlignment.baseline,
          // Indique quel type de baseline utiliser (alphabetic est le standard)
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              formatVolume(quantity ?? 0),
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: frontColor,
                height: 1,
              ),
            ),
            SizedBox(width: 3),
            Text(
              AppConstants.symbolKilowattHour,
              style: TextStyle(
                fontSize: fontSize * 0.5,
                color: frontColor.withValues(alpha: 0.5),
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoney(double money, double width, Color bgColor) {
    return SizedBox(
      width: width + 5, // On contraint la largeur maximale
      child: FittedBox(
        fit: BoxFit.scaleDown, // Réduit la taille seulement si ça dépasse
        alignment: Alignment.center, // Aligne à gauche dans l'espace disponible
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          width: width + 5,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                // Aligne les enfants sur leur ligne de base de texte
                crossAxisAlignment: CrossAxisAlignment.baseline,
                // Indique quel type de baseline utiliser (alphabetic est le standard)
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    formatMoney(getCurrencyFromSymbol(money, widget.currency)),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    widget.currency,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
