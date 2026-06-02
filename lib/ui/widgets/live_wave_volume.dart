import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/conversions.dart';
import 'package:hydrao_flutter_offline/models/threshold.dart';
import 'package:hydrao_flutter_offline/ui/widgets/wave_progress.dart';
import 'package:hydrao_flutter_offline/utils.dart';

class LiveWaveVolume extends StatelessWidget {
  final int volume;
  final String unit;
  final List<HydraoThreshold> thresholds;
  final double size;
  final Color textColor;

  const LiveWaveVolume({
    super.key,
    required this.volume,
    required this.unit,
    required this.thresholds,
    this.size = 50,
    this.textColor = Colors.black,
  });
  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = _getThresholdColor(volume, thresholds);
    // final Color backgroundColor = baseColor.withValues(alpha: 0.2);
    // final Color textColor = getTextColorForBackground(
    //   background: backgroundColor,
    // );

    final volumeFromUnit = getVolumeForUnit(volume.toDouble(), unit);

    final double progress = computeProgress(
      volume.toDouble(),
      thresholds,
    ); // between 15 and 80

    return Padding(
      padding: EdgeInsetsGeometry.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          WaveProgress(
            size: size,
            // borderColor: backgroundColor.withValues(alpha: 0.2),
            borderColor: textColor,
            borderSize: 2.0,
            fillColor: backgroundColor.withValues(alpha: 0.5),
            backgroundColor: textColor.withValues(alpha: 0.7),
            progress: progress,
          ),
          SizedBox(height: 5),
          Center(
            // FittedBox s’occupe de redimensionner le texte pour tenir dans le cercle
            child: SizedBox(
              width: size,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatVolume(volumeFromUnit),
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: textColor,
                        fontSize:
                            size *
                            0.4, // base relative (FittedBox la réduira si besoin)
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text(
                        unit,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: textColor.withValues(alpha: 0.5),
                          fontSize: size * 0.18,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double computeProgress(double volume, List<HydraoThreshold> thresholds) {
    if (thresholds.isEmpty) return 15.0;

    final double minProgress = 15.0;
    final double maxProgress = 80.0;

    // Volume max = dernier seuil
    final double maxVolume = thresholds.last.liter;

    if (volume <= 0) return minProgress;
    if (volume >= maxVolume) return maxProgress;

    // Interpolation linéaire
    final double ratio = volume / maxVolume;
    return minProgress + (maxProgress - minProgress) * ratio;
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
