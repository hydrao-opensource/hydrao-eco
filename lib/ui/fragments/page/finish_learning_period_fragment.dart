import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrao_flutter_offline/constants.dart';
import 'package:hydrao_flutter_offline/conversions.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/domains/form_domain.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/models/learning_period.dart';
import 'package:hydrao_flutter_offline/providers.dart';
import 'package:hydrao_flutter_offline/theme.dart';
import 'package:hydrao_flutter_offline/ui/widgets/custom_expansion_tile.dart';
import 'package:hydrao_flutter_offline/ui/widgets/duration_display.dart';
import 'package:hydrao_flutter_offline/ui/widgets/labeled_switch.dart';
import 'package:hydrao_flutter_offline/ui/widgets/ref_shower_card.dart';
import 'package:hydrao_flutter_offline/ui/widgets/threshold_horizontal.dart';

const _logTag = "[FINISH_LEARNING_PERIOD_FRAGMENT] ";

enum Field { threshold, showers }

class FinishLearningPeriodFragment extends ConsumerStatefulWidget {
  final LearningPeriod learningPeriod;
  final String waterUnit;

  const FinishLearningPeriodFragment({
    super.key,
    required this.learningPeriod,
    required this.waterUnit,
  });

  @override
  ConsumerState<FinishLearningPeriodFragment> createState() =>
      _FinishLearningPeriodFragmentState();
}

class _FinishLearningPeriodFragmentState
    extends ConsumerState<FinishLearningPeriodFragment> {
  LearningPeriod? currentLearningPeriod;
  late List<int> showerIds;
  late bool applyThresholds;
  late FormDomain<LearningPeriod> formDomain;
  bool learningPeriodInitialized = false;

  @override
  void initState() {
    super.initState();

    formDomain = ref.read(shLearningPeriodFormStateProvider.notifier);
  }

  void onFieldChanged(Field field, dynamic value, {int? key}) {
    // if (!mounted) return;

    appLogger.d(
      '$_logTag field "${field.toString()}" changed : $value / key : $key',
    );

    setState(() {
      switch (field) {
        case Field.showers:
          setState(() {
            if (value == true) {
              if (!showerIds.contains(key)) {
                showerIds.add(key!);
              }
            } else if (showerIds.contains(key)) {
              showerIds.remove(key);
            }
          });
          break;
        case Field.threshold:
          setState(() {
            applyThresholds = value as bool;
          });
          break;
      }

      // update state
      currentLearningPeriod = widget.learningPeriod.filter(
        showerIds,
        applyThresholds,
      );
      formDomain.setChanges(currentLearningPeriod);

      // validate values
      var errors = _checkErrors();
      formDomain.updateErrors(errors);
    });
  }

  Map<String, String> _checkErrors() {
    // final t = AppLocalizations.of(context)!;

    Map<String, String> errors = {};

    // no error in this form

    return errors;
  }

  @override
  Widget build(BuildContext context) {
    appLogger.d('$_logTag build');

    if (currentLearningPeriod == null) {
      showerIds = widget.learningPeriod.getShowerIds();
      applyThresholds = widget.learningPeriod.applyThresholds;
      currentLearningPeriod = widget.learningPeriod.filter(showerIds, true);
      learningPeriodInitialized = true;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (learningPeriodInitialized == true) {
        setState(() {
          formDomain.setChanges(currentLearningPeriod);
          formDomain.updateErrors(_checkErrors());
          learningPeriodInitialized = false;
        });
      }
    });

    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // buildInfoPanel(),
          const SizedBox(height: 12),

          buildShowersSection(),
          if (showerIds.isNotEmpty) SizedBox(height: 12),

          if (showerIds.isNotEmpty &&
              currentLearningPeriod?.getNewThresholds() != null)
            buildThresholdsSection(),

          if (showerIds.isNotEmpty &&
              currentLearningPeriod?.getNewThresholds() != null)
            SizedBox(height: 12),

          if (showerIds.isNotEmpty) buildDurationSection(),
        ],
      ),
    );
  }

  Widget buildShowersSection() {
    final t = AppLocalizations.of(context)!;

    List<Widget> contents = [];
    if (widget.learningPeriod.showers.isNotEmpty) {
      contents.add(
        Text(
          t.finishLearningPeriodChooseRefShower,
          style: TextStyle(
            color: AppTheme.textColor.withValues(alpha: 0.6),
            fontSize: 13,
          ),
        ),
      );
      contents.add(SizedBox(height: 5));
      for (var shower in widget.learningPeriod.showers) {
        contents.add(
          Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical: 6),
            child: RefShowerCard(
              waterUnit: widget.waterUnit,
              shower: shower,
              toggleValue: showerIds.contains(shower.id),
              onToggleChange: (bool value) {
                onFieldChanged(Field.showers, value, key: shower.id);
              },
            ),
          ),
        );
      }
    } else {
      contents.add(
        Text(
          t.finishLearningPeriodNoRefShower,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.textColor.withValues(alpha: 0.6),
            fontSize: 13,
          ),
        ),
      );
    }

    return CustomExpansionTile(
      expanded: true,
      expandable: false,
      globalPadding: 10,
      title: t.finishLearningPeriodRefShowerSectionTitle,
      children: contents,
    );
  }

  Widget buildThresholdsSection() {
    final t = AppLocalizations.of(context)!;

    // Widget toggleThresholds = SizedBox(
    //   width: 60,
    //   height: 25,
    //   child: LabeledSwitch(
    //     switchOnRight: false,
    //     value: applyThresholds,
    //     onChanged: (newValue) {
    //       onFieldChanged(Field.threshold, newValue);
    //     },
    //   ),
    // );

    return CustomExpansionTile(
      expanded: true,
      expandable: false,
      globalPadding: 10,
      title: t.finishLearningPeriodNewThresholdsSectionTitle,
      // trailingButton: toggleThresholds,
      children: [
        Text(
          t.finishLearningPeriodNewThresholdsNew,
          style: TextStyle(
            color: AppTheme.textColor.withValues(alpha: 0.8),
            fontWeight: FontWeight.w300,
          ),
        ),
        SizedBox(height: 3),
        ThresholdHorizontal(
          thresholds:
              thresholdsFromJson(currentLearningPeriod?.sh.threshold) ??
              thresholdsFromJson(AppConstants.shDefaultThresholds)!,
          unit: widget.waterUnit,
          // maxLiter: 25,
          height: 30,
        ),
        SizedBox(height: 8),
        Icon(Icons.arrow_downward_rounded, size: 20),
        SizedBox(height: 8),
        Text(
          t.finishLearningPeriodNewThresholdsNew,
          style: TextStyle(
            color: AppTheme.textColor.withValues(alpha: 0.8),
            fontWeight: FontWeight.w300,
          ),
        ),
        ThresholdHorizontal(
          thresholds:
              currentLearningPeriod?.getNewThresholds() ??
              thresholdsFromJson(AppConstants.shDefaultThresholds)!,
          unit: widget.waterUnit,
          // maxLiter: 25,
          height: 30,
          opacity: 0.5,
        ),
        SizedBox(height: 12),
        Text(
          t.finishLearningPeriodNewThresholdsMessage,
          style: TextStyle(
            color: AppTheme.textColor.withValues(alpha: 0.6),
            fontSize: 13,
          ),
        ),
        SizedBox(height: 8),
        LabeledSwitch(
          switchOnRight: false,
          label: t.finishLearningPeriodNewThresholdsAccept,
          value: applyThresholds,
          onChanged: (newValue) {
            onFieldChanged(Field.threshold, newValue);
          },
        ),
      ],
    );
  }

  Widget buildDurationSection() {
    final t = AppLocalizations.of(context)!;

    Color textColor = AppTheme.textColor;

    return CustomExpansionTile(
      expanded: true,
      expandable: false,
      globalPadding: 10,
      title: t.finishLearningPeriodRefDurationSectionTitle,
      trailingButton: Padding(
        padding: EdgeInsets.only(left: 15),
        child: DurationDisplay(
          totalSeconds:
              currentLearningPeriod?.getAverageDuration() ??
              widget.learningPeriod.sh.refShowerDuration ??
              AppConstants.refShowerDuration,
          gapBetweenBlocks: 8,
          unitStyle: TextStyle(
            fontSize: 14,
            color: textColor.withValues(alpha: 0.5),
            fontWeight: FontWeight.w400,
          ),
          valueStyle: TextStyle(
            fontSize: 17,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      children: [
        Text(
          t.finishLearningPeriodRefDurationMessage,
          style: TextStyle(
            color: AppTheme.textColor.withValues(alpha: 0.6),
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
