import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:hydrao_flutter_offline/constants.dart';
import 'package:hydrao_flutter_offline/models/threshold.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';
import 'package:hydrao_flutter_offline/utils.dart';

// --- water volume

Map<String, String> waterUnits = {
  AppConstants.symbolLiter: AppConstants.symbolLiter,
  AppConstants.symbolGallon: AppConstants.symbolGallon,
};

double getVolumeForUnit(double volumeInLiters, String unit) {
  switch (unit) {
    case AppConstants.symbolGallon:
      return litersToGallon(volumeInLiters);
    default:
      return volumeInLiters;
  }
}

double getLitersFromUnit(double volumeInUnit, String unit) {
  switch (unit) {
    case AppConstants.symbolGallon:
      return gallonsToLiters(volumeInUnit);
    default:
      return volumeInUnit;
  }
}

double litersToGallon(double volumeInLiters) {
  return volumeInLiters == 0
      ? 0
      : (volumeInLiters * 0.264172 * 10).round() / 10;
}

double gallonsToLiters(double volumeInGallons) {
  return volumeInGallons == 0
      ? 0
      : (volumeInGallons * 3.78541 * 10).round() / 10;
}

String getWaterUnitForPrice(String waterUnit) {
  return waterUnit == AppConstants.symbolGallon
      ? AppConstants.symbolCCF
      : AppConstants.symbolCubicMeter;
}

Map<String, String> getLiterChoicesForUnit(
  int minLiters,
  int maxLiters,
  String unit,
) {
  Map<String, String> choices = {};

  switch (unit) {
    case AppConstants.symbolGallon:
      for (
        double i = _toHalfDouble(maxLiters.toDouble() * 0.264);
        i >= _toHalfDouble(minLiters.toDouble() * 0.264);
        i -= 0.5
      ) {
        int liter = (i * 3.78541).round();
        var formattedLiter = formatVolume(i);
        choices["$liter"] = "$formattedLiter $unit";
      }
      break;
    default:
      for (var i = maxLiters; i >= minLiters; i--) {
        var formattedLiter = formatVolume(i.toDouble());
        choices["$i"] = "$formattedLiter $unit";
      }
      break;
  }

  return choices;
}

double _toHalfDouble(double input) {
  int intVal = input.floor();
  double doubleVal = input - intVal;
  double adjustedValue;
  if (doubleVal < 0.25) {
    adjustedValue = intVal.toDouble();
  } else if (doubleVal >= 0.25 && doubleVal < 0.75) {
    adjustedValue = intVal + 0.5;
  } else {
    adjustedValue = intVal.toDouble() + 1;
  }
  return adjustedValue;
}

// --- water flow

String getFlowUnitSymbol(String volumeUnit) {
  switch (volumeUnit) {
    case AppConstants.symbolGallon:
      return AppConstants.symbolGallonByMinute;
    default:
      return AppConstants.symbolLiterByMinute;
  }
}

// --- temperature

double getTemperatureForUnit(double temperatureInCelcius, String unit) {
  switch (unit) {
    case AppConstants.symbolFahrenheit:
      return celciusToFahrenheit(temperatureInCelcius);
    default:
      return temperatureInCelcius;
  }
}

double celciusToFahrenheit(double temperatureInCelcius) {
  return temperatureInCelcius == 0
      ? 0
      : ((temperatureInCelcius * 1.8 + 32) * 10).round() / 10;
}

// --- currencies

// --- Currencies conversion rate from euro
// from : https://www.xe.com/currencycharts/?from=EUR&to=HKD
// take average rate on a year
Map<String, double> currencyConversionRate = {
  "USD": 1.15,
  "SGD": 1.5,
  "GBP": 0.86,
  "AUD": 1.65,
  "HKD": 8.9,
  "KRW": 1.65,
  "CHF": 0.92,
};

Map<String, String> currencySymbol = {
  "EUR": '€',
  "USD": '\$',
  "SGD": 'SGP\$',
  "GBP": '£',
  "AUD": 'AU\$',
  "HKD": 'HK\$',
  "KRW": '₩',
  "CHF": 'CHF',
};

String getSymbolFromCurrencyCode(String currencyCode) {
  return currencySymbol[currencyCode] ?? '€';
}

String getCurrencyCodeFromSymbol(String symbol) {
  return currencySymbol.entries
      .firstWhere(
        (entry) => entry.value == symbol,
        orElse: () => const MapEntry('', ''),
      )
      .key;
}

// convert from euros to userCurrency
double getCurrencyFromSymbol(double euros, String symbol) {
  final currencyCode = getCurrencyCodeFromSymbol(symbol);
  if (currencyCode == '' || currencyCode == 'EUR') return euros;

  final conversionRate = currencyConversionRate[currencyCode];
  if (conversionRate == null) return euros;

  return euros * conversionRate;
}

// convert from userCurrency to euros (for DB Storage)
double getEurosFromSymbol(double money, String symbol) {
  if (money == 0) return money;

  final currencyCode = getCurrencyCodeFromSymbol(symbol);
  if (currencyCode == '' || currencyCode == 'EUR') return money;

  final conversionRate = currencyConversionRate[currencyCode];
  if (conversionRate == null) return money; // already euros

  return money / conversionRate;
}

// --- thresholds

List<HydraoThreshold>? thresholdsFromJson(String? thresholdsJsonString) {
  if (thresholdsJsonString == null) return null;

  try {
    // 1. Décoder en List<dynamic> (ce que renvoie réellement json.decode)
    final List<dynamic> decoded =
        json.decode(thresholdsJsonString) as List<dynamic>;

    // 2. Transformer chaque élément en Map de manière sécurisée
    return decoded
        .map((e) => HydraoThreshold.fromJson(e as Map<String, dynamic>))
        .toList();
  } catch (e) {
    // En cas d'erreur de format JSON ou de structure, on renvoie une liste vide
    return [];
  }
}

String thresholdsToJson(List<HydraoThreshold> thresholds) {
  final List<Map<String, dynamic>> data = thresholds
      .map((t) => t.toJson())
      .toList();
  return json.encode(data);
}

bool thresholdsHasChanged(
  List<HydraoThreshold>? currentThresholds,
  List<HydraoThreshold> newThresholds,
) {
  if (currentThresholds == null) {
    return newThresholds.length == 4;
  }
  // order thresholds by liters
  currentThresholds.sort((t1, t2) => t1.liter.compareTo(t2.liter));
  newThresholds.sort((t1, t2) => t1.liter.compareTo(t2.liter));

  return !listEquals(currentThresholds, newThresholds);
}

double? getThresholdsMaxVolume(List<HydraoThreshold> thresholds) {
  if (thresholds.isEmpty) return null;

  final sorted = [...thresholds]..sort((a, b) => a.liter.compareTo(b.liter));

  return sorted.last.liter;
}

Color getDisplayColorFromThresholdColor(ThresholdColor color) {
  // UI colors from threshold colors => less flashy

  switch (color) {
    case ThresholdColor.black:
      return Color(0xFF000000);
    case ThresholdColor.lightGreen:
      return Color(0xFF83B663);
    case ThresholdColor.green:
      return Color(0xFF52A684);
    case ThresholdColor.lightBlue:
      return Color(0xFF49ABBF);
    case ThresholdColor.blue:
      return Color(0xFF008DCC);
    case ThresholdColor.purple:
      return Color(0xFFBC59AF);
    case ThresholdColor.red:
      return Color(0xFFDC2926);
    case ThresholdColor.orange:
      return Color(0xFFF36F16);
    case ThresholdColor.yellow:
      return Color(0xFFE3A003);
  }
}

ThresholdColor getThresholdColorFromHexa(String hexaColor) {
  final color = hexaColor.replaceFirst('#', '');

  switch (color) {
    case '67FF11':
      return ThresholdColor.lightGreen;
    case '00FF00':
      return ThresholdColor.green;
    case '0AD2F0':
    case '4CDDF1':
      return ThresholdColor.lightBlue;
    case '0000FF':
      return ThresholdColor.blue;
    case 'FF00B4':
    case 'FF00FF':
      return ThresholdColor.purple;
    case 'FF0000':
      return ThresholdColor.red;
    case 'FF5000':
    case 'FF7100':
      return ThresholdColor.orange;
    case 'FAB900':
    case 'FFDE1A':
      return ThresholdColor.yellow;
    default:
      return ThresholdColor.black;
  }
}

String getHexaColorFromThresholdColor(ThresholdColor color) {
  switch (color) {
    case ThresholdColor.black:
      return '#000000';
    case ThresholdColor.lightGreen:
      return '#67FF11';
    case ThresholdColor.green:
      return '#00FF00';
    case ThresholdColor.lightBlue:
      return '#0AD2F0';
    case ThresholdColor.blue:
      return '#0000FF';
    case ThresholdColor.purple:
      return '#FF00B4';
    case ThresholdColor.red:
      return '#FF0000';
    case ThresholdColor.orange:
      return '#FF5000';
    case ThresholdColor.yellow:
      return '#FAB900';
  }
}

// --- raw BLE values

double? rawTempToCelciusTemp(int? rawTemp) {
  if (rawTemp == null) return null;

  if (rawTemp > 0) {
    if (rawTemp > 3000) {
      return null; // temp sensor missing
    } else if (rawTemp <= 100) {
      return rawTemp / 2; // A verifier
    } else {
      return -0.02635 * (rawTemp * 16) + 79.48293;
    }
  }
  return null;
}

double? rawFlowToLitersByMinuteFlow(
  int? rawFlow,
  int calibration,
  int? hwVersion,
) {
  if (hwVersion != null && hwVersion < 8) {
    return 6.8;
  } else if (rawFlow != null) {
    return (1000 * 60 * 20) / (calibration * rawFlow);
  }
  return null;
}

double computeDuration(int volume, double flow) {
  if (volume == 0 || flow == 0) {
    return 0;
  } else {
    return ((volume / flow) * 60).round().toDouble();
  }
}

// ---- showers

double? getAverageVolumeFromShowers(List<Shower> showers) {
  if (showers.isEmpty) return null;
  final total = showers.fold<int>(0, (sum, s) => sum + s.volume);
  return total / showers.length;
}
