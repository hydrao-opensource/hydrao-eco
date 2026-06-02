import 'package:flutter/material.dart';

class PillTabs extends StatelessWidget {
  final List<Icon> tabs;
  final int currentIndex;
  final ValueChanged<int> onChanged;
  final Color? backgroundColor;
  final Color? selectedBgColor;
  final Color? foregroundColor;
  final double height;

  const PillTabs({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onChanged,
    this.backgroundColor,
    this.selectedBgColor,
    this.foregroundColor,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);

    return SizedBox(
      height: height,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              offset: const Offset(0, 2),
              color: Colors.black.withValues(alpha: 0.08),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final tabWidth = constraints.maxWidth / tabs.length;

            return Stack(
              children: [
                // Fond bleu de l’onglet sélectionné
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutQuad,
                  left: currentIndex * tabWidth,
                  top: 0,
                  bottom: 0,
                  width: tabWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          selectedBgColor ?? Colors.blue.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),

                // Icônes cliquables
                Row(
                  children: List.generate(tabs.length, (index) {
                    final selected = index == currentIndex;

                    return Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(999),
                        onTap: () => onChanged(index),
                        child: Center(
                          child: IconTheme.merge(
                            data: IconThemeData(
                              size: 28,
                              color: foregroundColor ?? Colors.black,
                              opacity: selected ? 1.0 : 0.8,
                            ),
                            child: tabs[index],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
