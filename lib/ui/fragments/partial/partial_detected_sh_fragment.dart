import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/models/showerhead_device.dart';
import 'package:hydrao_flutter_offline/ui/widgets/ble_showerhead_card.dart';
import 'package:hydrao_flutter_offline/ui/widgets/custom_expansion_tile.dart';

class PartialDetectedShFragment extends StatelessWidget {
  final void Function(ShowerheadDevice device) onDeviceClicked;
  final List<ShowerheadDevice> detectedDevices;
  final ShowerheadDevice? connectingDevice;
  final bool expanded;
  final Color? backgroundColor;

  const PartialDetectedShFragment({
    super.key,
    required this.detectedDevices,
    this.connectingDevice,
    required this.onDeviceClicked,
    this.expanded = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        children: [
          CustomExpansionTile(
            title: t.partialDetectedShSectionTitle(detectedDevices.length),
            expanded: expanded,
            headerPadding: EdgeInsets.all(0),
            backgroundColor: backgroundColor ?? Colors.white,
            titleCentered: true,
            children: [
              ListView.builder(
                itemCount: detectedDevices.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final device = detectedDevices[index];
                  return BleShowerheadCard(
                    device: device,
                    connectingProgress: (device.id == connectingDevice?.id)
                        ? connectingDevice!.autoConnectProgress
                        : null,
                    onShClicked: () => onDeviceClicked(device),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
