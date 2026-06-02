import 'package:flutter/material.dart';

class TopTabs extends StatelessWidget {
  final List<String> tabs;
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const TopTabs({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Ligne de textes
        Row(
          children: List.generate(tabs.length, (index) {
            // final isSelected = index == currentIndex;
            return Expanded(
              child: InkWell(
                onTap: () => onChanged(index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    tabs[index],
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),

        // Ligne grise + barre bleue animée
        LayoutBuilder(
          builder: (context, constraints) {
            final tabWidth = constraints.maxWidth / tabs.length;

            return Stack(
              children: [
                // ligne grise sur toute la largeur
                Container(
                  width: double.infinity,
                  height: 4,
                  color: Colors.grey[300],
                ),
                // indicateur bleu sous l’onglet sélectionné
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  left: currentIndex * tabWidth,
                  width: tabWidth,
                  height: 8, // épaisseur de la barre bleue
                  child: Container(color: primary),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
