import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';

double? cleanDouble(String value) {
  return value.isNotEmpty ? double.tryParse(value.replaceAll(',', '.')) : null;
}

String? validateRequired(AppLocalizations t, dynamic value) {
  return value == null || value == "" ? t.formValidatorRequired : null;
}

String? validateNumberGreaterThan(
  AppLocalizations t,
  dynamic value,
  double minValue,
) {
  if (value is num && value <= minValue) {
    return t.formValidatorGreaterThan(minValue);
  }
  return null;
}

String? validateNumberLesserOrEqualThan(
  AppLocalizations t,
  dynamic value,
  double maxValue,
) {
  if (value is num && value > maxValue) {
    return t.formValidatorLesserOrEqualThan(maxValue);
  }
  return null;
}
