import 'package:flutter/material.dart';

class MetricDisplay extends StatelessWidget {
  final String value;
  final String unit;
  final String label;
  final double height;
  final double padding;

  final Color? backgroundColor;
  final TextStyle? valueStyle;
  final TextStyle? unitStyle;
  final TextStyle? labelStyle;
  final double? minWidth;

  const MetricDisplay({
    super.key,
    required this.height,
    required this.value,
    required this.unit,
    required this.label,
    this.valueStyle,
    this.unitStyle,
    this.labelStyle,
    this.backgroundColor = Colors.transparent,
    this.padding = 8,
    this.minWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Container(
        constraints: minWidth != null
            ? BoxConstraints(minWidth: minWidth!)
            : null,
        padding: EdgeInsets.symmetric(vertical: padding, horizontal: padding),
        decoration: BoxDecoration(
          // color: Colors.grey.shade300,
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  value,
                  style:
                      valueStyle ??
                      const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        height: 1.0,
                      ),
                ),
                const SizedBox(width: 4),
                Text(
                  unit,
                  style:
                      unitStyle ??
                      const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style:
                  labelStyle ??
                  const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
