import 'package:flutter/material.dart';

class IconToggleRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;

  /// Icône affichée quand `value == true`
  final Widget trueIcon;

  /// Icône affichée quand `value == false`
  final Widget falseIcon;

  /// Espace entre l’icône et le texte
  final double spacing;

  const IconToggleRow({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    required this.trueIcon,
    required this.falseIcon,
    this.spacing = 8.0,
  });

  void _toggle() => onChanged(!value);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _toggle,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icône qui change selon l’état
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _toggle,
            child: value ? trueIcon : falseIcon,
          ),
          SizedBox(width: spacing),
          // Libellé cliquable
          Flexible(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _toggle,
              child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
            ),
          ),
        ],
      ),
    );
  }
}
