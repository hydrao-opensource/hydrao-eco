import 'dart:async';

import 'package:collection/collection.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hydrao_flutter_offline/constants.dart';
import 'package:hydrao_flutter_offline/conversions.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/models/savings_stats.dart';
import 'package:hydrao_flutter_offline/models/shower_data.dart';
import 'package:hydrao_flutter_offline/models/shower_filters.dart';
import 'package:hydrao_flutter_offline/models/shower_stats.dart';
import 'package:hydrao_flutter_offline/models/threshold.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';
import 'package:hydrao_flutter_offline/theme.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/edit_shower_filters_dialog.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/savings_details_dialog.dart';
import 'package:hydrao_flutter_offline/ui/widgets/click_tooltip.dart';
import 'package:hydrao_flutter_offline/ui/widgets/custom_expansion_tile.dart';
import 'package:hydrao_flutter_offline/ui/widgets/dashed_divider.dart';
import 'package:hydrao_flutter_offline/ui/widgets/filter_pill_button.dart';
import 'package:hydrao_flutter_offline/ui/widgets/icon_toggle_row.dart';
import 'package:hydrao_flutter_offline/ui/widgets/metric_display.dart';
import 'package:hydrao_flutter_offline/ui/widgets/shower_volume_barchart.dart';
import 'package:hydrao_flutter_offline/ui/widgets/threshold_horizontal.dart';
import 'package:hydrao_flutter_offline/utils.dart';

const _logTag = "[STATS_SHOWERHEAD_CARD] ";

class StatsShowerheadCard extends StatefulWidget {
  final String title;
  final bool expanded;
  final bool expandable;
  final bool highlighted;
  final void Function(bool expanded) onSwitchExpanded;
  final Showerhead? sh;
  final SavingsStats? savingsStats; // for case without sh (global stats)
  final List<Shower> showers; // callback to retreive type selected
  final String waterUnit;
  final String tempUnit;
  final String currency;
  final SavingsParams savingsParams;
  final Function onUpdateShower;
  final ShowerFilters? showerFilter;
  final Color? borderColor;

  const StatsShowerheadCard({
    super.key,
    required this.title,
    required this.showers,
    required this.waterUnit,
    required this.tempUnit,
    required this.currency,
    required this.savingsParams,
    required this.onSwitchExpanded,
    required this.onUpdateShower,
    this.expanded = false,
    this.expandable = true,
    this.highlighted = true,
    this.sh,
    this.savingsStats,
    this.showerFilter,
    this.borderColor,
  });

  @override
  State<StatsShowerheadCard> createState() => _StatsShowerheadCardState();
}

class _StatsShowerheadCardState extends State<StatsShowerheadCard> {
  // late final AnimationController _controller;
  ShowerData? selected;
  ShowerData? selectedNext;
  ShowerData? selectedPrev;
  List<Shower>? _currentShowers;
  List<ShowerData> _currentShowersData = [];
  late ShowerFilters _currentFilters;
  final GlobalKey _cardKey = GlobalKey();

  Timer? _showersThrottleTimer;
  static const _throttleDuration = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();

    _currentFilters = ShowerFilters(actives: []);
    updateShowers(List<Shower>.from(widget.showers));
  }

  @override
  void didUpdateWidget(covariant StatsShowerheadCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    final eq = const ListEquality<Shower>();

    if (widget.showerFilter != oldWidget.showerFilter) {
      appLogger.t('$_logTag input shower filters changed');
      appLogger.t('old Filters = ${oldWidget.showerFilter}');
      appLogger.t('new Filters = ${widget.showerFilter}');
      updateShowers(getFilteredShowers());
    } else if (widget.sh != oldWidget.sh) {
      appLogger.t('$_logTag input SH changed');
      updateShowers(getFilteredShowers());
    } else if (!eq.equals(widget.showers, oldWidget.showers)) {
      appLogger.t('$_logTag input showers changed');
      _scheduleThrottledShowersUpdate();
    }
  }

  @override
  void dispose() {
    // _controller.dispose();
    _showersThrottleTimer?.cancel();

    super.dispose();
  }

  // void _toggleExpanded() {
  //   if (widget.expandable == false) return;
  //   setState(() {
  //     _isExpanded = !_isExpanded;
  //     if (_isExpanded) {
  //       _controller.forward();
  //     } else {
  //       _controller.reverse();
  //     }
  //   });
  // }

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
      // appLogger.d('$LOG_TAG update showers to show : $newShowers');
      _currentShowers = newShowers;
      _currentShowersData = prepareShowersData(newShowers);

      if (selected != null) {
        // refresh selected
        selected = _currentShowersData.firstWhereOrNull(
          (showerData) => showerData.entity.id == selected!.entity.id,
        );
        updateNavFromSelected();
      }
    });
  }

  List<ShowerData> prepareShowersData(List<Shower> newShowers) {
    List<ShowerData> showersData = [];
    for (var shower in newShowers) {
      showersData.add(ShowerData(shower));
    }
    // add live shower
    if (widget.sh != null &&
        widget.sh!.uuid != null &&
        widget.sh!.liveVolume != null &&
        widget.sh!.liveVolume! > 0 &&
        widget.sh!.liveDate != null &&
        _currentFilters.count() == 0) {
      Shower liveShower = Shower(
        id: 100000, // need a high value
        deviceId: widget.sh!.uuid!,
        isEmpty: false,
        isReference: false,
        isIgnored: false,
        volume: widget.sh!.liveVolume!,
        date: widget.sh!.liveDate!,
        flow: widget.sh!.liveFlow,
        temperature: widget.sh!.liveTemperature,
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
      sh: widget.sh!,
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

  void updateNavFromSelected() {
    final index = _currentShowersData.indexWhere(
      (s) => s.entity.id == selected?.entity.id,
    );
    if (index == -1) {
      selectedNext = null;
      selectedPrev = null;
    } else {
      selectedNext = index < _currentShowersData.length - 1
          ? _currentShowersData[index + 1]
          : null;
      selectedPrev = index > 0 ? _currentShowersData[index - 1] : null;
    }
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
        updateNavFromSelected();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    appLogger.t('$_logTag build');

    if (_currentShowers == null) {
      _currentShowers = widget.showers;
      _currentShowersData = prepareShowersData(_currentShowers!);
    }

    bool hasFilteredShowers = _currentShowers?.isNotEmpty ?? false;
    Widget? statsSection;
    if (hasFilteredShowers) {
      if (widget.expanded == false) {
        statsSection = buildShowersSection();
      } else if (selected == null) {
        statsSection = buildShowersSection();
      } else if (selected!.isLive) {
        statsSection = buildLiveShowerSection();
      } else {
        statsSection = buildSelectedShowerSection();
      }
    } else {
      statsSection = buildNoShowerSection();
    }

    return Opacity(
      opacity: widget.highlighted ? 1 : 0.5,
      child: CustomExpansionTile(
        title: widget.title,
        expandable: false,
        expanded: true,
        backgroundColor: Colors.white,
        borderColor: widget.borderColor,
        globalPadding: 0,
        headerPadding: EdgeInsetsGeometry.only(
          left: 15,
          right: 15,
          top: widget.expandable && widget.showers.isNotEmpty ? 6 : 16,
          bottom: !widget.expandable ? 10 : 0,
        ),
        contentPadding: EdgeInsets.all(0),
        trailingButton: widget.expandable && widget.showers.isNotEmpty
            ? TextButton(
                onPressed: () => widget.onSwitchExpanded(!widget.expanded),
                child: Row(
                  children: [
                    FaIcon(
                      widget.expanded
                          ? FontAwesomeIcons.solidEyeSlash
                          : FontAwesomeIcons.solidEye,
                    ),
                    SizedBox(width: 6),
                    Text(
                      (widget.expanded
                              ? t.statsShowerheadCardHideShowers
                              : t.statsShowerheadCardShowShowers)
                          .toUpperCase(),
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              )
            : null,
        children: [
          if (widget.expanded) buildGraphSection(),
          if (widget.expanded)
            Padding(
              padding: EdgeInsets.only(top: 5, bottom: 8),
              child: DashedDivider(),
            ),
          statsSection,
        ],
      ),
    );
  }

  Widget buildGraphSection() {
    final t = AppLocalizations.of(context)!;

    // bool hasShowers = widget.showers.isNotEmpty;
    bool hasFilteredShowers = _currentShowers?.isNotEmpty ?? false;

    Widget? syncDatesView = _buildSyncDatesView();

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
          // if (hasShowers)
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
                      key: _cardKey,
                      showers: _currentShowersData,
                      showIds: false,
                      selectedShowerId: selected?.entity.id,
                      unit: widget.waterUnit,
                      onBarSelected: (shower) {
                        if (shower != null) {
                          updateSelected(shower as ShowerData?);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          if (hasFilteredShowers && syncDatesView != null) SizedBox(height: 10),
          if (hasFilteredShowers && syncDatesView != null) syncDatesView,
        ],
      ),
    );
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

    SavingsStats savingsStats =
        widget.savingsStats ??
        SavingsStats.from(widget.sh!, _currentShowers!, widget.savingsParams);

    Widget avgVolumeView = Row(
      children: [
        Text(
          t.statsShowerheadCardAverageVol,
          style: TextStyle(
            fontSize: 12,
            height: 1,
            color: AppTheme.textColor.withValues(alpha: 0.7),
          ),
        ),
        SizedBox(width: 5),
        _buildVolume(showerStats.averageVolume),
      ],
    );

    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
      child: Column(
        children: [
          // title + avg vol + badge
          Row(
            children: [
              Text(
                t.shStatisticsCountShowers(_currentShowers!.length),
                style: TextStyle(
                  color: AppTheme.textColor.withValues(alpha: 0.7),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Spacer(),
              avgVolumeView,
              SizedBox(width: 8),
              _buildBadge(showerStats.averageVolume ?? 0),
            ],
          ),
          SizedBox(height: 8),
          _buildSavings(savingsStats),
        ],
      ),
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

    Widget thresholdView = selected!.entity.threshold != null
        ? Row(
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
          )
        : SizedBox.shrink();

    List<HydraoThreshold>? showerThresholds = thresholdsFromJson(
      selected!.entity.threshold,
    );
    List<HydraoThreshold>? learningThresholds = thresholdsFromJson(
      AppConstants.shLearningThresholds,
    );
    if (!thresholdsHasChanged(showerThresholds, learningThresholds!)) {
      thresholdView = Text(
        t.shStatisticsShowerLearningThresholds,
        style: TextStyle(color: AppTheme.textColor),
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 10, left: 15, right: 15),
      child: Column(
        children: [
          // title + nav + ignore
          Row(
            children: [
              Text(
                t.shStatisticsShowerSelected,
                style: TextStyle(
                  color: AppTheme.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              showerOptions,
            ],
          ),

          // selected stats
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: stats,
          ),

          // thresholds
          if (selected!.entity.threshold != null) SizedBox(height: 8),
          if (selected!.entity.threshold != null) thresholdView,
        ],
      ),
    );
  }

  Widget buildLiveShowerSection() {
    final t = AppLocalizations.of(context)!;

    Widget showerOptions = Row(
      children: [
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

    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          // title + nav + ignore
          Row(
            children: [
              Text(
                t.shStatisticsLiveShowerSelected,
                style: TextStyle(
                  color: AppTheme.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              showerOptions,
            ],
          ),

          // selected stats
          SizedBox(height: 8),
          Text(
            t.shStatisticsLiveShowerMessage,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppTheme.textColor),
          ),
        ],
      ),
    );
  }

  Widget buildNoShowerSection() {
    final t = AppLocalizations.of(context)!;

    String title;
    String message;
    if (widget.showers.isEmpty) {
      // case no shower
      title = t.showerVolumeBarchartNoShowerTitle;
      message = t.showerVolumeBarchartNoShowerMessage;
    } else {
      // case no filtered shower => change filters
      title = t.shStatisticsNoFilteredShower;
      message = t.shStatisticsNoFilteredShowerMessage;
    }

    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // title
          Text(
            title,
            style: TextStyle(
              color: AppTheme.textColor,
              fontWeight: FontWeight.bold,
            ),
          ),

          // selected stats
          SizedBox(height: 8),
          Text(
            message, // "Commencez à utiliser votre pommeau et vous retrouverez votre suivi de consommation ici"
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textColor.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavings(SavingsStats stats) {
    double oldShBarWidth = 120;
    final t = AppLocalizations.of(context)!;

    // appLogger.t(
    //   '$LOG_TAG savingsPourcent=${stats.savingPourcent}, oldVolume=${stats.oldTotalVolume}, savedVolume=${stats.savedWaterVolume}',
    // );

    double savingBarWidth = (stats.savingPourcent > 0)
        ? oldShBarWidth * stats.savingPourcent
        : 0;

    Color oldColor = AppTheme.textColor.withValues(alpha: 0.3);
    double leftWidth = 100;

    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              // savings
              Row(
                children: [
                  // savings text + help icon
                  SizedBox(
                    width: leftWidth,
                    child: Row(
                      children: [
                        Text(
                          t.statsShowerheadCardSavings,
                          style: TextStyle(color: AppTheme.textColor),
                        ),
                        SizedBox(width: 5),
                        _buildClickableIcon(
                          Icon(
                            Icons.help_outline,
                            color: AppTheme.textColor.withValues(alpha: 0.5),
                            size: 18,
                          ),
                          () {
                            appLogger.d(
                              '$_logTag savings details dialog clicked',
                            );
                            showSavingsDetailsDialog(
                              context: context,
                              stats: stats,
                              details: widget.title,
                              waterUnit: widget.waterUnit,
                              currency: widget.currency,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  // savings bar + volume
                  _buildBar(
                    savingBarWidth,
                    15,
                    Colors.green.withValues(alpha: 0.2),
                  ),
                ],
              ),

              // previous consumption
              Row(
                children: [
                  SizedBox(
                    width: leftWidth,
                    child: Row(
                      children: [
                        // text + total volume
                        Text(
                          t.statsShowerheadCardOnNVolume,
                          style: TextStyle(color: oldColor),
                        ),
                        SizedBox(width: 4),
                        // total bar
                        _buildVolume(stats.oldTotalVolume, color: oldColor),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  _buildBar(
                    oldShBarWidth,
                    5,
                    Colors.grey.withValues(alpha: 0.3),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 10),
        _buildMoney(stats.savedTotalMoney),
      ],
    );
  }

  Widget _buildBar(double width, double height, Color bgColor) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      width: width,
      height: height,
    );
  }

  Widget _buildClickableIcon(Icon icon, void Function() onClick) {
    return InkWell(onTap: onClick, child: icon);
  }

  Widget _buildVolume(double? volume, {double fontSize = 16, Color? color}) {
    Color frontColor = color ?? AppTheme.textColor;

    double fixedVolume = volume ?? 0;
    String fixedWaterUnit = widget.waterUnit;
    if (fixedVolume > 1000 && fixedWaterUnit == AppConstants.symbolLiter) {
      fixedVolume = fixedVolume / 1000;
      fixedWaterUnit = AppConstants.symbolCubicMeter;
    }

    return Row(
      // Aligne les enfants sur leur ligne de base de texte
      crossAxisAlignment: CrossAxisAlignment.baseline,
      // Indique quel type de baseline utiliser (alphabetic est le standard)
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          formatVolume(getVolumeForUnit(fixedVolume, fixedWaterUnit)),
          style: TextStyle(
            fontSize: fontSize,
            // fontWeight: FontWeight.bold,
            color: frontColor,
            height: 1,
          ),
        ),
        SizedBox(width: 3),
        Text(
          fixedWaterUnit,
          style: TextStyle(
            fontSize: fontSize - (fontSize / 3),
            color: frontColor.withValues(alpha: 0.5),
            height: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildMoney(double money) {
    return Row(
      // Aligne les enfants sur leur ligne de base de texte
      crossAxisAlignment: CrossAxisAlignment.baseline,
      // Indique quel type de baseline utiliser (alphabetic est le standard)
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          formatMoney(getCurrencyFromSymbol(money, widget.currency)),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
        ),
        SizedBox(width: 4),
        Text(
          widget.currency,
          style: TextStyle(fontSize: 14, color: Colors.black54, height: 1),
        ),
      ],
    );
  }

  Widget _buildBadge(double avgVolume) {
    final t = AppLocalizations.of(context)!;

    if (avgVolume <= 0) return SizedBox.shrink();

    String text;
    Color color;
    if (avgVolume < 20) {
      // gold
      text = t.statsShowerheadCardGoldBadge;
      color = Color(0xFFFFD700).withValues(alpha: 0.4);
    } else if (avgVolume <= 35) {
      // silver
      text = t.statsShowerheadCardSilverBadge;
      color = Color(0xFFC0C0C0).withValues(alpha: 0.4);
    } else {
      // bronze
      text = t.statsShowerheadCardBronzeBadge;
      color = Color(0xFFCD7F32).withValues(alpha: 0.4);
    }
    Color textColor = getTextColorForBackground(background: color);
    String badgeTooltip = (widget.waterUnit == AppConstants.symbolGallon)
        ? t.statsShowerheadCardBadgeTootipGallon
        : t.statsShowerheadCardBadgeTootipLiter;

    return ClickTooltip(
      message: badgeTooltip,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        width: 80,
        child: Text(
          text,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget? _buildSyncDatesView() {
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
      if (widget.sh!.isLastSyncComplete == false) {
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
              color: widget.sh!.isLastSyncComplete == true
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
            widget.sh!.isLastSyncComplete == true
                ? t.shStatisticsShowersSyncedInPeriod
                : t.shStatisticsShowersSyncedPartially,
            style: TextStyle(
              fontSize: 13,
              color: widget.sh!.isLastSyncComplete == true
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
    // if (selected!.entity.soapingTime != null) {
    //   final double duration = (selected!.entity.soapingTime! > 60)
    //       ? selected!.entity.soapingTime! / 60
    //       : selected!.entity.soapingTime!.toDouble();
    //   final durationUnit = (selected!.entity.soapingTime! > 60)
    //       ? getDurationUnit(context, "min")
    //       : getDurationUnit(context, "sec");
    //   stats.add(
    //     MetricDisplay(
    //       height: metricHeight,
    //       minWidth: metricWidth,
    //       value: duration > 0 ? formatDuration(duration) : "-",
    //       unit: duration > 0 ? durationUnit : "",
    //       label: t.shStatisticsShowerSoapingMetric,
    //       backgroundColor: metricsBgColor,
    //     ),
    //   );
    // }

    return stats;
  }
}
