import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/conversions.dart';
import 'package:hydrao_flutter_offline/models/threshold.dart';
import 'package:hydrao_flutter_offline/theme.dart';
import 'package:hydrao_flutter_offline/utils.dart';

class ThresholdHorizontal extends StatelessWidget {
  final List<HydraoThreshold> thresholds;
  final String unit; // water unit
  final double? height;
  final double? maxLiter;
  final double? opacity;
  final bool withIndicator;

  const ThresholdHorizontal({
    super.key,
    required this.thresholds,
    required this.unit,
    this.height,
    this.maxLiter,
    this.opacity = 1,
    this.withIndicator = false,
  });

  List<_StepData> _computeSteps() {
    if (thresholds.isEmpty) return [];

    final lastVolume = getVolumeForUnit(thresholds.last.liter, unit);
    if (lastVolume == 0) return [];

    final steps = <_StepData>[];
    double previousVolume = 0;

    for (var threshold in thresholds) {
      final volume = getVolumeForUnit(threshold.liter, unit);

      final size = ((volume - previousVolume) / lastVolume) * 100;
      steps.add(
        _StepData(
          color: threshold.getColor().withValues(alpha: opacity!),
          size: size,
          value: formatVolume(volume),
          unit: unit,
        ),
      );
      previousVolume = volume;
    }

    return steps;
  }

  double _marginMax() {
    if (maxLiter == null || thresholds.isEmpty) return 0;
    final lastVolume = getVolumeForUnit(thresholds.last.liter, unit);
    final maxVolume = getVolumeForUnit(maxLiter!, unit);
    if (lastVolume >= maxVolume) return 0;

    return 100 - (lastVolume / maxVolume) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final steps = _computeSteps();
    final marginMax = _marginMax();

    return SizedBox(
      width: double.infinity,
      height: height ?? 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Wrapper for steps
          Flexible(
            flex: (100 - marginMax).round(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (int i = 0; i < steps.length; i++)
                  Expanded(
                    flex: steps[i].size.round(),
                    child: Container(
                      height: double
                          .infinity, // <-- prend toute la hauteur du parent
                      margin: EdgeInsets.only(
                        right: i == steps.length - 1 ? 0 : 2,
                      ),
                      decoration: BoxDecoration(
                        color: steps[i].color,
                        borderRadius: BorderRadius.horizontal(
                          left: i == 0
                              ? const Radius.circular(20)
                              : Radius.zero,
                          right: i == steps.length - 1
                              ? const Radius.circular(20)
                              : Radius.zero,
                        ),
                      ),
                      // padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsetsGeometry.symmetric(
                            vertical: 2,
                            horizontal: 4,
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              children: [
                                Text(
                                  steps[i].value,
                                  style: TextStyle(
                                    color: getTextColorForBackground(
                                      background: steps[i].color,
                                    ),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (steps[i].unit != null) SizedBox(width: 3),
                                if (steps[i].unit != null)
                                  Text(
                                    steps[i].unit!,
                                    style: TextStyle(
                                      color: getTextColorForBackground(
                                        background: steps[i].color,
                                        textLight: Colors.white70,
                                        textDark: Colors.black45,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (withIndicator) SizedBox(width: 5),
          if (withIndicator)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppTheme.color,
              ),
              width: 10,
              height: 10,
            ),
          // Optional right margin
          if (marginMax > 0)
            Flexible(flex: marginMax.round(), child: Container()),
        ],
      ),
    );
  }
}

class _StepData {
  final Color color;
  final double size;
  final String value;
  final String? unit;

  _StepData({
    required this.color,
    required this.size,
    required this.value,
    this.unit,
  });
}
