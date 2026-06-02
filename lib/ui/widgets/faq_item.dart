import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/theme.dart';

class FaqItem extends StatefulWidget {
  final String question;
  final String answer;
  final bool initiallyExpanded;
  final Color? questionBgColor;

  const FaqItem({
    super.key,
    required this.question,
    required this.answer,
    this.initiallyExpanded = false,
    this.questionBgColor,
  });

  @override
  State<FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<FaqItem> with SingleTickerProviderStateMixin {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
  }

  @override
  Widget build(BuildContext context) {
    final headerColor =
        widget.questionBgColor ?? AppTheme.sectionSpecialBackground;
    const bodyBgColor = Colors.white;

    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: bodyBgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // HEADER
            Material(
              color: headerColor,
              child: InkWell(
                onTap: _toggle,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.question,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      _MinusPlusIcon(isExpanded: _expanded),
                    ],
                  ),
                ),
              ),
            ),

            // BODY (réponse)
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: _expanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 12,
                ),
                // color: bodyBgColor,
                decoration: BoxDecoration(
                  border: BoxBorder.all(color: headerColor),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Text(
                  widget.answer,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textColor.withValues(alpha: 0.5),
                    fontSize: 14,
                    height: 1.3,
                  ),
                ),
              ),
              secondChild: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Petit widget pour l’icône – / +
class _MinusPlusIcon extends StatelessWidget {
  final bool isExpanded;

  const _MinusPlusIcon({required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    const barColor = Colors.white;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      transitionBuilder: (child, anim) =>
          FadeTransition(opacity: anim, child: child),
      child: SizedBox(
        key: ValueKey(isExpanded),
        width: 24,
        height: 16,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // barre horizontale
              Container(
                width: 18,
                height: 3,
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              // barre verticale (pour faire un + quand fermé)
              if (!isExpanded)
                Container(
                  width: 3,
                  height: 18,
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
