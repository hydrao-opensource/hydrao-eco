// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get defaultScreenTitle => 'Hydrao';

  @override
  String get typeAloe => 'Aloe';

  @override
  String get typeCereus => 'Cereus';

  @override
  String get typeYucca => 'Yucca';

  @override
  String get typeFirst => 'First';

  @override
  String get typeMixer => 'Mixer';

  @override
  String get typeUnknown => 'Not defined';

  @override
  String get newShowerheadLabel => 'Showerhead';

  @override
  String get defaultShowerheadName => 'Hydrao Showerhead';

  @override
  String get addShTitle => 'Add a showerhead';

  @override
  String get bluetoothDisabled => 'our Bluetooth is turned off. Please enable it before continuing.';

  @override
  String get openBluetoothSettings => 'Open Settings';

  @override
  String get showerheadDetectionBlocked => 'Your Bluetooth is turned off. Please enable it before continuing.';

  @override
  String get allowPermissions => 'Allow permissions';

  @override
  String get enableBluetooth => 'Please enable Bluetooth in the settings';

  @override
  String get showerheadNotDetected => 'Your showerhead isn’t detected?';

  @override
  String get addShScanningText => 'Keep the app open and turn on the water of the showerhead to be installed.';

  @override
  String get addShConnectingText => 'Connecting...';

  @override
  String get addShBackWarningMessage => 'Your showerhead has not been added yet!\n\nAre you sure you want to exit?';

  @override
  String get connectedShStopWater => 'Please turn off the water before continuing';

  @override
  String get addShConnectedText => 'The showerhead has been successfully detected';

  @override
  String get addShConnectedWarningFlowTitle => 'Low flow rate detected';

  @override
  String get addShConnectedWarningFlowMessage => 'If a flow reducer is installed,\nplease remove it.';

  @override
  String get needHelpToInstall => 'Need help installing the showerhead?';

  @override
  String get helpShNotDetectedDialogTitle => 'Showerhead not detected ?';

  @override
  String get helpShNotDetectedNeedShowerSectionTitle => 'During a shower';

  @override
  String get helpShNotDetectedNeedShowerWaterText => 'The showerhead has no battery, so it needs a sufficient water flow to communicate.';

  @override
  String get helpShNotDetectedNeedShowerLightsText => 'The lights on the showerhead must be on.';

  @override
  String get helpShNotDetectedBleSectionTitle => 'Bluetooth (BLE)';

  @override
  String get helpShNotDetectedBleCompatibilityText => 'Your phone must be compatible with Bluetooth 4.0 or higher.';

  @override
  String get helpShNotDetectedBleServiceText => 'The Bluetooth service must be enabled.';

  @override
  String get helpShNotDetectedBlePermissionText => 'The app must have location permission to detect the showerhead.';

  @override
  String get helpShNotDetectedBleRangeText => 'The phone should ideally be within 3 meters of the showerhead.';

  @override
  String get helpShNotDetectedConflictSectionTitle => 'Conflict risk';

  @override
  String get helpShNotDetectedConflictOnlyOneDevieText => 'The showerhead can only connect to one device at a time.';

  @override
  String get helpShNotDetectedConflictGateway => 'If you are using a gateway, please temporarily unplug it.';

  @override
  String get helpRemoveFlowRestrictorDialogTitle => 'In case of low flow';

  @override
  String get helpRemoveFlowRestrictorDialogIssuesSection => 'Low flow may affect the proper functioning of the showerhead lights as well as shower synchronization';

  @override
  String get helpRemoveFlowRestrictorDialogRemoveSection => 'Check whether your showerhead has a flow restrictor installed.\n\nIf so, please remove it.';

  @override
  String get installNewShowerhead => 'Install the new showerhead';

  @override
  String get installNewShText => 'To begin,\nyou need to install your new showerhead.';

  @override
  String get installNewShProduct => 'Product';

  @override
  String partialDetectedShSectionTitle(int count) {
    return '$count detected showerhead(s)';
  }

  @override
  String dashboardShowerheadsSectionTitle(int count) {
    return 'My showerheads ($count)';
  }

  @override
  String dbShowerheadCardOnShowers(int count) {
    return '$count showers';
  }

  @override
  String get dbShowerheadCardNewThresholds => 'New thresholds to be sent to the showerhead';

  @override
  String get dbShowerheadCardLearning => 'Learning in progress';

  @override
  String get dbShowerheadCardLearningStart => 'Sync to start the learning period';

  @override
  String get dbShowerheadCardSyncPartial => 'incomplete';

  @override
  String get dbShowerheadCardSynUpToDate => 'up to date';

  @override
  String get dbShowerheadCardSyncToDo => 'Synchronization pending';

  @override
  String get dbShowerheadCardNoShower => 'No showers';

  @override
  String get dbShowerheadCardAverageVol => 'Avg.';

  @override
  String get statsShowerheadCardAverageVol => 'Avg.';

  @override
  String get statsShowerheadCardShowShowers => 'Showers';

  @override
  String get statsShowerheadCardHideShowers => 'Hide';

  @override
  String get statsShowerheadCardGoldBadge => 'Gold';

  @override
  String get statsShowerheadCardSilverBadge => 'Silver';

  @override
  String get statsShowerheadCardBronzeBadge => 'Bronze';

  @override
  String get statsShowerheadCardBadgeTootipLiter => 'The badge represents the challenge level achieved:\n\nGold = Average volume below 20 L\n\nSilver = Average volume between 20 L and 35 L\n\nBronze = Average volume above 35 L';

  @override
  String get statsShowerheadCardBadgeTootipGallon => 'The badge represents the challenge level achieved:\n\nGold = Average volume below 5.3 gallons\n\nSilver = Average volume between 5.3 and 9.2 gallons\n\nBronze = Average volume above 9.2 gallons';

  @override
  String get statsShowerheadCardSavings => 'Savings';

  @override
  String get statsShowerheadCardOnNVolume => 'On';

  @override
  String get begin => 'Begin';

  @override
  String get beginAgain => 'Start again';

  @override
  String get stop => 'Stop';

  @override
  String get close => 'Close';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get deleteAllData => 'Reset the application';

  @override
  String get add => 'Add';

  @override
  String get toContinue => 'Continue';

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get choose => 'Choose';

  @override
  String get share => 'Share';

  @override
  String get unselect => 'Unselect';

  @override
  String get filter => 'Filter';

  @override
  String get import => 'Import';

  @override
  String get export => 'Export';

  @override
  String get merge => 'Merge';

  @override
  String get erase => 'Erase';

  @override
  String get send => 'Send';

  @override
  String get reset => 'Reset';

  @override
  String get takeAPhoto => 'Take a photo';

  @override
  String get login => 'Log in';

  @override
  String get logout => 'Log out';

  @override
  String get fromGallery => 'Choose from gallery';

  @override
  String get fromFiles => 'Choose from files';

  @override
  String get connecting => 'Connecting...';

  @override
  String get formValidatorRequired => 'Required field';

  @override
  String formValidatorGreaterThan(double value) {
    return 'The value must be greater than $value';
  }

  @override
  String formValidatorLesserOrEqualThan(double value) {
    return 'The value must be less than or equal to $value';
  }

  @override
  String get iNeedHelp => 'I need help';

  @override
  String get loginDialogTitle => 'My Hydrao account';

  @override
  String get loginFormFailMessage => 'Login failed, please check your credentials';

  @override
  String get loginFormEmailField => 'Email';

  @override
  String get loginFormPasswordField => 'Password';

  @override
  String get formContactUsDialogTitle => 'Contact form';

  @override
  String get contactUsDialogTitle => 'Contact us';

  @override
  String get contactUsNeedHelpSection => 'Need help?';

  @override
  String get contactUsNeedHelpText => 'Provide us with some information so we can better answer your question';

  @override
  String get contactUsSupportNeedDataSection => 'At the support team\'s request';

  @override
  String get contactUsSupportNeedDataText => 'If the support team asks you for technical or usage data to help resolve your issue.';

  @override
  String get contactUsMessageHint => 'Write your message here...';

  @override
  String get contactUsAllowShareTechData => 'I authorize the sharing of technical data';

  @override
  String get contactUsAllowShareUserData => 'I authorize the sharing of my data (an export)';

  @override
  String get contactUsNoDataSharedConfirm => 'You have chosen not to share any data (technical & usage).\n\nThis will make it harder for the Support team to provide you with the best possible assistance.\n\nAre you sure you want to continue?';

  @override
  String get moreScreenFaqMenuItem => 'Frequently Asked Questions';

  @override
  String get moreScreenLegalNoticeMenuItem => 'Legal notice';

  @override
  String get moreScreenContactUsMenuItem => 'Contact us';

  @override
  String get shInstalled => 'My showerhead is installed';

  @override
  String get showerFinished => 'I’ve finished my shower';

  @override
  String get confirmCloseFormWithChanges => 'You have unsaved changes.\n\nAre you sure you want to continue?';

  @override
  String get confirmDeleteSh => 'This showerhead will be forgotten on this phone. All synchronized showers will be deleted.\n\nOnly the showers stored in the showerhead will be kept.\n\nAre you sure you want to continue?';

  @override
  String get confirmResetApp => 'All data (showerheads, synchronized showers, settings) will be deleted.\n\nOnly the showers stored in the showerheads will be kept.\n\nAs a reminder, you can create a backup of the application data.\n\nAre you sure you want to continue with the reset?';

  @override
  String get confirmCloseApp => 'Are you sure you want to exit the application?';

  @override
  String get editShThresholdsDialogTitle => 'Threshold configuration';

  @override
  String get importBackupDialogTitle => 'Import';

  @override
  String get importBackupCloudSectionTitle => 'My Hydrao account';

  @override
  String get importBackupCloudNoEmail => 'Not provided';

  @override
  String get importBackupCloudDownloadingBackup => 'Downloading data...';

  @override
  String get importBackupCloudDownloadFailed => 'Download failed';

  @override
  String get importBackupSelectDataToImport => 'Select data to import';

  @override
  String get createBackupDialogTitle => 'Application backup';

  @override
  String get shareBackupSubject => 'Hydrao backup';

  @override
  String get shareBackupMessage => 'Here is an export of the Hydrao application data.';

  @override
  String get configShDialogTitle => 'Set up the showerhead';

  @override
  String get configShMergeNotice => 'This showerhead already exists in your list with a different identifier.';

  @override
  String get configShSavingsSectionTitle => 'Savings calculation';

  @override
  String get configShThresholdsSectionTitle => 'Color / consumption';

  @override
  String get configShNewThresholdsSyncMessage => 'The new thresholds will be sent to the showerhead during the next shower synchronized with your device.';

  @override
  String get configShThresholdsLearningMessage => 'During the learning period, thresholds are disabled so as not to influence your habits.';

  @override
  String get configShThresholdsCurrent => 'Current thresholds';

  @override
  String get configShThresholdsNewToApply => 'New thresholds to apply';

  @override
  String get configShOldShFlowField => 'Old showerhead flow rate';

  @override
  String get configShRefShowerDurationField => 'Reference shower';

  @override
  String get configShRefShowerDurationHelp => 'This is the average shower duration during the learning period (or 5 minutes by default).';

  @override
  String get configShLearningSectionTitle => 'Learning';

  @override
  String get configShLearningLastShowerExcluded => 'The most recent shower is not taken into account';

  @override
  String get configShLearningStartWarning => 'The learning period will start at the next synchronization.\n\nThe showerhead lights will turn solid green.\n\nTo complete this process, you will need to reconnect to the app and wait for the full synchronization.\n\nDo you want to continue?';

  @override
  String get configShLearningStartHelp => 'Remember to save and synchronize to get the green thresholds';

  @override
  String get configShLearningRunningHelp => 'Remember to synchronize your showers';

  @override
  String get configShLearningFirstTimeMessage => 'We need to get to know you better to help you save water. Start the learning process!';

  @override
  String get configShLearningInPeriodMessage => 'Take at least one shower per person using this showerhead. You can stop the learning process manually at any time.';

  @override
  String configShLearningRefShowersCount(int count) {
    return '$count shower(s)';
  }

  @override
  String get configShLearningStarted => 'Started';

  @override
  String get configShLearningEnded => 'Completed';

  @override
  String get configShTechnicalSectionTitle => 'Technical information';

  @override
  String get configShNameExistsError => 'This name is already in use';

  @override
  String get configShLastConnectionSectionTitle => 'Last connection';

  @override
  String get configShLastConnectionFlowRate => 'Water flow rate';

  @override
  String get configShFlowQualityGood => 'Good';

  @override
  String get configShFlowQualityLow => 'Weak';

  @override
  String get configShTechnicalUuidField => 'Uuid';

  @override
  String get configShTechnicalFwVersionField => 'Firmware';

  @override
  String get configShTechnicalHwVersionField => 'Hardware';

  @override
  String get finishLearningPeriodRefShowerSectionTitle => 'Reference showers';

  @override
  String get finishLearningPeriodNoRefShower => 'No reference showers were recorded during the learning period';

  @override
  String get finishLearningPeriodChooseRefShower => 'Choose the showers to be taken into account for calculating the reference duration and the challenge';

  @override
  String get finishLearningPeriodNewThresholdsSectionTitle => 'New thresholds';

  @override
  String get finishLearningPeriodNewThresholdsCurrent => 'Current thresholds';

  @override
  String get finishLearningPeriodNewThresholdsNew => 'Proposed new thresholds';

  @override
  String get finishLearningPeriodNewThresholdsMessage => 'These new thresholds are calculated from the selected reference showers';

  @override
  String get finishLearningPeriodNewThresholdsAccept => 'I accept the proposed new thresholds';

  @override
  String get finishLearningPeriodRefDurationSectionTitle => 'Reference duration';

  @override
  String get finishLearningPeriodRefDurationMessage => 'This duration is used as the basis for savings calculation';

  @override
  String get stopLearningPeriodDialogTitle => 'Stop learning';

  @override
  String get configAppScreenTitle => 'Preferences';

  @override
  String get configAppDialogTitle => 'Edit my preferences';

  @override
  String get configAppImportSectionTitle => 'Import my data from...';

  @override
  String get configAppImportFromCloud => 'My Hydrao account';

  @override
  String get configAppImportFromBackupFile => 'A backup';

  @override
  String get configAppExportSectionTitle => 'Export my data to...';

  @override
  String get configAppExportToBackupFile => 'A backup';

  @override
  String get configAppCountrySectionTitle => 'Country';

  @override
  String get configAppUnitSectionTitle => 'Currency & unit';

  @override
  String get configAppSavingsSectionTitle => 'Savings calculation';

  @override
  String get configAppWaterPriceField => 'Water price';

  @override
  String get configAppEnergyPriceField => 'Energy price';

  @override
  String get configAppEnergyField => 'Energy';

  @override
  String get configAppEnergyHelp => 'This refers to the energy required to heat 1 liter of water.';

  @override
  String get configAppStatsSectionTitle => 'Statistics';

  @override
  String get configAppShowerIgnored => 'Ignore showers shorter than';

  @override
  String get createBackupFileCreated => 'A backup of the application data has been created in this file:';

  @override
  String get importBackupWrongFile => 'This file does not contain a backup.';

  @override
  String get importBackupMinContentError => 'You must select at least one item to start the import.';

  @override
  String get importBackupVersionWarning => 'The data comes from a previous version of the application; some data may be missing during the import.';

  @override
  String get importBackupOsChangeWarning => 'The data appears to come from another operating system. To ensure proper detection of the showerheads, you will need to go through adding the showerhead again and merge.';

  @override
  String get importBackupDataSourceSectionTitle => 'Data source';

  @override
  String get importBackupFromFileField => 'From a file';

  @override
  String get importBackupSettingsSectionTitle => 'Preferences';

  @override
  String get importBackupShowerNone => 'None';

  @override
  String importBackupShowerNewCount(int count) {
    return '$count new';
  }

  @override
  String get importBackupShowerhead => 'Showerhead';

  @override
  String get importBackupShowers => 'Showers';

  @override
  String get importBackupNewStatus => 'new';

  @override
  String get importBackupConflictStatus => 'conflict';

  @override
  String get importBackupNoChangeStatus => 'no change';

  @override
  String get dashboardScreenTitle => 'Dashboard';

  @override
  String get dashboardSavingSectionTitle => 'Overall savings';

  @override
  String get dashboardSavingSectionDescription => 'Across all products, for all periods combined.';

  @override
  String get dashboardLiveResetVolume => 'Preparing a new shower';

  @override
  String get dashboardLiveSendThresholds => 'Sending thresholds';

  @override
  String get dashboardLiveSyncShowers => 'Shower synchronization';

  @override
  String get dashboardLiveShowerInProgress => 'Shower in progress';

  @override
  String get dashboardSoapingInProgress => 'Soaping in progress';

  @override
  String get dashboardScanningText => 'Keep the app open for immediate synchronization or sync your showers later';

  @override
  String get dashboardScanningShStoreShowers => 'The showerhead stores up to 200 showers';

  @override
  String get statisticsScreenGlobalCardTitle => 'Tous les produits';

  @override
  String get statisticsScreenFilterAll => 'Across all showers';

  @override
  String statisticsScreenFilterOnLastShowers(int count) {
    return 'Over the last $count showers';
  }

  @override
  String get showerVolumeBarchartNoShowerTitle => 'No showers to display';

  @override
  String get showerVolumeBarchartNoShowerMessage => 'Start using your showerhead and you will see your showers appear here.';

  @override
  String get showerVolumeBarchartSeeNextShowers => 'View next showers';

  @override
  String get showerVolumeBarchartSeePreviousShowers => 'View previous showers';

  @override
  String shStatisticsDialogTitle(String sh) {
    return 'Showers of $sh';
  }

  @override
  String get shStatisticsSelectShowerAdvice => 'Select a shower to view details.';

  @override
  String get shStatisticsCancelSelection => 'Selection';

  @override
  String get shStatisticsAverageVolumeMetric => 'Average vol.';

  @override
  String get shStatisticsWaterSavingsMetric => 'Water saved';

  @override
  String get shStatisticsMoneySavingsMetric => 'Savings';

  @override
  String get shStatisticsShowerVolumeMetric => 'Volume';

  @override
  String get shStatisticsShowerTemperatureMetric => 'Temperature';

  @override
  String get shStatisticsShowerDurationMetric => 'Duration';

  @override
  String get shStatisticsShowerSoapingMetric => 'Soaping';

  @override
  String get shStatisticsShowerSyncedAt => 'Synchronized on';

  @override
  String get shStatisticsShowersSyncedAt => 'Synchronized on';

  @override
  String get shStatisticsShowersSyncedInPeriod => 'Synchronized';

  @override
  String get shStatisticsShowersSyncedPartially => 'Synch. incomplete';

  @override
  String get shStatisticsShowerSelected => 'Shower';

  @override
  String get shStatisticsLiveShowerSelected => 'Last shower';

  @override
  String shStatisticsCountShowers(int count) {
    return '$count shower(s)';
  }

  @override
  String get shStatisticsNoFilteredShower => 'No showers match the filters';

  @override
  String get shStatisticsNoFilteredShowerMessage => 'Please modify or clear the filters to see the showers.';

  @override
  String get shStatisticsShowersAvgVolume => 'avg. volume';

  @override
  String get shStatisticsShowerheadSavings => 'Savings for this showerhead';

  @override
  String get shStatisticsShowerIgnored => 'Ignored';

  @override
  String get shStatisticsShowerThresholds => 'Thresholds';

  @override
  String get shStatisticsShowerLearningThresholds => 'Learning period thresholds';

  @override
  String get shStatisticsLiveShowerVol => 'Vol.';

  @override
  String get shStatisticsLiveShowerMessage => 'The information may change.';

  @override
  String get showerFiltersDialogTitle => 'Filter showers';

  @override
  String get showerFiltersUserPrefsSectionTitle => 'User preferences';

  @override
  String get showerFiltersVolumeSectionTitle => 'Volume';

  @override
  String get showerFiltersIgnoredField => 'Ignored';

  @override
  String get showerFiltersIsChechedText => 'is checked';

  @override
  String get showerFiltersIsNotCheckedText => 'is not checked';

  @override
  String get showerFiltersIsRefShowerField => 'is a reference shower';

  @override
  String get showerFiltersChallengeKo => 'Exceeds defined thresholds';

  @override
  String get showerFiltersIsGreaterThanField => 'Is greater than';

  @override
  String get showerFiltersIsLessThanField => 'Is less than';

  @override
  String get showerFiltersDurationSectionTitle => 'Duration';

  @override
  String get showerFiltersExceedRefShowerDurationField => 'Exceeds the reference shower duration';

  @override
  String get savingsDetailsDialogTitle => 'Savings';

  @override
  String get savingsDetailsDialogCompareSection => 'Comparison';

  @override
  String get savingsDetailsDialogConsumptionSection => 'Consumption';

  @override
  String get savingsDetailsDialogOldShowerhead => 'Old showerhead';

  @override
  String get savingsDetailsDialogHydrao => 'Hydrao';

  @override
  String get savingsDetailsDialogOldShowerheadHeader => 'Old';

  @override
  String get savingsDetailsDialogSavingsHeader => 'Savings';

  @override
  String get instAloe1 => 'Unscrew your previous shower head to remove it.';

  @override
  String get instAloe2 => 'Set in the supplied washer in the hose.';

  @override
  String get instAloe3 => 'Screw on your new HYDRAO shower head';

  @override
  String get instYucca1 => 'Turn the water off.';

  @override
  String get instYucca2 => 'Unscrew your previous rain shower to remove it.';

  @override
  String get instYucca3 => 'Screw on your new HYDRAO rain shower';

  @override
  String get faqDialogTitle => 'Frequently Asked Questions';

  @override
  String get faqUsageTitle1 => 'How is the shower head powered?';

  @override
  String get faqUsageTitle2 => 'Can we turn off the water during the shower to soap without ending the current shower?';

  @override
  String get faqUsageTitle3 => 'HYDRAO Shower doesn’t light on';

  @override
  String get faqUsageTitle4 => 'Why do I only see colors when I open the tap completely?';

  @override
  String get faqUsageTitle5 => 'Why can’t I have the shower dates ?';

  @override
  String get faqUsageTitle6 => 'Do I have to use the application each time I take a shower ?';

  @override
  String get faqUsageDescription1 => 'HYDRAO Shower is equipped with a micro-turbine which supplies the power to the shower head thanks to the water flow. No battery is needed!';

  @override
  String get faqUsageDescription2 => 'During your shower you can turn off the water as long as 2 minutes to soap without loosing your current shower data. After 2 minutes the shower head considers you have finished your shower.';

  @override
  String get faqUsageDescription3 => 'First check you have the right pressure for the shower head to operate. As you already know, HYDRAO Shower doesn’t have any battery as its turbine harvest the energy of the water flow. Plug in your HYDRAO Shower (if not already done) and open the tap. Move the shower head upwards so that the water flow is directed upwards like a fountain. Measure the height of the water flow. It has to be higher than 70cm (27 inches) so that HYDRAO operate correctly, this is equivalent to 0.8 bar.';

  @override
  String get faqUsageDescription4 => 'HYDRAO Shower Aloé is designed to limit your water consumption while optimising the turbine performances for the lights. Therefore, even if the tap is completely open, your water consumption from 2 to 5 bar is limited to 6.6L/min with the excess flow valve (Class A+) and 9L/min without the valve (Class A).';

  @override
  String get faqUsageDescription5 => 'HYDRAO shower operates without batteries. It gets the energy from a turbine powered by water flow. Using no batteries is the most ecological solution, but as a consequence, we can’t maintain a clock in the shower head, and therefore have a timestamp on each shower. We are currently working on adding a battery in the shower head, or using a wifi/bluetooth gateway to be able to date showers.';

  @override
  String get faqUsageDescription6 => 'You don’t need to connect to shower head on each showers. HYDRAO shower heads have a 200 shower memory. Connecting from time to time is enough to keep your shower history updated.';

  @override
  String get faqInstallationTitle2 => 'Excess flow valve : How to use it?';

  @override
  String get faqInstallationDescription2 => 'In order to warranty the best possible experience with HYDRAO Shower, the water flow limiter should only be used if the water pressure at the shower head is above 0.8 bar. First, check your HYDRAO Shower works perfectly without the excess flow valve (colors, Bluetooth connectivity, pressure: the height of water flow should be higher than 70cm (27 inches) when you turn your HYDRAO Shower upwards). Then, unscrew HYDRAO Shower and insert the excess flow valve following the waterflow installation Guide. Screw your HYDRAO Shower back on the flexible hose. The flow will then be limited to 6.6L/min. If you would like to remove the water flow limiter, it is possible to take it out using with precaution a simple tool such as a corkscrew, a paperclip or a screwdriver.';

  @override
  String get faqConnectivityTitle1 => 'Is my smartphone compatible with HYDRAO?';

  @override
  String get faqConnectivityTitle2 => 'How far can you use the HYDRAO app from the shower head?';

  @override
  String get faqConnectivityTitle3 => 'Do I need to establish a connection with the app during each shower to retrieve all the data?';

  @override
  String get faqConnectivityTitle4 => 'I can’t connect my Android smartphone to my HYDRAO Shower, what should I do?';

  @override
  String get faqConnectivityDescription1 => 'In order to connect to HYDRAO Shower you need a smartphone that works with Android or iOS and is at least Bluetooth 4.0 capable.';

  @override
  String get faqConnectivityDescription2 => 'The shower head uses the latest Bluetooth 4.0 technology that allows you to establish a connection within a few meters.';

  @override
  String get faqConnectivityDescription3 => 'No, the shower head is equipped with an internal memory capable of storing up to 200 showers, meaning you can connect once from time to time without loosing your shower data.';

  @override
  String get faqConnectivityDescription4 => 'It is required to give the app HYDRAO localisation permission, because Android requires localisation to be activated for the Bluetooth to function. On your smartphone, select Settings > Applications > HYDRAO > Permissions > Localisation : Allow';

  @override
  String get legalNotice => 'Legal notice';

  @override
  String get legalNoticeText => '\t1.\tPRESENTATION :\nApp publisher: Smart & Blue\n196 route des vignes, 38430 Moirans\nResponsible publication: HYDRAO\ncontact@hydrao.fr\n\n\t2.\tTERMS OF USE OF OUR SERVICES\nThe use of our services include compliance with the following rules:\nDon’t misuse our Services. Do not interfere with our Services or try to access them using a method other than the interface and the instructions that we provide. You may use our Services only as permitted by law, including applicable export and re-export control laws and regulations. We may suspend or stop providing our Services to you if you do not comply with our terms or policies or if we are investigating suspected misconduct.\n\nABOUT THESE TERMS OF USE\n\nWe may modify these terms or any additional terms that apply to a Service to, for example, reflect changes to the law or changes to our Services. You should look at the terms regularly. We’ll post notice of modifications to these terms on this page. We’ll post notice of modified additional terms in the applicable Service. If you do not accept changes to the Conditions of a given service, you must cease all use of the Service.\n\nThese terms control the relationship between HYDRAO - Smart & Blue and you. They do not create any third party beneficiary rights.\n\nIf you do not comply with these terms, and we don’t take action right away, this doesn’t mean that we are giving up any rights that we may have. \n\n\nBY USING THE SOFTWARE, YOU ACCEPT THESE TERMS IF YOU DO NOT AGREE, DO NOT USE THE SOFTWARE.\n\n\nThese license terms are an agreement between HYDRAO – Smart & Blue and you. Please read them. They apply to the software named above. The terms also apply to any HYDRAO\n•   \tupdates,\n•   \tsupplements,\n•   \tInternet-based services, and\n•   \tsupport services\nfor this software, unless other terms accompany those items. If so, those terms apply.\n\nBY USING THE SOFTWARE, YOU ACCEPT THESE TERMS. IF YOU DO NOT ACCEPT THEM, DO NOT USE THE SOFTWARE.\n\nIf you comply with these license terms, you have the perpetual rights below.\n\n\n\t3.\tINSTALLATION AND USE RIGHTS.\n\t\t3.1.\tInstallation and Use.\nYou may install and use one copy of the software on an device that you own or control for non-commercial use purposes.\n\n\t\t3.2.\tThird Party Programs. \nThe software may include third party programs that HYDRAO - Smart & Blue, not the third party, licenses to you under this agreement. Notices, if any, for the third party program are included for your information only.\n\n\t4.\tDESCRIPTION OF SERVICES PROVIDED.\nThe purpose of the HYDRAO SMART SHOWER SOFTWARE is to collect data regarding on the usage habits for the water used for showering. These data are analyzed to evaluate HYDRAO SMART SHOWER products and thus to propose the most interesting evolutions to help the users understand and reduce their water usage. The HYDRAO SMART SHOWER SOFTWARE strives to provide as accurate information as possible. However, the company can not be held liable for oversights, inaccuracies or deficiencies due to updates, whether by it or third parties that provide it with this information.\n\nAll the information provided by HYDRAO SMART SHOWER SOFTWARE is for reference purposes only and is subject to change without. Furthermore, the information provided by HYDRAO SMART SHOWER SOFTWARE is not exhaustive. It is given subject to modifications that may arise after their in-line availability.\n\n\t5.\tCONTRACTUAL LIMITATIONS ON TECHNICAL DATA\nThe software uses Flutter technology. The software can not be held liable for material damages related to the use of the software. In addition, the user agrees to use the software on recent hardware, free from viruses and using an operating system with all the latest updates.\n\n\t6.\tINTERNET ACCESS MAY BE REQUIRED.\nYou may incur charges related to Internet access, data transfer and other services per the terms of the data service plan and any other agreement you have with your network operator due to use of the software.  You are solely responsible for any network operator charges.\n\n\t7.\tSCOPE OF LICENSE.\nThe software is not sold but licensed. This contract only gives you some rights to use the software. HYDRAO - Smart & Blue owns the intellectual property rights and has the rights to use all the elements available on the software, including text, images, graphics, logos, videos, icons and sounds. Except where applicable regulations give you other rights, and notwithstanding this limitation, you may only use the software in accordance with the terms of this agreement. To this end, you must comply with the technical restrictions contained in the software that allow you to use it only in a given manner. You are not allowed to:\n\n•   \tcircumvent the technical restrictions contained in the software;\n•   \treconstruct the logic of the software, decompile or disassemble it, except to the extent that such operations would be expressly permitted by applicable law notwithstanding this limitation;\n•   \tmake more copies of the software thanthan permitted in this agreement or applicable regulations, notwithstanding this limitation;\n•   \tpublish the software for reproduction by other parties\n•   \trent or lend the software;\n•   \ttransfer the software or this contract to a third party; or\n•   \tuse the software in combination with commercial hosting services.\nAny unauthorized use of the software or any of the elements it contains will be considered as constituting an infringement and prosecuted in accordance with the provisions of Articles L.335-2 and following of the Intellectual Property Code.\n\n\t8.\tLIABIITLY LIMITS\nHYDRAO – Smart & Blue acts as publisher of the software. The HYDRAO SMART SHOWER SOFTWARE is responsible for the quality and veracity of the content it publishes.\nThe HYDRAO SMART SHOWER SOFTWARE can not be held liable for direct or indirect damage to the user’s equipment when accessing the HYDRAO SMART SHOWER SOFTWARE, and resulting from the use of hardware that does not meet its specification as indicated in point 5, nor the appearance of a bug or an incompatibility.\nThe HYDRAO SMART SHOWER SOFTWARE can not be held liable for subsequent damages resulting from the use of the HYDRAO SMART SHOWER SOFTWARE.\n\n\t9.\tMANAGEMENT OF PERSONAL DATA.\nThe customer is informed of the regulations concerning marketing communication, the law of June 21, 2014 regarding the trust in the Digital Economy, the Data Protection Act of August 06, 2004 as well as the General Regulation on Data Protection (RGPD: no. 2016-679).\n\n\t\t9.1.\tHead of personal data collection\nFor personal data collected as part of the creation of the user’s personal account and its use of the application. The HYDRAO SMART SHOWER SOFTWARE is represented by Gabriel Della-Monica, the company’s legal representative.\nGiven that the HYDRAO SMART SHOWER SOFTWARE is in charge of processing the data it collects, it undertakes to comply with the legal provisions in force. It is its responsibility to establish the purposes of his data processing, to provide its customers, from obtaining their consent, complete information on the processing of their personal data and maintain a record of processing in accordance with reality. Whenever the HYDRAO SMART SHOWER SOFTWARE processes personal data, the HYDRAO SMART SHOWER SOFTWARE undertakes all reasonable measures to ensure the accuracy and relevance of the personal data collected for the purposes for which the HYDRAO SMART SHOWER SOFTWARE processes the data.\n\n\t\t9.2.\tPurpose of the data collected\nThe HYDRAO SMART SHOWER SOFTWARE is likely to process all or part of the following data:•   \tThe username to provide continuity of service when uninstalling the application\n•   \tThe tap water usage to help the user understand the stakes and reduce their usage\n•   \tCosts related to domestic water to inform the user of the financial cost of its consumption\n•   \tApplication usage data for diagnostic aid purposes in case of malfunction and help to improve our services\n•   \tUser communications\nThe HYDRAO SMART SHOWER SOFTWARE does not commercialize your personal data which are therefore only used by necessity or for statistical and analytical purposes.\n\n\t\t9.3.\tRight of access, rectification and opposition\nIn accordance with current European regulations, users of the HYDRAO SMART SHOWER SOFTWARE have the following rights:\n•   \tThe right of access (article 15 RGPD) and rectification (article 16 RGPD), updating, completeness of user data right of locking or deletion of personal user data (article 17 of the RGPD) , when they are inaccurate, incomplete, equivocal, out of date, or whose collection, use, communication or conservation is prohibited\n•   \tThe right to withdraw consent at any time (article 13-2c RGPD)\n•   \tThe right to limit the processing of users’ data (Article 18 RGPD)\n•   \tThe right of objection to the processing of users’ data (Article 21 RGPD)\n•   \tThe right to the portability of the data that the users have provided, when this data is the subject of automated processing based on their consent or on a contract (article 20 RGPD)\n•   \tThe right to define the fate of users’ data after their death and to choose to whom HYDRAO - Smart & Blue will have to communicate (or not) their data to a third party they have previously designated\n\nAs soon as HYDRAO - Smart & Blue becomes aware of the death of a user and in the absence of instructions from it, HYDRAO undertakes to destroy his(her) data, unless their retention is necessary for probative purposes or to fulfill a legal obligation.\nIf the user wishes to know how HYDRAO - Smart & Blue uses his personal data, wants  to rectify them or opposes their processing, the user can contact HYDRAO by email at contact@hydrao.com.\nIn this case, the user must indicate the personal data that he / she would like HYDRAO to correct, update or delete, identifying himself / herself with a copy of an identity document (identity card or passport) as well as a screenshot of the application with the identifier of the shower head used (see section parameters / My shower in the HYDRAO SMART SHOWER SOFTWARE).\nRequests for the deletion of personal data will be subject to the obligations imposed on HYDRAO by law, particularly with regard to the preservation or archiving of documents. Finally, users of the HYDRAO SMART SHOWER SOFTWARE may file a request with the supervisory authorities, particularly the CNIL (https://www.cnil.fr/fr/plaintes).\n\n\t\t9.4.\tNon-disclosure of personal data\n HYDRAO - Smart & Blue is prohibited from processing, hosting or transferring the information collected from its customers to/in a country located outside the European Union or recognized as \"unsuitable\" by the European Commission without informing the customer beforehand. However, HYDRAO remains free from the choice of its technical and commercial subcontractors on the condition that they present sufficient warrantees with regard to the requirements of the General Regulation on Data Protection (RGPD: No. 2016-679).\nHYDRAO - Smart & Blue undertakes to take all necessary precautions to preserve the security of personal information and in particular that it is not communicated to unauthorized persons. However, if an incident affecting the integrity or confidentiality of the customer’s information is brought to the attention of HYDRAO, it will promptly inform the customer and inform him of the corrective measures taken. In addition, HYDRAO - Smart & Blue does not collect any sensitive data.\nThe personal data of the user may be processed by HYDRAO - Smart & Blue subsidiaries and subcontractors (service providers), exclusively for the purposes of this policy.\nWithin the limits of their respective responsibilities and for the purposes mentioned above, the persons likely to have access to HYDRAO users’ data are mainly the employees in our technical department.\n\n\t\t9.5.\tTypes of data collected\n Regarding the users of the HYDRAO SMART SHOWER SOFTWARE, we collect the following data which are essential for the operation of the service, and which will be kept for a maximum period of 36 months after the last connection of the pommel through the application to our servers:\n•   \tUsername and passwords (encrypted)\n•   \tWater usage (volume, temperature, flow rate, pressure, time)\n•   \tProgrammed thresholds\n•   \tThe local cost of domestic water and water heating given in the application\n•   \tUsers’ communications with third parties via the HYDRAO SMART SHOWER SOFTWARE\n•   \tPublications or comments you provide to HYDRAO\n•   \tUsers’ usage and connection data\n•   \tModel and OS of the smartphone used for data collection\n•   \tThe approximate GPS coordinates of the phone connected to the shower head\n\n\t10.\tNOTIFICATION OF BREACHES\nWhatever efforts are made, no method of transmission over the Internet and no method of electronic storage is completely secure. We can not therefore guarantee absolute security. If we become aware of a security breach, we will notify the affected users so that they can take appropriate action. Our incident reporting procedures take into account our legal obligations, whether at the national or European level. We are committed to fully informing our customers of all matters relating to the security of their account and providing them with all the information they need to help them meet their own regulatory reporting requirements.\nNo personal information of the HYDRAO SMART SHOWER SOFTWARE user is published without the knowledge of the user, exchanged, transferred, assigned or sold on any support to third parties. Global statistics calculated from anonymized data may be disseminated for advertising purposes of our products. Only the acquisition of HYDRAO SMART SHOWER SOFTWARE and associated rights allow the transmission of such information to the prospective purchaser who would in turn be given the same obligation to store and modify users’ data as per HYDRAO SMART SHOWER SOFTWARE.\nTo ensure the security and confidentiality of personal data, the HYDRAO SMART SHOWER SOFTWARE uses networks protected by standard devices such as firewall, pseudo-anonymization, encryption and password.\nWhen processing personal data, the HYDRAO SMART SHOWER SOFTWARE takes all reasonable steps to protect against loss, misuse, unauthorized access, disclosure, alteration or destruction.\n\n\t11.\tTRANSFER TO ANOTHER DEVICE.\nYou may uninstall the software and install it on another device for your use. You may not do so to share this license between devices beyond the scope of this agreement.\n\n\t12.\tEXPORT RESTRICTIONS.\nThe software is subject to French export laws and regulations. You must comply with all domestic and international export laws and regulations that apply to the software. These laws include restrictions on destinations, end users and end use.\n\n\t13.\tCOPYRIGHT NOTICES.\nHYDRAO – Smart & Blue is a registered trademark of Smart & Blue SAS. in France.\n\n\t14.\tENTIRE AGREEMENT.\nThis agreement, and the terms for supplements, updates, Internet-based services and support services that you use, are the entire agreement for the software and support services.\n\n\t15.\tLEGAL EFFECT.\nThis agreement describes certain legal rights. You may have other rights under the laws of your country. You may also have rights with respect to the party from whom you acquired the software. This agreement does not change your rights under the laws of your country if the laws of your country do not permit it to do so.\n\n\t16.\tDISCLAIMER OF WARRANTY.\nTHE SOFTWARE IS LICENSED “AS-IS,” “WITH ALL FAULTS,” AND “AS AVAILABLE.”  YOU BEAR THE RISK OF USING IT.  IF DESIRED, YOU MAY NOTIFY GOOGLE FOR A REFUND OF THE PURCHASE PRICE.  TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, GOOGLE WILL HAVE NO OTHER WARRANTY OBLIGATION WHATSOEVER.  HYDRAO AND WIRELESS CARRIERS OVER WHOSE NETWORK THE SOFTWARE IS DISTRIBUTED, AND EACH OF OUR RESPECTIVE AFFILIATES, AND SUPPLIERS (“COVERED PARTIES”) GIVE NO EXPRESS WARRANTIES, GUARANTEES OR CONDITIONS UNDER OR IN RELATION TO THE SOFTWARE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH YOU.  SHOULD THE SOFTWARE BE DEFECTIVE, YOU ASSUME THE ENTIRE COST OF ALL NECESSARY SERVICING OR REPAIR.  YOU MAY HAVE ADDITIONAL CONSUMER RIGHTS UNDER YOUR LOCAL LAWS WHICH THIS AGREEMENT CANNOT CHANGE. TO THE EXTENT PERMITTED UNDER YOUR LOCAL LAWS, COVERED PARTIES EXCLUDE THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT.\n\n\t17.\tLIMITATION ON AND EXCLUSION OF REMEDIES AND DAMAGES.\nTO THE EXTENT NOT PROHIBITED BY LAW, YOU CAN RECOVER FROM HYDRAO ONLY DIRECT DAMAGES UP TO ONE U.S. DOLLAR. YOU AGREE NOT TO SEEK TO RECOVER ANY OTHER DAMAGES, INCLUDING CONSEQUENTIAL, LOST PROFITS, SPECIAL, INDIRECT OR INCIDENTAL DAMAGES FROM ANY COVERED PARTIES.\nThis limitation applies to:\n•   \tanything related to the software, services, content (including code) on third party Internet sites, or third party programs; and\n•   \tclaims for breach of contract, warranty, guarantee or condition; consumer protection; deception; unfair competition; strict liability, negligence, misinterpretation, omission, trespass or other tort; violation of statute or regulation; or unjust enrichment; all to the extent permitted by applicable law.\nIt also applies even if:\n\n•   \tRepair, replacement or refund for the software does not fully compensate you for any losses; or\n•   \tCovered Parties knew or should have known about the possibility of the damages.\nThe above limitation or exclusion may not apply to you because your country may not allow the exclusion or limitation of incidental, consequential or other damages.\n\n';

  @override
  String get legalNoticeSection1Title => '1. PRESENTATION';

  @override
  String get legalNoticeSection1Text => 'App publisher: Smart & Blue\n196 route des vignes, 38430 Moirans\nResponsible publication: HYDRAO\ncontact@hydrao.fr';

  @override
  String get legalNoticeSection2Title => '2. TERMS OF USE OF OUR SERVICES';

  @override
  String get legalNoticeSection2Text => 'The use of our services include compliance with the following rules:\nDon’t misuse our Services. Do not interfere with our Services or try to access them using a method other than the interface and the instructions that we provide. You may use our Services only as permitted by law, including applicable export and re-export control laws and regulations. We may suspend or stop providing our Services to you if you do not comply with our terms or policies or if we are investigating suspected misconduct.\n\nABOUT THESE TERMS OF USE\n\nWe may modify these terms or any additional terms that apply to a Service to, for example, reflect changes to the law or changes to our Services. You should look at the terms regularly. We’ll post notice of modifications to these terms on this page. We’ll post notice of modified additional terms in the applicable Service. If you do not accept changes to the Conditions of a given service, you must cease all use of the Service.\n\nThese terms control the relationship between HYDRAO - Smart & Blue and you. They do not create any third party beneficiary rights.\n\nIf you do not comply with these terms, and we don’t take action right away, this doesn’t mean that we are giving up any rights that we may have. \n\n\nBY USING THE SOFTWARE, YOU ACCEPT THESE TERMS IF YOU DO NOT AGREE, DO NOT USE THE SOFTWARE.\n\n\nThese license terms are an agreement between HYDRAO – Smart & Blue and you. Please read them. They apply to the software named above. The terms also apply to any HYDRAO\n•   \tupdates,\n•   \tsupplements,\n•   \tInternet-based services, and\n•   \tsupport services\nfor this software, unless other terms accompany those items. If so, those terms apply.\n\nBY USING THE SOFTWARE, YOU ACCEPT THESE TERMS. IF YOU DO NOT ACCEPT THEM, DO NOT USE THE SOFTWARE.\n\nIf you comply with these license terms, you have the perpetual rights below.';

  @override
  String get legalNoticeSection3Title => '3. INSTALLATION AND USE RIGHTS';

  @override
  String get legalNoticeSection3Text => '\t\t3.1.\tInstallation and Use.\nYou may install and use one copy of the software on an device that you own or control for non-commercial use purposes.\n\n\t\t3.2.\tThird Party Programs. \nThe software may include third party programs that HYDRAO - Smart & Blue, not the third party, licenses to you under this agreement. Notices, if any, for the third party program are included for your information only.';

  @override
  String get legalNoticeSection4Title => '4. DESCRIPTION OF SERVICES PROVIDED';

  @override
  String get legalNoticeSection4Text => 'The purpose of the HYDRAO SMART SHOWER SOFTWARE is to collect data regarding on the usage habits for the water used for showering. These data are analyzed to evaluate HYDRAO SMART SHOWER products and thus to propose the most interesting evolutions to help the users understand and reduce their water usage. The HYDRAO SMART SHOWER SOFTWARE strives to provide as accurate information as possible. However, the company can not be held liable for oversights, inaccuracies or deficiencies due to updates, whether by it or third parties that provide it with this information.\n\nAll the information provided by HYDRAO SMART SHOWER SOFTWARE is for reference purposes only and is subject to change without. Furthermore, the information provided by HYDRAO SMART SHOWER SOFTWARE is not exhaustive. It is given subject to modifications that may arise after their in-line availability.';

  @override
  String get legalNoticeSection5Title => '5. CONTRACTUAL LIMITATIONS ON TECHNICAL DATA';

  @override
  String get legalNoticeSection5Text => 'The software uses Flutter technology. The software can not be held liable for material damages related to the use of the software. In addition, the user agrees to use the software on recent hardware, free from viruses and using an operating system with all the latest updates.';

  @override
  String get legalNoticeSection6Title => '6. INTERNET ACCESS MAY BE REQUIRED';

  @override
  String get legalNoticeSection6Text => 'You may incur charges related to Internet access, data transfer and other services per the terms of the data service plan and any other agreement you have with your network operator due to use of the software.  You are solely responsible for any network operator charges.';

  @override
  String get legalNoticeSection7Title => '7. SCOPE OF LICENSE';

  @override
  String get legalNoticeSection7Text => 'The software is not sold but licensed. This contract only gives you some rights to use the software. HYDRAO - Smart & Blue owns the intellectual property rights and has the rights to use all the elements available on the software, including text, images, graphics, logos, videos, icons and sounds. Except where applicable regulations give you other rights, and notwithstanding this limitation, you may only use the software in accordance with the terms of this agreement. To this end, you must comply with the technical restrictions contained in the software that allow you to use it only in a given manner. You are not allowed to:\n\n•   \tcircumvent the technical restrictions contained in the software;\n•   \treconstruct the logic of the software, decompile or disassemble it, except to the extent that such operations would be expressly permitted by applicable law notwithstanding this limitation;\n•   \tmake more copies of the software thanthan permitted in this agreement or applicable regulations, notwithstanding this limitation;\n•   \tpublish the software for reproduction by other parties\n•   \trent or lend the software;\n•   \ttransfer the software or this contract to a third party; or\n•   \tuse the software in combination with commercial hosting services.\nAny unauthorized use of the software or any of the elements it contains will be considered as constituting an infringement and prosecuted in accordance with the provisions of Articles L.335-2 and following of the Intellectual Property Code.';

  @override
  String get legalNoticeSection8Title => '8. LIABIITLY LIMITS';

  @override
  String get legalNoticeSection8Text => 'HYDRAO – Smart & Blue acts as publisher of the software. The HYDRAO SMART SHOWER SOFTWARE is responsible for the quality and veracity of the content it publishes.\nThe HYDRAO SMART SHOWER SOFTWARE can not be held liable for direct or indirect damage to the user’s equipment when accessing the HYDRAO SMART SHOWER SOFTWARE, and resulting from the use of hardware that does not meet its specification as indicated in point 5, nor the appearance of a bug or an incompatibility.\nThe HYDRAO SMART SHOWER SOFTWARE can not be held liable for subsequent damages resulting from the use of the HYDRAO SMART SHOWER SOFTWARE.';

  @override
  String get legalNoticeSection9Title => '9. MANAGEMENT OF PERSONAL DATA';

  @override
  String get legalNoticeSection9Text => 'The customer is informed of the regulations concerning marketing communication, the law of June 21, 2014 regarding the trust in the Digital Economy, the Data Protection Act of August 06, 2004 as well as the General Regulation on Data Protection (RGPD: no. 2016-679).\n\n\t\t9.1.\tHead of personal data collection\nFor personal data collected as part of the creation of the user’s personal account and its use of the application. The HYDRAO SMART SHOWER SOFTWARE is represented by Gabriel Della-Monica, the company’s legal representative.\nGiven that the HYDRAO SMART SHOWER SOFTWARE is in charge of processing the data it collects, it undertakes to comply with the legal provisions in force. It is its responsibility to establish the purposes of his data processing, to provide its customers, from obtaining their consent, complete information on the processing of their personal data and maintain a record of processing in accordance with reality. Whenever the HYDRAO SMART SHOWER SOFTWARE processes personal data, the HYDRAO SMART SHOWER SOFTWARE undertakes all reasonable measures to ensure the accuracy and relevance of the personal data collected for the purposes for which the HYDRAO SMART SHOWER SOFTWARE processes the data.\n\n\t\t9.2.\tPurpose of the data collected\nThe HYDRAO SMART SHOWER SOFTWARE is likely to process all or part of the following data:•   \tThe username to provide continuity of service when uninstalling the application\n•   \tThe tap water usage to help the user understand the stakes and reduce their usage\n•   \tCosts related to domestic water to inform the user of the financial cost of its consumption\n•   \tApplication usage data for diagnostic aid purposes in case of malfunction and help to improve our services\n•   \tUser communications\nThe HYDRAO SMART SHOWER SOFTWARE does not commercialize your personal data which are therefore only used by necessity or for statistical and analytical purposes.\n\n\t\t9.3.\tRight of access, rectification and opposition\nIn accordance with current European regulations, users of the HYDRAO SMART SHOWER SOFTWARE have the following rights:\n•   \tThe right of access (article 15 RGPD) and rectification (article 16 RGPD), updating, completeness of user data right of locking or deletion of personal user data (article 17 of the RGPD) , when they are inaccurate, incomplete, equivocal, out of date, or whose collection, use, communication or conservation is prohibited\n•   \tThe right to withdraw consent at any time (article 13-2c RGPD)\n•   \tThe right to limit the processing of users’ data (Article 18 RGPD)\n•   \tThe right of objection to the processing of users’ data (Article 21 RGPD)\n•   \tThe right to the portability of the data that the users have provided, when this data is the subject of automated processing based on their consent or on a contract (article 20 RGPD)\n•   \tThe right to define the fate of users’ data after their death and to choose to whom HYDRAO - Smart & Blue will have to communicate (or not) their data to a third party they have previously designated\n\nAs soon as HYDRAO - Smart & Blue becomes aware of the death of a user and in the absence of instructions from it, HYDRAO undertakes to destroy his(her) data, unless their retention is necessary for probative purposes or to fulfill a legal obligation.\nIf the user wishes to know how HYDRAO - Smart & Blue uses his personal data, wants  to rectify them or opposes their processing, the user can contact HYDRAO by email at contact@hydrao.com.\nIn this case, the user must indicate the personal data that he / she would like HYDRAO to correct, update or delete, identifying himself / herself with a copy of an identity document (identity card or passport) as well as a screenshot of the application with the identifier of the shower head used (see section parameters / My shower in the HYDRAO SMART SHOWER SOFTWARE).\nRequests for the deletion of personal data will be subject to the obligations imposed on HYDRAO by law, particularly with regard to the preservation or archiving of documents. Finally, users of the HYDRAO SMART SHOWER SOFTWARE may file a request with the supervisory authorities, particularly the CNIL (https://www.cnil.fr/fr/plaintes).\n\n\t\t9.4.\tNon-disclosure of personal data\n HYDRAO - Smart & Blue is prohibited from processing, hosting or transferring the information collected from its customers to/in a country located outside the European Union or recognized as \"unsuitable\" by the European Commission without informing the customer beforehand. However, HYDRAO remains free from the choice of its technical and commercial subcontractors on the condition that they present sufficient warrantees with regard to the requirements of the General Regulation on Data Protection (RGPD: No. 2016-679).\nHYDRAO - Smart & Blue undertakes to take all necessary precautions to preserve the security of personal information and in particular that it is not communicated to unauthorized persons. However, if an incident affecting the integrity or confidentiality of the customer’s information is brought to the attention of HYDRAO, it will promptly inform the customer and inform him of the corrective measures taken. In addition, HYDRAO - Smart & Blue does not collect any sensitive data.\nThe personal data of the user may be processed by HYDRAO - Smart & Blue subsidiaries and subcontractors (service providers), exclusively for the purposes of this policy.\nWithin the limits of their respective responsibilities and for the purposes mentioned above, the persons likely to have access to HYDRAO users’ data are mainly the employees in our technical department.\n\n\t\t9.5.\tTypes of data collected\n Regarding the users of the HYDRAO SMART SHOWER SOFTWARE, we collect the following data which are essential for the operation of the service, and which will be kept for a maximum period of 36 months after the last connection of the pommel through the application to our servers:\n•   \tUsername and passwords (encrypted)\n•   \tWater usage (volume, temperature, flow rate, pressure, time)\n•   \tProgrammed thresholds\n•   \tThe local cost of domestic water and water heating given in the application\n•   \tUsers’ communications with third parties via the HYDRAO SMART SHOWER SOFTWARE\n•   \tPublications or comments you provide to HYDRAO\n•   \tUsers’ usage and connection data\n•   \tModel and OS of the smartphone used for data collection\n•   \tThe approximate GPS coordinates of the phone connected to the shower head';

  @override
  String get legalNoticeSection10Title => '10. NOTIFICATION OF BREACHES';

  @override
  String get legalNoticeSection10Text => 'Whatever efforts are made, no method of transmission over the Internet and no method of electronic storage is completely secure. We can not therefore guarantee absolute security. If we become aware of a security breach, we will notify the affected users so that they can take appropriate action. Our incident reporting procedures take into account our legal obligations, whether at the national or European level. We are committed to fully informing our customers of all matters relating to the security of their account and providing them with all the information they need to help them meet their own regulatory reporting requirements.\nNo personal information of the HYDRAO SMART SHOWER SOFTWARE user is published without the knowledge of the user, exchanged, transferred, assigned or sold on any support to third parties. Global statistics calculated from anonymized data may be disseminated for advertising purposes of our products. Only the acquisition of HYDRAO SMART SHOWER SOFTWARE and associated rights allow the transmission of such information to the prospective purchaser who would in turn be given the same obligation to store and modify users’ data as per HYDRAO SMART SHOWER SOFTWARE.\nTo ensure the security and confidentiality of personal data, the HYDRAO SMART SHOWER SOFTWARE uses networks protected by standard devices such as firewall, pseudo-anonymization, encryption and password.\nWhen processing personal data, the HYDRAO SMART SHOWER SOFTWARE takes all reasonable steps to protect against loss, misuse, unauthorized access, disclosure, alteration or destruction.';

  @override
  String get legalNoticeSection11Title => '11. TRANSFER TO ANOTHER DEVICE';

  @override
  String get legalNoticeSection11Text => 'You may uninstall the software and install it on another device for your use. You may not do so to share this license between devices beyond the scope of this agreement.';

  @override
  String get legalNoticeSection12Title => '12. EXPORT RESTRICTIONS';

  @override
  String get legalNoticeSection12Text => 'The software is subject to French export laws and regulations. You must comply with all domestic and international export laws and regulations that apply to the software. These laws include restrictions on destinations, end users and end use.';

  @override
  String get legalNoticeSection13Title => '13. COPYRIGHT NOTICES';

  @override
  String get legalNoticeSection13Text => 'HYDRAO – Smart & Blue is a registered trademark of Smart & Blue SAS. in France.';

  @override
  String get legalNoticeSection14Title => '14. ENTIRE AGREEMENT';

  @override
  String get legalNoticeSection14Text => 'This agreement, and the terms for supplements, updates, Internet-based services and support services that you use, are the entire agreement for the software and support services.';

  @override
  String get legalNoticeSection15Title => '15. LEGAL EFFECT';

  @override
  String get legalNoticeSection15Text => 'This agreement describes certain legal rights. You may have other rights under the laws of your country. You may also have rights with respect to the party from whom you acquired the software. This agreement does not change your rights under the laws of your country if the laws of your country do not permit it to do so.';

  @override
  String get legalNoticeSection16Title => '16. DISCLAIMER OF WARRANTY';

  @override
  String get legalNoticeSection16Text => 'THE SOFTWARE IS LICENSED “AS-IS,” “WITH ALL FAULTS,” AND “AS AVAILABLE.”  YOU BEAR THE RISK OF USING IT.  IF DESIRED, YOU MAY NOTIFY GOOGLE FOR A REFUND OF THE PURCHASE PRICE.  TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, GOOGLE WILL HAVE NO OTHER WARRANTY OBLIGATION WHATSOEVER.  HYDRAO AND WIRELESS CARRIERS OVER WHOSE NETWORK THE SOFTWARE IS DISTRIBUTED, AND EACH OF OUR RESPECTIVE AFFILIATES, AND SUPPLIERS (“COVERED PARTIES”) GIVE NO EXPRESS WARRANTIES, GUARANTEES OR CONDITIONS UNDER OR IN RELATION TO THE SOFTWARE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH YOU.  SHOULD THE SOFTWARE BE DEFECTIVE, YOU ASSUME THE ENTIRE COST OF ALL NECESSARY SERVICING OR REPAIR.  YOU MAY HAVE ADDITIONAL CONSUMER RIGHTS UNDER YOUR LOCAL LAWS WHICH THIS AGREEMENT CANNOT CHANGE. TO THE EXTENT PERMITTED UNDER YOUR LOCAL LAWS, COVERED PARTIES EXCLUDE THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT.';

  @override
  String get legalNoticeSection17Title => '17. LIMITATION ON AND EXCLUSION OF REMEDIES AND DAMAGES';

  @override
  String get legalNoticeSection17Text => 'TO THE EXTENT NOT PROHIBITED BY LAW, YOU CAN RECOVER FROM HYDRAO ONLY DIRECT DAMAGES UP TO ONE U.S. DOLLAR. YOU AGREE NOT TO SEEK TO RECOVER ANY OTHER DAMAGES, INCLUDING CONSEQUENTIAL, LOST PROFITS, SPECIAL, INDIRECT OR INCIDENTAL DAMAGES FROM ANY COVERED PARTIES.\nThis limitation applies to:\n•   \tanything related to the software, services, content (including code) on third party Internet sites, or third party programs; and\n•   \tclaims for breach of contract, warranty, guarantee or condition; consumer protection; deception; unfair competition; strict liability, negligence, misinterpretation, omission, trespass or other tort; violation of statute or regulation; or unjust enrichment; all to the extent permitted by applicable law.\nIt also applies even if:\n\n•   \tRepair, replacement or refund for the software does not fully compensate you for any losses; or\n•   \tCovered Parties knew or should have known about the possibility of the damages.\nThe above limitation or exclusion may not apply to you because your country may not allow the exclusion or limitation of incidental, consequential or other damages.';
}
