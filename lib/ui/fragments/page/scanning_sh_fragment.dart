import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/models/showerhead_device.dart';
import 'package:hydrao_flutter_offline/theme.dart';
import 'package:hydrao_flutter_offline/ui/fragments/partial/partial_detected_sh_fragment.dart';
import 'package:hydrao_flutter_offline/ui/widgets/animated_sequence.dart';
import 'package:hydrao_flutter_offline/ui/widgets/help_incitation.dart';

class ScanningShFragment extends StatelessWidget {
  final String message;
  final List<ShowerheadDevice> detectedDevices;
  final ShowerheadDevice? connectingDevice;
  final VoidCallback onHelpTap;
  final void Function(ShowerheadDevice device)?
  onDetectedDeviceTap; // callback optionnel

  const ScanningShFragment({
    super.key,
    required this.message,
    required this.onHelpTap,
    required this.detectedDevices,
    this.connectingDevice,
    this.onDetectedDeviceTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: BoxDecoration(
            color: AppTheme.sectionBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSequenceWidget(
                width: 180,
                height: 180,
                imagePaths: [
                  "assets/images/showerhead_search_1a.png",
                  "assets/images/showerhead_search_1b.png",
                  "assets/images/showerhead_search_1c.png",
                ],
                duration: Duration(milliseconds: 800),
              ),
              const SizedBox(height: 20),

              Text(
                message,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        if (detectedDevices.isNotEmpty) const SizedBox(height: 15),

        if (detectedDevices.isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            decoration: BoxDecoration(
              color: AppTheme.sectionBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: PartialDetectedShFragment(
              connectingDevice: connectingDevice,
              detectedDevices: detectedDevices,
              onDeviceClicked: onDetectedDeviceTap!,
              expanded: detectedDevices.length > 1,
            ),
          ),

        const SizedBox(height: 8),

        HelpIncitation(message: t.showerheadNotDetected, onTap: onHelpTap),
      ],
    );
  }
}
