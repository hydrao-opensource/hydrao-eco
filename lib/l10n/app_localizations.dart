import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @defaultScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Hydrao'**
  String get defaultScreenTitle;

  /// No description provided for @typeAloe.
  ///
  /// In en, this message translates to:
  /// **'Aloe'**
  String get typeAloe;

  /// No description provided for @typeCereus.
  ///
  /// In en, this message translates to:
  /// **'Cereus'**
  String get typeCereus;

  /// No description provided for @typeYucca.
  ///
  /// In en, this message translates to:
  /// **'Yucca'**
  String get typeYucca;

  /// No description provided for @typeFirst.
  ///
  /// In en, this message translates to:
  /// **'First'**
  String get typeFirst;

  /// No description provided for @typeMixer.
  ///
  /// In en, this message translates to:
  /// **'Mixer'**
  String get typeMixer;

  /// No description provided for @typeUnknown.
  ///
  /// In en, this message translates to:
  /// **'Not defined'**
  String get typeUnknown;

  /// No description provided for @newShowerheadLabel.
  ///
  /// In en, this message translates to:
  /// **'Showerhead'**
  String get newShowerheadLabel;

  /// No description provided for @defaultShowerheadName.
  ///
  /// In en, this message translates to:
  /// **'Hydrao Showerhead'**
  String get defaultShowerheadName;

  /// No description provided for @addShTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a showerhead'**
  String get addShTitle;

  /// No description provided for @bluetoothDisabled.
  ///
  /// In en, this message translates to:
  /// **'our Bluetooth is turned off. Please enable it before continuing.'**
  String get bluetoothDisabled;

  /// No description provided for @openBluetoothSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openBluetoothSettings;

  /// No description provided for @showerheadDetectionBlocked.
  ///
  /// In en, this message translates to:
  /// **'Your Bluetooth is turned off. Please enable it before continuing.'**
  String get showerheadDetectionBlocked;

  /// No description provided for @allowPermissions.
  ///
  /// In en, this message translates to:
  /// **'Allow permissions'**
  String get allowPermissions;

  /// No description provided for @enableBluetooth.
  ///
  /// In en, this message translates to:
  /// **'Please enable Bluetooth in the settings'**
  String get enableBluetooth;

  /// No description provided for @showerheadNotDetected.
  ///
  /// In en, this message translates to:
  /// **'Your showerhead isn’t detected?'**
  String get showerheadNotDetected;

  /// No description provided for @addShScanningText.
  ///
  /// In en, this message translates to:
  /// **'Keep the app open and turn on the water of the showerhead to be installed.'**
  String get addShScanningText;

  /// No description provided for @addShConnectingText.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get addShConnectingText;

  /// No description provided for @addShBackWarningMessage.
  ///
  /// In en, this message translates to:
  /// **'Your showerhead has not been added yet!\n\nAre you sure you want to exit?'**
  String get addShBackWarningMessage;

  /// No description provided for @connectedShStopWater.
  ///
  /// In en, this message translates to:
  /// **'Please turn off the water before continuing'**
  String get connectedShStopWater;

  /// No description provided for @addShConnectedText.
  ///
  /// In en, this message translates to:
  /// **'The showerhead has been successfully detected'**
  String get addShConnectedText;

  /// No description provided for @addShConnectedWarningFlowTitle.
  ///
  /// In en, this message translates to:
  /// **'Low flow rate detected'**
  String get addShConnectedWarningFlowTitle;

  /// No description provided for @addShConnectedWarningFlowMessage.
  ///
  /// In en, this message translates to:
  /// **'If a flow reducer is installed,\nplease remove it.'**
  String get addShConnectedWarningFlowMessage;

  /// No description provided for @needHelpToInstall.
  ///
  /// In en, this message translates to:
  /// **'Need help installing the showerhead?'**
  String get needHelpToInstall;

  /// No description provided for @helpShNotDetectedDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Showerhead not detected ?'**
  String get helpShNotDetectedDialogTitle;

  /// No description provided for @helpShNotDetectedNeedShowerSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'During a shower'**
  String get helpShNotDetectedNeedShowerSectionTitle;

  /// No description provided for @helpShNotDetectedNeedShowerWaterText.
  ///
  /// In en, this message translates to:
  /// **'The showerhead has no battery, so it needs a sufficient water flow to communicate.'**
  String get helpShNotDetectedNeedShowerWaterText;

  /// No description provided for @helpShNotDetectedNeedShowerLightsText.
  ///
  /// In en, this message translates to:
  /// **'The lights on the showerhead must be on.'**
  String get helpShNotDetectedNeedShowerLightsText;

  /// No description provided for @helpShNotDetectedBleSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth (BLE)'**
  String get helpShNotDetectedBleSectionTitle;

  /// No description provided for @helpShNotDetectedBleCompatibilityText.
  ///
  /// In en, this message translates to:
  /// **'Your phone must be compatible with Bluetooth 4.0 or higher.'**
  String get helpShNotDetectedBleCompatibilityText;

  /// No description provided for @helpShNotDetectedBleServiceText.
  ///
  /// In en, this message translates to:
  /// **'The Bluetooth service must be enabled.'**
  String get helpShNotDetectedBleServiceText;

  /// No description provided for @helpShNotDetectedBlePermissionText.
  ///
  /// In en, this message translates to:
  /// **'The app must have location permission to detect the showerhead.'**
  String get helpShNotDetectedBlePermissionText;

  /// No description provided for @helpShNotDetectedBleRangeText.
  ///
  /// In en, this message translates to:
  /// **'The phone should ideally be within 3 meters of the showerhead.'**
  String get helpShNotDetectedBleRangeText;

  /// No description provided for @helpShNotDetectedConflictSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Conflict risk'**
  String get helpShNotDetectedConflictSectionTitle;

  /// No description provided for @helpShNotDetectedConflictOnlyOneDevieText.
  ///
  /// In en, this message translates to:
  /// **'The showerhead can only connect to one device at a time.'**
  String get helpShNotDetectedConflictOnlyOneDevieText;

  /// No description provided for @helpShNotDetectedConflictGateway.
  ///
  /// In en, this message translates to:
  /// **'If you are using a gateway, please temporarily unplug it.'**
  String get helpShNotDetectedConflictGateway;

  /// No description provided for @helpRemoveFlowRestrictorDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'In case of low flow'**
  String get helpRemoveFlowRestrictorDialogTitle;

  /// No description provided for @helpRemoveFlowRestrictorDialogIssuesSection.
  ///
  /// In en, this message translates to:
  /// **'Low flow may affect the proper functioning of the showerhead lights as well as shower synchronization'**
  String get helpRemoveFlowRestrictorDialogIssuesSection;

  /// No description provided for @helpRemoveFlowRestrictorDialogRemoveSection.
  ///
  /// In en, this message translates to:
  /// **'Check whether your showerhead has a flow restrictor installed.\n\nIf so, please remove it.'**
  String get helpRemoveFlowRestrictorDialogRemoveSection;

  /// No description provided for @installNewShowerhead.
  ///
  /// In en, this message translates to:
  /// **'Install the new showerhead'**
  String get installNewShowerhead;

  /// No description provided for @installNewShText.
  ///
  /// In en, this message translates to:
  /// **'To begin,\nyou need to install your new showerhead.'**
  String get installNewShText;

  /// No description provided for @installNewShProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get installNewShProduct;

  /// No description provided for @partialDetectedShSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'{count} detected showerhead(s)'**
  String partialDetectedShSectionTitle(int count);

  /// No description provided for @dashboardShowerheadsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'My showerheads ({count})'**
  String dashboardShowerheadsSectionTitle(int count);

  /// No description provided for @dbShowerheadCardOnShowers.
  ///
  /// In en, this message translates to:
  /// **'{count} showers'**
  String dbShowerheadCardOnShowers(int count);

  /// No description provided for @dbShowerheadCardNewThresholds.
  ///
  /// In en, this message translates to:
  /// **'New thresholds to be sent to the showerhead'**
  String get dbShowerheadCardNewThresholds;

  /// No description provided for @dbShowerheadCardLearning.
  ///
  /// In en, this message translates to:
  /// **'Learning in progress'**
  String get dbShowerheadCardLearning;

  /// No description provided for @dbShowerheadCardLearningStart.
  ///
  /// In en, this message translates to:
  /// **'Sync to start the learning period'**
  String get dbShowerheadCardLearningStart;

  /// No description provided for @dbShowerheadCardSyncPartial.
  ///
  /// In en, this message translates to:
  /// **'incomplete'**
  String get dbShowerheadCardSyncPartial;

  /// No description provided for @dbShowerheadCardSynUpToDate.
  ///
  /// In en, this message translates to:
  /// **'up to date'**
  String get dbShowerheadCardSynUpToDate;

  /// No description provided for @dbShowerheadCardSyncToDo.
  ///
  /// In en, this message translates to:
  /// **'Synchronization pending'**
  String get dbShowerheadCardSyncToDo;

  /// No description provided for @dbShowerheadCardNoShower.
  ///
  /// In en, this message translates to:
  /// **'No showers'**
  String get dbShowerheadCardNoShower;

  /// No description provided for @dbShowerheadCardAverageVol.
  ///
  /// In en, this message translates to:
  /// **'Avg.'**
  String get dbShowerheadCardAverageVol;

  /// No description provided for @statsShowerheadCardAverageVol.
  ///
  /// In en, this message translates to:
  /// **'Avg.'**
  String get statsShowerheadCardAverageVol;

  /// No description provided for @statsShowerheadCardShowShowers.
  ///
  /// In en, this message translates to:
  /// **'Showers'**
  String get statsShowerheadCardShowShowers;

  /// No description provided for @statsShowerheadCardHideShowers.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get statsShowerheadCardHideShowers;

  /// No description provided for @statsShowerheadCardGoldBadge.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get statsShowerheadCardGoldBadge;

  /// No description provided for @statsShowerheadCardSilverBadge.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get statsShowerheadCardSilverBadge;

  /// No description provided for @statsShowerheadCardBronzeBadge.
  ///
  /// In en, this message translates to:
  /// **'Bronze'**
  String get statsShowerheadCardBronzeBadge;

  /// No description provided for @statsShowerheadCardBadgeTootipLiter.
  ///
  /// In en, this message translates to:
  /// **'The badge represents the challenge level achieved:\n\nGold = Average volume below 20 L\n\nSilver = Average volume between 20 L and 35 L\n\nBronze = Average volume above 35 L'**
  String get statsShowerheadCardBadgeTootipLiter;

  /// No description provided for @statsShowerheadCardBadgeTootipGallon.
  ///
  /// In en, this message translates to:
  /// **'The badge represents the challenge level achieved:\n\nGold = Average volume below 5.3 gallons\n\nSilver = Average volume between 5.3 and 9.2 gallons\n\nBronze = Average volume above 9.2 gallons'**
  String get statsShowerheadCardBadgeTootipGallon;

  /// No description provided for @statsShowerheadCardSavings.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get statsShowerheadCardSavings;

  /// No description provided for @statsShowerheadCardOnNVolume.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get statsShowerheadCardOnNVolume;

  /// No description provided for @begin.
  ///
  /// In en, this message translates to:
  /// **'Begin'**
  String get begin;

  /// No description provided for @beginAgain.
  ///
  /// In en, this message translates to:
  /// **'Start again'**
  String get beginAgain;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteAllData.
  ///
  /// In en, this message translates to:
  /// **'Reset the application'**
  String get deleteAllData;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @toContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get toContinue;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @choose.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get choose;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @unselect.
  ///
  /// In en, this message translates to:
  /// **'Unselect'**
  String get unselect;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @merge.
  ///
  /// In en, this message translates to:
  /// **'Merge'**
  String get merge;

  /// No description provided for @erase.
  ///
  /// In en, this message translates to:
  /// **'Erase'**
  String get erase;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @takeAPhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takeAPhoto;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @fromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get fromGallery;

  /// No description provided for @fromFiles.
  ///
  /// In en, this message translates to:
  /// **'Choose from files'**
  String get fromFiles;

  /// No description provided for @connecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get connecting;

  /// No description provided for @formValidatorRequired.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get formValidatorRequired;

  /// No description provided for @formValidatorGreaterThan.
  ///
  /// In en, this message translates to:
  /// **'The value must be greater than {value}'**
  String formValidatorGreaterThan(double value);

  /// No description provided for @formValidatorLesserOrEqualThan.
  ///
  /// In en, this message translates to:
  /// **'The value must be less than or equal to {value}'**
  String formValidatorLesserOrEqualThan(double value);

  /// No description provided for @iNeedHelp.
  ///
  /// In en, this message translates to:
  /// **'I need help'**
  String get iNeedHelp;

  /// No description provided for @loginDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'My Hydrao account'**
  String get loginDialogTitle;

  /// No description provided for @loginFormFailMessage.
  ///
  /// In en, this message translates to:
  /// **'Login failed, please check your credentials'**
  String get loginFormFailMessage;

  /// No description provided for @loginFormEmailField.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginFormEmailField;

  /// No description provided for @loginFormPasswordField.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginFormPasswordField;

  /// No description provided for @formContactUsDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact form'**
  String get formContactUsDialogTitle;

  /// No description provided for @contactUsDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contactUsDialogTitle;

  /// No description provided for @contactUsNeedHelpSection.
  ///
  /// In en, this message translates to:
  /// **'Need help?'**
  String get contactUsNeedHelpSection;

  /// No description provided for @contactUsNeedHelpText.
  ///
  /// In en, this message translates to:
  /// **'Provide us with some information so we can better answer your question'**
  String get contactUsNeedHelpText;

  /// No description provided for @contactUsSupportNeedDataSection.
  ///
  /// In en, this message translates to:
  /// **'At the support team\'s request'**
  String get contactUsSupportNeedDataSection;

  /// No description provided for @contactUsSupportNeedDataText.
  ///
  /// In en, this message translates to:
  /// **'If the support team asks you for technical or usage data to help resolve your issue.'**
  String get contactUsSupportNeedDataText;

  /// No description provided for @contactUsMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Write your message here...'**
  String get contactUsMessageHint;

  /// No description provided for @contactUsAllowShareTechData.
  ///
  /// In en, this message translates to:
  /// **'I authorize the sharing of technical data'**
  String get contactUsAllowShareTechData;

  /// No description provided for @contactUsAllowShareUserData.
  ///
  /// In en, this message translates to:
  /// **'I authorize the sharing of my data (an export)'**
  String get contactUsAllowShareUserData;

  /// No description provided for @contactUsNoDataSharedConfirm.
  ///
  /// In en, this message translates to:
  /// **'You have chosen not to share any data (technical & usage).\n\nThis will make it harder for the Support team to provide you with the best possible assistance.\n\nAre you sure you want to continue?'**
  String get contactUsNoDataSharedConfirm;

  /// No description provided for @moreScreenFaqMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get moreScreenFaqMenuItem;

  /// No description provided for @moreScreenLegalNoticeMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Legal notice'**
  String get moreScreenLegalNoticeMenuItem;

  /// No description provided for @moreScreenContactUsMenuItem.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get moreScreenContactUsMenuItem;

  /// No description provided for @shInstalled.
  ///
  /// In en, this message translates to:
  /// **'My showerhead is installed'**
  String get shInstalled;

  /// No description provided for @showerFinished.
  ///
  /// In en, this message translates to:
  /// **'I’ve finished my shower'**
  String get showerFinished;

  /// No description provided for @confirmCloseFormWithChanges.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes.\n\nAre you sure you want to continue?'**
  String get confirmCloseFormWithChanges;

  /// No description provided for @confirmDeleteSh.
  ///
  /// In en, this message translates to:
  /// **'This showerhead will be forgotten on this phone. All synchronized showers will be deleted.\n\nOnly the showers stored in the showerhead will be kept.\n\nAre you sure you want to continue?'**
  String get confirmDeleteSh;

  /// No description provided for @confirmResetApp.
  ///
  /// In en, this message translates to:
  /// **'All data (showerheads, synchronized showers, settings) will be deleted.\n\nOnly the showers stored in the showerheads will be kept.\n\nAs a reminder, you can create a backup of the application data.\n\nAre you sure you want to continue with the reset?'**
  String get confirmResetApp;

  /// No description provided for @confirmCloseApp.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit the application?'**
  String get confirmCloseApp;

  /// No description provided for @editShThresholdsDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Threshold configuration'**
  String get editShThresholdsDialogTitle;

  /// No description provided for @importBackupDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get importBackupDialogTitle;

  /// No description provided for @importBackupCloudSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'My Hydrao account'**
  String get importBackupCloudSectionTitle;

  /// No description provided for @importBackupCloudNoEmail.
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get importBackupCloudNoEmail;

  /// No description provided for @importBackupCloudDownloadingBackup.
  ///
  /// In en, this message translates to:
  /// **'Downloading data...'**
  String get importBackupCloudDownloadingBackup;

  /// No description provided for @importBackupCloudDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Download failed'**
  String get importBackupCloudDownloadFailed;

  /// No description provided for @importBackupSelectDataToImport.
  ///
  /// In en, this message translates to:
  /// **'Select data to import'**
  String get importBackupSelectDataToImport;

  /// No description provided for @createBackupDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Application backup'**
  String get createBackupDialogTitle;

  /// No description provided for @shareBackupSubject.
  ///
  /// In en, this message translates to:
  /// **'Hydrao backup'**
  String get shareBackupSubject;

  /// No description provided for @shareBackupMessage.
  ///
  /// In en, this message translates to:
  /// **'Here is an export of the Hydrao application data.'**
  String get shareBackupMessage;

  /// No description provided for @configShDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up the showerhead'**
  String get configShDialogTitle;

  /// No description provided for @configShMergeNotice.
  ///
  /// In en, this message translates to:
  /// **'This showerhead already exists in your list with a different identifier.'**
  String get configShMergeNotice;

  /// No description provided for @configShSavingsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Savings calculation'**
  String get configShSavingsSectionTitle;

  /// No description provided for @configShThresholdsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Color / consumption'**
  String get configShThresholdsSectionTitle;

  /// No description provided for @configShNewThresholdsSyncMessage.
  ///
  /// In en, this message translates to:
  /// **'The new thresholds will be sent to the showerhead during the next shower synchronized with your device.'**
  String get configShNewThresholdsSyncMessage;

  /// No description provided for @configShThresholdsLearningMessage.
  ///
  /// In en, this message translates to:
  /// **'During the learning period, thresholds are disabled so as not to influence your habits.'**
  String get configShThresholdsLearningMessage;

  /// No description provided for @configShThresholdsCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current thresholds'**
  String get configShThresholdsCurrent;

  /// No description provided for @configShThresholdsNewToApply.
  ///
  /// In en, this message translates to:
  /// **'New thresholds to apply'**
  String get configShThresholdsNewToApply;

  /// No description provided for @configShOldShFlowField.
  ///
  /// In en, this message translates to:
  /// **'Old showerhead flow rate'**
  String get configShOldShFlowField;

  /// No description provided for @configShRefShowerDurationField.
  ///
  /// In en, this message translates to:
  /// **'Reference shower'**
  String get configShRefShowerDurationField;

  /// No description provided for @configShRefShowerDurationHelp.
  ///
  /// In en, this message translates to:
  /// **'This is the average shower duration during the learning period (or 5 minutes by default).'**
  String get configShRefShowerDurationHelp;

  /// No description provided for @configShLearningSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get configShLearningSectionTitle;

  /// No description provided for @configShLearningLastShowerExcluded.
  ///
  /// In en, this message translates to:
  /// **'The most recent shower is not taken into account'**
  String get configShLearningLastShowerExcluded;

  /// No description provided for @configShLearningStartWarning.
  ///
  /// In en, this message translates to:
  /// **'The learning period will start at the next synchronization.\n\nThe showerhead lights will turn solid green.\n\nTo complete this process, you will need to reconnect to the app and wait for the full synchronization.\n\nDo you want to continue?'**
  String get configShLearningStartWarning;

  /// No description provided for @configShLearningStartHelp.
  ///
  /// In en, this message translates to:
  /// **'Remember to save and synchronize to get the green thresholds'**
  String get configShLearningStartHelp;

  /// No description provided for @configShLearningRunningHelp.
  ///
  /// In en, this message translates to:
  /// **'Remember to synchronize your showers'**
  String get configShLearningRunningHelp;

  /// No description provided for @configShLearningFirstTimeMessage.
  ///
  /// In en, this message translates to:
  /// **'We need to get to know you better to help you save water. Start the learning process!'**
  String get configShLearningFirstTimeMessage;

  /// No description provided for @configShLearningInPeriodMessage.
  ///
  /// In en, this message translates to:
  /// **'Take at least one shower per person using this showerhead. You can stop the learning process manually at any time.'**
  String get configShLearningInPeriodMessage;

  /// No description provided for @configShLearningRefShowersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} shower(s)'**
  String configShLearningRefShowersCount(int count);

  /// No description provided for @configShLearningStarted.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get configShLearningStarted;

  /// No description provided for @configShLearningEnded.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get configShLearningEnded;

  /// No description provided for @configShTechnicalSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Technical information'**
  String get configShTechnicalSectionTitle;

  /// No description provided for @configShNameExistsError.
  ///
  /// In en, this message translates to:
  /// **'This name is already in use'**
  String get configShNameExistsError;

  /// No description provided for @configShLastConnectionSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Last connection'**
  String get configShLastConnectionSectionTitle;

  /// No description provided for @configShLastConnectionFlowRate.
  ///
  /// In en, this message translates to:
  /// **'Water flow rate'**
  String get configShLastConnectionFlowRate;

  /// No description provided for @configShFlowQualityGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get configShFlowQualityGood;

  /// No description provided for @configShFlowQualityLow.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get configShFlowQualityLow;

  /// No description provided for @configShTechnicalUuidField.
  ///
  /// In en, this message translates to:
  /// **'Uuid'**
  String get configShTechnicalUuidField;

  /// No description provided for @configShTechnicalFwVersionField.
  ///
  /// In en, this message translates to:
  /// **'Firmware'**
  String get configShTechnicalFwVersionField;

  /// No description provided for @configShTechnicalHwVersionField.
  ///
  /// In en, this message translates to:
  /// **'Hardware'**
  String get configShTechnicalHwVersionField;

  /// No description provided for @finishLearningPeriodRefShowerSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Reference showers'**
  String get finishLearningPeriodRefShowerSectionTitle;

  /// No description provided for @finishLearningPeriodNoRefShower.
  ///
  /// In en, this message translates to:
  /// **'No reference showers were recorded during the learning period'**
  String get finishLearningPeriodNoRefShower;

  /// No description provided for @finishLearningPeriodChooseRefShower.
  ///
  /// In en, this message translates to:
  /// **'Choose the showers to be taken into account for calculating the reference duration and the challenge'**
  String get finishLearningPeriodChooseRefShower;

  /// No description provided for @finishLearningPeriodNewThresholdsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'New thresholds'**
  String get finishLearningPeriodNewThresholdsSectionTitle;

  /// No description provided for @finishLearningPeriodNewThresholdsCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current thresholds'**
  String get finishLearningPeriodNewThresholdsCurrent;

  /// No description provided for @finishLearningPeriodNewThresholdsNew.
  ///
  /// In en, this message translates to:
  /// **'Proposed new thresholds'**
  String get finishLearningPeriodNewThresholdsNew;

  /// No description provided for @finishLearningPeriodNewThresholdsMessage.
  ///
  /// In en, this message translates to:
  /// **'These new thresholds are calculated from the selected reference showers'**
  String get finishLearningPeriodNewThresholdsMessage;

  /// No description provided for @finishLearningPeriodNewThresholdsAccept.
  ///
  /// In en, this message translates to:
  /// **'I accept the proposed new thresholds'**
  String get finishLearningPeriodNewThresholdsAccept;

  /// No description provided for @finishLearningPeriodRefDurationSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Reference duration'**
  String get finishLearningPeriodRefDurationSectionTitle;

  /// No description provided for @finishLearningPeriodRefDurationMessage.
  ///
  /// In en, this message translates to:
  /// **'This duration is used as the basis for savings calculation'**
  String get finishLearningPeriodRefDurationMessage;

  /// No description provided for @stopLearningPeriodDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Stop learning'**
  String get stopLearningPeriodDialogTitle;

  /// No description provided for @configAppScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get configAppScreenTitle;

  /// No description provided for @configAppDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit my preferences'**
  String get configAppDialogTitle;

  /// No description provided for @configAppImportSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Import my data from...'**
  String get configAppImportSectionTitle;

  /// No description provided for @configAppImportFromCloud.
  ///
  /// In en, this message translates to:
  /// **'My Hydrao account'**
  String get configAppImportFromCloud;

  /// No description provided for @configAppImportFromBackupFile.
  ///
  /// In en, this message translates to:
  /// **'A backup'**
  String get configAppImportFromBackupFile;

  /// No description provided for @configAppExportSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Export my data to...'**
  String get configAppExportSectionTitle;

  /// No description provided for @configAppExportToBackupFile.
  ///
  /// In en, this message translates to:
  /// **'A backup'**
  String get configAppExportToBackupFile;

  /// No description provided for @configAppCountrySectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get configAppCountrySectionTitle;

  /// No description provided for @configAppUnitSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Currency & unit'**
  String get configAppUnitSectionTitle;

  /// No description provided for @configAppSavingsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Savings calculation'**
  String get configAppSavingsSectionTitle;

  /// No description provided for @configAppWaterPriceField.
  ///
  /// In en, this message translates to:
  /// **'Water price'**
  String get configAppWaterPriceField;

  /// No description provided for @configAppEnergyPriceField.
  ///
  /// In en, this message translates to:
  /// **'Energy price'**
  String get configAppEnergyPriceField;

  /// No description provided for @configAppEnergyField.
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get configAppEnergyField;

  /// No description provided for @configAppEnergyHelp.
  ///
  /// In en, this message translates to:
  /// **'This refers to the energy required to heat 1 liter of water.'**
  String get configAppEnergyHelp;

  /// No description provided for @configAppStatsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get configAppStatsSectionTitle;

  /// No description provided for @configAppShowerIgnored.
  ///
  /// In en, this message translates to:
  /// **'Ignore showers shorter than'**
  String get configAppShowerIgnored;

  /// No description provided for @createBackupFileCreated.
  ///
  /// In en, this message translates to:
  /// **'A backup of the application data has been created in this file:'**
  String get createBackupFileCreated;

  /// No description provided for @importBackupWrongFile.
  ///
  /// In en, this message translates to:
  /// **'This file does not contain a backup.'**
  String get importBackupWrongFile;

  /// No description provided for @importBackupMinContentError.
  ///
  /// In en, this message translates to:
  /// **'You must select at least one item to start the import.'**
  String get importBackupMinContentError;

  /// No description provided for @importBackupVersionWarning.
  ///
  /// In en, this message translates to:
  /// **'The data comes from a previous version of the application; some data may be missing during the import.'**
  String get importBackupVersionWarning;

  /// No description provided for @importBackupOsChangeWarning.
  ///
  /// In en, this message translates to:
  /// **'The data appears to come from another operating system. To ensure proper detection of the showerheads, you will need to go through adding the showerhead again and merge.'**
  String get importBackupOsChangeWarning;

  /// No description provided for @importBackupDataSourceSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Data source'**
  String get importBackupDataSourceSectionTitle;

  /// No description provided for @importBackupFromFileField.
  ///
  /// In en, this message translates to:
  /// **'From a file'**
  String get importBackupFromFileField;

  /// No description provided for @importBackupSettingsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get importBackupSettingsSectionTitle;

  /// No description provided for @importBackupShowerNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get importBackupShowerNone;

  /// No description provided for @importBackupShowerNewCount.
  ///
  /// In en, this message translates to:
  /// **'{count} new'**
  String importBackupShowerNewCount(int count);

  /// No description provided for @importBackupShowerhead.
  ///
  /// In en, this message translates to:
  /// **'Showerhead'**
  String get importBackupShowerhead;

  /// No description provided for @importBackupShowers.
  ///
  /// In en, this message translates to:
  /// **'Showers'**
  String get importBackupShowers;

  /// No description provided for @importBackupNewStatus.
  ///
  /// In en, this message translates to:
  /// **'new'**
  String get importBackupNewStatus;

  /// No description provided for @importBackupConflictStatus.
  ///
  /// In en, this message translates to:
  /// **'conflict'**
  String get importBackupConflictStatus;

  /// No description provided for @importBackupNoChangeStatus.
  ///
  /// In en, this message translates to:
  /// **'no change'**
  String get importBackupNoChangeStatus;

  /// No description provided for @dashboardScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardScreenTitle;

  /// No description provided for @dashboardSavingSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Overall savings'**
  String get dashboardSavingSectionTitle;

  /// No description provided for @dashboardSavingSectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Across all products, for all periods combined.'**
  String get dashboardSavingSectionDescription;

  /// No description provided for @dashboardLiveResetVolume.
  ///
  /// In en, this message translates to:
  /// **'Preparing a new shower'**
  String get dashboardLiveResetVolume;

  /// No description provided for @dashboardLiveSendThresholds.
  ///
  /// In en, this message translates to:
  /// **'Sending thresholds'**
  String get dashboardLiveSendThresholds;

  /// No description provided for @dashboardLiveSyncShowers.
  ///
  /// In en, this message translates to:
  /// **'Shower synchronization'**
  String get dashboardLiveSyncShowers;

  /// No description provided for @dashboardLiveShowerInProgress.
  ///
  /// In en, this message translates to:
  /// **'Shower in progress'**
  String get dashboardLiveShowerInProgress;

  /// No description provided for @dashboardSoapingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Soaping in progress'**
  String get dashboardSoapingInProgress;

  /// No description provided for @dashboardScanningText.
  ///
  /// In en, this message translates to:
  /// **'Keep the app open for immediate synchronization or sync your showers later'**
  String get dashboardScanningText;

  /// No description provided for @dashboardScanningShStoreShowers.
  ///
  /// In en, this message translates to:
  /// **'The showerhead stores up to 200 showers'**
  String get dashboardScanningShStoreShowers;

  /// No description provided for @statisticsScreenGlobalCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Tous les produits'**
  String get statisticsScreenGlobalCardTitle;

  /// No description provided for @statisticsScreenFilterAll.
  ///
  /// In en, this message translates to:
  /// **'Across all showers'**
  String get statisticsScreenFilterAll;

  /// No description provided for @statisticsScreenFilterOnLastShowers.
  ///
  /// In en, this message translates to:
  /// **'Over the last {count} showers'**
  String statisticsScreenFilterOnLastShowers(int count);

  /// No description provided for @showerVolumeBarchartNoShowerTitle.
  ///
  /// In en, this message translates to:
  /// **'No showers to display'**
  String get showerVolumeBarchartNoShowerTitle;

  /// No description provided for @showerVolumeBarchartNoShowerMessage.
  ///
  /// In en, this message translates to:
  /// **'Start using your showerhead and you will see your showers appear here.'**
  String get showerVolumeBarchartNoShowerMessage;

  /// No description provided for @showerVolumeBarchartSeeNextShowers.
  ///
  /// In en, this message translates to:
  /// **'View next showers'**
  String get showerVolumeBarchartSeeNextShowers;

  /// No description provided for @showerVolumeBarchartSeePreviousShowers.
  ///
  /// In en, this message translates to:
  /// **'View previous showers'**
  String get showerVolumeBarchartSeePreviousShowers;

  /// No description provided for @shStatisticsDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Showers of {sh}'**
  String shStatisticsDialogTitle(String sh);

  /// No description provided for @shStatisticsSelectShowerAdvice.
  ///
  /// In en, this message translates to:
  /// **'Select a shower to view details.'**
  String get shStatisticsSelectShowerAdvice;

  /// No description provided for @shStatisticsCancelSelection.
  ///
  /// In en, this message translates to:
  /// **'Selection'**
  String get shStatisticsCancelSelection;

  /// No description provided for @shStatisticsAverageVolumeMetric.
  ///
  /// In en, this message translates to:
  /// **'Average vol.'**
  String get shStatisticsAverageVolumeMetric;

  /// No description provided for @shStatisticsWaterSavingsMetric.
  ///
  /// In en, this message translates to:
  /// **'Water saved'**
  String get shStatisticsWaterSavingsMetric;

  /// No description provided for @shStatisticsMoneySavingsMetric.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get shStatisticsMoneySavingsMetric;

  /// No description provided for @shStatisticsShowerVolumeMetric.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get shStatisticsShowerVolumeMetric;

  /// No description provided for @shStatisticsShowerTemperatureMetric.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get shStatisticsShowerTemperatureMetric;

  /// No description provided for @shStatisticsShowerDurationMetric.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get shStatisticsShowerDurationMetric;

  /// No description provided for @shStatisticsShowerSoapingMetric.
  ///
  /// In en, this message translates to:
  /// **'Soaping'**
  String get shStatisticsShowerSoapingMetric;

  /// No description provided for @shStatisticsShowerSyncedAt.
  ///
  /// In en, this message translates to:
  /// **'Synchronized on'**
  String get shStatisticsShowerSyncedAt;

  /// No description provided for @shStatisticsShowersSyncedAt.
  ///
  /// In en, this message translates to:
  /// **'Synchronized on'**
  String get shStatisticsShowersSyncedAt;

  /// No description provided for @shStatisticsShowersSyncedInPeriod.
  ///
  /// In en, this message translates to:
  /// **'Synchronized'**
  String get shStatisticsShowersSyncedInPeriod;

  /// No description provided for @shStatisticsShowersSyncedPartially.
  ///
  /// In en, this message translates to:
  /// **'Synch. incomplete'**
  String get shStatisticsShowersSyncedPartially;

  /// No description provided for @shStatisticsShowerSelected.
  ///
  /// In en, this message translates to:
  /// **'Shower'**
  String get shStatisticsShowerSelected;

  /// No description provided for @shStatisticsLiveShowerSelected.
  ///
  /// In en, this message translates to:
  /// **'Last shower'**
  String get shStatisticsLiveShowerSelected;

  /// No description provided for @shStatisticsCountShowers.
  ///
  /// In en, this message translates to:
  /// **'{count} shower(s)'**
  String shStatisticsCountShowers(int count);

  /// No description provided for @shStatisticsNoFilteredShower.
  ///
  /// In en, this message translates to:
  /// **'No showers match the filters'**
  String get shStatisticsNoFilteredShower;

  /// No description provided for @shStatisticsNoFilteredShowerMessage.
  ///
  /// In en, this message translates to:
  /// **'Please modify or clear the filters to see the showers.'**
  String get shStatisticsNoFilteredShowerMessage;

  /// No description provided for @shStatisticsShowersAvgVolume.
  ///
  /// In en, this message translates to:
  /// **'avg. volume'**
  String get shStatisticsShowersAvgVolume;

  /// No description provided for @shStatisticsShowerheadSavings.
  ///
  /// In en, this message translates to:
  /// **'Savings for this showerhead'**
  String get shStatisticsShowerheadSavings;

  /// No description provided for @shStatisticsShowerIgnored.
  ///
  /// In en, this message translates to:
  /// **'Ignored'**
  String get shStatisticsShowerIgnored;

  /// No description provided for @shStatisticsShowerThresholds.
  ///
  /// In en, this message translates to:
  /// **'Thresholds'**
  String get shStatisticsShowerThresholds;

  /// No description provided for @shStatisticsShowerLearningThresholds.
  ///
  /// In en, this message translates to:
  /// **'Learning period thresholds'**
  String get shStatisticsShowerLearningThresholds;

  /// No description provided for @shStatisticsLiveShowerVol.
  ///
  /// In en, this message translates to:
  /// **'Vol.'**
  String get shStatisticsLiveShowerVol;

  /// No description provided for @shStatisticsLiveShowerMessage.
  ///
  /// In en, this message translates to:
  /// **'The information may change.'**
  String get shStatisticsLiveShowerMessage;

  /// No description provided for @showerFiltersDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter showers'**
  String get showerFiltersDialogTitle;

  /// No description provided for @showerFiltersUserPrefsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'User preferences'**
  String get showerFiltersUserPrefsSectionTitle;

  /// No description provided for @showerFiltersVolumeSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get showerFiltersVolumeSectionTitle;

  /// No description provided for @showerFiltersIgnoredField.
  ///
  /// In en, this message translates to:
  /// **'Ignored'**
  String get showerFiltersIgnoredField;

  /// No description provided for @showerFiltersIsChechedText.
  ///
  /// In en, this message translates to:
  /// **'is checked'**
  String get showerFiltersIsChechedText;

  /// No description provided for @showerFiltersIsNotCheckedText.
  ///
  /// In en, this message translates to:
  /// **'is not checked'**
  String get showerFiltersIsNotCheckedText;

  /// No description provided for @showerFiltersIsRefShowerField.
  ///
  /// In en, this message translates to:
  /// **'is a reference shower'**
  String get showerFiltersIsRefShowerField;

  /// No description provided for @showerFiltersChallengeKo.
  ///
  /// In en, this message translates to:
  /// **'Exceeds defined thresholds'**
  String get showerFiltersChallengeKo;

  /// No description provided for @showerFiltersIsGreaterThanField.
  ///
  /// In en, this message translates to:
  /// **'Is greater than'**
  String get showerFiltersIsGreaterThanField;

  /// No description provided for @showerFiltersIsLessThanField.
  ///
  /// In en, this message translates to:
  /// **'Is less than'**
  String get showerFiltersIsLessThanField;

  /// No description provided for @showerFiltersDurationSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get showerFiltersDurationSectionTitle;

  /// No description provided for @showerFiltersExceedRefShowerDurationField.
  ///
  /// In en, this message translates to:
  /// **'Exceeds the reference shower duration'**
  String get showerFiltersExceedRefShowerDurationField;

  /// No description provided for @savingsDetailsDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get savingsDetailsDialogTitle;

  /// No description provided for @savingsDetailsDialogCompareSection.
  ///
  /// In en, this message translates to:
  /// **'Comparison'**
  String get savingsDetailsDialogCompareSection;

  /// No description provided for @savingsDetailsDialogConsumptionSection.
  ///
  /// In en, this message translates to:
  /// **'Consumption'**
  String get savingsDetailsDialogConsumptionSection;

  /// No description provided for @savingsDetailsDialogOldShowerhead.
  ///
  /// In en, this message translates to:
  /// **'Old showerhead'**
  String get savingsDetailsDialogOldShowerhead;

  /// No description provided for @savingsDetailsDialogHydrao.
  ///
  /// In en, this message translates to:
  /// **'Hydrao'**
  String get savingsDetailsDialogHydrao;

  /// No description provided for @savingsDetailsDialogOldShowerheadHeader.
  ///
  /// In en, this message translates to:
  /// **'Old'**
  String get savingsDetailsDialogOldShowerheadHeader;

  /// No description provided for @savingsDetailsDialogSavingsHeader.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get savingsDetailsDialogSavingsHeader;

  /// No description provided for @instAloe1.
  ///
  /// In en, this message translates to:
  /// **'Unscrew your previous shower head to remove it.'**
  String get instAloe1;

  /// No description provided for @instAloe2.
  ///
  /// In en, this message translates to:
  /// **'Set in the supplied washer in the hose.'**
  String get instAloe2;

  /// No description provided for @instAloe3.
  ///
  /// In en, this message translates to:
  /// **'Screw on your new HYDRAO shower head'**
  String get instAloe3;

  /// No description provided for @instYucca1.
  ///
  /// In en, this message translates to:
  /// **'Turn the water off.'**
  String get instYucca1;

  /// No description provided for @instYucca2.
  ///
  /// In en, this message translates to:
  /// **'Unscrew your previous rain shower to remove it.'**
  String get instYucca2;

  /// No description provided for @instYucca3.
  ///
  /// In en, this message translates to:
  /// **'Screw on your new HYDRAO rain shower'**
  String get instYucca3;

  /// No description provided for @faqDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get faqDialogTitle;

  /// No description provided for @faqUsageTitle1.
  ///
  /// In en, this message translates to:
  /// **'How is the shower head powered?'**
  String get faqUsageTitle1;

  /// No description provided for @faqUsageTitle2.
  ///
  /// In en, this message translates to:
  /// **'Can we turn off the water during the shower to soap without ending the current shower?'**
  String get faqUsageTitle2;

  /// No description provided for @faqUsageTitle3.
  ///
  /// In en, this message translates to:
  /// **'HYDRAO Shower doesn’t light on'**
  String get faqUsageTitle3;

  /// No description provided for @faqUsageTitle4.
  ///
  /// In en, this message translates to:
  /// **'Why do I only see colors when I open the tap completely?'**
  String get faqUsageTitle4;

  /// No description provided for @faqUsageTitle5.
  ///
  /// In en, this message translates to:
  /// **'Why can’t I have the shower dates ?'**
  String get faqUsageTitle5;

  /// No description provided for @faqUsageTitle6.
  ///
  /// In en, this message translates to:
  /// **'Do I have to use the application each time I take a shower ?'**
  String get faqUsageTitle6;

  /// No description provided for @faqUsageDescription1.
  ///
  /// In en, this message translates to:
  /// **'HYDRAO Shower is equipped with a micro-turbine which supplies the power to the shower head thanks to the water flow. No battery is needed!'**
  String get faqUsageDescription1;

  /// No description provided for @faqUsageDescription2.
  ///
  /// In en, this message translates to:
  /// **'During your shower you can turn off the water as long as 2 minutes to soap without loosing your current shower data. After 2 minutes the shower head considers you have finished your shower.'**
  String get faqUsageDescription2;

  /// No description provided for @faqUsageDescription3.
  ///
  /// In en, this message translates to:
  /// **'First check you have the right pressure for the shower head to operate. As you already know, HYDRAO Shower doesn’t have any battery as its turbine harvest the energy of the water flow. Plug in your HYDRAO Shower (if not already done) and open the tap. Move the shower head upwards so that the water flow is directed upwards like a fountain. Measure the height of the water flow. It has to be higher than 70cm (27 inches) so that HYDRAO operate correctly, this is equivalent to 0.8 bar.'**
  String get faqUsageDescription3;

  /// No description provided for @faqUsageDescription4.
  ///
  /// In en, this message translates to:
  /// **'HYDRAO Shower Aloé is designed to limit your water consumption while optimising the turbine performances for the lights. Therefore, even if the tap is completely open, your water consumption from 2 to 5 bar is limited to 6.6L/min with the excess flow valve (Class A+) and 9L/min without the valve (Class A).'**
  String get faqUsageDescription4;

  /// No description provided for @faqUsageDescription5.
  ///
  /// In en, this message translates to:
  /// **'HYDRAO shower operates without batteries. It gets the energy from a turbine powered by water flow. Using no batteries is the most ecological solution, but as a consequence, we can’t maintain a clock in the shower head, and therefore have a timestamp on each shower. We are currently working on adding a battery in the shower head, or using a wifi/bluetooth gateway to be able to date showers.'**
  String get faqUsageDescription5;

  /// No description provided for @faqUsageDescription6.
  ///
  /// In en, this message translates to:
  /// **'You don’t need to connect to shower head on each showers. HYDRAO shower heads have a 200 shower memory. Connecting from time to time is enough to keep your shower history updated.'**
  String get faqUsageDescription6;

  /// No description provided for @faqInstallationTitle2.
  ///
  /// In en, this message translates to:
  /// **'Excess flow valve : How to use it?'**
  String get faqInstallationTitle2;

  /// No description provided for @faqInstallationDescription2.
  ///
  /// In en, this message translates to:
  /// **'In order to warranty the best possible experience with HYDRAO Shower, the water flow limiter should only be used if the water pressure at the shower head is above 0.8 bar. First, check your HYDRAO Shower works perfectly without the excess flow valve (colors, Bluetooth connectivity, pressure: the height of water flow should be higher than 70cm (27 inches) when you turn your HYDRAO Shower upwards). Then, unscrew HYDRAO Shower and insert the excess flow valve following the waterflow installation Guide. Screw your HYDRAO Shower back on the flexible hose. The flow will then be limited to 6.6L/min. If you would like to remove the water flow limiter, it is possible to take it out using with precaution a simple tool such as a corkscrew, a paperclip or a screwdriver.'**
  String get faqInstallationDescription2;

  /// No description provided for @faqConnectivityTitle1.
  ///
  /// In en, this message translates to:
  /// **'Is my smartphone compatible with HYDRAO?'**
  String get faqConnectivityTitle1;

  /// No description provided for @faqConnectivityTitle2.
  ///
  /// In en, this message translates to:
  /// **'How far can you use the HYDRAO app from the shower head?'**
  String get faqConnectivityTitle2;

  /// No description provided for @faqConnectivityTitle3.
  ///
  /// In en, this message translates to:
  /// **'Do I need to establish a connection with the app during each shower to retrieve all the data?'**
  String get faqConnectivityTitle3;

  /// No description provided for @faqConnectivityTitle4.
  ///
  /// In en, this message translates to:
  /// **'I can’t connect my Android smartphone to my HYDRAO Shower, what should I do?'**
  String get faqConnectivityTitle4;

  /// No description provided for @faqConnectivityDescription1.
  ///
  /// In en, this message translates to:
  /// **'In order to connect to HYDRAO Shower you need a smartphone that works with Android or iOS and is at least Bluetooth 4.0 capable.'**
  String get faqConnectivityDescription1;

  /// No description provided for @faqConnectivityDescription2.
  ///
  /// In en, this message translates to:
  /// **'The shower head uses the latest Bluetooth 4.0 technology that allows you to establish a connection within a few meters.'**
  String get faqConnectivityDescription2;

  /// No description provided for @faqConnectivityDescription3.
  ///
  /// In en, this message translates to:
  /// **'No, the shower head is equipped with an internal memory capable of storing up to 200 showers, meaning you can connect once from time to time without loosing your shower data.'**
  String get faqConnectivityDescription3;

  /// No description provided for @faqConnectivityDescription4.
  ///
  /// In en, this message translates to:
  /// **'It is required to give the app HYDRAO localisation permission, because Android requires localisation to be activated for the Bluetooth to function. On your smartphone, select Settings > Applications > HYDRAO > Permissions > Localisation : Allow'**
  String get faqConnectivityDescription4;

  /// No description provided for @legalNotice.
  ///
  /// In en, this message translates to:
  /// **'Legal notice'**
  String get legalNotice;

  /// No description provided for @legalNoticeText.
  ///
  /// In en, this message translates to:
  /// **'\t1.\tPRESENTATION :\nApp publisher: Smart & Blue\n196 route des vignes, 38430 Moirans\nResponsible publication: HYDRAO\ncontact@hydrao.fr\n\n\t2.\tTERMS OF USE OF OUR SERVICES\nThe use of our services include compliance with the following rules:\nDon’t misuse our Services. Do not interfere with our Services or try to access them using a method other than the interface and the instructions that we provide. You may use our Services only as permitted by law, including applicable export and re-export control laws and regulations. We may suspend or stop providing our Services to you if you do not comply with our terms or policies or if we are investigating suspected misconduct.\n\nABOUT THESE TERMS OF USE\n\nWe may modify these terms or any additional terms that apply to a Service to, for example, reflect changes to the law or changes to our Services. You should look at the terms regularly. We’ll post notice of modifications to these terms on this page. We’ll post notice of modified additional terms in the applicable Service. If you do not accept changes to the Conditions of a given service, you must cease all use of the Service.\n\nThese terms control the relationship between HYDRAO - Smart & Blue and you. They do not create any third party beneficiary rights.\n\nIf you do not comply with these terms, and we don’t take action right away, this doesn’t mean that we are giving up any rights that we may have. \n\n\nBY USING THE SOFTWARE, YOU ACCEPT THESE TERMS IF YOU DO NOT AGREE, DO NOT USE THE SOFTWARE.\n\n\nThese license terms are an agreement between HYDRAO – Smart & Blue and you. Please read them. They apply to the software named above. The terms also apply to any HYDRAO\n•   \tupdates,\n•   \tsupplements,\n•   \tInternet-based services, and\n•   \tsupport services\nfor this software, unless other terms accompany those items. If so, those terms apply.\n\nBY USING THE SOFTWARE, YOU ACCEPT THESE TERMS. IF YOU DO NOT ACCEPT THEM, DO NOT USE THE SOFTWARE.\n\nIf you comply with these license terms, you have the perpetual rights below.\n\n\n\t3.\tINSTALLATION AND USE RIGHTS.\n\t\t3.1.\tInstallation and Use.\nYou may install and use one copy of the software on an device that you own or control for non-commercial use purposes.\n\n\t\t3.2.\tThird Party Programs. \nThe software may include third party programs that HYDRAO - Smart & Blue, not the third party, licenses to you under this agreement. Notices, if any, for the third party program are included for your information only.\n\n\t4.\tDESCRIPTION OF SERVICES PROVIDED.\nThe purpose of the HYDRAO SMART SHOWER SOFTWARE is to collect data regarding on the usage habits for the water used for showering. These data are analyzed to evaluate HYDRAO SMART SHOWER products and thus to propose the most interesting evolutions to help the users understand and reduce their water usage. The HYDRAO SMART SHOWER SOFTWARE strives to provide as accurate information as possible. However, the company can not be held liable for oversights, inaccuracies or deficiencies due to updates, whether by it or third parties that provide it with this information.\n\nAll the information provided by HYDRAO SMART SHOWER SOFTWARE is for reference purposes only and is subject to change without. Furthermore, the information provided by HYDRAO SMART SHOWER SOFTWARE is not exhaustive. It is given subject to modifications that may arise after their in-line availability.\n\n\t5.\tCONTRACTUAL LIMITATIONS ON TECHNICAL DATA\nThe software uses Flutter technology. The software can not be held liable for material damages related to the use of the software. In addition, the user agrees to use the software on recent hardware, free from viruses and using an operating system with all the latest updates.\n\n\t6.\tINTERNET ACCESS MAY BE REQUIRED.\nYou may incur charges related to Internet access, data transfer and other services per the terms of the data service plan and any other agreement you have with your network operator due to use of the software.  You are solely responsible for any network operator charges.\n\n\t7.\tSCOPE OF LICENSE.\nThe software is not sold but licensed. This contract only gives you some rights to use the software. HYDRAO - Smart & Blue owns the intellectual property rights and has the rights to use all the elements available on the software, including text, images, graphics, logos, videos, icons and sounds. Except where applicable regulations give you other rights, and notwithstanding this limitation, you may only use the software in accordance with the terms of this agreement. To this end, you must comply with the technical restrictions contained in the software that allow you to use it only in a given manner. You are not allowed to:\n\n•   \tcircumvent the technical restrictions contained in the software;\n•   \treconstruct the logic of the software, decompile or disassemble it, except to the extent that such operations would be expressly permitted by applicable law notwithstanding this limitation;\n•   \tmake more copies of the software thanthan permitted in this agreement or applicable regulations, notwithstanding this limitation;\n•   \tpublish the software for reproduction by other parties\n•   \trent or lend the software;\n•   \ttransfer the software or this contract to a third party; or\n•   \tuse the software in combination with commercial hosting services.\nAny unauthorized use of the software or any of the elements it contains will be considered as constituting an infringement and prosecuted in accordance with the provisions of Articles L.335-2 and following of the Intellectual Property Code.\n\n\t8.\tLIABIITLY LIMITS\nHYDRAO – Smart & Blue acts as publisher of the software. The HYDRAO SMART SHOWER SOFTWARE is responsible for the quality and veracity of the content it publishes.\nThe HYDRAO SMART SHOWER SOFTWARE can not be held liable for direct or indirect damage to the user’s equipment when accessing the HYDRAO SMART SHOWER SOFTWARE, and resulting from the use of hardware that does not meet its specification as indicated in point 5, nor the appearance of a bug or an incompatibility.\nThe HYDRAO SMART SHOWER SOFTWARE can not be held liable for subsequent damages resulting from the use of the HYDRAO SMART SHOWER SOFTWARE.\n\n\t9.\tMANAGEMENT OF PERSONAL DATA.\nThe customer is informed of the regulations concerning marketing communication, the law of June 21, 2014 regarding the trust in the Digital Economy, the Data Protection Act of August 06, 2004 as well as the General Regulation on Data Protection (RGPD: no. 2016-679).\n\n\t\t9.1.\tHead of personal data collection\nFor personal data collected as part of the creation of the user’s personal account and its use of the application. The HYDRAO SMART SHOWER SOFTWARE is represented by Gabriel Della-Monica, the company’s legal representative.\nGiven that the HYDRAO SMART SHOWER SOFTWARE is in charge of processing the data it collects, it undertakes to comply with the legal provisions in force. It is its responsibility to establish the purposes of his data processing, to provide its customers, from obtaining their consent, complete information on the processing of their personal data and maintain a record of processing in accordance with reality. Whenever the HYDRAO SMART SHOWER SOFTWARE processes personal data, the HYDRAO SMART SHOWER SOFTWARE undertakes all reasonable measures to ensure the accuracy and relevance of the personal data collected for the purposes for which the HYDRAO SMART SHOWER SOFTWARE processes the data.\n\n\t\t9.2.\tPurpose of the data collected\nThe HYDRAO SMART SHOWER SOFTWARE is likely to process all or part of the following data:•   \tThe username to provide continuity of service when uninstalling the application\n•   \tThe tap water usage to help the user understand the stakes and reduce their usage\n•   \tCosts related to domestic water to inform the user of the financial cost of its consumption\n•   \tApplication usage data for diagnostic aid purposes in case of malfunction and help to improve our services\n•   \tUser communications\nThe HYDRAO SMART SHOWER SOFTWARE does not commercialize your personal data which are therefore only used by necessity or for statistical and analytical purposes.\n\n\t\t9.3.\tRight of access, rectification and opposition\nIn accordance with current European regulations, users of the HYDRAO SMART SHOWER SOFTWARE have the following rights:\n•   \tThe right of access (article 15 RGPD) and rectification (article 16 RGPD), updating, completeness of user data right of locking or deletion of personal user data (article 17 of the RGPD) , when they are inaccurate, incomplete, equivocal, out of date, or whose collection, use, communication or conservation is prohibited\n•   \tThe right to withdraw consent at any time (article 13-2c RGPD)\n•   \tThe right to limit the processing of users’ data (Article 18 RGPD)\n•   \tThe right of objection to the processing of users’ data (Article 21 RGPD)\n•   \tThe right to the portability of the data that the users have provided, when this data is the subject of automated processing based on their consent or on a contract (article 20 RGPD)\n•   \tThe right to define the fate of users’ data after their death and to choose to whom HYDRAO - Smart & Blue will have to communicate (or not) their data to a third party they have previously designated\n\nAs soon as HYDRAO - Smart & Blue becomes aware of the death of a user and in the absence of instructions from it, HYDRAO undertakes to destroy his(her) data, unless their retention is necessary for probative purposes or to fulfill a legal obligation.\nIf the user wishes to know how HYDRAO - Smart & Blue uses his personal data, wants  to rectify them or opposes their processing, the user can contact HYDRAO by email at contact@hydrao.com.\nIn this case, the user must indicate the personal data that he / she would like HYDRAO to correct, update or delete, identifying himself / herself with a copy of an identity document (identity card or passport) as well as a screenshot of the application with the identifier of the shower head used (see section parameters / My shower in the HYDRAO SMART SHOWER SOFTWARE).\nRequests for the deletion of personal data will be subject to the obligations imposed on HYDRAO by law, particularly with regard to the preservation or archiving of documents. Finally, users of the HYDRAO SMART SHOWER SOFTWARE may file a request with the supervisory authorities, particularly the CNIL (https://www.cnil.fr/fr/plaintes).\n\n\t\t9.4.\tNon-disclosure of personal data\n HYDRAO - Smart & Blue is prohibited from processing, hosting or transferring the information collected from its customers to/in a country located outside the European Union or recognized as \"unsuitable\" by the European Commission without informing the customer beforehand. However, HYDRAO remains free from the choice of its technical and commercial subcontractors on the condition that they present sufficient warrantees with regard to the requirements of the General Regulation on Data Protection (RGPD: No. 2016-679).\nHYDRAO - Smart & Blue undertakes to take all necessary precautions to preserve the security of personal information and in particular that it is not communicated to unauthorized persons. However, if an incident affecting the integrity or confidentiality of the customer’s information is brought to the attention of HYDRAO, it will promptly inform the customer and inform him of the corrective measures taken. In addition, HYDRAO - Smart & Blue does not collect any sensitive data.\nThe personal data of the user may be processed by HYDRAO - Smart & Blue subsidiaries and subcontractors (service providers), exclusively for the purposes of this policy.\nWithin the limits of their respective responsibilities and for the purposes mentioned above, the persons likely to have access to HYDRAO users’ data are mainly the employees in our technical department.\n\n\t\t9.5.\tTypes of data collected\n Regarding the users of the HYDRAO SMART SHOWER SOFTWARE, we collect the following data which are essential for the operation of the service, and which will be kept for a maximum period of 36 months after the last connection of the pommel through the application to our servers:\n•   \tUsername and passwords (encrypted)\n•   \tWater usage (volume, temperature, flow rate, pressure, time)\n•   \tProgrammed thresholds\n•   \tThe local cost of domestic water and water heating given in the application\n•   \tUsers’ communications with third parties via the HYDRAO SMART SHOWER SOFTWARE\n•   \tPublications or comments you provide to HYDRAO\n•   \tUsers’ usage and connection data\n•   \tModel and OS of the smartphone used for data collection\n•   \tThe approximate GPS coordinates of the phone connected to the shower head\n\n\t10.\tNOTIFICATION OF BREACHES\nWhatever efforts are made, no method of transmission over the Internet and no method of electronic storage is completely secure. We can not therefore guarantee absolute security. If we become aware of a security breach, we will notify the affected users so that they can take appropriate action. Our incident reporting procedures take into account our legal obligations, whether at the national or European level. We are committed to fully informing our customers of all matters relating to the security of their account and providing them with all the information they need to help them meet their own regulatory reporting requirements.\nNo personal information of the HYDRAO SMART SHOWER SOFTWARE user is published without the knowledge of the user, exchanged, transferred, assigned or sold on any support to third parties. Global statistics calculated from anonymized data may be disseminated for advertising purposes of our products. Only the acquisition of HYDRAO SMART SHOWER SOFTWARE and associated rights allow the transmission of such information to the prospective purchaser who would in turn be given the same obligation to store and modify users’ data as per HYDRAO SMART SHOWER SOFTWARE.\nTo ensure the security and confidentiality of personal data, the HYDRAO SMART SHOWER SOFTWARE uses networks protected by standard devices such as firewall, pseudo-anonymization, encryption and password.\nWhen processing personal data, the HYDRAO SMART SHOWER SOFTWARE takes all reasonable steps to protect against loss, misuse, unauthorized access, disclosure, alteration or destruction.\n\n\t11.\tTRANSFER TO ANOTHER DEVICE.\nYou may uninstall the software and install it on another device for your use. You may not do so to share this license between devices beyond the scope of this agreement.\n\n\t12.\tEXPORT RESTRICTIONS.\nThe software is subject to French export laws and regulations. You must comply with all domestic and international export laws and regulations that apply to the software. These laws include restrictions on destinations, end users and end use.\n\n\t13.\tCOPYRIGHT NOTICES.\nHYDRAO – Smart & Blue is a registered trademark of Smart & Blue SAS. in France.\n\n\t14.\tENTIRE AGREEMENT.\nThis agreement, and the terms for supplements, updates, Internet-based services and support services that you use, are the entire agreement for the software and support services.\n\n\t15.\tLEGAL EFFECT.\nThis agreement describes certain legal rights. You may have other rights under the laws of your country. You may also have rights with respect to the party from whom you acquired the software. This agreement does not change your rights under the laws of your country if the laws of your country do not permit it to do so.\n\n\t16.\tDISCLAIMER OF WARRANTY.\nTHE SOFTWARE IS LICENSED “AS-IS,” “WITH ALL FAULTS,” AND “AS AVAILABLE.”  YOU BEAR THE RISK OF USING IT.  IF DESIRED, YOU MAY NOTIFY GOOGLE FOR A REFUND OF THE PURCHASE PRICE.  TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, GOOGLE WILL HAVE NO OTHER WARRANTY OBLIGATION WHATSOEVER.  HYDRAO AND WIRELESS CARRIERS OVER WHOSE NETWORK THE SOFTWARE IS DISTRIBUTED, AND EACH OF OUR RESPECTIVE AFFILIATES, AND SUPPLIERS (“COVERED PARTIES”) GIVE NO EXPRESS WARRANTIES, GUARANTEES OR CONDITIONS UNDER OR IN RELATION TO THE SOFTWARE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH YOU.  SHOULD THE SOFTWARE BE DEFECTIVE, YOU ASSUME THE ENTIRE COST OF ALL NECESSARY SERVICING OR REPAIR.  YOU MAY HAVE ADDITIONAL CONSUMER RIGHTS UNDER YOUR LOCAL LAWS WHICH THIS AGREEMENT CANNOT CHANGE. TO THE EXTENT PERMITTED UNDER YOUR LOCAL LAWS, COVERED PARTIES EXCLUDE THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT.\n\n\t17.\tLIMITATION ON AND EXCLUSION OF REMEDIES AND DAMAGES.\nTO THE EXTENT NOT PROHIBITED BY LAW, YOU CAN RECOVER FROM HYDRAO ONLY DIRECT DAMAGES UP TO ONE U.S. DOLLAR. YOU AGREE NOT TO SEEK TO RECOVER ANY OTHER DAMAGES, INCLUDING CONSEQUENTIAL, LOST PROFITS, SPECIAL, INDIRECT OR INCIDENTAL DAMAGES FROM ANY COVERED PARTIES.\nThis limitation applies to:\n•   \tanything related to the software, services, content (including code) on third party Internet sites, or third party programs; and\n•   \tclaims for breach of contract, warranty, guarantee or condition; consumer protection; deception; unfair competition; strict liability, negligence, misinterpretation, omission, trespass or other tort; violation of statute or regulation; or unjust enrichment; all to the extent permitted by applicable law.\nIt also applies even if:\n\n•   \tRepair, replacement or refund for the software does not fully compensate you for any losses; or\n•   \tCovered Parties knew or should have known about the possibility of the damages.\nThe above limitation or exclusion may not apply to you because your country may not allow the exclusion or limitation of incidental, consequential or other damages.\n\n'**
  String get legalNoticeText;

  /// No description provided for @legalNoticeSection1Title.
  ///
  /// In en, this message translates to:
  /// **'1. PRESENTATION'**
  String get legalNoticeSection1Title;

  /// No description provided for @legalNoticeSection1Text.
  ///
  /// In en, this message translates to:
  /// **'App publisher: Smart & Blue\n196 route des vignes, 38430 Moirans\nResponsible publication: HYDRAO\ncontact@hydrao.fr'**
  String get legalNoticeSection1Text;

  /// No description provided for @legalNoticeSection2Title.
  ///
  /// In en, this message translates to:
  /// **'2. TERMS OF USE OF OUR SERVICES'**
  String get legalNoticeSection2Title;

  /// No description provided for @legalNoticeSection2Text.
  ///
  /// In en, this message translates to:
  /// **'The use of our services include compliance with the following rules:\nDon’t misuse our Services. Do not interfere with our Services or try to access them using a method other than the interface and the instructions that we provide. You may use our Services only as permitted by law, including applicable export and re-export control laws and regulations. We may suspend or stop providing our Services to you if you do not comply with our terms or policies or if we are investigating suspected misconduct.\n\nABOUT THESE TERMS OF USE\n\nWe may modify these terms or any additional terms that apply to a Service to, for example, reflect changes to the law or changes to our Services. You should look at the terms regularly. We’ll post notice of modifications to these terms on this page. We’ll post notice of modified additional terms in the applicable Service. If you do not accept changes to the Conditions of a given service, you must cease all use of the Service.\n\nThese terms control the relationship between HYDRAO - Smart & Blue and you. They do not create any third party beneficiary rights.\n\nIf you do not comply with these terms, and we don’t take action right away, this doesn’t mean that we are giving up any rights that we may have. \n\n\nBY USING THE SOFTWARE, YOU ACCEPT THESE TERMS IF YOU DO NOT AGREE, DO NOT USE THE SOFTWARE.\n\n\nThese license terms are an agreement between HYDRAO – Smart & Blue and you. Please read them. They apply to the software named above. The terms also apply to any HYDRAO\n•   \tupdates,\n•   \tsupplements,\n•   \tInternet-based services, and\n•   \tsupport services\nfor this software, unless other terms accompany those items. If so, those terms apply.\n\nBY USING THE SOFTWARE, YOU ACCEPT THESE TERMS. IF YOU DO NOT ACCEPT THEM, DO NOT USE THE SOFTWARE.\n\nIf you comply with these license terms, you have the perpetual rights below.'**
  String get legalNoticeSection2Text;

  /// No description provided for @legalNoticeSection3Title.
  ///
  /// In en, this message translates to:
  /// **'3. INSTALLATION AND USE RIGHTS'**
  String get legalNoticeSection3Title;

  /// No description provided for @legalNoticeSection3Text.
  ///
  /// In en, this message translates to:
  /// **'\t\t3.1.\tInstallation and Use.\nYou may install and use one copy of the software on an device that you own or control for non-commercial use purposes.\n\n\t\t3.2.\tThird Party Programs. \nThe software may include third party programs that HYDRAO - Smart & Blue, not the third party, licenses to you under this agreement. Notices, if any, for the third party program are included for your information only.'**
  String get legalNoticeSection3Text;

  /// No description provided for @legalNoticeSection4Title.
  ///
  /// In en, this message translates to:
  /// **'4. DESCRIPTION OF SERVICES PROVIDED'**
  String get legalNoticeSection4Title;

  /// No description provided for @legalNoticeSection4Text.
  ///
  /// In en, this message translates to:
  /// **'The purpose of the HYDRAO SMART SHOWER SOFTWARE is to collect data regarding on the usage habits for the water used for showering. These data are analyzed to evaluate HYDRAO SMART SHOWER products and thus to propose the most interesting evolutions to help the users understand and reduce their water usage. The HYDRAO SMART SHOWER SOFTWARE strives to provide as accurate information as possible. However, the company can not be held liable for oversights, inaccuracies or deficiencies due to updates, whether by it or third parties that provide it with this information.\n\nAll the information provided by HYDRAO SMART SHOWER SOFTWARE is for reference purposes only and is subject to change without. Furthermore, the information provided by HYDRAO SMART SHOWER SOFTWARE is not exhaustive. It is given subject to modifications that may arise after their in-line availability.'**
  String get legalNoticeSection4Text;

  /// No description provided for @legalNoticeSection5Title.
  ///
  /// In en, this message translates to:
  /// **'5. CONTRACTUAL LIMITATIONS ON TECHNICAL DATA'**
  String get legalNoticeSection5Title;

  /// No description provided for @legalNoticeSection5Text.
  ///
  /// In en, this message translates to:
  /// **'The software uses Flutter technology. The software can not be held liable for material damages related to the use of the software. In addition, the user agrees to use the software on recent hardware, free from viruses and using an operating system with all the latest updates.'**
  String get legalNoticeSection5Text;

  /// No description provided for @legalNoticeSection6Title.
  ///
  /// In en, this message translates to:
  /// **'6. INTERNET ACCESS MAY BE REQUIRED'**
  String get legalNoticeSection6Title;

  /// No description provided for @legalNoticeSection6Text.
  ///
  /// In en, this message translates to:
  /// **'You may incur charges related to Internet access, data transfer and other services per the terms of the data service plan and any other agreement you have with your network operator due to use of the software.  You are solely responsible for any network operator charges.'**
  String get legalNoticeSection6Text;

  /// No description provided for @legalNoticeSection7Title.
  ///
  /// In en, this message translates to:
  /// **'7. SCOPE OF LICENSE'**
  String get legalNoticeSection7Title;

  /// No description provided for @legalNoticeSection7Text.
  ///
  /// In en, this message translates to:
  /// **'The software is not sold but licensed. This contract only gives you some rights to use the software. HYDRAO - Smart & Blue owns the intellectual property rights and has the rights to use all the elements available on the software, including text, images, graphics, logos, videos, icons and sounds. Except where applicable regulations give you other rights, and notwithstanding this limitation, you may only use the software in accordance with the terms of this agreement. To this end, you must comply with the technical restrictions contained in the software that allow you to use it only in a given manner. You are not allowed to:\n\n•   \tcircumvent the technical restrictions contained in the software;\n•   \treconstruct the logic of the software, decompile or disassemble it, except to the extent that such operations would be expressly permitted by applicable law notwithstanding this limitation;\n•   \tmake more copies of the software thanthan permitted in this agreement or applicable regulations, notwithstanding this limitation;\n•   \tpublish the software for reproduction by other parties\n•   \trent or lend the software;\n•   \ttransfer the software or this contract to a third party; or\n•   \tuse the software in combination with commercial hosting services.\nAny unauthorized use of the software or any of the elements it contains will be considered as constituting an infringement and prosecuted in accordance with the provisions of Articles L.335-2 and following of the Intellectual Property Code.'**
  String get legalNoticeSection7Text;

  /// No description provided for @legalNoticeSection8Title.
  ///
  /// In en, this message translates to:
  /// **'8. LIABIITLY LIMITS'**
  String get legalNoticeSection8Title;

  /// No description provided for @legalNoticeSection8Text.
  ///
  /// In en, this message translates to:
  /// **'HYDRAO – Smart & Blue acts as publisher of the software. The HYDRAO SMART SHOWER SOFTWARE is responsible for the quality and veracity of the content it publishes.\nThe HYDRAO SMART SHOWER SOFTWARE can not be held liable for direct or indirect damage to the user’s equipment when accessing the HYDRAO SMART SHOWER SOFTWARE, and resulting from the use of hardware that does not meet its specification as indicated in point 5, nor the appearance of a bug or an incompatibility.\nThe HYDRAO SMART SHOWER SOFTWARE can not be held liable for subsequent damages resulting from the use of the HYDRAO SMART SHOWER SOFTWARE.'**
  String get legalNoticeSection8Text;

  /// No description provided for @legalNoticeSection9Title.
  ///
  /// In en, this message translates to:
  /// **'9. MANAGEMENT OF PERSONAL DATA'**
  String get legalNoticeSection9Title;

  /// No description provided for @legalNoticeSection9Text.
  ///
  /// In en, this message translates to:
  /// **'The customer is informed of the regulations concerning marketing communication, the law of June 21, 2014 regarding the trust in the Digital Economy, the Data Protection Act of August 06, 2004 as well as the General Regulation on Data Protection (RGPD: no. 2016-679).\n\n\t\t9.1.\tHead of personal data collection\nFor personal data collected as part of the creation of the user’s personal account and its use of the application. The HYDRAO SMART SHOWER SOFTWARE is represented by Gabriel Della-Monica, the company’s legal representative.\nGiven that the HYDRAO SMART SHOWER SOFTWARE is in charge of processing the data it collects, it undertakes to comply with the legal provisions in force. It is its responsibility to establish the purposes of his data processing, to provide its customers, from obtaining their consent, complete information on the processing of their personal data and maintain a record of processing in accordance with reality. Whenever the HYDRAO SMART SHOWER SOFTWARE processes personal data, the HYDRAO SMART SHOWER SOFTWARE undertakes all reasonable measures to ensure the accuracy and relevance of the personal data collected for the purposes for which the HYDRAO SMART SHOWER SOFTWARE processes the data.\n\n\t\t9.2.\tPurpose of the data collected\nThe HYDRAO SMART SHOWER SOFTWARE is likely to process all or part of the following data:•   \tThe username to provide continuity of service when uninstalling the application\n•   \tThe tap water usage to help the user understand the stakes and reduce their usage\n•   \tCosts related to domestic water to inform the user of the financial cost of its consumption\n•   \tApplication usage data for diagnostic aid purposes in case of malfunction and help to improve our services\n•   \tUser communications\nThe HYDRAO SMART SHOWER SOFTWARE does not commercialize your personal data which are therefore only used by necessity or for statistical and analytical purposes.\n\n\t\t9.3.\tRight of access, rectification and opposition\nIn accordance with current European regulations, users of the HYDRAO SMART SHOWER SOFTWARE have the following rights:\n•   \tThe right of access (article 15 RGPD) and rectification (article 16 RGPD), updating, completeness of user data right of locking or deletion of personal user data (article 17 of the RGPD) , when they are inaccurate, incomplete, equivocal, out of date, or whose collection, use, communication or conservation is prohibited\n•   \tThe right to withdraw consent at any time (article 13-2c RGPD)\n•   \tThe right to limit the processing of users’ data (Article 18 RGPD)\n•   \tThe right of objection to the processing of users’ data (Article 21 RGPD)\n•   \tThe right to the portability of the data that the users have provided, when this data is the subject of automated processing based on their consent or on a contract (article 20 RGPD)\n•   \tThe right to define the fate of users’ data after their death and to choose to whom HYDRAO - Smart & Blue will have to communicate (or not) their data to a third party they have previously designated\n\nAs soon as HYDRAO - Smart & Blue becomes aware of the death of a user and in the absence of instructions from it, HYDRAO undertakes to destroy his(her) data, unless their retention is necessary for probative purposes or to fulfill a legal obligation.\nIf the user wishes to know how HYDRAO - Smart & Blue uses his personal data, wants  to rectify them or opposes their processing, the user can contact HYDRAO by email at contact@hydrao.com.\nIn this case, the user must indicate the personal data that he / she would like HYDRAO to correct, update or delete, identifying himself / herself with a copy of an identity document (identity card or passport) as well as a screenshot of the application with the identifier of the shower head used (see section parameters / My shower in the HYDRAO SMART SHOWER SOFTWARE).\nRequests for the deletion of personal data will be subject to the obligations imposed on HYDRAO by law, particularly with regard to the preservation or archiving of documents. Finally, users of the HYDRAO SMART SHOWER SOFTWARE may file a request with the supervisory authorities, particularly the CNIL (https://www.cnil.fr/fr/plaintes).\n\n\t\t9.4.\tNon-disclosure of personal data\n HYDRAO - Smart & Blue is prohibited from processing, hosting or transferring the information collected from its customers to/in a country located outside the European Union or recognized as \"unsuitable\" by the European Commission without informing the customer beforehand. However, HYDRAO remains free from the choice of its technical and commercial subcontractors on the condition that they present sufficient warrantees with regard to the requirements of the General Regulation on Data Protection (RGPD: No. 2016-679).\nHYDRAO - Smart & Blue undertakes to take all necessary precautions to preserve the security of personal information and in particular that it is not communicated to unauthorized persons. However, if an incident affecting the integrity or confidentiality of the customer’s information is brought to the attention of HYDRAO, it will promptly inform the customer and inform him of the corrective measures taken. In addition, HYDRAO - Smart & Blue does not collect any sensitive data.\nThe personal data of the user may be processed by HYDRAO - Smart & Blue subsidiaries and subcontractors (service providers), exclusively for the purposes of this policy.\nWithin the limits of their respective responsibilities and for the purposes mentioned above, the persons likely to have access to HYDRAO users’ data are mainly the employees in our technical department.\n\n\t\t9.5.\tTypes of data collected\n Regarding the users of the HYDRAO SMART SHOWER SOFTWARE, we collect the following data which are essential for the operation of the service, and which will be kept for a maximum period of 36 months after the last connection of the pommel through the application to our servers:\n•   \tUsername and passwords (encrypted)\n•   \tWater usage (volume, temperature, flow rate, pressure, time)\n•   \tProgrammed thresholds\n•   \tThe local cost of domestic water and water heating given in the application\n•   \tUsers’ communications with third parties via the HYDRAO SMART SHOWER SOFTWARE\n•   \tPublications or comments you provide to HYDRAO\n•   \tUsers’ usage and connection data\n•   \tModel and OS of the smartphone used for data collection\n•   \tThe approximate GPS coordinates of the phone connected to the shower head'**
  String get legalNoticeSection9Text;

  /// No description provided for @legalNoticeSection10Title.
  ///
  /// In en, this message translates to:
  /// **'10. NOTIFICATION OF BREACHES'**
  String get legalNoticeSection10Title;

  /// No description provided for @legalNoticeSection10Text.
  ///
  /// In en, this message translates to:
  /// **'Whatever efforts are made, no method of transmission over the Internet and no method of electronic storage is completely secure. We can not therefore guarantee absolute security. If we become aware of a security breach, we will notify the affected users so that they can take appropriate action. Our incident reporting procedures take into account our legal obligations, whether at the national or European level. We are committed to fully informing our customers of all matters relating to the security of their account and providing them with all the information they need to help them meet their own regulatory reporting requirements.\nNo personal information of the HYDRAO SMART SHOWER SOFTWARE user is published without the knowledge of the user, exchanged, transferred, assigned or sold on any support to third parties. Global statistics calculated from anonymized data may be disseminated for advertising purposes of our products. Only the acquisition of HYDRAO SMART SHOWER SOFTWARE and associated rights allow the transmission of such information to the prospective purchaser who would in turn be given the same obligation to store and modify users’ data as per HYDRAO SMART SHOWER SOFTWARE.\nTo ensure the security and confidentiality of personal data, the HYDRAO SMART SHOWER SOFTWARE uses networks protected by standard devices such as firewall, pseudo-anonymization, encryption and password.\nWhen processing personal data, the HYDRAO SMART SHOWER SOFTWARE takes all reasonable steps to protect against loss, misuse, unauthorized access, disclosure, alteration or destruction.'**
  String get legalNoticeSection10Text;

  /// No description provided for @legalNoticeSection11Title.
  ///
  /// In en, this message translates to:
  /// **'11. TRANSFER TO ANOTHER DEVICE'**
  String get legalNoticeSection11Title;

  /// No description provided for @legalNoticeSection11Text.
  ///
  /// In en, this message translates to:
  /// **'You may uninstall the software and install it on another device for your use. You may not do so to share this license between devices beyond the scope of this agreement.'**
  String get legalNoticeSection11Text;

  /// No description provided for @legalNoticeSection12Title.
  ///
  /// In en, this message translates to:
  /// **'12. EXPORT RESTRICTIONS'**
  String get legalNoticeSection12Title;

  /// No description provided for @legalNoticeSection12Text.
  ///
  /// In en, this message translates to:
  /// **'The software is subject to French export laws and regulations. You must comply with all domestic and international export laws and regulations that apply to the software. These laws include restrictions on destinations, end users and end use.'**
  String get legalNoticeSection12Text;

  /// No description provided for @legalNoticeSection13Title.
  ///
  /// In en, this message translates to:
  /// **'13. COPYRIGHT NOTICES'**
  String get legalNoticeSection13Title;

  /// No description provided for @legalNoticeSection13Text.
  ///
  /// In en, this message translates to:
  /// **'HYDRAO – Smart & Blue is a registered trademark of Smart & Blue SAS. in France.'**
  String get legalNoticeSection13Text;

  /// No description provided for @legalNoticeSection14Title.
  ///
  /// In en, this message translates to:
  /// **'14. ENTIRE AGREEMENT'**
  String get legalNoticeSection14Title;

  /// No description provided for @legalNoticeSection14Text.
  ///
  /// In en, this message translates to:
  /// **'This agreement, and the terms for supplements, updates, Internet-based services and support services that you use, are the entire agreement for the software and support services.'**
  String get legalNoticeSection14Text;

  /// No description provided for @legalNoticeSection15Title.
  ///
  /// In en, this message translates to:
  /// **'15. LEGAL EFFECT'**
  String get legalNoticeSection15Title;

  /// No description provided for @legalNoticeSection15Text.
  ///
  /// In en, this message translates to:
  /// **'This agreement describes certain legal rights. You may have other rights under the laws of your country. You may also have rights with respect to the party from whom you acquired the software. This agreement does not change your rights under the laws of your country if the laws of your country do not permit it to do so.'**
  String get legalNoticeSection15Text;

  /// No description provided for @legalNoticeSection16Title.
  ///
  /// In en, this message translates to:
  /// **'16. DISCLAIMER OF WARRANTY'**
  String get legalNoticeSection16Title;

  /// No description provided for @legalNoticeSection16Text.
  ///
  /// In en, this message translates to:
  /// **'THE SOFTWARE IS LICENSED “AS-IS,” “WITH ALL FAULTS,” AND “AS AVAILABLE.”  YOU BEAR THE RISK OF USING IT.  IF DESIRED, YOU MAY NOTIFY GOOGLE FOR A REFUND OF THE PURCHASE PRICE.  TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, GOOGLE WILL HAVE NO OTHER WARRANTY OBLIGATION WHATSOEVER.  HYDRAO AND WIRELESS CARRIERS OVER WHOSE NETWORK THE SOFTWARE IS DISTRIBUTED, AND EACH OF OUR RESPECTIVE AFFILIATES, AND SUPPLIERS (“COVERED PARTIES”) GIVE NO EXPRESS WARRANTIES, GUARANTEES OR CONDITIONS UNDER OR IN RELATION TO THE SOFTWARE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH YOU.  SHOULD THE SOFTWARE BE DEFECTIVE, YOU ASSUME THE ENTIRE COST OF ALL NECESSARY SERVICING OR REPAIR.  YOU MAY HAVE ADDITIONAL CONSUMER RIGHTS UNDER YOUR LOCAL LAWS WHICH THIS AGREEMENT CANNOT CHANGE. TO THE EXTENT PERMITTED UNDER YOUR LOCAL LAWS, COVERED PARTIES EXCLUDE THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT.'**
  String get legalNoticeSection16Text;

  /// No description provided for @legalNoticeSection17Title.
  ///
  /// In en, this message translates to:
  /// **'17. LIMITATION ON AND EXCLUSION OF REMEDIES AND DAMAGES'**
  String get legalNoticeSection17Title;

  /// No description provided for @legalNoticeSection17Text.
  ///
  /// In en, this message translates to:
  /// **'TO THE EXTENT NOT PROHIBITED BY LAW, YOU CAN RECOVER FROM HYDRAO ONLY DIRECT DAMAGES UP TO ONE U.S. DOLLAR. YOU AGREE NOT TO SEEK TO RECOVER ANY OTHER DAMAGES, INCLUDING CONSEQUENTIAL, LOST PROFITS, SPECIAL, INDIRECT OR INCIDENTAL DAMAGES FROM ANY COVERED PARTIES.\nThis limitation applies to:\n•   \tanything related to the software, services, content (including code) on third party Internet sites, or third party programs; and\n•   \tclaims for breach of contract, warranty, guarantee or condition; consumer protection; deception; unfair competition; strict liability, negligence, misinterpretation, omission, trespass or other tort; violation of statute or regulation; or unjust enrichment; all to the extent permitted by applicable law.\nIt also applies even if:\n\n•   \tRepair, replacement or refund for the software does not fully compensate you for any losses; or\n•   \tCovered Parties knew or should have known about the possibility of the damages.\nThe above limitation or exclusion may not apply to you because your country may not allow the exclusion or limitation of incidental, consequential or other damages.'**
  String get legalNoticeSection17Text;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
