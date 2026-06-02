import 'package:flutter/material.dart';

class MiddleElement extends StatelessWidget {
  final Color? color;

  const MiddleElement({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _MiddleElementPainter(context, color: color));
  }
}

class _MiddleElementPainter extends CustomPainter {
  Color? color;

  _MiddleElementPainter(BuildContext context, {this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color!
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, 2.5), paint);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width / 2.0, size.height), paint);
  }

  @override
  bool shouldRepaint(_MiddleElementPainter oldDelegate) {
    if (oldDelegate.color != color) {
      return true;
    } else {
      return false;
    }
  }
}
