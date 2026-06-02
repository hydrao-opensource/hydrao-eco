import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/theme.dart';
import 'package:hydrao_flutter_offline/ui/widgets/pill_tabs.dart';
import 'package:hydrao_flutter_offline/ui/widgets/scan_monitor.dart';

enum Menu { dashboard, statistics, more }

const _logTag = "[MENU_FRAGMENT] ";

class MenuFragment extends StatelessWidget {
  final Menu selected;
  final void Function(Menu newMenu) onMenuChanged;
  final VoidCallback onSettingsClicked;

  const MenuFragment({
    super.key,
    required this.selected,
    required this.onMenuChanged,
    required this.onSettingsClicked,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // scan view
        buildScan(),

        SizedBox(width: 10),

        // menu
        // SizedBox(width: 220, child: buildMenu()),
        Expanded(child: buildMenu(context)),

        SizedBox(width: 10),

        // settings
        buildSettings(),
      ],
    );
  }

  Widget buildScan() {
    return Container(
      // margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      width: 55,
      height: 50,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.color,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ScanMonitor(),
    );
  }

  Widget buildMenu(BuildContext context) {
    const iconTabs = [
      Icon(Icons.home),
      Icon(Icons.bar_chart),
      Icon(Icons.help_sharp),
    ];

    return PillTabs(
      tabs: iconTabs,
      currentIndex: selected.index,
      height: 50,
      onChanged: (i) {
        if (i == selected.index) return;

        appLogger.i('[MENU_FRAGMENT] menu clicked : ${Menu.values[i]}');
        onMenuChanged(Menu.values[i]);
      },
    );
  }

  Widget buildSettings() {
    return Container(
      width: 55,
      height: 50,
      // margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          bottomLeft: Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            appLogger.i('$_logTag settings clicked');
            onSettingsClicked();
          },
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            bottomLeft: Radius.circular(50),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: SvgPicture.asset(
              'assets/images/user_settings.svg',
              colorFilter: ColorFilter.mode(
                AppTheme.textColor,
                BlendMode.srcIn,
              ),
              width: 24,
              height: 24,
            ),
          ),
        ),
      ),
    );
  }
}
