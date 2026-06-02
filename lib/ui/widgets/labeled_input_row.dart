import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/theme.dart';

class LabeledInputRow extends StatefulWidget {
  final String? label;
  final Widget field;
  final String? unit;
  final Widget? infoWidget;
  final double? fieldWidth;
  final Color? textColor;
  final bool vertical;

  const LabeledInputRow({
    super.key,
    required this.field,
    this.infoWidget,
    this.label,
    this.unit,
    this.fieldWidth,
    this.textColor,
    this.vertical = false,
  });

  @override
  State<LabeledInputRow> createState() => _LabeledInputRowState();
}

class _LabeledInputRowState extends State<LabeledInputRow> {
  @override
  Widget build(BuildContext context) {
    return widget.vertical == true ? buildVertical() : buildHorizontal();
  }

  Widget buildHorizontal() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: widget.textColor ?? AppTheme.textColor),
              ),
              if (widget.infoWidget != null) const SizedBox(width: 4),
              if (widget.infoWidget != null) widget.infoWidget!,
            ],
          ),

        if (widget.label != null) const SizedBox(width: 8),

        if (widget.fieldWidth == null) Expanded(child: widget.field),
        if (widget.fieldWidth != null)
          SizedBox(width: widget.fieldWidth!, child: widget.field),

        if (widget.unit != null) const SizedBox(width: 8),
        if (widget.unit != null)
          SizedBox(
            width: 70,
            child: Text(
              widget.unit!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: TextStyle(color: widget.textColor ?? AppTheme.textColor),
            ),
          ),

        if (widget.label == null && widget.infoWidget != null)
          const SizedBox(width: 8),
        if (widget.label == null && widget.infoWidget != null)
          widget.infoWidget!,
      ],
    );
  }

  Widget buildVertical() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // label + [label not null] infowidget
        if (widget.label != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.label!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: widget.textColor ?? AppTheme.textColor),
              ),
              if (widget.infoWidget != null) const SizedBox(width: 4),
              if (widget.infoWidget != null) widget.infoWidget!,
            ],
          ),
        if (widget.label != null) SizedBox(height: 8),
        // field + unit + [label null] infoWidget
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.fieldWidth == null) Expanded(child: widget.field),
            if (widget.fieldWidth != null)
              SizedBox(width: widget.fieldWidth!, child: widget.field),

            if (widget.unit != null) const SizedBox(width: 8),
            if (widget.unit != null)
              SizedBox(
                width: 70,
                child: Text(
                  widget.unit!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: widget.textColor ?? AppTheme.textColor,
                  ),
                ),
              ),

            if (widget.label == null && widget.infoWidget != null)
              const SizedBox(width: 8),
            if (widget.label == null && widget.infoWidget != null)
              widget.infoWidget!,
          ],
        ),
      ],
    );
  }
}
