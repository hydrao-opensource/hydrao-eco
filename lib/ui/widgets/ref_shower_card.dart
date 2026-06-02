import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/conversions.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';
import 'package:hydrao_flutter_offline/theme.dart';
import 'package:hydrao_flutter_offline/ui/widgets/duration_display.dart';
import 'package:hydrao_flutter_offline/utils.dart';

class RefShowerCard extends StatelessWidget {
  final Shower shower;
  final String waterUnit; // ex: "L", "m³", "gal"
  final bool toggleValue;
  final ValueChanged<bool> onToggleChange;

  const RefShowerCard({
    super.key,
    required this.shower,
    required this.waterUnit,
    required this.toggleValue,
    required this.onToggleChange,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Date / time formatting
    final dateStr = formatDate(context, shower.date);
    final timeStr = formatTime(context, shower.date);

    final volumeStr = formatVolume(
      getVolumeForUnit(shower.volume.toDouble(), waterUnit),
    );

    return Row(
      children: [
        // Toggle
        Transform.scale(
          scale: 0.70,
          child: Switch(
            value: toggleValue,
            onChanged: onToggleChange,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 6),

        // Date + time (left block)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                dateStr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF6E9CFF), // bleu du mock
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                timeStr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF6E9CFF),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),

        // // Volume pill
        _Pill(
          background: const Color(0xFFD9ECF7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                volumeStr,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                waterUnit,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black38,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        if (shower.duration != null) SizedBox(width: 12),

        if (shower.duration != null)
          // Duration pill
          _Pill(
            background: const Color(0xFFD9ECF7),
            child: DurationDisplay(
              totalSeconds: shower.duration!.round(),
              gapBetweenBlocks: 8,
              unitStyle: TextStyle(
                fontSize: 11,
                color: AppTheme.textColor.withValues(alpha: 0.5),
                fontWeight: FontWeight.w400,
              ),
              valueStyle: TextStyle(
                fontSize: 13,
                color: AppTheme.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final Color background;
  final Widget child;

  const _Pill({required this.background, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
