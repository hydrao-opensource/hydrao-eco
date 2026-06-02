import 'dart:math';

import 'package:flutter/material.dart';

/// FROM LIB : https://github.com/studioidan/wave_progress/blob/master/lib/wave_progress.dart
/// not maintained from 7 years ago => included in project

class WaveProgress extends StatefulWidget {
  final double size;
  final double borderSize;
  final Color borderColor, fillColor;
  final double progress;
  final Color? backgroundColor;
  final Widget? child;

  const WaveProgress({
    super.key,
    required this.size,
    required this.borderColor,
    required this.fillColor,
    required this.progress,
    this.backgroundColor,
    this.child,
    this.borderSize = 4.0,
  });

  @override
  WaveProgressState createState() => WaveProgressState();
}

class WaveProgressState extends State<WaveProgress>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );

    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: ClipPath(
        clipper: CircleClipper(),
        child: Container(
          color: widget.backgroundColor ?? Colors.grey.withValues(alpha: 0.08),
          child: AnimatedBuilder(
            animation: controller,
            builder: (BuildContext context, Widget? child) {
              return CustomPaint(
                painter: WaveProgressPainter(
                  controller,
                  widget.borderColor,
                  widget.fillColor,
                  widget.progress,
                  widget.borderSize,
                ),
                child: widget.child,
              );
            },
          ),
        ),
      ),
    );
  }
}

class WaveProgressPainter extends CustomPainter {
  final Animation<double> _animation;
  Color borderColor, fillColor;
  final double _progress, borderSize;

  WaveProgressPainter(
    this._animation,
    this.borderColor,
    this.fillColor,
    this._progress,
    this.borderSize,
  ) : super(repaint: _animation);

  @override
  void paint(Canvas canvas, Size size) {
    // draw small wave
    Paint wave2Paint = Paint()..color = fillColor.withValues(alpha: 0.5);
    double p = _progress / 100.0;
    double n = 2.4;
    double amp = 1.5;
    double baseHeight = (1 - p) * size.height;

    Path path = Path();
    path.moveTo(0.0, baseHeight);
    for (double i = 0.0; i < size.width; i++) {
      path.lineTo(
        i,
        baseHeight +
            sin(
                  (i / size.width * 2 * pi * n) +
                      (_animation.value * 2 * pi) +
                      pi * 1,
                ) *
                amp,
      );
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    canvas.drawPath(path, wave2Paint);

    // draw big wave
    Paint wave1Paint = Paint()..color = fillColor;
    n = 1.2;
    amp = 5.5;

    path = Path();
    path.moveTo(0.0, baseHeight);
    for (double i = 0.0; i < size.width; i++) {
      path.lineTo(
        i,
        baseHeight +
            sin((i / size.width * 2 * pi * n) + (_animation.value * 2 * pi)) *
                amp,
      );
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    canvas.drawPath(path, wave1Paint);

    // draw border
    Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderSize;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()..addOval(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2,
      ),
    );
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
