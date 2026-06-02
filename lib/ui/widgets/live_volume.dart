import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/conversions.dart';
import 'package:hydrao_flutter_offline/models/threshold.dart';
import 'package:hydrao_flutter_offline/utils.dart';

class LiveVolume extends StatelessWidget {
  final int volume;
  final String unit;
  final List<HydraoThreshold> thresholds;
  final double size;

  const LiveVolume({
    super.key,
    required this.volume,
    required this.unit,
    required this.thresholds,
    this.size = 60,
  });
  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = _getThresholdColor(volume, thresholds);
    // final Color backgroundColor = baseColor.withValues(alpha: 0.2);
    final Color textColor = getTextColorForBackground(
      background: backgroundColor,
    );

    final volumeFromUnit = getVolumeForUnit(volume.toDouble(), unit);

    // return Padding(
    //   padding: EdgeInsetsGeometry.all(10),
    //   child: SizedBox(
    //     width: size,
    //     height: size,
    //     child: DecoratedBox(
    //       decoration: BoxDecoration(
    //         color: backgroundColor,
    //         shape: BoxShape.circle,
    //       ),
    //       child: Expanded(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               crossAxisAlignment: CrossAxisAlignment.end,
    //               children: [
    //                 // volume
    //                 Text(
    //                   '$volume',
    //                   style: TextStyle(
    //                     fontSize: size * 0.45,
    //                     fontWeight: FontWeight.w700,
    //                     color: textColor,
    //                   ),
    //                 ),
    //                 const SizedBox(width: 2),
    //                 // unit
    //                 Padding(
    //                   padding: EdgeInsetsGeometry.only(bottom: 7),
    //                   child: Text(
    //                     unit,
    //                     style: TextStyle(
    //                       fontSize: size * 0.18,
    //                       fontWeight: FontWeight.w500,
    //                       color: textColor.withAlpha(150),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );

    return Padding(
      padding: EdgeInsetsGeometry.all(10),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(12.0),
        child: Center(
          // FittedBox s’occupe de redimensionner le texte pour tenir dans le cercle
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatVolume(volumeFromUnit),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: textColor,
                    fontSize:
                        size *
                        0.5, // base relative (FittedBox la réduira si besoin)
                    height: 1.0,
                  ),
                ),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    unit,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: textColor,
                      fontSize: size * 0.18,
                      height: 1.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getThresholdColor(int volume, List<HydraoThreshold> thresholds) {
    if (thresholds.isEmpty) {
      return Colors.blue;
    }

    // On trie pour être sûr
    final sorted = [...thresholds]..sort((a, b) => a.liter.compareTo(b.liter));

    HydraoThreshold selected = sorted.last;

    for (final t in sorted) {
      if (volume <= t.liter) {
        selected = t;
        break;
      }
    }

    return selected.getColor();
  }
}
