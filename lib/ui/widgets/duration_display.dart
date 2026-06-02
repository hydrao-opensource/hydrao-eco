import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/utils.dart';

class DurationDisplay extends StatelessWidget {
  final int totalSeconds;
  final TextStyle valueStyle;
  final TextStyle unitStyle;
  final double gapBetweenValueAndUnit;
  final double gapBetweenBlocks;

  const DurationDisplay({
    super.key,
    required this.totalSeconds,
    required this.valueStyle,
    required this.unitStyle,
    this.gapBetweenValueAndUnit = 4,
    this.gapBetweenBlocks = 10,
  });

  @override
  Widget build(BuildContext context) {
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;

    final children = <Widget>[];

    // Bloc minutes (si > 0)
    if (minutes > 0) {
      children.add(
        _ValueUnitBlock(
          value: minutes.toString(),
          unit: getDurationUnit(context, 'min'),
          valueStyle: valueStyle,
          unitStyle: unitStyle,
          gap: gapBetweenValueAndUnit,
        ),
      );
    }

    // Bloc secondes (toujours affiché)
    if (minutes > 0 && seconds > 0) {
      children.add(SizedBox(width: gapBetweenBlocks));
    }

    if (seconds > 0) {
      children.add(
        _ValueUnitBlock(
          value: seconds.toString().padLeft(2, '0'),
          unit: getDurationUnit(context, 'sec'),
          valueStyle: valueStyle,
          unitStyle: unitStyle,
          gap: gapBetweenValueAndUnit,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: children,
    );
  }
}

class _ValueUnitBlock extends StatelessWidget {
  final String value;
  final String unit;
  final TextStyle valueStyle;
  final TextStyle unitStyle;
  final double gap;

  const _ValueUnitBlock({
    required this.value,
    required this.unit,
    required this.valueStyle,
    required this.unitStyle,
    required this.gap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(value, style: valueStyle),
        SizedBox(width: gap),
        Text(unit, style: unitStyle),
      ],
    );
  }
}
