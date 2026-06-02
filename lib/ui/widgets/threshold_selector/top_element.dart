import 'package:flutter/material.dart';

class TopElement extends StatefulWidget {
  final Color? color;

  const TopElement({super.key, this.color});

  @override
  // ignore: library_private_types_in_public_api
  _TopElementState createState() => _TopElementState();
}

class _TopElementState extends State<TopElement>
    with SingleTickerProviderStateMixin {
  late Animation<Color?> _colorAnimation;
  AnimationController? _animationController;

  void _launchAnimation() {
    final CurvedAnimation curvedAnimation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeOutCubic,
    );

    curvedAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController!.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController!.forward();
      }
      setState(() {});
    });

    _colorAnimation =
        ColorTween(
          begin: Color.lerp(
            widget.color == Colors.black
                ? Colors.black
                : Colors.white, //there is no such things as blinking black.
            widget.color,
            0.5,
          ),
          end: widget.color,
        ).animate(curvedAnimation)..addListener(() {
          setState(() {});
        });

    _animationController!.forward();
  }

  @override
  void didUpdateWidget(TopElement oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.color != widget.color) {
      _launchAnimation();
    }
  }

  @override
  void dispose() {
    _animationController?.stop();
    _animationController?.dispose();
    _animationController = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _launchAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TopElementPainter(context, color: _colorAnimation.value),
    );
  }
}

class _TopElementPainter extends CustomPainter {
  Color? color;

  _TopElementPainter(BuildContext context, {this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color ?? Colors.transparent
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        0,
        0,
        size.width,
        size.height,
        topLeft: Radius.circular(size.width / 2),
        topRight: Radius.circular(size.width / 2),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(_TopElementPainter oldDelegate) {
    if (oldDelegate.color != color) {
      return true;
    } else {
      return false;
    }
  }
}
