import 'dart:async';

import 'package:flutter/material.dart';

class ClickTooltip extends StatefulWidget {
  final Widget child;
  final String message;
  final double maxWidth;
  final EdgeInsets padding;
  final Duration animationDuration;
  final Duration? displayDuration;
  final double margin;

  const ClickTooltip({
    super.key,
    required this.child,
    required this.message,
    this.maxWidth = 250,
    this.margin = 8.0,
    this.padding = const EdgeInsets.all(12),
    this.animationDuration = const Duration(milliseconds: 200),
    this.displayDuration,
  });

  @override
  State<ClickTooltip> createState() => _ClickTooltipState();
}

class _ClickTooltipState extends State<ClickTooltip>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  late AnimationController _controller;
  late Animation<double> _scale;
  Timer? _autoCloseTimer; // Pour stocker le timer
  final TextStyle textStyle = const TextStyle(
    fontSize: 14,
    color: Colors.white,
    height: 1.4,
    fontWeight: FontWeight.w400,
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
  }

  @override
  void dispose() {
    _autoCloseTimer?.cancel(); // Toujours annuler le timer
    _removeOverlay();
    _controller.dispose();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _toggleTooltip() {
    if (_overlayEntry == null) {
      _showTooltip();
    } else {
      _hideTooltip();
    }
  }

  void _showTooltip() {
    // Annuler un éventuel timer précédent au cas où
    _autoCloseTimer?.cancel();

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final targetSize = renderBox.size;
    final targetOffset = renderBox.localToGlobal(Offset.zero);
    final screenSize = MediaQuery.of(context).size;
    final double systemBottom = MediaQuery.of(context).viewPadding.bottom;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final screenBottomPadding = keyboardHeight > 0
        ? keyboardHeight
        : systemBottom;
    // final double systemTop = MediaQuery.of(context).viewPadding.top;

    final spaceBelow =
        screenSize.height -
        (targetOffset.dy + targetSize.height) -
        screenBottomPadding -
        10;
    final spaceAbove = targetOffset.dy - 10;

    // const estimatedHeight = 80.0;

    final textPainter =
        TextPainter(
          text: TextSpan(text: widget.message, style: textStyle),
          textDirection: TextDirection.ltr,
        )..layout(
          maxWidth:
              widget.maxWidth - widget.padding.left - widget.padding.right,
        );

    // 3. Calculer la hauteur totale estimée
    // On ajoute le padding vertical interne (ex: 12 en haut/bas) + une marge de sécurité
    final estimatedHeight =
        textPainter.height +
        widget.padding.top +
        widget.padding.bottom +
        widget.margin; // 24 (padding) + 16 (marge flèche/espacement)

    final showAbove = spaceBelow < estimatedHeight && spaceAbove > spaceBelow;

    double left =
        targetOffset.dx + (targetSize.width / 2) - (widget.maxWidth / 2);
    left = left.clamp(
      widget.margin,
      screenSize.width - widget.maxWidth - widget.margin,
    );

    double top = showAbove
        ? targetOffset.dy - widget.margin
        : targetOffset.dy + targetSize.height + widget.margin;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _hideTooltip,
            ),
          ),
          Positioned(
            left: left,
            top: showAbove ? null : top,
            bottom: showAbove
                ? screenSize.height - targetOffset.dy + widget.margin
                : null,
            child: Material(
              color: Colors.transparent,
              child: ScaleTransition(
                scale: _scale,
                alignment: showAbove
                    ? Alignment.bottomCenter
                    : Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: widget.maxWidth),
                  child: Container(
                    padding: widget.padding,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      widget.message,
                      textAlign: TextAlign.center,
                      style: textStyle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(_overlayEntry!);
    _controller.forward().then((_) {
      // Si une durée est définie, on lance le compte à rebours après l'apparition
      if (widget.displayDuration != null) {
        _autoCloseTimer = Timer(widget.displayDuration!, () {
          if (mounted) _hideTooltip();
        });
      }
    });
  }

  void _hideTooltip() async {
    _autoCloseTimer
        ?.cancel(); // Annule le timer si l'utilisateur ferme manuellement
    if (_overlayEntry == null) return;

    await _controller.reverse();
    _removeOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _toggleTooltip,
      child: widget.child,
    );
  }
}
