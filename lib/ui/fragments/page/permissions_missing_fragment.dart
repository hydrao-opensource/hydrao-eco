import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsMissingFragment extends StatelessWidget {
  const PermissionsMissingFragment({super.key});

  Future<void> _openAppSettings() async {
    await openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/showerhead_search_locked.png',
              width: 180,
              height: 180,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 32),

            Text(
              t.showerheadDetectionBlocked,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: _openAppSettings,
              icon: const Icon(Icons.settings),
              label: Text(t.allowPermissions),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
