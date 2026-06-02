import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/constants.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/theme.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/help_dialog.dart';
import 'package:hydrao_flutter_offline/ui/widgets/help_incitation.dart';

class ShConnectedFragment extends StatelessWidget {
  final String message;
  final double? flow;
  final String? shType;

  const ShConnectedFragment({
    super.key,
    required this.message,
    this.flow,
    this.shType,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: BoxDecoration(
            color: AppTheme.sectionBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/showerhead_connected.png',
                width: 180,
                height: 180,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 32),

              Text(
                message,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              Text(
                t.connectedShStopWater,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
        if (flow != null && flow! < AppConstants.shMinFlow)
          SizedBox(height: 15),
        if (flow != null && flow! < AppConstants.shMinFlow)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
              color: AppTheme.sectionBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // icon
                Icon(
                  Icons.warning_rounded,
                  color: AppTheme.textWarningColor,
                  size: 40,
                ),
                SizedBox(height: 10),
                Text(
                  t.addShConnectedWarningFlowTitle,
                  style: TextStyle(
                    color: AppTheme.textWarningColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                // Text(
                //   t.addShConnectedWarningFlowMessage,
                //   style: TextStyle(
                //     color: AppTheme.textWarningColor,
                //     fontWeight: FontWeight.w400,
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                HelpIncitation(
                  message: t.iNeedHelp,
                  textExpand: false,
                  iconOnRight: false,
                  color: AppTheme.textWarningColor,
                  iconSize: 24,
                  onTap: () {
                    showHelpDialog(
                      context: context,
                      key: HelpCase.removeFlowRestrictor,
                      data: shType,
                    );
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
