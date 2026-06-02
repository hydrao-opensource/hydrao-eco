import 'package:flutter/material.dart';

class RoundedProgressBar extends StatelessWidget {
  final double value; // entre 0.0 et 1.0
  final Color color;
  final double height;

  const RoundedProgressBar({
    super.key,
    required this.value,
    this.color = Colors.deepPurple,
    this.height = 20,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: LinearProgressIndicator(
        value: value,
        minHeight: height,
        backgroundColor: color.withValues(alpha: 0.25),
        valueColor: AlwaysStoppedAnimation(color),
      ),
    );
  }
}
