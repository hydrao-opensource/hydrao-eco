import 'package:country_picker/country_picker.dart';
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
import 'package:hydrao_flutter_offline/providers.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/confirm_dialog.dart';
import 'package:hydrao_flutter_offline/ui/fragments/page/import_backup_fragment.dart';
import 'package:hydrao_flutter_offline/ui/widgets/custom_expansion_tile.dart';
import 'package:hydrao_flutter_offline/utils.dart';

const _logTag = "[GLOBAL_SETTINGS_FRAGMENT] ";

enum Field {
  countryCode,
  currencyCode,
  waterUnit,
  waterPrice,
  energyPrice,
  heatingEnergy,
  minShowerLiter,
}

class GlobalSettingsFragment extends ConsumerStatefulWidget {
  final Settings? settings;
  final bool canReset;
  final Function? onReset;
  final bool canBackup;
  final Function? onCreateBackup;
  final void Function(From from) onImportBackup;

  const GlobalSettingsFragment({
    super.key,
    this.settings,
    this.canReset = false,
    this.canBackup = false,
    this.onReset,
    this.onCreateBackup,
    required this.onImportBackup,
  });

  @override
  ConsumerState<GlobalSettingsFragment> createState() =>
      _GlobalSettingsFragmentState();
}

class _GlobalSettingsFragmentState
    extends ConsumerState<GlobalSettingsFragment> {
  Settings? currentSettings;
  late FormDomain<AppSettingsCompanion> formDomain;

  @override
  void initState() {
    super.initState();
    formDomain = ref.read(settingsFormStateProvider.notifier);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (currentSettings != null) return;

    if (widget.settings != null) {
      currentSettings = widget.settings!.copyWith();
    } else {
      final locale = Localizations.localeOf(context);
      currentSettings = Settings(
        id: 1,
        minShowerLiter: AppConstants.minShowerLiter,
        heatingEnergy: AppConstants.heatingEnergy,
      );
      _applyCountryCodeToSettings(
        locale.countryCode ?? AppConstants.defaultCountryCode,
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        formDomain.setChanges(currentSettings?.getChangesFrom(widget.settings));
        formDomain.updateErrors(_checkErrors());
      });
    });
  }

  @override
  void didUpdateWidget(GlobalSettingsFragment oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.settings != oldWidget.settings && widget.settings != null) {
      setState(() {
        currentSettings = widget.settings!.copyWith();
        formDomain.setChanges(currentSettings?.getChangesFrom(widget.settings));
        formDomain.updateErrors(_checkErrors());
      });
    }
  }

  // Pure mutation — doit être appelée depuis un bloc setState.
  void _applyCountryCodeToSettings(String? newCountryCode) {
    final countrySettings =
        AppConstants.getCountrySettingsFromCountryCode(newCountryCode);

    appLogger.d(
      '$_logTag apply new country code : $newCountryCode : $countrySettings',
    );

    currentSettings = currentSettings!.copyWith(
      countryCode: drift.Value(newCountryCode),
      currencyCode: drift.Value(countrySettings.currencyIsoCode),
      waterUnit: drift.Value(countrySettings.volumeUnit),
      energyPrice: drift.Value(countrySettings.defaultKWhPrice),
      waterPrice: drift.Value(countrySettings.defaultWaterPrice),
    );
  }

  double? _convertToEuros(double? value) {
    if (value == null) return null;
    final code = getCurrencyCodeFromSymbol(
      currentSettings!.currencyCode ?? 'EUR',
    );
    return getEurosFromSymbol(value, code);
  }

  void onFieldChanged(Field field, dynamic value) {
    appLogger.d('$_logTag field "${field.toString()}" changed : $value');

    setState(() {
      switch (field) {
        case Field.countryCode:
          _applyCountryCodeToSettings(value as String?);
          break;
        case Field.currencyCode:
          currentSettings = currentSettings!.copyWith(
            currencyCode: drift.Value(value as String?),
          );
          break;
        case Field.waterUnit:
          currentSettings = currentSettings!.copyWith(
            waterUnit: drift.Value(value as String?),
          );
          break;
        case Field.waterPrice:
          currentSettings = currentSettings!.copyWith(
            waterPrice: drift.Value(_convertToEuros(value as double?)),
          );
          break;
        case Field.energyPrice:
          currentSettings = currentSettings!.copyWith(
            energyPrice: drift.Value(_convertToEuros(value as double?)),
          );
          break;
        case Field.heatingEnergy:
          currentSettings = currentSettings!.copyWith(
            heatingEnergy: drift.Value(value as double?),
          );
          break;
        case Field.minShowerLiter:
          currentSettings = currentSettings!.copyWith(
            minShowerLiter: (value as double).round(),
          );
          break;
      }

      formDomain.setChanges(currentSettings!.getChangesFrom(widget.settings));
      formDomain.updateErrors(_checkErrors());
    });
  }

  Map<String, String> _checkErrors() {
    final t = AppLocalizations.of(context)!;
    final errors = <String, String>{};

    _checkNumberField(Field.waterPrice, currentSettings?.waterPrice, errors, t);
    _checkNumberField(
      Field.energyPrice,
      currentSettings?.energyPrice,
      errors,
      t,
    );
    _checkNumberField(
      Field.heatingEnergy,
      currentSettings?.heatingEnergy,
      errors,
      t,
    );

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

  void _openFilteredCountryPickerDialog() => showCountryPicker(
    context: context,
    countryListTheme: CountryListThemeData(
      flagSize: 25,
      backgroundColor: Colors.white,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15.0),
        topRight: Radius.circular(15.0),
      ),
    ),
    onSelect: (Country newCountry) {
      final code = newCountry.countryCode;
      final newCountryCode =
          code.contains('-') ? code.substring(0, code.indexOf('-')) : code;
      onFieldChanged(Field.countryCode, newCountryCode);
    },
    favorite: AppConstants.countrySettingsbyCountryCode.keys.toList(),
  );

  Widget _buildActionRow({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) =>
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 5,
          ), // zone cliquable maîtrisée
          child: Row(
            children: [
              Icon(icon, size: 20, color: Colors.white),
              const SizedBox(width: 5),
              Text(
                label,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final bottomActions = buildBottomActions();

    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildImportDataSection(),
          const SizedBox(height: 12),
          buildCountrySection(),
          const SizedBox(height: 12),
          buildCurrencyAndUnitSection(),
          const SizedBox(height: 12),
          buildSavingsSection(),
          const SizedBox(height: 12),
          buildStatisticsSection(),
          if (widget.canBackup) ...[
            const SizedBox(height: 12),
            buildExportDataSection(),
          ],
          if (bottomActions != null) ...[
            const SizedBox(height: 16),
            bottomActions,
          ],
        ],
      ),
    );
  }

  Widget buildImportDataSection() {
    final t = AppLocalizations.of(context)!;

    return CustomExpansionTile(
      backgroundColor: Theme.of(context).colorScheme.primary.lighten(0.3),
      foregroundColor: Colors.white,
      expanded: true,
      expandable: false,
      globalPadding: 10,
      title: t.configAppImportSectionTitle,
      children: [
        _buildActionRow(
          icon: Icons.cloud_download,
          label: t.configAppImportFromCloud,
          onTap: () => widget.onImportBackup(From.cloud),
        ),
        const SizedBox(height: 10),
        _buildActionRow(
          icon: Icons.file_download,
          label: t.configAppImportFromBackupFile,
          onTap: () => widget.onImportBackup(From.file),
        ),
      ],
    );
  }

  Widget buildExportDataSection() {
    final t = AppLocalizations.of(context)!;

    return CustomExpansionTile(
      backgroundColor: Theme.of(context).colorScheme.primary.lighten(0.3),
      foregroundColor: Colors.white,
      expanded: true,
      expandable: false,
      globalPadding: 10,
      title: t.configAppExportSectionTitle,
      children: [
        _buildActionRow(
          icon: Icons.file_upload,
          label: t.configAppExportToBackupFile,
          onTap: () => widget.onCreateBackup?.call(),
        ),
      ],
    );
  }

  Widget buildCountrySection() {
    final t = AppLocalizations.of(context)!;

    return CustomExpansionTile(
      expanded: true,
      expandable: false,
      globalPadding: 10,
      title: t.configAppCountrySectionTitle,
      children: [
        Container(
          width: 180,
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black12),
          ),
          child: InkWell(
            onTap: _openFilteredCountryPickerDialog,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    Country.tryParse(
                          currentSettings?.countryCode ?? '',
                        )?.displayNameNoCountryCode ??
                        '-',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCurrencyAndUnitSection() {
    final t = AppLocalizations.of(context)!;

    return CustomExpansionTile(
      expanded: true,
      expandable: false,
      globalPadding: 10,
      title: t.configAppUnitSectionTitle,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 120,
              child: buildDropdownField(
                currentSettings!.currencyCode!,
                currencySymbol,
                (newCurrencyCode) {
                  onFieldChanged(Field.currencyCode, newCurrencyCode);
                },
              ),
            ),
            SizedBox(
              width: 120,
              child: buildDropdownField(
                currentSettings!.waterUnit!,
                waterUnits,
                (newWaterUnit) {
                  onFieldChanged(Field.waterUnit, newWaterUnit);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSavingsSection() {
    final t = AppLocalizations.of(context)!;

    final currency = currencySymbol[currentSettings?.currencyCode] ?? '€';
    final volumePriceUnit = getWaterUnitForPrice(currentSettings!.waterUnit!);
    final waterPriceUnit = '$currency/$volumePriceUnit';
    final energyUnit = AppConstants.symbolKilowattHour;
    final energyPriceUnit = '$currency/$energyUnit';

    return CustomExpansionTile(
      expanded: true,
      expandable: false,
      globalPadding: 10,
      title: t.configAppSavingsSectionTitle,
      children: [
        buildDoubleField(
          currentSettings?.waterPrice,
          (newWaterPrice) {
            onFieldChanged(Field.waterPrice, newWaterPrice);
          },
          label: t.configAppWaterPriceField,
          unit: waterPriceUnit,
          errorMessage: formDomain.getFieldError(Field.waterPrice.toString()),
        ),
        buildDoubleField(
          currentSettings?.energyPrice,
          (newEnergyPrice) {
            onFieldChanged(Field.energyPrice, newEnergyPrice);
          },
          label: t.configAppEnergyPriceField,
          unit: energyPriceUnit,
          errorMessage: formDomain.getFieldError(Field.energyPrice.toString()),
        ),
        buildDoubleField(
          currentSettings?.heatingEnergy,
          (newHeatingEnergy) {
            onFieldChanged(Field.heatingEnergy, newHeatingEnergy);
          },
          label: t.configAppEnergyField,
          unit: energyUnit,
          infoMessage: t.configAppEnergyHelp,
          errorMessage: formDomain.getFieldError(
            Field.heatingEnergy.toString(),
          ),
        ),
      ],
    );
  }

  Widget buildStatisticsSection() {
    final t = AppLocalizations.of(context)!;

    final minShowerLiter = getVolumeForUnit(
      currentSettings!.minShowerLiter.toDouble(),
      currentSettings!.waterUnit!,
    );
    final minShowerLiterText =
        '${formatVolume(minShowerLiter)} ${currentSettings!.waterUnit!}';

    return CustomExpansionTile(
      expanded: true,
      expandable: false,
      globalPadding: 10,
      title: t.configAppStatsSectionTitle,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(t.configAppShowerIgnored),
                const SizedBox(width: 2),
                Text(
                  minShowerLiterText,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            buildSliderField(
              currentSettings!.minShowerLiter.toDouble(),
              0,
              10,
              1,
              (newMinShowerLiter) {
                onFieldChanged(Field.minShowerLiter, newMinShowerLiter);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget? buildBottomActions() {
    final t = AppLocalizations.of(context)!;

    if (!widget.canReset) return null;

    return FractionallySizedBox(
      widthFactor: 0.9,
      child: TextButton(
        onPressed: () async {
          final result = await showConfirmDialog(
            context: context,
            message: t.confirmResetApp,
          );
          if (result) widget.onReset?.call();
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
        child: Text(
          t.deleteAllData.toUpperCase(),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
