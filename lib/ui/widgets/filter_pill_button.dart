import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/models/shower_filters.dart';

class FilterPillButton extends StatelessWidget {
  final ShowerFilters filters;
  final VoidCallback onTap;
  final String label;
  final double height;
  final Color? inactiveBadgeColor;
  final Color? activeBadgeColor;
  final Color? labelColor;

  const FilterPillButton({
    super.key,
    required this.filters,
    required this.onTap,
    this.label = "Filtrer",
    this.height = 40,
    this.inactiveBadgeColor,
    this.activeBadgeColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final int count = filters.count();
    final bool showBadge = count > 0;

    return Material(
      color: const Color(0xFFE8F4FA), // fond bleu très clair (mock)
      borderRadius: BorderRadius.circular(40),
      child: InkWell(
        borderRadius: BorderRadius.circular(40),
        onTap: onTap,
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              // -----------------------
              // Pastille ronde + nombre
              // -----------------------
              CircleAvatar(
                radius: height / 3,
                backgroundColor: showBadge
                    ? activeBadgeColor ?? const Color(0xFF6EC1E4)
                    : inactiveBadgeColor ?? Colors.grey.withValues(alpha: 0.4),
                child: Text(
                  showBadge ? count.toString() : "0",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // -----------------------
              // Label "Filtrer"
              // -----------------------
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: labelColor ?? Colors.grey.shade700,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // -----------------------
              // Flèche
              // -----------------------
              Icon(
                Icons.expand_more,
                size: 24,
                color: Colors.black.withValues(alpha: 0.8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
