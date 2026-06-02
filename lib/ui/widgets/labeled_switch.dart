import 'package:flutter/material.dart';

class LabeledSwitch extends StatelessWidget {
  final bool value;
  final String? label;
  final Widget? labelWidget;
  final String? subLabel;
  final ValueChanged<bool> onChanged;
  final bool enabled;
  final bool switchOnRight;

  const LabeledSwitch({
    super.key,
    required this.value,
    this.label,
    this.labelWidget,
    this.subLabel,
    required this.onChanged,
    this.enabled = true,
    this.switchOnRight = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textColor = enabled
        ? theme.textTheme.bodyMedium?.color
        : theme.disabledColor;

    Widget? textColumn;
    if (label != null || labelWidget != null) {
      textColumn = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null)
            Text(
              label!,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ?labelWidget,
          if (subLabel != null && subLabel!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(
                subLabel!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: textColor?.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
        ],
      );
    }

    final switchWidget = Transform.scale(
      scale: 0.7, // 70% de la taille normale
      child: Switch(value: value, onChanged: enabled ? onChanged : null),
    );

    return InkWell(
      onTap: enabled ? () => onChanged(!value) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: switchOnRight
              ? [
                  if (textColumn != null) Expanded(child: textColumn),
                  switchWidget,
                ]
              : [
                  switchWidget,
                  if (textColumn != null) const SizedBox(width: 5),
                  if (textColumn != null) Expanded(child: textColumn),
                ],
        ),
      ),
    );
  }
}
