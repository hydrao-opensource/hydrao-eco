import 'dart:async';

import 'package:collection/collection.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/conversions.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/models/savings_stats.dart';
import 'package:hydrao_flutter_offline/models/shower_data.dart';
import 'package:hydrao_flutter_offline/models/shower_filters.dart';
import 'package:hydrao_flutter_offline/models/shower_stats.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';
import 'package:hydrao_flutter_offline/theme.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/edit_shower_filters_dialog.dart';
import 'package:hydrao_flutter_offline/ui/widgets/custom_expansion_tile.dart';
import 'package:hydrao_flutter_offline/ui/widgets/filter_pill_button.dart';
import 'package:hydrao_flutter_offline/ui/widgets/icon_toggle_row.dart';
import 'package:hydrao_flutter_offline/ui/widgets/metric_display.dart';
import 'package:hydrao_flutter_offline/ui/widgets/savings_stats_widget.dart';
import 'package:hydrao_flutter_offline/ui/widgets/shower_volume_barchart.dart';
import 'package:hydrao_flutter_offline/ui/widgets/threshold_horizontal.dart';
import 'package:hydrao_flutter_offline/utils.dart';

const _logTag = "[SH_STATISTICS_FRAGMENT] ";

class ShStatisticsFragment extends StatefulWidget {
  final Showerhead sh;
  final List<Shower> showers; // callback to retreive type selected
  final String waterUnit;
  final String tempUnit;
  final String currency;
  final SavingsParams savingsParams;
  // final Function onResetReference;
  final Function onUpdateShower;
  final ShowerFilters? showerFilter;

  const ShStatisticsFragment({
    super.key,
    required this.sh,
    required this.showers,
    required this.waterUnit,
    required this.tempUnit,
    required this.currency,
    required this.savingsParams,
    // required this.onResetReference,
    required this.onUpdateShower,
    this.showerFilter,
  });

  @override
  State<ShStatisticsFragment> createState() => _ShStatisticsFragmentState();
}

class _ShStatisticsFragmentState extends State<ShStatisticsFragment> {
  ShowerData? selected;
  ShowerData? selectedNext;
  ShowerData? selectedPrev;
  List<Shower>? _currentShowers;
  List<ShowerData>? _currentShowersData;
  late ShowerFilters _currentFilters;

  Timer? _showersThrottleTimer;
  static const _throttleDuration = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();

    _currentFilters = widget.showerFilter ?? ShowerFilters(actives: []);
    updateShowers(List<Shower>.from(widget.showers));
  }

  @override
  void dispose() {
    _showersThrottleTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ShStatisticsFragment oldWidget) {
    super.didUpdateWidget(oldWidget);

    final eq = const ListEquality<Shower>();

    // la liste a réellement changé (ajout/suppression/modif)
    if (!eq.equals(widget.showers, oldWidget.showers)) {
      _scheduleThrottledShowersUpdate();
    }
  }

  List<Shower> getFilteredShowers() {
    List<Shower> filteredShowers = List<Shower>.from(widget.showers);

    return _currentFilters.filter(filteredShowers);
  }

  void _scheduleThrottledShowersUpdate() {
    // Si un timer est déjà en cours, on ne fait rien :
    // les changements seront pris en compte à la prochaine mise à jour.
    if (_showersThrottleTimer != null) return;

    _showersThrottleTimer = Timer(_throttleDuration, () {
      _showersThrottleTimer = null;

      // On prend la liste la plus récente au moment où le timer se déclenche

      updateShowers(getFilteredShowers());
    });
  }

  void doResetRefShowers() {
    // update localy
    final updatedShowers = _currentShowers!.map((s) {
      if (s.isReference == true) {
        return s.copyWith(isReference: false);
      }
      return s;
    }).toList();
    updateShowers(updatedShowers);

    // update db
    // widget.onResetReference();
  }

  void doUpdateShower(Shower shower, {bool? isReference, bool? isIgnored}) {
    bool fixedIsReference = isReference ?? shower.isReference;
    if (isIgnored == true) fixedIsReference = false;

    bool fixedIsIgnored = isIgnored ?? shower.isIgnored;
    if (fixedIsReference == true) fixedIsIgnored = false;

    // update localy
    final updatedShowers = _currentShowers!.map((s) {
      if (s.id == shower.id) {
        return s.copyWith(
          isReference: fixedIsReference,
          isIgnored: fixedIsIgnored,
        );
      }
      return s;
    }).toList();
    updateShowers(updatedShowers);

    // update db
    widget.onUpdateShower(
      shower
          .toCompanion(false)
          .copyWith(
            isReference: drift.Value(fixedIsReference),
            isIgnored: drift.Value(fixedIsIgnored),
          ),
    );
  }

  void updateShowers(List<Shower> newShowers) {
    setState(() {
      appLogger.d('$_logTag update showers to show : $newShowers');
      _currentShowers = newShowers;
      _currentShowersData = prepareShowersData(newShowers);

      if (selected != null) {
        // refresh selected
        selected = _currentShowersData?.firstWhereOrNull(
          (showerData) => showerData.entity.id == selected!.entity.id,
        );
        //TODO refresh selectedNext
        //TODO refresh selectedPrev
      }
    });
  }

  List<ShowerData> prepareShowersData(List<Shower> newShowers) {
    List<ShowerData> showersData = [];
    for (var shower in newShowers) {
      showersData.add(ShowerData(shower));
    }
    // add live shower
    if (widget.sh.liveVolume != null &&
        widget.sh.liveVolume! > 0 &&
        widget.sh.liveDate != null &&
        _currentFilters.count() == 0) {
      Shower liveShower = Shower(
        id: 100000, // need a high value
        deviceId: widget.sh.uuid!,
        isEmpty: false,
        isReference: false,
        isIgnored: false,
        volume: widget.sh.liveVolume!,
        date: widget.sh.liveDate!,
        flow: widget.sh.liveFlow,
        temperature: widget.sh.liveTemperature,
      );
      ShowerData liveShowerData = ShowerData(liveShower);
      liveShowerData.isLive = true;
      showersData.add(liveShowerData);
    }

    return showersData;
  }

  Future<void> showShowerFiltersDialog() async {
    appLogger.i('$_logTag show showers filters dialog');

    await showEditShowerFiltersDialog(
      context: context,
      sh: widget.sh,
      filters: _currentFilters,
      onSave: (filters) {
        setState(() {
          _currentFilters = filters;
          selected = null;
          selectedNext = null;
          selectedPrev = null;
          updateShowers(getFilteredShowers());
        });
      },
      waterUnit: widget.waterUnit,
    );
  }

  void updateSelected(ShowerData? newSelected) {
    if (newSelected == null) {
      setState(() {
        selected = null;
        selectedNext = null;
        selectedPrev = null;
      });
    } else {
      setState(() {
        selected = newSelected;
        final index = _currentShowersData?.indexWhere(
          (s) => s.entity.id == selected?.entity.id,
        );
        if (index == -1) {
          selectedNext = null;
          selectedPrev = null;
        } else {
          selectedNext = index! < _currentShowersData!.length - 1
              ? _currentShowersData![index + 1]
              : null;
          selectedPrev = index > 0 ? _currentShowersData![index - 1] : null;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final t = AppLocalizations.of(context)!;

    appLogger.d('$_logTag build / shLiveVolume=${widget.sh.liveVolume}');

    if (_currentShowers == null) {
      _currentShowers = widget.showers;
      _currentShowersData = prepareShowersData(_currentShowers!);
    }

    bool hasFilteredShowers = _currentShowers?.isNotEmpty ?? false;
    Widget? statsSection;
    if (hasFilteredShowers) {
      if (selected == null) {
        statsSection = buildShowersSection();
      } else if (selected!.isLive) {
        statsSection = buildLiveShowerSection();
      } else {
        statsSection = buildSelectedShowerSection();
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (hasFilteredShowers) buildAdvicePanel(),
        if (hasFilteredShowers) SizedBox(height: 10),
        buildGraphSection(),
        if (statsSection != null) SizedBox(height: 10),
        ?statsSection,
      ],
    );
  }

  Widget buildGraphSection() {
    final t = AppLocalizations.of(context)!;

    bool hasShowers = widget.showers.isNotEmpty;
    bool hasFilteredShowers = _currentShowers?.isNotEmpty ?? false;

    Widget? syncDatesView = buildSyncDatesView();

    Widget unselectButton = TextButton(
      onPressed: () {
        appLogger.d('$_logTag reset selection here');
        updateSelected(null);
      },
      style: TextButton.styleFrom(
        visualDensity: VisualDensity.compact,
        backgroundColor: Colors.transparent, // <-- pas de fond
        foregroundColor: Colors.black, // couleur du texte
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
      ),
      child: Row(
        children: [
          const Icon(Icons.cancel, size: 16),
          const SizedBox(width: 5),
          Text(t.shStatisticsCancelSelection, style: TextStyle(fontSize: 13)),
        ],
      ),
    );

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          if (hasShowers)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 140,
                  child: FilterPillButton(
                    filters: _currentFilters,
                    height: 30,
                    onTap: () {
                      showShowerFiltersDialog();
                    },
                  ),
                ),
                if (selected != null) unselectButton,
              ],
            ),
          if (hasFilteredShowers)
            Builder(
              builder: (context) {
                final screenH = MediaQuery.of(context).size.height;

                // appLogger.d('$LOG_TAG screenH=$screenH');

                double reservedSpace = 500;
                double freeSpace = screenH - reservedSpace;

                double maxChartH = freeSpace.clamp(140.0, 400.0);
                if (selected != null) maxChartH = maxChartH - 20;

                return ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 120,
                    maxHeight: maxChartH,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ShowerVolumeBarChart(
                      showers: _currentShowersData ?? [],
                      showIds: false,
                      selectedShowerId: selected?.entity.id,
                      unit: widget.waterUnit,
                      onBarSelected: (shower) {
                        if (shower != null) {
                          updateSelected(shower);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          if (hasFilteredShowers && syncDatesView != null) SizedBox(height: 10),
          if (hasFilteredShowers && syncDatesView != null) syncDatesView,
          if (hasFilteredShowers == false) buildNoShowerView(),
        ],
      ),
    );
  }

  Widget buildAdvicePanel() {
    final t = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: BoxDecoration(
        // color: Colors.grey.shade300,
        color: Colors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.info,
            size: 20,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              t.shStatisticsSelectShowerAdvice,
              style: TextStyle(fontSize: 12, color: AppTheme.textColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget? buildSyncDatesView() {
    final t = AppLocalizations.of(context)!;

    Widget? view;

    String? syncDateBegin;
    String? syncDateEnd;

    if (selected == null) {
      // CASE many showers => compute first / last sync date
      ShowerStats showerStats = ShowerStats.fromShowers(_currentShowers!);
      if (showerStats.minDate != null) {
        syncDateBegin = formatShortDate(context, showerStats.minDate!);
        if (!isSameDay(showerStats.minDate!, showerStats.maxDate!)) {
          syncDateEnd = formatShortDate(context, showerStats.maxDate!);
        }
      }
    } else {
      // CASE selected shower => sync date
      syncDateBegin = formatShortDate(context, selected!.entity.date);
    }

    if (syncDateBegin != null && syncDateEnd == null) {
      String syncBeginLabel = t.shStatisticsShowerSyncedAt;
      if (widget.sh.isLastSyncComplete == false) {
        syncBeginLabel = t.shStatisticsShowersSyncedPartially;
      } else if (_currentShowers!.length > 1 && selected == null) {
        syncBeginLabel = t.shStatisticsShowersSyncedAt;
      }
      view = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            syncBeginLabel,
            style: TextStyle(
              fontSize: 12,
              color: widget.sh.isLastSyncComplete == true
                  ? AppTheme.textColor.withValues(alpha: 0.6)
                  : AppTheme.textWarningColor.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(width: 4),
          Text(
            syncDateBegin,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor.withValues(alpha: 0.5),
            ),
          ),
        ],
      );
    } else if (syncDateBegin != null && syncDateEnd != null) {
      view = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.sh.isLastSyncComplete == true
                ? t.shStatisticsShowersSyncedInPeriod
                : t.shStatisticsShowersSyncedPartially,
            style: TextStyle(
              fontSize: 13,
              color: widget.sh.isLastSyncComplete == true
                  ? AppTheme.textColor.withValues(alpha: 0.6)
                  : AppTheme.textWarningColor.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                syncDateBegin,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor.withValues(alpha: 0.5),
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.arrow_right, size: 14),
              SizedBox(width: 4),
              Text(
                syncDateEnd,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return view;
  }

  Widget buildNoShowerView() {
    String title;
    String message;

    final t = AppLocalizations.of(context)!;

    if (_currentFilters.count() == 0) {
      title = t.showerVolumeBarchartNoShowerTitle;
      message = t.showerVolumeBarchartNoShowerMessage;
    } else {
      title = t.shStatisticsNoFilteredShower;
      message = t.shStatisticsNoFilteredShowerMessage;
    }

    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, textAlign: TextAlign.center),
          SizedBox(height: 30),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black45),
          ),
        ],
      ),
    );
  }

  Widget buildShowersSection() {
    final t = AppLocalizations.of(context)!;

    ShowerStats showerStats = ShowerStats.fromShowers(_currentShowers!);
    SavingsStats savingsStats = SavingsStats.from(
      widget.sh,
      _currentShowers!,
      widget.savingsParams,
    );

    Widget averageVolView = Row(
      children: [
        Text(
          t.shStatisticsShowersAvgVolume,
          style: TextStyle(
            fontSize: 12,
            height: 1,
            color: AppTheme.textColor.withValues(alpha: 0.7),
          ),
        ),
        SizedBox(width: 5),
        Text(
          formatVolume(
            getVolumeForUnit(showerStats.averageVolume ?? 0, widget.waterUnit),
          ),
          style: TextStyle(
            fontSize: 16,
            // fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
            height: 1,
          ),
        ),
        SizedBox(width: 3),
        Text(
          widget.waterUnit,
          style: TextStyle(fontSize: 9, color: Colors.black54, height: 1),
        ),
      ],
    );

    Widget savingsSummary = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          t.shStatisticsShowerheadSavings,
          style: TextStyle(
            color: AppTheme.textColor.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
            height: 1,
          ),
        ),
        SizedBox(width: 10),
        Text(
          formatMoney(
            getCurrencyFromSymbol(
              savingsStats.savedTotalMoney,
              widget.currency,
            ),
          ),
          style: TextStyle(
            color: AppTheme.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 17,
            height: 1,
          ),
        ),
        SizedBox(width: 4),
        Text(
          widget.currency,
          style: TextStyle(
            color: AppTheme.textColor,
            fontWeight: FontWeight.w300,
            height: 1,
          ),
        ),
      ],
    );

    return CustomExpansionTile(
      title: t.shStatisticsCountShowers(_currentShowers!.length),
      expanded: true,
      expandable: false,
      // verticalPadding: selected == null ? 10.0 : 5.0,
      globalPadding: 10,
      headerPadding: EdgeInsets.only(top: 5, bottom: 2.5),
      trailingButton: averageVolView,
      children: [
        SizedBox(height: 8),
        Column(
          children: [
            SavingsStatsWidget(
              stats: savingsStats,
              currency: widget.currency,
              waterUnit: widget.waterUnit,
            ),
            SizedBox(height: 12),
            savingsSummary,
          ],
        ),
      ],
    );
  }

  Widget buildSelectedShowerSection() {
    final t = AppLocalizations.of(context)!;

    Widget? showerOptions = Row(
      children: [
        IconToggleRow(
          label: t.shStatisticsShowerIgnored,
          value: selected!.entity.isIgnored,
          falseIcon: Icon(Icons.check_box_outline_blank_outlined, size: 15),
          trueIcon: Icon(Icons.check_box, size: 15),
          onChanged: (newValue) {
            // appLogger.d('$LOG_TAG shower isIgnored changed : $newValue');
            doUpdateShower(selected!.entity, isIgnored: newValue);
          },
        ),
        SizedBox(width: 8),
        // navigate to previous shower
        InkWell(
          onTap: () {
            if (selectedPrev != null) {
              // appLogger.d('$LOG_TAG navigate to previous shower : $selectedPrev');
              updateSelected(selectedPrev);
            }
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 3,
            ), // zone cliquable maîtrisée
            child: Icon(
              Icons.arrow_back,
              size: 20,
              color: selectedPrev != null
                  ? AppTheme.textColor
                  : AppTheme.textColor.withValues(alpha: 0.3),
            ),
          ),
        ),
        SizedBox(width: 8),
        // navigate to next shower
        InkWell(
          onTap: () {
            if (selectedNext != null) {
              appLogger.d('$_logTag navigate to next shower : $selectedNext');
              updateSelected(selectedNext);
            }
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 3,
            ), // zone cliquable maîtrisée
            child: Icon(
              Icons.arrow_forward,
              size: 20,
              color: selectedNext != null
                  ? AppTheme.textColor
                  : AppTheme.textColor.withValues(alpha: 0.3),
            ),
          ),
        ),
        // IconToggleRow(
        //   label: "Réf.",
        //   value: selected!.entity.isReference,
        //   falseIcon: Icon(Icons.star_border, size: 15),
        //   trueIcon: Icon(Icons.star, size: 15),
        //   onChanged: (newValue) {
        //     appLogger.d('$LOG_TAG shower isReference changed : $newValue');
        //     doUpdateShower(selected!.entity, isReference: newValue);
        //   },
        // ),
      ],
    );

    List<Widget> stats = _computeSelectedShowerStats();

    return CustomExpansionTile(
      title: t.shStatisticsShowerSelected,
      expanded: true,
      expandable: false,
      globalPadding: 10,
      headerPadding: EdgeInsets.only(top: 5, bottom: 2.5),
      trailingButton: showerOptions,
      children: [
        SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: stats),

        if (selected!.entity.threshold != null) SizedBox(height: 8),
        if (selected!.entity.threshold != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                t.shStatisticsShowerThresholds,
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(width: 10),
              SizedBox(
                width: 150,
                child: ThresholdHorizontal(
                  thresholds: thresholdsFromJson(selected!.entity.threshold!)!,
                  unit: widget.waterUnit,
                  height: 20,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget buildLiveShowerSection() {
    final t = AppLocalizations.of(context)!;

    Widget volumeView = Row(
      children: [
        Text(
          t.shStatisticsLiveShowerVol,
          style: TextStyle(fontSize: 12, height: 1),
        ),
        SizedBox(width: 5),
        Text(
          formatVolume(
            getVolumeForUnit(
              selected!.entity.volume.toDouble(),
              widget.waterUnit,
            ),
          ),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
        ),
        SizedBox(width: 3),
        Text(
          widget.waterUnit,
          style: TextStyle(fontSize: 9, color: Colors.black54, height: 1),
        ),
      ],
    );

    return CustomExpansionTile(
      title: t.shStatisticsLiveShowerSelected,
      expanded: true,
      expandable: false,
      globalPadding: 10,
      headerPadding: EdgeInsets.only(top: 5, bottom: 2.5),
      trailingButton: volumeView,
      children: [
        SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            t.shStatisticsLiveShowerMessage,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppTheme.textColor),
          ),
        ),
      ],
    );
  }

  List<Widget> _computeSelectedShowerStats() {
    final t = AppLocalizations.of(context)!;

    List<Widget> stats = [];

    if (selected == null && selected!.isLive == true) return stats;

    double metricHeight = 50;
    double metricWidth = 65;
    Color metricsBgColor = Theme.of(context).colorScheme.primary.lighten(0.6);

    // volume
    stats.add(
      MetricDisplay(
        height: metricHeight,
        minWidth: metricWidth,
        value: formatVolume(
          getVolumeForUnit(
            selected!.entity.volume.toDouble(),
            widget.waterUnit,
          ),
        ),
        unit: widget.waterUnit,
        label: t.shStatisticsShowerVolumeMetric,
        backgroundColor: metricsBgColor,
      ),
    );
    // temperature
    if (selected!.entity.temperature != null &&
        selected!.entity.temperature! > 0) {
      stats.add(
        MetricDisplay(
          height: metricHeight,
          minWidth: metricWidth,
          value: formatTemperature(
            getTemperatureForUnit(
              selected!.entity.temperature!,
              widget.tempUnit,
            ),
          ),
          unit: widget.tempUnit,
          label: t.shStatisticsShowerTemperatureMetric,
          backgroundColor: metricsBgColor,
        ),
      );
    }

    // duration
    if (selected!.entity.duration != null) {
      final double duration = (selected!.entity.duration! > 60)
          ? selected!.entity.duration! / 60
          : selected!.entity.duration!;
      final durationUnit = (selected!.entity.duration! > 60)
          ? getDurationUnit(context, "min")
          : getDurationUnit(context, "sec");
      stats.add(
        MetricDisplay(
          height: metricHeight,
          minWidth: metricWidth,
          value: formatDuration(duration),
          unit: durationUnit,
          label: t.shStatisticsShowerDurationMetric,
          backgroundColor: metricsBgColor,
        ),
      );
    }

    // soapingTime
    if (selected!.entity.soapingTime != null) {
      final double duration = (selected!.entity.soapingTime! > 60)
          ? selected!.entity.soapingTime! / 60
          : selected!.entity.soapingTime!.toDouble();
      final durationUnit = (selected!.entity.soapingTime! > 60)
          ? getDurationUnit(context, "min")
          : getDurationUnit(context, "sec");
      stats.add(
        MetricDisplay(
          height: metricHeight,
          minWidth: metricWidth,
          value: duration > 0 ? formatDuration(duration) : "-",
          unit: duration > 0 ? durationUnit : "",
          label: t.shStatisticsShowerSoapingMetric,
          backgroundColor: metricsBgColor,
        ),
      );
    }

    return stats;
  }
}
