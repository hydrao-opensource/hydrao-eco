import 'package:flutter/material.dart';

class CircularProgressLoader extends StatelessWidget {
  final double progress; // entre 0.0 et 1.0
  final double size;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;
  final Widget? centeredContent;

  const CircularProgressLoader({
    super.key,
    required this.progress,
    this.size = 80,
    this.color = Colors.blue,
    this.backgroundColor = Colors.grey,
    this.strokeWidth = 6,
    this.centeredContent,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Cercle d’arrière-plan
          Transform.scale(
            scale:
                size /
                36, // 36 = taille par défaut du CircularProgressIndicator
            child: CircularProgressIndicator(
              value: 1, // cercle complet (fond)
              color: backgroundColor.withValues(alpha: 0.2),
              strokeWidth: strokeWidth,
            ),
          ),
          // Progression réelle
          Transform.scale(
            scale:
                size /
                36, // 36 = taille par défaut du CircularProgressIndicator
            child: CircularProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              color: color,
              strokeWidth: strokeWidth,
              backgroundColor: Colors.transparent,
            ),
          ),
          ?centeredContent,
          // Texte au centre (ex: %)
          // Text(
          //   '${(progress * 100).toStringAsFixed(0)}%',
          //   style: TextStyle(
          //     fontSize: size * 0.22,
          //     fontWeight: FontWeight.w600,
          //   ),
          // ),
        ],
      ),
    );
  }
}
