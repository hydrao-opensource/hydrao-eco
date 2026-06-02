import 'package:flutter/material.dart';

class LabeledCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Text label;

  const LabeledCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value), // toggle en cliquant sur le texte
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 25,
            height: 25,
            child: Transform.scale(
              scale: 0.8, // 0.6 ou 0.5 si tu veux encore plus petit
              child: Checkbox(
                value: value,
                onChanged: (v) => onChanged(v ?? false),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
          Expanded(child: label),
        ],
      ),
    );
  }
}
