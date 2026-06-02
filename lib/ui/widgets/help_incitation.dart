import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/theme.dart';

class HelpIncitation extends StatelessWidget {
  final VoidCallback? onTap; // callback optionnel
  final String message;
  final EdgeInsets? padding;
  final double? iconSize;
  final Color? color;
  final bool iconOnRight;
  final double fontSize;
  final MainAxisAlignment alignement;
  final bool showIcon;
  final IconData icon;
  final bool textExpand;

  const HelpIncitation({
    super.key,
    required this.message,
    this.onTap,
    this.iconSize = 40,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
    this.color,
    this.iconOnRight = true,
    this.fontSize = 15,
    this.alignement = MainAxisAlignment.center,
    this.showIcon = true,
    this.icon = Icons.help,
    this.textExpand = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconView = Icon(
      icon,
      color: color ?? AppTheme.textColor,
      size: iconSize!,
    );

    Widget textView = Text(
      message,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: color ?? AppTheme.textColor,
        fontWeight: FontWeight.w400,
        fontSize: fontSize,
      ),
      textAlign: textExpand ? TextAlign.center : TextAlign.start,
      softWrap: true,
      overflow: TextOverflow.visible,
    );

    return InkWell(
      onTap: onTap, // déclenche le callback au clic
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: padding,
        child: Row(
          mainAxisAlignment: alignement,
          children: [
            if (!iconOnRight && showIcon) iconView,
            if (!iconOnRight && showIcon) SizedBox(width: 10),
            if (textExpand) Expanded(child: textView),
            if (!textExpand) textView,
            if (iconOnRight && showIcon) SizedBox(width: 10),
            if (iconOnRight && showIcon) iconView,
          ],
        ),
      ),
    );
  }
}
