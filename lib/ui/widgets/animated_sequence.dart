import 'dart:async';

import 'package:flutter/material.dart';

class AnimatedSequenceWidget extends StatefulWidget {
  final List<String> imagePaths;
  final Duration duration;
  final double? width;
  final double? height;
  final BoxFit fit;

  const AnimatedSequenceWidget({
    super.key,
    required this.imagePaths,
    this.duration = const Duration(milliseconds: 500),
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  @override
  State<AnimatedSequenceWidget> createState() => _AnimatedSequenceWidgetState();
}

class _AnimatedSequenceWidgetState extends State<AnimatedSequenceWidget> {
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.duration, (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.imagePaths.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Center(
        child: Image.asset(widget.imagePaths[_currentIndex], fit: widget.fit),
      ),
    );
  }
}
