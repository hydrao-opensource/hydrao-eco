import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hydrao_flutter_offline/constants.dart';
import 'package:hydrao_flutter_offline/conversions.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';
import 'package:hydrao_flutter_offline/ui/widgets/threshold_horizontal.dart';
import 'package:hydrao_flutter_offline/utils.dart';

class DbShowerheadOldCard extends StatelessWidget {
  final Showerhead showerhead;
  final double thresholdMaxLiter;
  final String unit;
  final bool connected;
  final VoidCallback onShClicked;
  final VoidCallback onSettingsClicked;
  final double? averageShower;

  const DbShowerheadOldCard({
    super.key,
    required this.showerhead,
    required this.unit,
    required this.connected,
    required this.thresholdMaxLiter,
    required this.onShClicked,
    required this.onSettingsClicked,
    this.averageShower,
  });

  @override
  Widget build(BuildContext context) {
    var fixedAverageShower = (averageShower != null)
        ? getVolumeForUnit(averageShower!, unit)
        : null;
    var averageShowerString = fixedAverageShower != null
        ? formatVolume(fixedAverageShower)
        : null;

    Widget? statusWidget;

    final colorScheme = Theme.of(context).colorScheme;

    if (showerhead.lastSyncDate == null) {
      // circle grey with ?
      statusWidget = Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(1.0),
        child: Center(
          child: Text(
            "?",
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else if (connected && showerhead.isLastSyncComplete == false) {
      statusWidget = SpinKitDoubleBounce(
        color: Colors.grey.shade500,
        size: 16.0,
      );
    } else if (showerhead.isLastSyncComplete == false) {
      // circle orange with warning
      statusWidget = Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: Colors.orange.shade100,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(1.0),
        child: Center(
          // child: Icon(Icons.warning_amber, size: 11, color: Colors.black54),
          child: Text(
            "!",
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else if (showerhead.isLastSyncComplete == true) {
      // circle green with check
      statusWidget = Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(2.0),
        child: Center(
          child: Icon(Icons.check, size: 12, color: Colors.black54),
        ),
      );
    }

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
              AppConstants.getShIconFromType(showerhead.type),
              width: 42,
              height: 42,
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // name
                  Text(
                    showerhead.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // thresholds
                  ThresholdHorizontal(
                    thresholds: thresholdsFromJson(
                      showerhead.getThresholdToShow() ??
                          AppConstants.shDefaultThresholds,
                    )!,
                    unit: unit,
                    height: 25,
                    maxLiter: thresholdMaxLiter,
                    opacity: showerhead.hasThresholdRequest() ? 0.5 : 1,
                  ),

                  const SizedBox(height: 8),

                  // last activity
                  if (showerhead.lastSeen != null)
                    Row(
                      children: [
                        ?statusWidget,
                        const SizedBox(width: 4),
                        SizedBox(
                          width: 80, // 🔥 largeur max
                          child: AutoSizeText(
                            formatRelative(context, showerhead.lastSeen!),
                            maxLines: 1,
                            minFontSize: 8, // 🔥 taille min acceptable
                            overflow:
                                TextOverflow.ellipsis, // tronquer si trop long
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.black54),
                          ),
                        ),

                        if (averageShower != null) const SizedBox(width: 10),
                        if (averageShower != null)
                          const Icon(
                            Icons.water_drop,
                            size: 16,
                            color: Colors.black54,
                          ),
                        if (averageShower != null) SizedBox(width: 3),
                        //   Text(
                        //     'moy.',
                        //     style: Theme.of(context).textTheme.bodySmall
                        //         ?.copyWith(color: Colors.black54),
                        //   ),
                        if (averageShower != null)
                          Text(
                            '$averageShowerString $unit',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            if (connected == false)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // button stats
                  IconButton(
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    onPressed: onShClicked,
                    icon: const Icon(
                      Icons.bar_chart,
                      size: 26,
                      color: Colors.black87,
                    ),
                  ),
                  // Bouton settings
                  IconButton(
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    onPressed: onSettingsClicked,
                    icon: const Icon(
                      Icons.settings,
                      size: 26,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

            if (connected == true)
              // SpinKitRipple(color: Colors.purple, size: 50.0),
              Padding(
                padding: EdgeInsetsGeometry.all(8),
                child: SpinKitFadingCircle(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                  size: 35.0,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
