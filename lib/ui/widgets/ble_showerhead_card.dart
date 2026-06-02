import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/constants.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/models/showerhead_device.dart';
import 'package:hydrao_flutter_offline/ui/widgets/rounded_progress_bar.dart';

class BleShowerheadCard extends StatelessWidget {
  final ShowerheadDevice device;
  final VoidCallback onShClicked;
  final double? connectingProgress;

  const BleShowerheadCard({
    super.key,
    required this.device,
    required this.onShClicked,
    this.connectingProgress,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return InkWell(
      onTap: onShClicked,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // icon
            Image.asset(
              AppConstants.getShIconFromType(device.type),
              width: 48,
              height: 48,
              fit: BoxFit.contain,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // name
                  Text(
                    device.name ?? t.defaultShowerheadName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    device.id,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                    ),
                  ),
                  // const SizedBox(height: 4),
                  // Text(
                  //   device.rssi.toString(),
                  //   style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  //     fontWeight: FontWeight.w400,
                  //     fontSize: 8,
                  //   ),
                  // ),

                  // connecting state
                  if (connectingProgress != null) const SizedBox(height: 8),
                  if (connectingProgress != null)
                    RoundedProgressBar(value: connectingProgress!, height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
