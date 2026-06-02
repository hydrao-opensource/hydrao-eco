import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/theme.dart';

class PartialBluetoothDisabledFragment extends StatelessWidget {
  const PartialBluetoothDisabledFragment({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            // 'assets/images/showerhead_search_locked.png',
            "assets/images/bluetooth_disabled.png",
            width: 80,
            height: 80,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 15),
          Expanded(
            // ← ici
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  t.showerheadDetectionBlocked,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppTheme.scanSectionTextColor,
                  ),
                  textAlign: TextAlign.start,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                const SizedBox(height: 5),

                Text(
                  t.enableBluetooth,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: AppTheme.scanSectionTextColor,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.start,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
