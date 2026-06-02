import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/theme.dart';
import 'package:hydrao_flutter_offline/ui/widgets/animated_sequence.dart';
import 'package:hydrao_flutter_offline/ui/widgets/circular_progress_loader.dart';

class PartialSoapingFragment extends StatelessWidget {
  final String shName;
  final double progress;
  final VoidCallback? onFinishTap; // callback optionnel

  const PartialSoapingFragment({
    super.key,
    required this.shName,
    required this.progress,
    required this.onFinishTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSequenceWidget(
            width: 80,
            height: 80,
            imagePaths: [
              "assets/images/soaping_white_1.png",
              "assets/images/soaping_white_2.png",
              "assets/images/soaping_white_3.png",
            ],
            duration: Duration(milliseconds: 800),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(height: 8),

                ElevatedButton.icon(
                  onPressed: onFinishTap,
                  // icon: const Icon(Icons.settings),
                  label: Text(t.showerFinished, style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    foregroundColor: AppTheme.textColor,
                    backgroundColor: AppTheme.scanSectionTextColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressLoader(
                progress: progress,
                color: AppTheme.scanSectionTextColor,
                backgroundColor: AppTheme.scanSectionTextColor.withValues(
                  alpha: 0.4,
                ),
                size: 45,
                centeredContent: Icon(
                  Icons.timer_outlined,
                  size: 24,
                  color: AppTheme.scanSectionTextColor,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "Savonnage",
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.scanSectionTextColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
