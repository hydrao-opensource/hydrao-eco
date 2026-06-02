import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrao_flutter_offline/constants.dart';
import 'package:hydrao_flutter_offline/conversions.dart';
import 'package:hydrao_flutter_offline/core/form_fields.dart';
import 'package:hydrao_flutter_offline/core/form_validators.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/domains/form_domain.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/models/learning_period.dart';
import 'package:hydrao_flutter_offline/models/threshold.dart';
import 'package:hydrao_flutter_offline/providers.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';
import 'package:hydrao_flutter_offline/theme.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/confirm_dialog.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/edit_sh_thresholds_dialog.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/help_dialog.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/stop_learning_period_dialog.dart';
import 'package:hydrao_flutter_offline/ui/widgets/click_tooltip.dart';
import 'package:hydrao_flutter_offline/ui/widgets/custom_expansion_tile.dart';
import 'package:hydrao_flutter_offline/ui/widgets/duration_display.dart';
import 'package:hydrao_flutter_offline/ui/widgets/help_button.dart';
import 'package:hydrao_flutter_offline/ui/widgets/threshold_horizontal.dart';
import 'package:hydrao_flutter_offline/utils.dart';

const _logTag = "[CONFIGURE_SHOWERHEAD_FORM] ";

enum Usecase { add, edit, merge }

enum Field { name, thresholds, previousFlow, startLearning }

class ConfigureShowerheadForm extends ConsumerStatefulWidget {
  final String unit;
  final Showerhead sh;
  final List<Shower> showers;
  final String? defaultName;
  final bool canDelete;
  final Function? onDelete;
  final void Function(LearningPeriod) onStopLearning;
  final List<Showerhead> existingShs;
  final String Function() refreshShName;
  final Usecase usecase;

  const ConfigureShowerheadForm({
    super.key,
    required this.unit,
    required this.sh,
    required this.showers,
    required this.existingShs,
    required this.onStopLearning,
    required this.refreshShName,
    this.defaultName,
    this.canDelete = false,
    this.onDelete,
    this.usecase = Usecase.add,
  });

  @override
  ConsumerState<ConfigureShowerheadForm> createState() =>
      ConfigureShowerheadFormState();
}

class ConfigureShowerheadFormState
    extends ConsumerState<ConfigureShowerheadForm> {
  Showerhead? currentSh;
  late FormDomain<ShowerheadsCompanion> formDomain;

  @override
  void initState() {
    super.initState();
    formDomain = ref.read(shFormStateProvider.notifier);
    currentSh = widget.sh.name.isEmpty
        ? widget.sh.copyWith(
            name: widget.defaultName,
            previousFlow: drift.Value(
              AppConstants.getDefaultFlowFromType(widget.sh.type),
            ),
          )
        : widget.sh.copyWith();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final changes = currentSh?.getChangesFrom(widget.sh);
      formDomain.setChanges(changes);
      formDomain.updateErrors(_checkErrors());
    });
  }

  @override
  void didUpdateWidget(ConfigureShowerheadForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sh != widget.sh) {
      setState(() {
        // Preserve user edits; only update non-editable BLE-sourced fields
        currentSh = currentSh!.copyWith(
          liveFlow: drift.Value(widget.sh.liveFlow),
          lastSeen: drift.Value(widget.sh.lastSeen),
          lastRssi: drift.Value(widget.sh.lastRssi),
        );
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final changes = currentSh?.getChangesFrom(widget.sh);
        formDomain.setChanges(changes);
        formDomain.updateErrors(_checkErrors());
      });
    }
  }

  void showEditThresholdsDialog() {
    String thresholds =
        currentSh?.thresholdRequest ??
        currentSh?.threshold ??
        AppConstants.shDefaultThresholds;

    showEditShThresholdsDialog(
      context,
      thresholdsFromJson(thresholds) ??
          thresholdsFromJson(AppConstants.shDefaultThresholds)!,
      widget.unit,
      (List<HydraoThreshold> newThresholds) {
        appLogger.i('$_logTag new thresholds chosen : $newThresholds');
        _onFieldChanged(Field.thresholds, newThresholds);
      },
    );
  }

  void _onFieldChanged(Field field, dynamic value) {
    // if (!mounted) return;
    appLogger.d('$_logTag field "${field.toString()}" changed : $value');
    switch (field) {
      case Field.name:
        setState(() {
          currentSh = currentSh!.copyWith(name: value as String? ?? "");
        });
        break;
      case Field.thresholds:
        setState(() {
          currentSh = currentSh!.copyWith(
            thresholdRequest: drift.Value(
              value != null
                  ? thresholdsToJson(value as List<HydraoThreshold>)
                  : null,
            ),
          );
        });
        break;
      case Field.previousFlow:
        setState(() {
          final v = value as double?;
          currentSh = currentSh!.copyWith(
            previousFlow: drift.Value(
              v != null ? getLitersFromUnit(v, widget.unit) : null,
            ),
          );
        });
        break;
      case Field.startLearning:
        setState(() {
          currentSh = currentSh!.copyWith(
            baselineEndIndex: drift.Value(null),
            baselineBeginIndex: drift.Value(null),
            baselineStatus: drift.Value(LearningStatus.begin.toString()),
            baselineBeginDate: drift.Value(DateTime.now()),
            baselineEndDate: drift.Value(null),
          );
        });
        break;
    }

    // update state
    var changes = currentSh!.getChangesFrom(widget.sh);
    if (changes != null) {
      formDomain.setChanges(changes);
    } else {
      formDomain.resetChanges();
    }

    // validate values
    var errors = _checkErrors();
    formDomain.updateErrors(errors);
  }

  void _checkNumberField(
    Field field,
    double? value,
    Map<String, String> errors,
    AppLocalizations t, {
    double? maxValue,
  }) {
    final required = validateRequired(t, value);
    if (required != null) {
      errors[field.toString()] = required;
      return;
    }

    final minValue = validateNumberGreaterThan(t, value, 0);
    if (minValue != null) {
      errors[field.toString()] = minValue;
    }

    if (maxValue != null) {
      final error = validateNumberLesserOrEqualThan(t, value, maxValue);
      if (error != null) {
        errors[field.toString()] = error;
      }
    }
  }

  Map<String, String> _checkErrors() {
    final t = AppLocalizations.of(context)!;

    Map<String, String> errors = {};

    // name required
    final required = validateRequired(t, currentSh?.name);
    if (required != null) {
      errors[Field.name.toString()] = required;
    } else {
      // check name is unique
      Showerhead? existing = widget.existingShs.firstWhereOrNull(
        (existingSh) =>
            existingSh.uuid != currentSh?.uuid &&
            existingSh.name.toLowerCase() == currentSh?.name.toLowerCase(),
      );
      if (existing != null) {
        errors[Field.name.toString()] = t.configShNameExistsError;
      }
    }

    // 0 < previousFlow <= 25
    _checkNumberField(
      Field.previousFlow,
      currentSh?.previousFlow,
      errors,
      t,
      maxValue: 25,
    );

    appLogger.d('$_logTag checkErrors : $errors');
    return errors;
  }

  void showEndLearningPeriodDialog() async {
    appLogger.i('$_logTag show end learning period dialog here');

    final learningPeriod = LearningPeriod(
      sh: currentSh!,
      showers: widget.showers.where((shower) {
        return currentSh?.baselineBeginIndex != null &&
            shower.id > currentSh!.baselineBeginIndex!;
      }).toList(),
    );

    await showStopLearningPeriodDialog(
      context: context,
      learningPeriod: learningPeriod,
      waterUnit: widget.unit,
      onStop: widget.onStopLearning,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget? bottomActions = buildBottomActions();

    bool showConnectionSection =
        currentSh?.lastSeen != null &&
        currentSh!.liveFlow != null &&
        !currentSh!.liveFlow!.isNaN &&
        !currentSh!.liveFlow!.isInfinite;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.usecase == Usecase.merge) buildMergePanel(),
        if (widget.usecase == Usecase.merge) SizedBox(height: 15),

        buildIdentityPanel(),

        const SizedBox(height: 15),

        buildLearningSection(),

        const SizedBox(height: 15),

        buildThresholdsSection(),

        const SizedBox(height: 15),

        buildSavingsSection(),

        if (showConnectionSection) SizedBox(height: 15),

        if (showConnectionSection) buildConnectionSection(),

        const SizedBox(height: 20),

        buildTechnicalSection(),

        if (bottomActions != null) SizedBox(height: 30),
        ?bottomActions,
      ],
    );
  }

  Widget buildMergePanel() {
    final t = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: AppTheme.color.lighten(0.4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.info, color: AppTheme.textColor),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              t.configShMergeNotice,
              style: TextStyle(color: AppTheme.textColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIdentityPanel() {
    return Row(
      children: [
        Image.asset(
          AppConstants.typeImages[widget.sh.type]!,
          width: 60,
          height: 60,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 15),
        Expanded(
          child: buildTextField(
            currentSh?.name,
            (newName) {
              _onFieldChanged(Field.name, newName);
            },
            errorMessage: formDomain.getFieldError(Field.name.toString()),
            textAlign: TextAlign.center,
            suffixIcon: IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                String newName = widget.refreshShName();
                appLogger.d('New sh name : $newName');
                _onFieldChanged(Field.name, newName);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLearningSection() {
    final t = AppLocalizations.of(context)!;
    final bool beginOrInLearningPeriod = isBeginOrInLearningPeriod();

    // Widget startButton = widget.usecase != Usecase.merge
    //     ? InkWell(
    //         onTap: () async {
    //           bool canStart = await showConfirmDialog(
    //             context: context,
    //             message:
    //                 "La période d'apprentissage démarrera à la prochaine synchronisation.\n\nLes lumières du pommeau passeront en vert continu.\n\nPour finalisez cette procédure, vous devrez vous reconnecter à l'application et attendre la synchronisation complète.\n\nVoulez-vous continuez ?",
    //           );
    //           if (canStart) {
    //             _onFieldChanged(Field.startLearning, true);
    //           }
    //         },
    //         borderRadius: BorderRadius.circular(20),
    //         child: const Padding(
    //           padding: EdgeInsets.symmetric(
    //             horizontal: 8,
    //             vertical: 3,
    //           ), // zone cliquable maîtrisée
    //           child: Icon(Icons.play_circle_fill, size: 20),
    //         ),
    //       )
    //     : SizedBox.shrink();
    Widget startButton = widget.usecase != Usecase.merge
        ? TextButton(
            onPressed: () async {
              bool canStart = await showConfirmDialog(
                context: context,
                message: t.configShLearningStartWarning,
              );
              if (!context.mounted) return;
              if (canStart) {
                _onFieldChanged(Field.startLearning, true);
              }
            },
            child: Text(
              currentSh?.baselineEndDate != null ? t.beginAgain : t.begin,
              style: TextStyle(color: AppTheme.textColor),
            ),
          )
        : SizedBox.shrink();

    // Widget stopButton = widget.usecase != Usecase.merge
    //     ? InkWell(
    //         onTap: () {
    //           showEndLearningPeriodDialog();
    //         },
    //         borderRadius: BorderRadius.circular(20),
    //         child: const Padding(
    //           padding: EdgeInsets.symmetric(
    //             horizontal: 8,
    //             vertical: 3,
    //           ), // zone cliquable maîtrisée
    //           child: Icon(Icons.stop_circle, size: 20),
    //         ),
    //       )
    //     : SizedBox.shrink();
    Widget stopButton = widget.usecase != Usecase.merge
        ? TextButton(
            onPressed: () {
              showEndLearningPeriodDialog();
            },
            child: Text(t.stop, style: TextStyle(color: AppTheme.textColor)),
          )
        : SizedBox.shrink();

    final startCheck =
        (currentSh?.baselineStatus == null ||
            currentSh?.baselineStatus == LearningStatus.end.toString()) &&
        currentSh?.baselineEndDate == null;
    String? message;
    if (startCheck) {
      message = t.configShLearningFirstTimeMessage;
    } else if (beginOrInLearningPeriod) {
      message = t.configShLearningInPeriodMessage;
    }
    Widget? statusMessage = message != null
        ? Text(
            message,
            style: TextStyle(
              color: AppTheme.textColor.withValues(alpha: 0.5),
              fontSize: 13,
            ),
          )
        : null;

    // print(
    //   '$LOG_TAG baseline endDate=${currentSh?.baselineEndDate} / status=${currentSh?.baselineStatus}',
    // );

    final statusDate = beginOrInLearningPeriod
        ? currentSh?.baselineBeginDate
        : currentSh?.baselineEndDate;
    final statusText = beginOrInLearningPeriod
        ? t.configShLearningStarted
        : t.configShLearningEnded;
    List<Shower> refShowers = widget.showers.where((shower) {
      return currentSh?.baselineBeginIndex != null &&
          shower.id > currentSh!.baselineBeginIndex!;
    }).toList();
    final refShowersCount = refShowers.length;
    final showersCountText = refShowersCount > 0
        ? t.configShLearningRefShowersCount(refShowersCount)
        : null;
    Widget statusLine = statusDate != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    statusText,
                    style: TextStyle(
                      color: AppTheme.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    formatRelative(context, statusDate),
                    style: TextStyle(
                      color: AppTheme.color.withValues(alpha: 0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              if (beginOrInLearningPeriod && refShowersCount > 0)
                Text(
                  showersCountText!,
                  style: TextStyle(color: AppTheme.textColor),
                ),
              if (currentSh?.baselineStatus == LearningStatus.begin.toString())
                Text(
                  t.configShLearningStartHelp,
                  style: TextStyle(
                    color: AppTheme.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (currentSh?.baselineStatus ==
                      LearningStatus.learn.toString() &&
                  refShowersCount == 0)
                Text(
                  t.configShLearningRunningHelp,
                  style: TextStyle(
                    color: AppTheme.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          )
        : SizedBox.shrink();

    Color noteColor = AppTheme.textColor.withValues(alpha: 0.3);
    Widget noteLastShower = Text(
      t.configShLearningLastShowerExcluded,
      style: TextStyle(fontStyle: FontStyle.italic, color: noteColor, fontSize: 13),
    );

    return CustomExpansionTile(
      expanded: true,
      title: t.configShLearningSectionTitle,
      // trailingButton: beginOrInLearningPeriod ? stopButton : startButton,
      children: [
        statusLine,
        if (statusMessage != null) SizedBox(height: 5),
        ?statusMessage,
        if (beginOrInLearningPeriod) SizedBox(height: 8),
        if (beginOrInLearningPeriod) noteLastShower,
        SizedBox(height: 5),
        beginOrInLearningPeriod ? stopButton : startButton,
      ],
    );
  }

  Widget buildThresholdsSection() {
    final t = AppLocalizations.of(context)!;

    bool beginOrInLearningPeriod = isBeginOrInLearningPeriod();

    return CustomExpansionTile(
      expanded: true,
      title: t.configShThresholdsSectionTitle,
      trailingButton: !beginOrInLearningPeriod
          ? InkWell(
              onTap: () {
                showEditThresholdsDialog();
              },
              borderRadius: BorderRadius.circular(20),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ), // zone cliquable maîtrisée
                child: Icon(Icons.edit, size: 20),
              ),
            )
          : null,
      children: beginOrInLearningPeriod
          ? [
              Text(
                t.configShThresholdsLearningMessage,
                style: TextStyle(
                  color: AppTheme.textColor.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w300,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 3),
              ThresholdHorizontal(
                thresholds: thresholdsFromJson(AppConstants.shLearningThresholds) ??
                    thresholdsFromJson(AppConstants.shDefaultThresholds)!,
                unit: widget.unit,
                // maxLiter: 25,
                height: 30,
              ),
            ]
          : [
              Text(
                t.configShThresholdsCurrent,
                style: TextStyle(
                  color: AppTheme.textColor.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 3),
              ThresholdHorizontal(
                thresholds: thresholdsFromJson(
                      currentSh?.threshold ?? AppConstants.shDefaultThresholds,
                    ) ??
                    thresholdsFromJson(AppConstants.shDefaultThresholds)!,
                unit: widget.unit,
                // maxLiter: 25,
                height: 30,
              ),
              SizedBox(height: 8),
              if (currentSh?.thresholdRequest != null) ...[
                Icon(Icons.arrow_downward_rounded, size: 20),
                SizedBox(height: 8),
                Text(
                  t.configShThresholdsNewToApply,
                  style: TextStyle(
                    color: AppTheme.textColor.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w300,
                  ),
                ),
                ThresholdHorizontal(
                  thresholds: thresholdsFromJson(currentSh?.thresholdRequest) ??
                      thresholdsFromJson(AppConstants.shDefaultThresholds)!,
                  unit: widget.unit,
                  // maxLiter: 25,
                  height: 30,
                  opacity: 0.5,
                ),
                SizedBox(height: 10),
                Text(
                  t.configShNewThresholdsSyncMessage,
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  onPressed: () {
                    _onFieldChanged(Field.thresholds, null);
                  },
                  child: Text(
                    t.cancel,
                    style: TextStyle(color: AppTheme.textWarningColor),
                  ),
                ),
              ],
            ],
    );
  }

  Widget buildSavingsSection() {
    final t = AppLocalizations.of(context)!;

    bool hasCustomRefDuration =
        widget.sh.refShowerDuration != null &&
        widget.sh.refShowerDuration != AppConstants.refShowerDuration;

    Color refDurationColor = (hasCustomRefDuration)
        ? AppTheme.color
        : AppTheme.textColor;

    return CustomExpansionTile(
      title: t.configShSavingsSectionTitle,
      expanded: widget.canDelete == false,
      children: [
        buildDoubleField(
          getVolumeForUnit(
            currentSh?.previousFlow ??
                AppConstants.getDefaultFlowFromType(widget.sh.type),
            widget.unit,
          ),
          (newPreviousFlow) {
            _onFieldChanged(Field.previousFlow, newPreviousFlow);
          },
          label: t.configShOldShFlowField,
          unit: getFlowUnitSymbol(widget.unit),
          errorMessage: formDomain.getFieldError(Field.previousFlow.toString()),
          layoutVertical: true,
        ),
        SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              t.configShRefShowerDurationField,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: AppTheme.textColor),
            ),
            ClickTooltip(
              message: t.configShRefShowerDurationHelp,
              child: Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: Icon(
                  Icons.help_outline,
                  size: 18,
                  color: AppTheme.textColor,
                ),
              ),
            ),
            SizedBox(width: 15),
            DurationDisplay(
              totalSeconds:
                  widget.sh.refShowerDuration ?? AppConstants.refShowerDuration,
              gapBetweenBlocks: 8,
              unitStyle: TextStyle(
                fontSize: 14,
                color: refDurationColor.withValues(alpha: 0.5),
                fontWeight: FontWeight.w400,
              ),
              valueStyle: TextStyle(
                fontSize: 17,
                color: refDurationColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildConnectionSection() {
    final t = AppLocalizations.of(context)!;

    // flowBadge (based on liveFlow)
    Widget flowBadge = SizedBox.shrink();
    if (currentSh?.liveFlow != null) {
      String text;
      Color color;

      if (currentSh!.liveFlow! > AppConstants.shMinFlow) {
        text = t.configShFlowQualityGood;
        color = Colors.green.shade600;
      } else {
        text = t.configShFlowQualityLow;
        color = AppTheme.textWarningColor.withValues(alpha: 0.7);
      }

      flowBadge = _buildBadge(text, color.withValues(alpha: 0.8));
    }

    // bleBadge (based on lastRssi)
    // Widget? bleBadge = SizedBox.shrink();
    // if (currentSh?.lastRssi != null) {
    //   String text;
    //   Color color;

    //   if (currentSh!.lastRssi! >= -80) {
    //     text = "Correcte";
    //     color = Colors.green.shade600;
    //   } else {
    //     text = "Faible";
    //     color = AppTheme.textWarningColor.withValues(alpha: 0.7);
    //   }

    //   bleBadge = _buildBadge(text, color.withValues(alpha: 0.8));
    // }

    return CustomExpansionTile(
      title: t.configShLastConnectionSectionTitle,
      expanded: true,
      children: [
        // last seen relative
        SizedBox(
          width: double.infinity, // 🔥 largeur max
          child: AutoSizeText(
            formatRelative(context, currentSh!.lastSeen!),
            maxLines: 1,
            minFontSize: 8, // 🔥 taille min acceptable
            overflow: TextOverflow.ellipsis, // tronquer si trop long
            style: TextStyle(color: AppTheme.textColor),
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(height: 8),
        // [liveFlow != null] water flow : text + badge + liveFlow
        if (currentSh?.liveFlow != null)
          Row(
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  t.configShLastConnectionFlowRate,
                  style: TextStyle(
                    color: AppTheme.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              flowBadge,
              SizedBox(width: 8),
              HelpButton(
                onTap: () {
                  showHelpDialog(
                    context: context,
                    key: HelpCase.removeFlowRestrictor,
                    data: currentSh!.type,
                  );
                },
                icon: Icons.help_outline,
                size: 24,
              ),

              // ClickTooltip(
              //   message:
              //       "Un débit faible peut entrainer une connexion instable avec le pommeau.\n\nSi un réducteur de débit est installé, veuillez le retirer.",
              //   child: Padding(
              //     padding: EdgeInsets.only(left: 4.0),
              //     child: Icon(
              //       Icons.help_outline,
              //       size: 18,
              //       color: AppTheme.textColor,
              //     ),
              //   ),
              // ),
              SizedBox(width: 8),
              Text(
                formatVolume(
                  getVolumeForUnit(currentSh!.liveFlow!, widget.unit),
                ),
                style: TextStyle(
                  color: AppTheme.textColor,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              SizedBox(width: 4),
              Text(
                getFlowUnitSymbol(widget.unit),
                style: TextStyle(
                  color: AppTheme.textColor.withValues(alpha: 0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        // if (currentSh?.liveFlow != null) SizedBox(height: 8),
        // // [lastRssi != null] ble reception : text + badge
        // if (currentSh?.lastRssi != null)
        //   Row(
        //     children: [
        //       SizedBox(
        //         width: 100,
        //         child: Text(
        //           "Réception\nbluetooth",
        //           style: TextStyle(
        //             color: AppTheme.textColor,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //       ),
        //       bleBadge,
        //       SizedBox(width: 8),
        //       ClickTooltip(
        //         message:
        //             "La réception bluetooth peut être influencée par la distance avec le pommeau, ou tout élément présent entre l'appareil et le pommeau pouvant créer des interférences.",
        //         child: Padding(
        //           padding: EdgeInsets.only(left: 4.0),
        //           child: Icon(
        //             Icons.help_outline,
        //             size: 18,
        //             color: AppTheme.textColor,
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
      ],
    );
  }

  Widget buildTechnicalSection() {
    final t = AppLocalizations.of(context)!;

    return CustomExpansionTile(
      title: t.configShTechnicalSectionTitle,
      children: [
        _buildTechRow(t.configShTechnicalUuidField, widget.sh.uuid, expanded: true),
        _buildTechRow(t.configShTechnicalFwVersionField, widget.sh.fwVersion),
        _buildTechRow(t.configShTechnicalHwVersionField, widget.sh.hwVersion?.toString()),
      ],
    );
  }

  Widget _buildTechRow(String label, String? value, {bool expanded = false}) {
    final valueWidget = Text(
      value ?? "???",
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      softWrap: expanded,
      overflow: expanded ? TextOverflow.visible : null,
    );
    return Row(
      children: [
        Text(
          "$label :",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 8),
        expanded ? Expanded(child: valueWidget) : valueWidget,
      ],
    );
  }

  Widget? buildBottomActions() {
    final t = AppLocalizations.of(context)!;

    Widget? view;
    if (widget.canDelete) {
      view = FractionallySizedBox(
        widthFactor: 0.9, // 9
        child: TextButton(
          onPressed: () async {
            // action ici
            final result = await showConfirmDialog(
              context: context,
              message: t.confirmDeleteSh,
            );
            if (!context.mounted) return;
            if (result && widget.onDelete != null) {
              widget.onDelete!();
            }
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: Text(t.delete.toUpperCase()),
        ),
      );
    }
    return view;
  }

  Widget _buildBadge(String text, Color bgColor) {
    Color textColor = getTextColorForBackground(background: bgColor);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      width: 90,
      child: Text(
        text,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  bool isBeginOrInLearningPeriod() {
    return currentSh?.baselineStatus != null &&
        (currentSh?.baselineStatus == LearningStatus.begin.toString() ||
            currentSh?.baselineStatus == LearningStatus.learn.toString());
  }
}
