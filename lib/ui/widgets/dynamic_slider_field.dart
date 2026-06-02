import 'package:flutter/material.dart';

class DynamicSliderField extends StatefulWidget {
  final double value;
  final ValueChanged<double>? onChanged;

  // Pass-through parameters
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final Color? activeColor;
  final Color? inactiveColor;
  final FocusNode? focusNode;
  final bool autofocus;
  final SemanticFormatterCallback? semanticFormatterCallback;

  const DynamicSliderField({
    super.key,
    required this.value,
    this.onChanged,
    this.min = 0,
    this.max = 10,
    this.divisions,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.focusNode,
    this.autofocus = false,
    this.semanticFormatterCallback,
  });

  @override
  State<DynamicSliderField> createState() => _DynamicSliderFieldState();
}

class _DynamicSliderFieldState extends State<DynamicSliderField> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  @override
  void didUpdateWidget(DynamicSliderField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _currentValue) {
      _currentValue = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _currentValue,
      onChanged: (v) {
        setState(() {
          _currentValue = v;
        });
        if (widget.onChanged != null) widget.onChanged!(v);
      },
      min: widget.min,
      max: widget.max,
      divisions: widget.divisions,
      label: widget.label,
      activeColor: widget.activeColor,
      inactiveColor: widget.inactiveColor,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      semanticFormatterCallback: widget.semanticFormatterCallback,
    );
  }
}
