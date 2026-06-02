import 'package:flutter/material.dart';

class BottomElement extends StatelessWidget {
  final Color? color;

  const BottomElement({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _BottomElementPainter(context, color: color));
  }
}

class _BottomElementPainter extends CustomPainter {
  Color? color;

  _BottomElementPainter(BuildContext context, {this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color!
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, 2.5), paint);
    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        0,
        0,
        size.width / 2.0,
        size.height,
        bottomLeft: Radius.circular(size.width / 2),
        bottomRight: Radius.circular(size.width / 2),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(_BottomElementPainter oldDelegate) {
    if (oldDelegate.color != color) {
      return true;
    } else {
      return false;
    }
  }
}
