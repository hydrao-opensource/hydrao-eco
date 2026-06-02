import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/domains/app_domain.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/models/savings_stats.dart';
import 'package:hydrao_flutter_offline/models/shower_filters.dart';
import 'package:hydrao_flutter_offline/providers.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';
import 'package:hydrao_flutter_offline/theme.dart';
import 'package:hydrao_flutter_offline/ui/fragments/menu_fragment.dart';
import 'package:hydrao_flutter_offline/ui/widgets/stats_showerhead_card.dart';
import 'package:hydrao_flutter_offline/utils.dart';

const _logTag = "[STATISTICS_SCREEN] ";
const _filterThresholds = [10, 25, 50, 100];

class StatisticsScreen extends ConsumerStatefulWidget {
  final double availableHeight;
  const StatisticsScreen({super.key, required this.availableHeight});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  late AppDomain appDomain;
  String? shId;
  ShowerFilters globalFilters = ShowerFilters(actives: []);
  String globalFilter = 'all';
  final GlobalKey _selectedKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    appDomain = ref.read(appDomainProvider.notifier);
    shId = ref.read(statisticsShSelectedProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateUIForScreenStatus();
      if (shId != null) _scrollToTarget();
    });
  }

  void _updateUIForScreenStatus() {
    if (!mounted) return;
    appDomain.updatePage(
      resetTitle: true,
      resetBgColor: true,
      resetActions: true,
      resetBottomButton: true,
      resetBackButton: true,
      bottomMenu: Menu.statistics,
    );
  }

  void _scrollToTarget() {
    if (_selectedKey.currentContext != null) {
      Scrollable.ensureVisible(
        _selectedKey.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    appLogger.t('$_logTag build / shId=$shId / globalFilter=$globalFilter');

    const double globalFilterHeight = 86;
    final double availableScrollHeight = widget.availableHeight - globalFilterHeight;

    final waterUnit = appDomain.getWaterUnit();
    final tempUnit = appDomain.getTemperatureUnit();
    final currency = appDomain.getCurrency();
    final savingsParams = appDomain.getSavingsParams();

    final List<Shower> selectedShowers = shId != null
        ? appDomain.getShowers(shId!, notEmpty: true, gteMinVolume: true)
        : [];
    final bool selectedHasShowers = selectedShowers.isNotEmpty;
    final int showerheadsCount = appDomain.getShowerheadsCount();

    final List<Widget> cards = [];
    final List<Shower> totalShowers = [];
    SavingsStats totalSavings = SavingsStats.none();
    int maxShowersBySh = 0;

    for (final Showerhead sh in appDomain.getShowerheads()) {
      final List<Shower> rawShowers = appDomain.getShowers(
        sh.id,
        notEmpty: true,
        gteMinVolume: true,
      );
      if (rawShowers.length > maxShowersBySh) maxShowersBySh = rawShowers.length;

      final List<Shower> showers = globalFilters.filter(rawShowers);
      totalShowers.addAll(showers);
      totalSavings = totalSavings.add(SavingsStats.from(sh, showers, savingsParams));

      final bool expanded = showers.isNotEmpty && (shId == sh.id || showerheadsCount == 1);

      cards.add(
        StatsShowerheadCard(
          key: expanded ? _selectedKey : null,
          sh: sh,
          expandable: showerheadsCount > 1,
          expanded: expanded,
          highlighted:
              shId == null || !selectedHasShowers || (shId == sh.id && showers.isNotEmpty),
          title: sh.name,
          showers: showers,
          waterUnit: waterUnit,
          tempUnit: tempUnit,
          currency: currency,
          savingsParams: savingsParams,
          showerFilter: globalFilters,
          onSwitchExpanded: (expanded) {
            appLogger.t(
              '$_logTag sh "${sh.name}" expanded changed : ${expanded ? 'ouvert' : 'fermé'}',
            );
            setState(() {
              shId = expanded ? sh.id : null;
            });
            if (expanded) {
              WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToTarget());
            }
          },
          onUpdateShower: (ShowersCompanion changes) async {
            appLogger.i('$_logTag saving shower changes : $changes');
            await appDomain.updateShower(changes);
            await appDomain.updateShowerheadRefDuration(sh.id);
            appLogger.i('$_logTag shower saved');
          },
        ),
      );
      cards.add(const SizedBox(height: 10));
    }

    if (showerheadsCount > 1 && totalShowers.isNotEmpty) {
      cards.insert(0, const SizedBox(height: 25));
      cards.insert(
        0,
        StatsShowerheadCard(
          expandable: false,
          expanded: false,
          borderColor: AppTheme.sectionSpecialBackground,
          highlighted: shId == null || !selectedHasShowers,
          title: t.statisticsScreenGlobalCardTitle,
          showers: totalShowers,
          savingsStats: totalSavings,
          waterUnit: waterUnit,
          tempUnit: tempUnit,
          currency: currency,
          savingsParams: savingsParams,
          showerFilter: globalFilters,
          onSwitchExpanded: (_) {},
          onUpdateShower: (_) {},
        ),
      );
    }

    return Column(
      children: [
        _buildGlobalFilterSelect(maxShowersBySh, t),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 10),
          child: SizedBox(
            width: double.infinity,
            height: availableScrollHeight,
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Column(children: cards),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlobalFilterSelect(int maxShowersBySh, AppLocalizations t) {
    if (maxShowersBySh == 0) return const SizedBox.shrink();

    final Map<String, String> choices = {
      'all': t.statisticsScreenFilterAll,
      for (final n in _filterThresholds)
        if (maxShowersBySh > n) 'last$n': t.statisticsScreenFilterOnLastShowers(n),
    };

    final effectiveFilter = choices.containsKey(globalFilter) ? globalFilter : 'all';
    if (effectiveFilter != globalFilter) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            globalFilter = 'all';
            globalFilters = globalFilters.copyWith()..setLastShowersCount(null);
          });
        }
      });
    }

    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.lighten(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: effectiveFilter,
          isExpanded: false,
          iconEnabledColor: Colors.white,
          alignment: AlignmentDirectional.center,
          selectedItemBuilder: (_) => choices.entries.map((entry) {
            return Center(
              child: SizedBox(
                width: 250,
                child: Text(
                  entry.value,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
          items: choices.entries
              .map(
                (entry) => DropdownMenuItem(
                  value: entry.key,
                  alignment: AlignmentDirectional.center,
                  child: Text(entry.value, style: TextStyle(color: AppTheme.textColor)),
                ),
              )
              .toList(),
          onChanged: (String? newFilter) {
            if (newFilter == null) return;
            appLogger.d('$_logTag global filter changed : $newFilter');
            final int? lastCount = int.tryParse(newFilter.replaceFirst('last', ''));
            setState(() {
              globalFilter = newFilter;
              globalFilters = globalFilters.copyWith()..setLastShowersCount(lastCount);
            });
          },
        ),
      ),
    );
  }
}
