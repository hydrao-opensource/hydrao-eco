import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/constants.dart';
import 'package:hydrao_flutter_offline/conversions.dart';
import 'package:hydrao_flutter_offline/models/savings_stats.dart';
import 'package:hydrao_flutter_offline/utils.dart';

class SavingsStatsWidget extends StatelessWidget {
  final SavingsStats stats;
  final String waterUnit;
  final String currency;

  const SavingsStatsWidget({
    super.key,
    required this.stats,
    required this.waterUnit,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    double fixedWaterVolume = stats.savedWaterVolume;
    String fixedWaterUnit = waterUnit;
    if (fixedWaterVolume > 1000 && waterUnit == AppConstants.symbolLiter) {
      fixedWaterVolume = fixedWaterVolume / 1000;
      fixedWaterUnit = AppConstants.symbolCubicMeter;
    }

    fixedWaterVolume = getVolumeForUnit(fixedWaterVolume, waterUnit);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: _SavingsPill(
            backgroundColor: const Color(0xFFD1E9F5), // bleu clair
            icon: Icon(
              Icons.water_drop,
              size: 24,
              color: Colors.black.withValues(alpha: 0.5),
            ),
            quantity: fixedWaterVolume,
            quantityUnit: fixedWaterUnit,
            price: stats.savedWaterMoney,
            currency: currency,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '+',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SavingsPill(
            backgroundColor: const Color(0xFFFFF1C2), // jaune clair
            icon: Icon(
              Icons.bolt,
              size: 24,
              color: Colors.black.withValues(alpha: 0.5),
            ),
            quantity: stats.savedEnergyQuantity,
            quantityUnit: AppConstants.symbolKilowattHour,
            price: stats.savedEnergyMoney,
            currency: currency,
          ),
        ),
      ],
    );
  }
}

class _SavingsPill extends StatelessWidget {
  final Color backgroundColor;
  final Icon icon;
  final double quantity;
  final String quantityUnit;
  final double price;
  final String currency;

  const _SavingsPill({
    required this.backgroundColor,
    required this.icon,
    required this.quantity,
    required this.quantityUnit,
    required this.price,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // String formattedPrice = formatMoney(getCurrencyFromSymbol(price, currency));
    // String priceMessage = "$formattedPrice $currency";

    return Container(
      height: 40,
      padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 4),

          /// Zone "quantité + unité"
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    formatVolume(quantity),
                    softWrap: false,
                    overflow: TextOverflow.visible,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade700,
                      fontSize: 16, // taille max, sera réduite si besoin
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    quantityUnit,
                    softWrap: false,
                    overflow: TextOverflow.visible,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w300,
                      color: Colors.grey.shade700,
                      fontSize: 11, // taille max
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // const SizedBox(width: 4),

          // ClickTooltip(
          //   message: priceMessage,
          //   maxWidth: 100,
          //   child: Icon(
          //     Icons.help,
          //     size: 18,
          //     color: Colors.black.withValues(alpha: 0.5),
          //   ),
          // ),

          //   /// Zone "prix + devise"
          //   Container(
          //     constraints: const BoxConstraints(
          //       minWidth: 40,
          //       maxWidth: 80, // limite pour éviter de prendre tout l’espace
          //     ),
          //     decoration: BoxDecoration(
          //       color: Colors.white.withValues(alpha: 0.5),
          //       borderRadius: BorderRadius.circular(40),
          //     ),
          //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          //     child: FittedBox(
          //       fit: BoxFit.scaleDown,
          //       alignment: Alignment.centerRight,
          //       child: Row(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           Text(
          //             formatMoney(price),
          //             softWrap: false,
          //             overflow: TextOverflow.visible,
          //             style: theme.textTheme.titleSmall?.copyWith(
          //               fontWeight: FontWeight.w700,
          //               color: Colors.black,
          //               fontSize: 15, // taille max
          //               height: 1,
          //             ),
          //           ),
          //           const SizedBox(width: 4),
          //           Text(
          //             currency,
          //             softWrap: false,
          //             overflow: TextOverflow.visible,
          //             style: theme.textTheme.titleMedium?.copyWith(
          //               fontWeight: FontWeight.w300,
          //               color: Colors.grey.shade700,
          //               fontSize: 12, // taille max
          //               height: 1,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
