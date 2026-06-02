import 'dart:math';

import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';

class AppConstants {
  // --- app

  static const String apiUrl = "https://api.hydrao.com";
  static const String apiKey = String.fromEnvironment(
    'API_KEY',
    defaultValue: 'NOT_FOUND',
  );

  static const contactUsEmail = "sav@hydrao.com";
  static const contactFormFrUrl =
      "https://forms.zohopublic.com/zohodocs1582/form/PageSAVB2CApplicatonFrancais/formperma/SndJZGV-blt_YdAwZd42xcXXeZdZvvs85E1iFfVnjSs";
  static const contactFormEnUrl =
      "https://forms.zohopublic.com/zohodocs1582/form/PageSAVB2CApplicationAnglais1/formperma/hmJfL4cpu-Xm-KKolu-GxNxOcRalbprcyngEEAeUsVk";

  static const prefixBackupFile =
      "hydrao_backup"; // ex backup file = hydrao_backup_<date>.json

  // --- default values

  static const minShowerLiter = 3;

  // not used yet
  static const calibration = 545;
  static const statsNbShowers = 200;
  static const previousFlowFixedShowerHead =
      12.0; // default previous flow for cereus
  static const previousFlowRainShower = 20.0; // default previous flow for yucca
  static const previousFlowShowerHead =
      12.0; // default previous flow for aloe / first
  static const previousFlowMixer = 12.0; // TODO à valider
  static const refShowerDuration = 300; // default duration in seconds
  static const soapingTimeInSeconds = 2 * 60; // 2 min 30 in theory

  static const symbolLiter = "L";
  static const symbolGallon = "gal";
  static const symbolCubicMeter = "m3";
  static const symbolCCF = "CCF"; // > 999 gal => CCF
  static const symbolLiterByMinute = "L/min";
  static const symbolGallonByMinute = "gal/min";
  static const symbolCelcius = "°C";
  static const symbolFahrenheit = "°F";
  static const symbolKilowattHour = "kWh";

  // --- HELP values

  static const helpScan = "scan";

  // --- BLE values

  static const bleScanTimeout = 20; // default scan duration in seconds
  static const bleConnectTimeout = 5;
  static const bleAutoConnectAfterTimeout = 10;
  static const bleLiveTick = 1; // read live each N seconds
  static const bleShowerheadName =
      "HYDRAO_SHOWER"; // ble filter name for showerheads
  static const bleOtaDeviceName = 'OTAServiceMgr'; // NOT USED

  // showerhead props
  static const bleServiceUuid =
      '180f'; // for discover showerhead service & caracteristics
  static const bleReadUuid = 'ca28';
  static const bleReadFirmware = '2a26';
  static const bleReadHardware = 'ca24';

  // showerhead settings
  static const bleReadWriteThreshold = 'ca1d';
  static const bleReadWriteCalibration = 'ca30';
  static const bleResetVolume = 'ca20'; // to reset soaping

  //
  static const bleWriteAskOta = 'ca1e';
  static const bleWriteReset = 'ca1f';
  static const bleWriteFwChecksum = 'ca1e';

  // showers
  static const bleReadHistoMinMax = 'ca21';
  static const bleWriteAskHisto = 'ca22';
  static const bleReadHisto = 'ca23';
  static const bleReadTotalLiter = 'ca1c';
  static const bleReadFlow = 'ca31';
  static const bleReadTemperature = 'ca32';
  static const bleReadVmot = 'ca27';

  // --- challenges / badges

  static const challengeGold = 20;
  static const challengeSilver = 35;

  // --- naming proposition

  static Map<String, List<String>> shDefaultNames = {
    "fr": [
      "Goutte Zen",
      "Pluie Douce",
      "Brume Magique",
      "Nuage Calme",
      "Source Tranquille",
      "Rivière Paisible",
      "Perle d’Eau",
      "Cascade Sérénité",
      "Brise d’Eau",
      "Rosée du Matin",
      "Source Claire",
      "Ruisseau Léger",
      "Onde Pure",
      "Clair de Goutte",
      "Éveil d’Eau",
      "Souffle de Pluie",
      "Lune Liquide",
      "Murmure d’Eau",
      "Voile de Brume",
      "Étoile d’Eau",
      "Silence d’Onde",
      "Pluie de Soie",
      "Halo d’Eau",
      "Nuit Apaisante",
      "Cocoon d’Eau",
      "Instant Calme",
      "Pause Cristalline",
      "Douce Évasion",
      "Sérénité Aqua",
      "Relax’O",
      "Bain de Nuage",
      "Harmonie d’Eau",
      "Petite Goutte Zen",
      "Dodo Pluie",
      "Nuage Douillet",
      "Pluie Câline",
      "Bulle Paisible",
      "Goutte Rêveuse",
      "Douce Pluie Magique",
      "Mini Source",
    ],
    "en": [
      "Gentle Stream",
      "Soft Rain",
      "Quiet Spring",
      "Calm Waters",
      "Pure Flow",
      "Light Drizzle",
      "Morning Dew",
      "Peaceful River",
      "Clear Source",
      "Whispering Stream",
      "Moon Water",
      "Dreamy Drops",
      "Silent Rain",
      "Misty Glow",
      "Cloud Whisper",
      "Starry Splash",
      "Velvet Rain",
      "Soft Horizon",
      "Twilight Flow",
      "Silver Drizzle",
      "Aqua Calm",
      "Zen Shower",
      "Pure Relax",
      "Tranquil Flow",
      "Easy Stream",
      "Serene Splash",
      "Calm Cascade",
      "Peace Drop",
      "Gentle Mist",
      "Harmony Flow",
      "Little Drop",
      "Cozy Cloud",
      "Snuggle Rain",
      "Happy Mist",
      "Tiny Splash",
      "Dream Drop",
      "Softy Shower",
      "Bubble Breeze",
      "Cuddle Flow",
      "Magic Mist",
    ],
  };

  static String getNextShName(String locale, Set<String> usedNames) {
    // Déterminer la langue
    String fixedLocale = locale == 'fr' ? 'fr' : 'en';
    List<String> names = shDefaultNames[fixedLocale]!;

    // Filtrer les noms qui n'ont pas encore été utilisés
    List<String> availableNames = names
        .where((name) => !usedNames.contains(name))
        .toList();

    final random = Random();

    if (availableNames.isNotEmpty) {
      // Si des noms sont encore disponibles, choisir un aléatoirement
      String newName = availableNames[random.nextInt(availableNames.length)];
      return newName;
    } else {
      // Si tous les noms sont utilisés, prendre un nom aléatoire et ajouter un index
      String baseName = names[random.nextInt(names.length)];

      // Trouver le plus petit index libre
      int index = 2;
      while (usedNames.contains("$baseName $index")) {
        index++;
      }

      return "$baseName $index";
    }
  }

  static const
  // --- Product types
  Map<String, String>
  typeImages = {
    'aloe': 'assets/images/aloe.png',
    'cereus': 'assets/images/cereus.png',
    'first': 'assets/images/first.png',
    'yucca': 'assets/images/yucca.png',
    'mixer': 'assets/images/vernet_mixer.png',
    'unknown': 'assets/images/showerhead_device.png',
  };

  static String getShIconFromType(String? shType) {
    if (shType == null) {
      return "assets/images/showerhead_device.png";
    }
    return typeImages[shType] ?? "assets/images/showerhead_device.png";
  }

  static Map<String, String> getTypeLabels(
    AppLocalizations t, {
    bool withUnknown = false,
    bool withOlds = false,
  }) {
    Map<String, String> labels = {
      'aloe': t.typeAloe,
      'cereus': t.typeCereus,
      'yucca': t.typeYucca,
    };
    if (withUnknown) {
      labels['unknown'] = t.typeUnknown;
    }
    if (withOlds) {
      labels['first'] = t.typeFirst;
      labels['mixer'] = t.typeMixer;
    }

    return labels;
  }

  static String getTypeLabel(AppLocalizations t, String? shType) {
    final types = getTypeLabels(t, withUnknown: true, withOlds: true);

    if (types.containsKey(shType)) {
      return types[shType]!;
    } else {
      return types['unknown']!;
    }
  }

  static double getDefaultFlowFromType(String type) {
    final Map<String, double> defaultFlow = {
      'aloe': AppConstants.previousFlowShowerHead,
      'cereus': AppConstants.previousFlowFixedShowerHead,
      'first': AppConstants.previousFlowShowerHead,
      'yucca': AppConstants.previousFlowRainShower,
      'mixer': AppConstants.previousFlowMixer,
    };

    return defaultFlow[type] ?? 12.0;
  }

  // --- Showerhead values

  static const shMinFlow = 5.5;
  static const shDefaultThresholdMaxLiter = 40.0;
  static const shDefaultThresholds =
      '[{"color": "#00FF00", "liter": 5.0},{"color": "#0000FF", "liter": 10.0},{"color": "#FF00FF", "liter": 15.0},{"color": "#FF0000", "liter": 20.0}]';
  static const shFakeHwVersion = 8;
  static const shFakeFwVersion = "99180910";
  static const shFakeOldUuid = "00000000-00000000-0000000";
  static const shFakeNewUuid = "00000000-0000-0000-0000-000000000000";
  static const shFakeThresholds1 =
      '[{"color": "#00FF00", "liter": 10.0},{"color": "#0000FF", "liter": 15.0},{"color": "#FF00FF", "liter": 25.0},{"color": "#FF0000", "liter": 30.0}]';
  static const shFakeThresholds2 =
      '[{"color": "#00FF00", "liter": 8.0},{"color": "#0000FF", "liter": 12.0},{"color": "#FF00FF", "liter": 18.0},{"color": "#FF0000", "liter": 23.0}]';
  static const shLearningThresholds =
      '[{"color": "#00FF00", "liter": 190.0},{"color": "#00FF00", "liter": 210.0},{"color": "#00FF00", "liter": 230.0},{"color": "#00FF00", "liter": 250.0}]'; //all green
  static const shMaxSoapingTimeInSeconds = 3 * 60;

  // --- Country values

  static const defaultCountryCode = "FR";
  static const defaultWaterUnit = "L";

  static const energyPrice = 0.28; // tarif règlementé energie
  static const waterPrice = 4.7; // varie selon les communes
  static const heatingEnergy = 0.0325;

  //TODO à revoir les valeurs
  static Map<String, CountrySettings> countrySettingsbyCountryCode = {
    'FR': CountrySettings(
      countryCode: 'FR',
      currencyIsoCode: 'EUR',
      volumeUnit: defaultWaterUnit,
      defaultWaterPrice: waterPrice,
      defaultKWhPrice: energyPrice,
    ),
    'US': CountrySettings(
      countryCode: 'US',
      currencyIsoCode: 'USD',
      volumeUnit: symbolGallon,
      defaultWaterPrice: 10.76,
      defaultKWhPrice: 0.10,
    ),
    'SG': CountrySettings(
      countryCode: 'SG',
      currencyIsoCode: 'SGD',
      volumeUnit: symbolLiter,
      defaultWaterPrice: 3.69,
      defaultKWhPrice: 0.22,
    ),
    'GB': CountrySettings(
      countryCode: 'GB',
      currencyIsoCode: 'GBP',
      volumeUnit: symbolLiter,
      defaultWaterPrice: 3.35,
      defaultKWhPrice: 0.14,
    ),
    'AU': CountrySettings(
      countryCode: 'AU',
      currencyIsoCode: 'AUD',
      volumeUnit: symbolLiter,
      defaultWaterPrice: 2.11,
      defaultKWhPrice: 0.24,
    ),
    'HK': CountrySettings(
      countryCode: 'HK',
      currencyIsoCode: 'HKD',
      volumeUnit: symbolLiter,
      defaultWaterPrice: 5,
      defaultKWhPrice: 1.17,
    ),
    'KR': CountrySettings(
      countryCode: 'KR',
      currencyIsoCode: 'KRW',
      volumeUnit: symbolLiter,
      defaultWaterPrice: 1545,
      defaultKWhPrice: 125,
    ),
    'CH': CountrySettings(
      countryCode: 'CH',
      currencyIsoCode: 'CHF',
      volumeUnit: symbolLiter,
      defaultWaterPrice: 1.5,
      defaultKWhPrice: 0.25,
    ),
  };

  static CountrySettings getCountrySettingsFromCountryCode(
    String? countryCode,
  ) {
    CountrySettings defaultSettings = countrySettingsbyCountryCode['FR']!;
    if (countryCode != null &&
        countrySettingsbyCountryCode.containsKey(countryCode)) {
      return countrySettingsbyCountryCode[countryCode]!;
    }

    return defaultSettings;
  }
}

class CountrySettings {
  final String countryCode;
  final String currencyIsoCode;
  final String volumeUnit;
  final double defaultWaterPrice;
  final double defaultKWhPrice;

  CountrySettings({
    required this.countryCode,
    required this.currencyIsoCode,
    required this.volumeUnit,
    required this.defaultWaterPrice,
    required this.defaultKWhPrice,
  });

  @override
  String toString() {
    return "CountrySettings(countryCode=$countryCode, currencyIsoCode=$currencyIsoCode, volumeUnit=$volumeUnit, defaultWaterPrice=$defaultWaterPrice)";
  }
}
