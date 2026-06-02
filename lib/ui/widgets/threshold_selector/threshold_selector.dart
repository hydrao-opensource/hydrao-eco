import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hydrao_flutter_offline/conversions.dart';
import 'package:hydrao_flutter_offline/models/threshold.dart';
import 'package:hydrao_flutter_offline/ui/widgets/threshold_selector/bottom_element.dart';
import 'package:hydrao_flutter_offline/ui/widgets/threshold_selector/color_dropdown.dart';
import 'package:hydrao_flutter_offline/ui/widgets/threshold_selector/liter_dropdown.dart';
import 'package:hydrao_flutter_offline/ui/widgets/threshold_selector/middle_element.dart';
import 'package:hydrao_flutter_offline/ui/widgets/threshold_selector/top_element.dart';

class ThresholdSelector extends StatefulWidget {
  final double height;
  final double width;
  final List<HydraoThreshold> thresholds;
  final String unit;
  final int maxLiter;
  final void Function(List<HydraoThreshold> value)? onChange;

  const ThresholdSelector({
    super.key,
    required this.thresholds,
    required this.unit,
    required this.height,
    required this.width,
    this.onChange,
    this.maxLiter = 250,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ThresholdSelectorState createState() => _ThresholdSelectorState();
}

class _ThresholdSelectorState extends State<ThresholdSelector> {
  static const topHeightPercent = 0.06;
  static const gapPercent = 0.02;
  static const centralWidth = 25.0;

  late List<HydraoThreshold> thresholds;

  @override
  void initState() {
    super.initState();
    thresholds = widget.thresholds;
    thresholds.sort((t1, t2) => t1.liter.compareTo(t2.liter));
  }

  @override
  void didUpdateWidget(covariant ThresholdSelector oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (thresholdsHasChanged(oldWidget.thresholds, widget.thresholds)) {
      // appLogger.d(
      //   'THRESHOLD SELECTOR / input thresholds changed : ${widget.thresholds}',
      // );
      thresholds = widget.thresholds;
      thresholds.sort((t1, t2) => t1.liter.compareTo(t2.liter));
    }
  }

  List<double> _computeSegmentHeights() {
    double topHeight = widget.height * topHeightPercent;
    double minHeight = 45.0;

    final thresholdsCount = thresholds.length;

    // Hauteur réellement disponible pour les segments
    final double availableHeight = widget.height - topHeight;
    // Si tu veux prendre en compte un espace entre segments :
    // final double availableHeight = widget.height - topHeight - gap * (thresholdsCount - 1);

    // 1) Calcul des "poids" (basés sur les litres par palier)
    final List<double> weights = [];
    double totalWeight = 0;

    for (var index = 0; index < thresholdsCount; index++) {
      final threshold = thresholds[index];
      final double prevLiter = index == 0 ? 0 : thresholds[index - 1].liter;
      final double delta = (threshold.liter - prevLiter).clamp(
        0,
        double.infinity,
      );
      weights.add(delta);
      totalWeight += delta;
    }

    // 2) Base minimale pour chaque segment
    final double basePerSegment = minHeight;
    final double totalBaseHeight = basePerSegment * thresholdsCount;

    // Hauteur restante à répartir proportionnellement
    final double remainingHeight = (availableHeight - totalBaseHeight).clamp(
      0,
      double.infinity,
    );

    // 3) Calcul final des hauteurs par segment
    return List.generate(thresholdsCount, (index) {
      if (remainingHeight == 0 || totalWeight == 0) {
        // Plus de marge : tout le monde à minHeight
        return basePerSegment;
      }

      final double extra = remainingHeight * (weights[index] / totalWeight);
      return basePerSegment + extra;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<double> segmentHeights = _computeSegmentHeights();
    double gap = widget.height * gapPercent; // si tu as des gaps entre segments
    double topHeight = widget.height * topHeightPercent;

    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Stack(
        children: (() {
          double beginBottom = 0;
          double lastColorDdlPos = widget.height - 10;
          double lastLiterDdlPos = widget.height - 10;
          List<Widget> widgetList = [];
          for (var index = 0; index < thresholds.length; index++) {
            final threshold = thresholds[index];
            final double thresholdHeight = segmentHeights[index];

            final int prevThreshold = index == 0
                ? 0
                : thresholds[index - 1].liter.toInt();
            final int nextThreshold = index == thresholds.length - 1
                ? widget.maxLiter + 2
                : thresholds[index + 1].liter.toInt();

            var colorDdlPos =
                widget.height - (thresholdHeight / 2 + beginBottom + 20);

            if (lastColorDdlPos - colorDdlPos < 30) {
              colorDdlPos = lastColorDdlPos - 30;
            }

            // print('delta color=${lastColorDdlPos - colorDdlPos}');
            //color dropdown
            widgetList.add(
              Positioned(
                top: colorDdlPos,
                right: widget.width / 2 + centralWidth / 2 + 35,
                child: ColorDropDown(
                  value: threshold.getThresholdColor(),
                  id: index,
                  onChanged: (tid, color) {
                    setState(() {
                      thresholds[tid] = thresholds[tid].copyWith(
                        color: getHexaColorFromThresholdColor(color),
                      );
                    });
                    if (widget.onChange != null) {
                      widget.onChange!(thresholds);
                    }
                  },
                ),
              ),
            );
            lastColorDdlPos = colorDdlPos;

            //center part
            if (beginBottom == 0) {
              //bottom element
              widgetList.add(
                Positioned(
                  bottom: beginBottom,
                  left: widget.width / 2 - centralWidth / 2 - 15,
                  child: SizedBox(
                    height: gap > thresholdHeight ? 2 : thresholdHeight - gap,
                    width: centralWidth * 2,
                    child: BottomElement(
                      color: getDisplayColorFromThresholdColor(
                        threshold.getThresholdColor(),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              //middle element
              widgetList.add(
                Positioned(
                  bottom: beginBottom,
                  left: widget.width / 2 - centralWidth / 2 - 15,
                  child: SizedBox(
                    height: gap > thresholdHeight ? 2 : thresholdHeight - gap,
                    width: centralWidth * 2,
                    child: MiddleElement(
                      color: getDisplayColorFromThresholdColor(
                        threshold.getThresholdColor(),
                      ),
                    ),
                  ),
                ),
              );
            }

            //print(beginBottom);
            //liter dropdown
            double literDdlPos =
                widget.height - (thresholdHeight + beginBottom + 10);
            // print('delta liter=${lastLiterDdlPos - literDdlPos}');
            if (lastLiterDdlPos - literDdlPos < 30) {
              literDdlPos = lastLiterDdlPos - 30;
            }
            widgetList.add(
              Positioned(
                top: literDdlPos,
                left: widget.width / 2 + centralWidth * 2 - 10,
                child: LiterDropDown(
                  minLiter: prevThreshold + 2,
                  maxLiter: nextThreshold - 2,
                  value: threshold.liter.toInt(),
                  id: index,
                  onChanged: (tid, liter) {
                    setState(() {
                      thresholds[tid] = thresholds[tid].copyWith(
                        liter: liter.toDouble(),
                      );
                    });
                    if (widget.onChange != null) {
                      widget.onChange!(thresholds);
                    }
                  },
                  unit: widget.unit,
                ),
              ),
            );
            lastLiterDdlPos = literDdlPos;

            beginBottom += thresholdHeight;
          }

          //top element
          widgetList.add(
            Positioned(
              left: widget.width / 2 - centralWidth / 2 - 15,
              top: 0,
              child: SizedBox(
                height: topHeight,
                width: centralWidth,
                child: TopElement(
                  color: getDisplayColorFromThresholdColor(
                    thresholds.last.getThresholdColor(),
                  ),
                ),
              ),
            ),
          );

          return widgetList;
        })(),
      ),
    );
  }
}
