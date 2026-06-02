import 'package:flutter/material.dart';

class HelpButton extends StatelessWidget {
  final VoidCallback? onTap; // callback optionnel
  final Color? iconColor;
  final double? size;
  final IconData? icon;

  const HelpButton({
    super.key,
    this.onTap,
    this.iconColor,
    this.size = 50,
    this.icon = Icons.help,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // déclenche le callback au clic
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Icon(
            icon ?? Icons.help,
            color: iconColor,
            size: (size ?? 50 * 32 / 50),
          ),
        ),
      ),
    );
  }
}
