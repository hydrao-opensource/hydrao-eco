import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrao_flutter_offline/constants.dart';
import 'package:hydrao_flutter_offline/core/form_fields.dart';
import 'package:hydrao_flutter_offline/core/form_validators.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/domains/form_domain.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/models/shower_filters.dart';
import 'package:hydrao_flutter_offline/providers.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';
import 'package:hydrao_flutter_offline/theme.dart';
import 'package:hydrao_flutter_offline/ui/widgets/custom_expansion_tile.dart';
import 'package:hydrao_flutter_offline/ui/widgets/labeled_switch.dart';

const _logTag = "[SHOWER_FILTERS_FRAGMENT] ";

enum Field {
  hideIgnored,
  onlyIgnored,
  onlyReference,
  onlyChallengeKo,
  inPeriod, // for later
  periodBegin, // for later
  periodEnd, // for later
  gteVolume,
  volumeMin,
  lteVolume,
  volumeMax,
  gtRefDuration,
  gteDuration,
  durationMinuteMin,
  durationSecondMin,
  lteDuration,
  durationMinuteMax,
  durationSecondMax,
}

class ShowerFiltersFragment extends ConsumerStatefulWidget {
  final ShowerFilters filters;
  final Showerhead sh; // for ref shower duration
  final String waterUnit;

  const ShowerFiltersFragment({
    super.key,
    required this.filters,
    required this.waterUnit,
    required this.sh,
  });

  @override
  ConsumerState<ShowerFiltersFragment> createState() =>
      _ShowerFiltersFragmentState();
}

class _ShowerFiltersFragmentState extends ConsumerState<ShowerFiltersFragment> {
  ShowerFilters? currentFilters;
  late FormDomain<ShowerFilters> formDomain;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();

    formDomain = ref.read(showerFiltersStateProvider.notifier);
  }

  void onFieldChanged(Field field, dynamic value) {
    // if (!mounted) return;

    appLogger.d('$_logTag field "${field.toString()}" changed : $value');

    setState(() {
      switch (field) {
        case Field.hideIgnored:
          if (value == true) {
            currentFilters?.add(ShowerFilter.hideIgnored);
          } else {
            currentFilters?.remove(ShowerFilter.hideIgnored);
          }
          break;
        case Field.onlyIgnored:
          if (value == true) {
            currentFilters?.add(ShowerFilter.onlyIgnored);
          } else {
            currentFilters?.remove(ShowerFilter.onlyIgnored);
          }
          break;
        case Field.onlyReference:
          if (value == true) {
            currentFilters?.add(ShowerFilter.onlyReference);
          } else {
            currentFilters?.remove(ShowerFilter.onlyReference);
          }
          break;
        case Field.onlyChallengeKo:
          if (value == true) {
            currentFilters?.add(ShowerFilter.onlyChallengeKo);
          } else {
            currentFilters?.remove(ShowerFilter.onlyChallengeKo);
          }
          break;
        case Field.inPeriod:
          if (value == true) {
            currentFilters?.add(ShowerFilter.inPeriod);
          } else {
            currentFilters?.remove(ShowerFilter.inPeriod);
          }
          break;
        case Field.periodBegin:
          currentFilters?.setPeriod(
            value as DateTime?,
            currentFilters?.periodEnd,
          );

          break;
        case Field.periodEnd:
          currentFilters?.setPeriod(
            currentFilters?.periodBegin,
            value as DateTime?,
          );

          break;
        case Field.gteVolume:
          if (value == true) {
            currentFilters?.add(ShowerFilter.gteVolume);
          } else {
            currentFilters?.remove(ShowerFilter.gteVolume);
          }
          break;
        case Field.volumeMin:
          currentFilters?.setVolumeMin(value as double?);

          break;
        case Field.lteVolume:
          if (value == true) {
            currentFilters?.add(ShowerFilter.lteVolume);
          } else {
            currentFilters?.remove(ShowerFilter.lteVolume);
          }
          break;
        case Field.volumeMax:
          currentFilters?.setVolumeMax(value as double?);
          break;
        case Field.gtRefDuration:
          if (value == true) {
            currentFilters?.setDurationRef(
              widget.sh.refShowerDuration ?? AppConstants.refShowerDuration,
            );
          } else {
            currentFilters?.remove(ShowerFilter.gtRefDuration);
          }
          break;
        default:
          break;
      }

      // update state
      formDomain.setChanges(
        currentFilters?.hasChanges(widget.filters) ?? false
            ? currentFilters
            : null,
      );

      // validate values
      var errors = _checkErrors();
      formDomain.updateErrors(errors);
    });
  }

  Map<String, String> _checkErrors() {
    final t = AppLocalizations.of(context)!;

    Map<String, String> errors = {};

    // TODO periodBegin < periodEnd
    if (currentFilters?.periodBegin != null &&
        currentFilters?.periodEnd != null &&
        currentFilters?.has(ShowerFilter.inPeriod) == true) {
      //TODO
    }

    if (currentFilters?.has(ShowerFilter.gteDuration) ?? false) {
      //TODO check durationMin not null
      //TODO check durationMin > 0
    }

    if (currentFilters?.has(ShowerFilter.lteDuration) ?? false) {
      //TODO check durationMax not null
      //TODO check durationMax > 1
    }

    if (currentFilters?.has(ShowerFilter.gteVolume) ?? false) {
      _checkNumberField(Field.volumeMin, currentFilters?.volumeMin, errors, t);
    }

    if (currentFilters?.has(ShowerFilter.lteVolume) ?? false) {
      _checkNumberField(Field.volumeMax, currentFilters?.volumeMax, errors, t);
    }

    return errors;
  }

  void _checkNumberField(
    Field field,
    double? value,
    Map<String, String> errors,
    AppLocalizations t,
  ) {
    final required = validateRequired(t, value);
    if (required != null) {
      errors[field.toString()] = required;
      return;
    }

    final minValue = validateNumberGreaterThan(t, value, 0);
    if (minValue != null) {
      errors[field.toString()] = minValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    appLogger.d('$_logTag build');

    if (currentFilters == null) {
      currentFilters = widget.filters.copyWith();
      isInitialized = true;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isInitialized == true) {
        setState(() {
          formDomain.setChanges(null);
          formDomain.updateErrors({});
          isInitialized = false;
        });
      }
    });

    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildUserPrefSection(),
          SizedBox(height: 10),
          buildVolumeSection(),
          SizedBox(height: 10),
          buildDurationSection(),
        ],
      ),
    );
  }

  Widget buildUserPrefSection() {
    final t = AppLocalizations.of(context)!;

    Widget? activeBadge;

    int activeCount = 0;
    List<ShowerFilter> sectionFilters = [
      ShowerFilter.hideIgnored,
      ShowerFilter.onlyIgnored,
      ShowerFilter.onlyReference,
    ];
    for (var filter in sectionFilters) {
      if (currentFilters?.has(filter) == true) {
        activeCount++;
      }
    }

    if (activeCount > 0) {
      activeBadge = buildBadge(activeCount);
    }

    return CustomExpansionTile(
      title: t.showerFiltersUserPrefsSectionTitle,
      expanded: true,
      expandable: false,
      trailingButton: activeBadge,
      globalPadding: 10,
      children: [
        getHideIgnoredWidget(),
        getOnlyIgnoredWidget(),
        getOnlyReferenceWidget(),
      ],
    );
  }

  Widget buildVolumeSection() {
    final t = AppLocalizations.of(context)!;

    Widget? activeBadge;

    int activeCount = 0;
    List<ShowerFilter> sectionFilters = [
      ShowerFilter.onlyChallengeKo,
      ShowerFilter.lteVolume,
      ShowerFilter.gteVolume,
    ];
    for (var filter in sectionFilters) {
      if (currentFilters?.has(filter) == true) {
        activeCount++;
      }
    }

    if (activeCount > 0) {
      activeBadge = buildBadge(activeCount);
    }

    return CustomExpansionTile(
      title: t.showerFiltersVolumeSectionTitle,
      expanded: true,
      expandable: false,
      trailingButton: activeBadge,
      globalPadding: 10,
      children: [
        getOnlyChallengeKoWidget(),
        getLteVolumeWidget(),
        getGteVolumeWidget(),
      ],
    );
  }

  Widget getOnlyIgnoredWidget() {
    final t = AppLocalizations.of(context)!;

    return LabeledSwitch(
      switchOnRight: false,
      value: currentFilters?.has(ShowerFilter.onlyIgnored) ?? false,
      labelWidget: Row(
        children: [
          Text(
            t.showerFiltersIgnoredField,
            style: TextStyle(
              color: AppTheme.textColor.withValues(alpha: 0.7),
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(width: 3),
          Text(t.showerFiltersIsChechedText),
        ],
      ),
      onChanged: (newValue) {
        onFieldChanged(Field.onlyIgnored, newValue);
      },
    );
  }

  Widget getHideIgnoredWidget() {
    final t = AppLocalizations.of(context)!;

    return LabeledSwitch(
      switchOnRight: false,
      value: currentFilters?.has(ShowerFilter.hideIgnored) ?? false,
      labelWidget: Row(
        children: [
          Text(
            t.showerFiltersIgnoredField,
            style: TextStyle(
              color: AppTheme.textColor.withValues(alpha: 0.7),
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(width: 3),
          Text(t.showerFiltersIsNotCheckedText),
        ],
      ),
      onChanged: (newValue) {
        onFieldChanged(Field.hideIgnored, newValue);
      },
    );
  }

  Widget getOnlyReferenceWidget() {
    final t = AppLocalizations.of(context)!;

    return LabeledSwitch(
      switchOnRight: false,
      value: currentFilters?.has(ShowerFilter.onlyReference) ?? false,
      label: t.showerFiltersIsRefShowerField,
      onChanged: (newValue) {
        onFieldChanged(Field.onlyReference, newValue);
      },
    );
  }

  Widget getOnlyChallengeKoWidget() {
    final t = AppLocalizations.of(context)!;

    return LabeledSwitch(
      switchOnRight: false,
      value: currentFilters?.has(ShowerFilter.onlyChallengeKo) ?? false,
      label: t.showerFiltersChallengeKo,
      onChanged: (newValue) {
        onFieldChanged(Field.onlyChallengeKo, newValue);
      },
    );
  }

  Widget getGteVolumeWidget() {
    final t = AppLocalizations.of(context)!;

    return Row(
      children: [
        SizedBox(
          width: 170,
          child: LabeledSwitch(
            switchOnRight: false,
            value: currentFilters?.has(ShowerFilter.gteVolume) ?? false,
            label: t.showerFiltersIsGreaterThanField,
            onChanged: (newValue) {
              onFieldChanged(Field.gteVolume, newValue);
            },
          ),
        ),
        Spacer(),
        SizedBox(
          width: 70,
          child: buildDoubleField(
            currentFilters?.volumeMin,
            (newValue) {
              onFieldChanged(Field.volumeMin, newValue);
            },
            errorMessage:
                formDomain.getFieldError(Field.volumeMin.toString()) != null
                ? " "
                : null,
          ),
        ),
        Text(
          widget.waterUnit,
          style: TextStyle(
            color: AppTheme.textColor,
            fontWeight: FontWeight.w400,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget getLteVolumeWidget() {
    final t = AppLocalizations.of(context)!;

    return Row(
      children: [
        SizedBox(
          width: 170,
          child: LabeledSwitch(
            switchOnRight: false,
            value: currentFilters?.has(ShowerFilter.lteVolume) ?? false,
            label: t.showerFiltersIsLessThanField,
            onChanged: (newValue) {
              onFieldChanged(Field.lteVolume, newValue);
            },
          ),
        ),
        Spacer(),
        SizedBox(
          width: 70,
          child: buildDoubleField(
            currentFilters?.volumeMax,
            (newValue) {
              onFieldChanged(Field.volumeMax, newValue);
            },
            errorMessage:
                formDomain.getFieldError(Field.volumeMax.toString()) != null
                ? " "
                : null,
          ),
        ),
        Text(
          widget.waterUnit,
          style: TextStyle(
            color: AppTheme.textColor,
            fontWeight: FontWeight.w400,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget buildDurationSection() {
    final t = AppLocalizations.of(context)!;

    Widget? activeBadge;

    int activeCount = 0;
    List<ShowerFilter> sectionFilters = [ShowerFilter.gtRefDuration];
    for (var filter in sectionFilters) {
      if (currentFilters?.has(filter) == true) {
        activeCount++;
      }
    }

    if (activeCount > 0) {
      activeBadge = buildBadge(activeCount);
    }

    return CustomExpansionTile(
      title: t.showerFiltersDurationSectionTitle,
      expanded: true,
      expandable: false,
      trailingButton: activeBadge,
      globalPadding: 10,
      children: [getGteRefDurationWidget()],
    );
  }

  Widget getGteRefDurationWidget() {
    final t = AppLocalizations.of(context)!;

    return LabeledSwitch(
      switchOnRight: false,
      value: currentFilters?.has(ShowerFilter.gtRefDuration) ?? false,
      label: t.showerFiltersExceedRefShowerDurationField,
      onChanged: (newValue) {
        onFieldChanged(Field.gtRefDuration, newValue);
      },
    );
  }

  Widget buildBadge(int count) {
    return CircleAvatar(
      radius: 12,
      backgroundColor: const Color(0xFF6EC1E4),
      child: Text(
        count.toString(),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
