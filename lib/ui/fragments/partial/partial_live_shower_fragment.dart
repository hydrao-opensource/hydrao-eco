import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/models/threshold.dart';
import 'package:hydrao_flutter_offline/theme.dart';
import 'package:hydrao_flutter_offline/ui/widgets/animated_sequence.dart';
import 'package:hydrao_flutter_offline/ui/widgets/live_wave_volume.dart';
import 'package:hydrao_flutter_offline/ui/widgets/rounded_progress_bar.dart';

class PartialLiveShowerFragment extends StatelessWidget {
  final String shName;
  final String message;
  final double? progress;
  final bool showVolume;
  final int? volume;
  final String unit;
  final List<HydraoThreshold> thresholds;

  const PartialLiveShowerFragment({
    super.key,
    required this.shName,
    required this.message,
    required this.thresholds,
    required this.unit,
    required this.showVolume,
    this.volume,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    // final t = AppLocalizations.of(context)!;

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSequenceWidget(
            width: 80,
            height: 80,
            imagePaths: [
              "assets/images/showerhead_live_white_2a.png",
              "assets/images/showerhead_live_white_2b.png",
              "assets/images/showerhead_live_white_2c.png",
              "assets/images/showerhead_live_white_2d.png",
            ],
            duration: Duration(milliseconds: 400),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  shName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: AppTheme.scanSectionTextColor,
                  ),
                  textAlign: TextAlign.start,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),

                const SizedBox(height: 7),

                Text(
                  message,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: AppTheme.scanSectionTextColor,
                  ),
                  textAlign: TextAlign.start,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                if (progress != null) const SizedBox(height: 8),
                if (progress != null)
                  RoundedProgressBar(
                    value: progress!,
                    height: 12,
                    color: AppTheme.scanSectionTextColor,
                  ),
              ],
            ),
          ),

          if (showVolume == true && volume != null) SizedBox(width: 8),
          if (showVolume == true && volume != null)
            // Container(
            //   decoration: BoxDecoration(
            //     color: AppTheme.scanSectionTextColor.withValues(alpha: 0.4),
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   child:
            // ),
            LiveWaveVolume(
              volume: volume!,
              unit: unit,
              thresholds: thresholds,
              textColor: AppTheme.scanSectionTextColor,
            ),
        ],
      ),
    );
  }
}
