// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get defaultScreenTitle => 'Hydrao';

  @override
  String get typeAloe => 'Aloé';

  @override
  String get typeCereus => 'Cereus';

  @override
  String get typeYucca => 'Yucca';

  @override
  String get typeFirst => 'First';

  @override
  String get typeMixer => 'Mitigeur';

  @override
  String get typeUnknown => 'Non défini';

  @override
  String get newShowerheadLabel => 'Pommeau';

  @override
  String get defaultShowerheadName => 'Pommeau Hydrao';

  @override
  String get addShTitle => 'Ajouter un pommeau';

  @override
  String get bluetoothDisabled => 'Votre Bluetooth est désactivé. Veuillez l\'activer avant de poursuivre.';

  @override
  String get openBluetoothSettings => 'Ouvrir les paramètres';

  @override
  String get showerheadDetectionBlocked => 'La détection de pommeau est bloquée';

  @override
  String get allowPermissions => 'Autoriser les permissions';

  @override
  String get enableBluetooth => 'Veuillez activer le bluetooth dans les paramètres';

  @override
  String get showerheadNotDetected => 'Votre pommeau n\'est pas détecté ?';

  @override
  String get addShScanningText => 'Laissez l\'application ouverte et ouvrez l\'eau du pommeau à installer';

  @override
  String get addShConnectingText => 'Connexion en cours ...';

  @override
  String get addShBackWarningMessage => 'Votre pommeau n\'est pas encore ajouté !\n\nÊtes-vous sûr de vouloir quitter ?';

  @override
  String get connectedShStopWater => 'Veuillez arrêter l\'eau avant de continuer';

  @override
  String get addShConnectedText => 'Le pommeau est bien reconnu';

  @override
  String get addShConnectedWarningFlowTitle => 'Débit faible détecté';

  @override
  String get addShConnectedWarningFlowMessage => 'Si un réducteur de débit est installé,\nveuillez le retirer.';

  @override
  String get needHelpToInstall => 'Besoin d\'aide pour installer le pommeau ?';

  @override
  String get helpShNotDetectedDialogTitle => 'Pommeau non détecté ?';

  @override
  String get helpShNotDetectedNeedShowerSectionTitle => 'Durant une douche';

  @override
  String get helpShNotDetectedNeedShowerWaterText => 'Le pommeau n\'a pas de batterie donc il lui faut un débit d\'eau suffisant pour communiquer.';

  @override
  String get helpShNotDetectedNeedShowerLightsText => 'Les lumières du pommeau doivent être éclairées.';

  @override
  String get helpShNotDetectedBleSectionTitle => 'Bluetooth (BLE)';

  @override
  String get helpShNotDetectedBleCompatibilityText => 'Votre téléphone doit être compatible avec le Bluetooth 4.0 ou supérieur.';

  @override
  String get helpShNotDetectedBleServiceText => 'Le service Bluetooth doit être activé.';

  @override
  String get helpShNotDetectedBlePermissionText => 'L\'application doit avoir la permission localisation pour détecter le pommeau.';

  @override
  String get helpShNotDetectedBleRangeText => 'Le téléphone doit être idéalement à 3 mètres maximum du pommeau.';

  @override
  String get helpShNotDetectedConflictSectionTitle => 'Risque de conflit';

  @override
  String get helpShNotDetectedConflictOnlyOneDevieText => 'Le pommeau ne peut se connecter qu\'à un appareil à la fois.';

  @override
  String get helpShNotDetectedConflictGateway => 'Si vous utilisez une passerelle, veuillez la débrancher temporairement.';

  @override
  String get helpRemoveFlowRestrictorDialogTitle => 'En cas de débit faible';

  @override
  String get helpRemoveFlowRestrictorDialogIssuesSection => 'Un débit faible peut influencer le bon fonctionnement des lumières du pommeau ainsi que la synchronisation des douches';

  @override
  String get helpRemoveFlowRestrictorDialogRemoveSection => 'Vérifiez si votre pommeau a un réducteur de débit installé.\n\nSi c\'est le cas, veuillez le retirer.';

  @override
  String get installNewShowerhead => 'Installer le nouveau pommeau';

  @override
  String get installNewShText => 'Pour commencer,\nvous devez installer votre nouveau pommeau';

  @override
  String get installNewShProduct => 'Produit';

  @override
  String partialDetectedShSectionTitle(int count) {
    return '$count pommeau(x) détecté(s)';
  }

  @override
  String dashboardShowerheadsSectionTitle(int count) {
    return 'Mes pommeaux ($count)';
  }

  @override
  String dbShowerheadCardOnShowers(int count) {
    return '$count douches';
  }

  @override
  String get dbShowerheadCardNewThresholds => 'Nouveaux seuils à transmettre au pommeau';

  @override
  String get dbShowerheadCardLearning => 'Apprentissage en cours';

  @override
  String get dbShowerheadCardLearningStart => 'Synchronisez pour démarrer la période d\'apprentissage';

  @override
  String get dbShowerheadCardSyncPartial => 'incomplet';

  @override
  String get dbShowerheadCardSynUpToDate => 'à jour';

  @override
  String get dbShowerheadCardSyncToDo => 'Synchronisation en attente';

  @override
  String get dbShowerheadCardNoShower => 'Aucune douche';

  @override
  String get dbShowerheadCardAverageVol => 'Moy.';

  @override
  String get statsShowerheadCardAverageVol => 'Moy.';

  @override
  String get statsShowerheadCardShowShowers => 'Douches';

  @override
  String get statsShowerheadCardHideShowers => 'Masquer';

  @override
  String get statsShowerheadCardGoldBadge => 'Or';

  @override
  String get statsShowerheadCardSilverBadge => 'Argent';

  @override
  String get statsShowerheadCardBronzeBadge => 'Bronze';

  @override
  String get statsShowerheadCardBadgeTootipLiter => 'Le badge symbolise le niveau de challenge atteint :\n\nOr = Volume moyen inférieur à 20L\n\nArgent = Volume moyen compris entre 20L et 35L\n\nBronze = Volume moyen supérieur à 35L';

  @override
  String get statsShowerheadCardBadgeTootipGallon => 'Le badge symbolise le niveau de challenge atteint :\n\nOr = Volume moyen inférieur à 5,3 gallons\n\nArgent = Volume moyen compris entre 5,3 et 9,2 gallons\n\nBronze = Volume moyen supérieur à 9,2 gallons';

  @override
  String get statsShowerheadCardSavings => 'Économies';

  @override
  String get statsShowerheadCardOnNVolume => 'Sur';

  @override
  String get begin => 'Commencer';

  @override
  String get beginAgain => 'Recommencer';

  @override
  String get stop => 'Arrêter';

  @override
  String get close => 'Fermer';

  @override
  String get save => 'Sauvegarder';

  @override
  String get edit => 'Modifier';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteAllData => 'Réinitialiser l\'application';

  @override
  String get add => 'Ajouter';

  @override
  String get toContinue => 'Continuer';

  @override
  String get confirm => 'Confirmer';

  @override
  String get cancel => 'Annuler';

  @override
  String get choose => 'Choisir';

  @override
  String get share => 'Partager';

  @override
  String get unselect => 'Déselectionner';

  @override
  String get filter => 'Filtrer';

  @override
  String get import => 'Importer';

  @override
  String get export => 'Exporter';

  @override
  String get merge => 'Fusionner';

  @override
  String get erase => 'Effacer';

  @override
  String get send => 'Envoyer';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get takeAPhoto => 'Prendre une photo';

  @override
  String get login => 'Se connecter';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get fromGallery => 'Choisir dans la galerie';

  @override
  String get fromFiles => 'Choisir dans les fichiers';

  @override
  String get connecting => 'Connexion en cours...';

  @override
  String get formValidatorRequired => 'Champs obligatoire';

  @override
  String formValidatorGreaterThan(double value) {
    return 'La valeur doit être supérieure à $value';
  }

  @override
  String formValidatorLesserOrEqualThan(double value) {
    return 'La valeur doit être inférieure ou égale à $value';
  }

  @override
  String get iNeedHelp => 'J\'ai besoin d\'aide';

  @override
  String get loginDialogTitle => 'Mon compte Hydrao';

  @override
  String get loginFormFailMessage => 'La connexion a échouée, veuillez vérifier vos identifiants';

  @override
  String get loginFormEmailField => 'Email';

  @override
  String get loginFormPasswordField => 'Mot de passe';

  @override
  String get formContactUsDialogTitle => 'Formulaire de contact';

  @override
  String get contactUsDialogTitle => 'Nous contacter';

  @override
  String get contactUsNeedHelpSection => 'Vous avez besoin d\'aide ?';

  @override
  String get contactUsNeedHelpText => 'Donnez-nous quelques informations afin de mieux répondre à votre question';

  @override
  String get contactUsSupportNeedDataSection => 'À la demande du support';

  @override
  String get contactUsSupportNeedDataText => 'Si l\'équipe de support vous demande des données techniques ou d\'usage afin de vous aider à régler votre problème.';

  @override
  String get contactUsMessageHint => 'Écrire votre message ici...';

  @override
  String get contactUsAllowShareTechData => 'J\'autorise l\'envoi de données techniques';

  @override
  String get contactUsAllowShareUserData => 'J\'autorise l\'envoi de mes données (un export)';

  @override
  String get contactUsNoDataSharedConfirm => 'Vous avez décider de ne pas partager de données (techniques & usages).\n\nCela rendra les choses plus difficile pour l\'équipe Support de vous apporter la meilleure aide possible.\n\nÊtes-vous sûr de vouloir continuer ?';

  @override
  String get moreScreenFaqMenuItem => 'Foire aux questions';

  @override
  String get moreScreenLegalNoticeMenuItem => 'Mentions légales';

  @override
  String get moreScreenContactUsMenuItem => 'Nous contacter';

  @override
  String get shInstalled => 'Mon pommeau est installé';

  @override
  String get showerFinished => 'J\'ai fini ma douche';

  @override
  String get confirmCloseFormWithChanges => 'Vous avez des modifications non sauvegardées.\n\nÊtes-vous sûr de continuer ?';

  @override
  String get confirmDeleteSh => 'Ce pommeau sera oublié sur ce téléphone. Toutes les douches synchronisées seront supprimées.\n\nSeules les douches en mémoire dans le pommeau seront conservées.\n\nÊtes-vous sûr de continuer ?';

  @override
  String get confirmResetApp => 'Toutes les données (pommeaux, douches synchronisées, paramétrages) seront supprimées.\n\nSeules les douches en mémoire dans les pommeaux seront conservées.\n\nPour rappel, vous pouvez réaliser une sauvegarde des données de l\'application.\n\nÊtes-vous sûr de continuer la réinitialisation ?';

  @override
  String get confirmCloseApp => 'Êtes-vous sûr de vouloir quitter l\'application ?';

  @override
  String get editShThresholdsDialogTitle => 'Configuration des seuils';

  @override
  String get importBackupDialogTitle => 'Import';

  @override
  String get importBackupCloudSectionTitle => 'Mon compte Hydrao';

  @override
  String get importBackupCloudNoEmail => 'Non renseigné';

  @override
  String get importBackupCloudDownloadingBackup => 'Téléchargement des données...';

  @override
  String get importBackupCloudDownloadFailed => 'Téléchargement échoué';

  @override
  String get importBackupSelectDataToImport => 'Sélectionner les données à importer';

  @override
  String get createBackupDialogTitle => 'Sauvegarde de l\'application';

  @override
  String get shareBackupSubject => 'Sauvegarde Hydrao';

  @override
  String get shareBackupMessage => 'Voici un export des données de l\'application Hydrao.';

  @override
  String get configShDialogTitle => 'Configurer le pommeau';

  @override
  String get configShMergeNotice => 'Ce pommeau existe déjà dans votre liste avec un autre identifiant';

  @override
  String get configShSavingsSectionTitle => 'Calcul des économies';

  @override
  String get configShThresholdsSectionTitle => 'Couleur / consommation';

  @override
  String get configShNewThresholdsSyncMessage => 'Les nouveaux seuils seront transmis au pommeau lors de la prochaine douche synchronisée avec votre appareil';

  @override
  String get configShThresholdsLearningMessage => 'Durant la période d\'apprentissage, les seuils sont désactivés afin de ne pas influencer vos habitudes.';

  @override
  String get configShThresholdsCurrent => 'Seuils actuels';

  @override
  String get configShThresholdsNewToApply => 'Nouveaux seuils à appliquer';

  @override
  String get configShOldShFlowField => 'Débit ancien pommeau';

  @override
  String get configShRefShowerDurationField => 'Douche de référence';

  @override
  String get configShRefShowerDurationHelp => 'Il s\'agit de la moyenne de la durée des douches durant la période d\'apprentissage (ou 5 minutes par défaut)';

  @override
  String get configShLearningSectionTitle => 'Apprentissage';

  @override
  String get configShLearningLastShowerExcluded => 'La douche la plus récente n\'est pas prise en compte';

  @override
  String get configShLearningStartWarning => 'La période d\'apprentissage démarrera à la prochaine synchronisation.\n\nLes lumières du pommeau passeront en vert continu.\n\nPour finalisez cette procédure, vous devrez vous reconnecter à l\'application et attendre la synchronisation complète.\n\nVoulez-vous continuez ?';

  @override
  String get configShLearningStartHelp => 'Pensez à sauvegarder puis synchroniser pour avoir les seuils verts';

  @override
  String get configShLearningRunningHelp => 'Pensez à synchroniser vos douches';

  @override
  String get configShLearningFirstTimeMessage => 'Nous avons besoin de mieux vous connaître pour vous aider à faire des économies. Commencez l\'apprentissage !';

  @override
  String get configShLearningInPeriodMessage => 'Prenez au moins une douche par personne amenée à utiliser ce pommeau. Arrêter manuellement l\'apprentissage à tout moment.';

  @override
  String configShLearningRefShowersCount(int count) {
    return '$count douche(s)';
  }

  @override
  String get configShLearningStarted => 'Démarré';

  @override
  String get configShLearningEnded => 'Fini';

  @override
  String get configShTechnicalSectionTitle => 'Informations techniques';

  @override
  String get configShNameExistsError => 'Ce nom est déjà utilisé';

  @override
  String get configShLastConnectionSectionTitle => 'Dernière connexion';

  @override
  String get configShLastConnectionFlowRate => 'Débit d\'eau';

  @override
  String get configShFlowQualityGood => 'Correct';

  @override
  String get configShFlowQualityLow => 'Faible';

  @override
  String get configShTechnicalUuidField => 'Uuid';

  @override
  String get configShTechnicalFwVersionField => 'Firmware';

  @override
  String get configShTechnicalHwVersionField => 'Version matérielle';

  @override
  String get finishLearningPeriodRefShowerSectionTitle => 'Douches de référence';

  @override
  String get finishLearningPeriodNoRefShower => 'Aucune douche de référence enregistrée durant la période d\'apprentissage';

  @override
  String get finishLearningPeriodChooseRefShower => 'Choisissez les douches à prendre en compte pour le calcul de la durée de référence et le challenge';

  @override
  String get finishLearningPeriodNewThresholdsSectionTitle => 'Nouveaux seuils';

  @override
  String get finishLearningPeriodNewThresholdsCurrent => 'Seuils actuels';

  @override
  String get finishLearningPeriodNewThresholdsNew => 'Nouveaux seuils proposés';

  @override
  String get finishLearningPeriodNewThresholdsMessage => 'Ces nouveaux seuils sont calculés à partir des douches de références choisies';

  @override
  String get finishLearningPeriodNewThresholdsAccept => 'J\'accepte les nouveaux seuils proposés';

  @override
  String get finishLearningPeriodRefDurationSectionTitle => 'Durée de référence';

  @override
  String get finishLearningPeriodRefDurationMessage => 'Cette durée sert de base pour le calcul des économies';

  @override
  String get stopLearningPeriodDialogTitle => 'Arrêter l\'apprentissage';

  @override
  String get configAppScreenTitle => 'Préférences';

  @override
  String get configAppDialogTitle => 'Modifier mes préférences';

  @override
  String get configAppImportSectionTitle => 'Importer mes données depuis...';

  @override
  String get configAppImportFromCloud => 'Mon compte Hydrao';

  @override
  String get configAppImportFromBackupFile => 'Une sauvegarde';

  @override
  String get configAppExportSectionTitle => 'Exporter mes données vers ...';

  @override
  String get configAppExportToBackupFile => 'Une sauvegarde';

  @override
  String get configAppCountrySectionTitle => 'Pays';

  @override
  String get configAppUnitSectionTitle => 'Monnaie & unité';

  @override
  String get configAppSavingsSectionTitle => 'Calcul des économies';

  @override
  String get configAppWaterPriceField => 'Prix de l\'eau';

  @override
  String get configAppEnergyPriceField => 'Prix de l\'énergie';

  @override
  String get configAppEnergyField => 'Énergie';

  @override
  String get configAppEnergyHelp => 'On parle ici de l\'énergie nécessaire pour chauffer 1 litre d\'eau';

  @override
  String get configAppStatsSectionTitle => 'Statistiques';

  @override
  String get configAppShowerIgnored => 'Ignorer les douches de moins de';

  @override
  String get createBackupFileCreated => 'Une sauvegarde des données de l\'application a été faite dans ce fichier :';

  @override
  String get importBackupWrongFile => 'Ce fichier ne contient pas une sauvegarde';

  @override
  String get importBackupMinContentError => 'Il faut choisir au minimum un élément pour démarrer l\'import';

  @override
  String get importBackupVersionWarning => 'Les données proviennent d\'une version antérieure de l\'application, certaines données peuvent être manquantes lors de l\'import';

  @override
  String get importBackupOsChangeWarning => 'Les données semblent venir d\'un autre système d\'exploitation. Pour assurer la bonne détection des pommeaux, il faudra repasser par l\'ajout de pommeau et fusionner';

  @override
  String get importBackupDataSourceSectionTitle => 'Source des données';

  @override
  String get importBackupFromFileField => 'Depuis un fichier';

  @override
  String get importBackupSettingsSectionTitle => 'Préférences';

  @override
  String get importBackupShowerNone => 'Aucune';

  @override
  String importBackupShowerNewCount(int count) {
    return '$count nouvelle(s)';
  }

  @override
  String get importBackupShowerhead => 'Pommeau';

  @override
  String get importBackupShowers => 'Douches';

  @override
  String get importBackupNewStatus => 'nouveau';

  @override
  String get importBackupConflictStatus => 'conflit';

  @override
  String get importBackupNoChangeStatus => 'identique';

  @override
  String get dashboardScreenTitle => 'Tableau de bord';

  @override
  String get dashboardSavingSectionTitle => 'Économies globales';

  @override
  String get dashboardSavingSectionDescription => 'Sur l\'ensemble des produits, toute période confondue';

  @override
  String get dashboardLiveResetVolume => 'Préparation nouvelle douche';

  @override
  String get dashboardLiveSendThresholds => 'Envoi des seuils';

  @override
  String get dashboardLiveSyncShowers => 'Synchronisation des douches';

  @override
  String get dashboardLiveShowerInProgress => 'Douche en cours';

  @override
  String get dashboardSoapingInProgress => 'Savonnage en cours';

  @override
  String get dashboardScanningText => 'Laissez l’application ouverte pour une synchronisation immédiate ou synchronisez vos douches plus tard';

  @override
  String get dashboardScanningShStoreShowers => 'Le pommeau enregistre jusqu\'à 200 douches';

  @override
  String get statisticsScreenGlobalCardTitle => 'Tous les produits';

  @override
  String get statisticsScreenFilterAll => 'Sur toutes les douches';

  @override
  String statisticsScreenFilterOnLastShowers(int count) {
    return 'Sur les $count dernières douches';
  }

  @override
  String get showerVolumeBarchartNoShowerTitle => 'Aucune douche à afficher';

  @override
  String get showerVolumeBarchartNoShowerMessage => 'Commencez à utiliser votre pommeau et vous retrouverez ici vos douches';

  @override
  String get showerVolumeBarchartSeeNextShowers => 'Voir les douches suivantes';

  @override
  String get showerVolumeBarchartSeePreviousShowers => 'Voir les douches précédentes';

  @override
  String shStatisticsDialogTitle(String sh) {
    return 'Douches de $sh';
  }

  @override
  String get shStatisticsSelectShowerAdvice => 'Sélectionner une douche pour avoir des détails';

  @override
  String get shStatisticsCancelSelection => 'Sélection';

  @override
  String get shStatisticsAverageVolumeMetric => 'Vol. moyen';

  @override
  String get shStatisticsWaterSavingsMetric => 'Eau éco.';

  @override
  String get shStatisticsMoneySavingsMetric => 'Économies';

  @override
  String get shStatisticsShowerVolumeMetric => 'Volume';

  @override
  String get shStatisticsShowerTemperatureMetric => 'Température';

  @override
  String get shStatisticsShowerDurationMetric => 'Durée';

  @override
  String get shStatisticsShowerSoapingMetric => 'Savonnage';

  @override
  String get shStatisticsShowerSyncedAt => 'Synchronisée le';

  @override
  String get shStatisticsShowersSyncedAt => 'Synchronisées le';

  @override
  String get shStatisticsShowersSyncedInPeriod => 'Synchronisées';

  @override
  String get shStatisticsShowersSyncedPartially => 'Synchro. incomplète';

  @override
  String get shStatisticsShowerSelected => 'Douche';

  @override
  String get shStatisticsLiveShowerSelected => 'Dernière douche';

  @override
  String shStatisticsCountShowers(int count) {
    return '$count douche(s)';
  }

  @override
  String get shStatisticsNoFilteredShower => 'Aucune douche correspond aux filtres';

  @override
  String get shStatisticsNoFilteredShowerMessage => 'Veuillez modifier ou effacer les filtres pour voir les douches';

  @override
  String get shStatisticsShowersAvgVolume => 'vol. moyen';

  @override
  String get shStatisticsShowerheadSavings => 'Économies de ce pommeau';

  @override
  String get shStatisticsShowerIgnored => 'Ignorée';

  @override
  String get shStatisticsShowerThresholds => 'Seuils';

  @override
  String get shStatisticsShowerLearningThresholds => 'Seuils d\'une période d\'apprentissage';

  @override
  String get shStatisticsLiveShowerVol => 'Vol.';

  @override
  String get shStatisticsLiveShowerMessage => 'Les informations peuvent être amener à évoluer.';

  @override
  String get showerFiltersDialogTitle => 'Filtrer les douches';

  @override
  String get showerFiltersUserPrefsSectionTitle => 'Préférences utilisateur';

  @override
  String get showerFiltersVolumeSectionTitle => 'Volume';

  @override
  String get showerFiltersIgnoredField => 'Ignorée';

  @override
  String get showerFiltersIsChechedText => 'est cochée';

  @override
  String get showerFiltersIsNotCheckedText => 'n\'est pas cochée';

  @override
  String get showerFiltersIsRefShowerField => 'est une douche de référence';

  @override
  String get showerFiltersChallengeKo => 'Dépasse les seuils définis';

  @override
  String get showerFiltersIsGreaterThanField => 'Est supérieur à';

  @override
  String get showerFiltersIsLessThanField => 'Est inférieur à';

  @override
  String get showerFiltersDurationSectionTitle => 'Durée';

  @override
  String get showerFiltersExceedRefShowerDurationField => 'Dépasse la durée de la douche de référence';

  @override
  String get savingsDetailsDialogTitle => 'Économies';

  @override
  String get savingsDetailsDialogCompareSection => 'Comparaison';

  @override
  String get savingsDetailsDialogConsumptionSection => 'Consommation';

  @override
  String get savingsDetailsDialogOldShowerhead => 'Ancien pommeau';

  @override
  String get savingsDetailsDialogHydrao => 'Hydrao';

  @override
  String get savingsDetailsDialogOldShowerheadHeader => 'Ancien';

  @override
  String get savingsDetailsDialogSavingsHeader => 'Économies';

  @override
  String get instAloe1 => 'Dévissez votre ancien pommeau de douche pour l’enlever.';

  @override
  String get instAloe2 => 'Mettez le joint grille fourni avec votre pommeau de douche HYDRAO en place.';

  @override
  String get instAloe3 => 'Vissez votre nouveau pommeau de douche HYDRAO';

  @override
  String get instYucca1 => 'Coupez l’eau.';

  @override
  String get instYucca2 => 'Dévissez votre ciel de pluie précédent pour l’enlever.';

  @override
  String get instYucca3 => 'Vissez votre nouveau ciel de pluie HYDRAO';

  @override
  String get faqDialogTitle => 'Foire aux questions';

  @override
  String get faqUsageTitle1 => 'Comment le pommeau de douche est-il alimenté ?';

  @override
  String get faqUsageTitle2 => 'Si je coupe l’eau (pour me savonner), le comptage des équipements HYDRAO se remet-il à zéro?';

  @override
  String get faqUsageTitle3 => 'Les lumières LED du pommeau HYDRAO ne s’allument pas, pourquoi?';

  @override
  String get faqUsageTitle4 => 'Si j’ai besoin d’ouvrir le robinet à fond pour activer les lumières, n’est-ce pas contre-productif pour les économies d’eau?\"';

  @override
  String get faqUsageTitle5 => 'Pourquoi ne peut-on pas voir la date des douches ?';

  @override
  String get faqUsageTitle6 => 'Faut-il utiliser l’appplication à chaque douche ?';

  @override
  String get faqUsageDescription1 => 'Le pommeau HYDRAO est équipé d’une micro-turbine qui l’alimente grâce à l’eau. Aucune batterie n’est nécessaire!';

  @override
  String get faqUsageDescription2 => 'Pendant votre douche, vous pouvez couper l’eau jusqu’à 2 minutes pour vous savonner sans perdre le comptage en cours. Après 2 minutes, le pommeau de douche considère que vous avez terminé votre douche.';

  @override
  String get faqUsageDescription3 => 'Cela est sûrement dû à une pression insuffisante en sortie de robinet pour alimenter la turbine du pommeau HYDRAO First ou Aloé. N’hésitez donc pas à ouvrir davantage votre robinet pour faire fonctionner le pommeau HYDRAO.\n\nNous vous recommandons de réaliser le test de pression suivant :\n\nOuvrez le robinet à fond et retournez le pommeau HYDRAO afin de faire une fontaine vers le haut (attention à ne pas éclabousser votre plafond surtout s’il y a des lumières!).\nMesurez la hauteur du jet d’eau.\nCelle-ci doit être supérieur à 70 cm pour que le pommeau HYDRAO fonctionne correctement, cela équivaut à 0.8 bar.\nSi la hauteur du jet est supérieure à 70 cm, vous avez assez de pression pour normalement faire fonctionner le pommeau HYDRAO. Veuillez contacter notre service SAV.\n';

  @override
  String get faqUsageDescription4 => 'Non ! car le pommeau profite d’une conception basse consommation. Il est conçu pour limiter votre consommation d’eau tout en optimisant le rendement de la turbine qui alimente les lumières. Ainsi, même si le robinet est ouvert à fond, la consommation d’eau entre 2 bar et 5 bar est plafonnée à un débit de \n6,6 L/min (débit très écologique) avec le limiteur de débit (fourni en accessoire)\n9 L/min (débit écologique) sans le limiteur de débit.\nEn comparaison, le débit d’un pommeau de douche classique varie entre 12 L/min et 15 L/min entre 2 et 5 Bars.';

  @override
  String get faqUsageDescription5 => 'Les pommeaux HYDRAO fonctionnent sans batterie ni pile. Ils récupèrent l’énergie nécessaire à leur fonctionnement grâce à une turbine qui est alimenté par le flux de l’eau pendant la douche. L’absence de pile est la solution la plus écologique mais elle a pour conséquence l’impossibilité de maintenir une horloge dans les pommeaux et donc de dater les douches. Nous travaillons à la mise en place de l’horodatage via l’intégration d’une batterie dans les pommeaux HYDRAO ou via la proposition d’une passerelle Bluetooth/wifi complémentaire à installer dans la salle bain.';

  @override
  String get faqUsageDescription6 => 'Pas besoin de se connecter à chaque douche. Les pommeaux HYDRAO disposent d’une mémoire de 200 douches. Une connexion occasionnelle suffit pour mettre votre historique à jour. ';

  @override
  String get faqInstallationTitle2 => 'Comment savoir s’il est possible d’utiliser le limiteur de débit ? ';

  @override
  String get faqInstallationDescription2 => 'Il faut vérifier que votre pression en sortie de robinet est suffisamment puissante pour faire fonctionner le pommeau HYDRAO avec le limiteur. La pression doit être supérieure à 0,8 bar. \nVous pouvez vérifier simplement cela en réalisant le test suivant avec le pommeau sans limiteur :\nOuvrez le robinet à fond et retournez le pommeau HYDRAO afin de faire une fontaine vers le haut (attention à ne pas éclabousser votre plafond surtout s’il y a des lumières au plafond !). Mesurez la hauteur du jet d’eau. Celle-ci doit être supérieur à 70 cm pour que le pommeau HYDRAO fonctionne correctement, cela équivaut à 0,8 bar.\n\nSi la hauteur du jet est supérieure à 70 cm, le pommeau HYDRAO fonctionnera avec le limiteur,\nSi la hauteur du jet est inférieure à 70 cm, nous vous conseillons de ne pas mettre le limiteur\nAttention à bien insérer le limiteur dans le bon sens. Veuillez bien suivre les consignes de la notice fournit avec pour cela.';

  @override
  String get faqConnectivityTitle1 => 'Mon smartphone est-il compatible avec les équipements HYDRAO ?';

  @override
  String get faqConnectivityTitle2 => 'A quelle distance des équipements HYDRAO est-il possible d’utiliser l’application HYDRAO ? Quelle est la portée maximale de connexion Bluetooth ? ';

  @override
  String get faqConnectivityTitle3 => 'Doit-on se connecter à chaque douche pour récupérer les informations de consommation ? ';

  @override
  String get faqConnectivityTitle4 => 'Je n’arrive pas à connecter mon équipement HYDRAO à l’application HYDRAO, que faire ? ';

  @override
  String get faqConnectivityDescription1 => 'Pour vous connecter aux équipements HYDRAO, il vous faut un smartphone sous Android (Android 5 ou plus) ou iOS (9.1 ou plus) qui supporte au minimum la norme Bluetooth 4.0.';

  @override
  String get faqConnectivityDescription2 => 'Elle est de 3 mètres maximum. Nos produits HYDRAO utilisent une technologie Bluetooth basse consommation moins gourmande en énergie par rapport au Bluetooth traditionnel. ';

  @override
  String get faqConnectivityDescription3 => 'Non, les équipements HYDRAO sont équipés d’une mémoire interne capable de sauvegarder jusqu’à 200 douches. Vous pouvez donc connecter occasionnellement votre appli HYDRAO au pommeau pour mettre à jour votre historique de douche.';

  @override
  String get faqConnectivityDescription4 => 'Il est nécessaire de donner l’autorisation de localisation à l’application HYDRAO, car Android requiert l’activation de la localisation pour que Bluetooth fonctionne. Sur votre smartphone, sélectionnez Paramètres-> Applications-> HYDRAO-> Autorisations-> Localisation : Autoriser.';

  @override
  String get legalNotice => 'Mentions légales';

  @override
  String get legalNoticeText => '\t1.\tPRESENTATION :\nPropriétaire : Smart & Blue \nResponsable publication : HYDRAO\ncontact : sav@hydrao.com\n\n\n2.    CONDITIONS D’UTILISATION DE NOS SERVICES\nL’utilisation de nos services implique le respect des règles ci-après:\nN’utilisez pas nos services de façon impropre. Ne tentez pas de produire des interférences avec nos services ou d’y accéder en utilisant une méthode autre que l’interface et les instructions que nous mettons à votre disposition. Vous ne devez utiliser nos services que dans le respect des lois en vigueur, y compris les lois et réglementations applicables concernant le contrôle des exportations et réexportations. Nous pouvons suspendre ou cesser la fourniture de nos services si vous ne respectez pas les conditions ou règlements applicables, ou si nous examinons une suspicion d’utilisation impropre. \n\nNous sommes susceptibles de modifier ces conditions d’utilisation ou toute autre condition d’utilisation complémentaire s’appliquant à un service, par exemple, pour refléter des modifications de la loi ou de nos services. Nous vous recommandons de consulter régulièrement les conditions d’utilisation. Les modifications apportées à ces conditions d’utilisation seront signalées sur cette page. Si vous n’acceptez pas les modifications apportées aux conditions d’utilisation d’un service donné, vous devez cesser toute utilisation de ce service.\nCes conditions d’utilisation régissent votre relation avec HYDRAO – Smart & Blue. Elles ne créent pas de droit pour des tiers bénéficiaires.\nSi vous ne respectez pas ces conditions d’utilisation et que nous ne prenons pas immédiatement de mesure à ce sujet, cela ne signifie pas que nous renonçons à nos droits\nTERMES DU CONTRAT DE LICENCE LOGICIEL HYDRAO SMART SHOWER   pour Google Play Store et Apple Store\n\nLes présents termes du contrat de licence constituent un contrat entre HYDRAO – Smart & Blue, et vous. Lisez-les attentivement. Ils s’appliquent au logiciel visé ci-dessus. Ce contrat porte également sur les produits HYDRAO suivants :\n•       les mises à jour,\n•       les suppléments,\n•       les services Internet, et\n•       les services d’assistance technique\nde ce logiciel à moins que d’autres termes n’accompagnent ces produits, Si c’est le cas, ces derniers prévalent.\n\nEN UTILISANT LE LOGICIEL, VOUS ACCEPTEZ CES TERMES. SI VOUS NE LES ACCEPTEZ PAS, N’UTILISEZ PAS LE LOGICIEL. \n\nDans le cadre du présent contrat de licence, vous disposez des droits présentés ci-dessous.\n\n\n3.    INSTALLATION ET DROITS D’UTILISATION.\n3.1.    Installation et utilisation. Vous pouvez installer et utiliser une (1) copie du logiciel sur un dispositif utilisant le système d’exploitation Android que vous possédez ou contrôlez à des fins non commerciales. \n3.2.    Programmes tiers. Le logiciel peut inclure des programmes de tiers que HYDRAO, et de non tiers, vous concède sous licence en vertu du présent contrat. Les mentions éventuelles relatives aux programmes de tiers sont incluses pour votre information uniquement.\n\n\n\n4.    DESCRIPTION DES SERVICES FOURNIS.\nLe LOGICIEL HYDRAO SMART SHOWER a pour objet de collecter des données sur les habitudes d’usage de l’eau utilisée pour la douche. Ces données sont analysées pour évaluer les produits HYDRAO SMART SHOWER  et ainsi proposer des évolutions les plus intéressantes pour aider les usagers à comprendre et réduire la consommation d’eau. Le LOGICIEL HYDRAO SMART SHOWER  s’efforce de fournir des informations aussi précises que possible. Toutefois, il ne pourra être tenu responsable des oublis, des inexactitudes et des carences dans la mise à jour, qu’elles soient de son fait ou du fait des tiers partenaires qui lui fournissent ces informations.\n\nToutes les informations indiquées sur le LOGICIEL HYDRAO SMART SHOWER  sont données à titre indicatif, et sont susceptibles d’évoluer. Par ailleurs, les renseignements figurant sur le LOGICIEL HYDRAO SMART SHOWER  ne sont pas exhaustifs. Ils sont donnés sous réserve de modifications ayant été apportées depuis leur mise en ligne.\n\n\n \n5.    LIMITATIONS CONTRACTUELLES SUR LES DONNEES TECHNIQUES\nLe logiciel utilise la technologie Flutter. Le logiciel ne pourra être tenu responsable de dommages matériels liés à l’utilisation du logiciel. De plus, l’utilisateur s’engage à utiliser le logiciel en utilisant un matériel récent, ne contenant pas de virus et avec un système d’exploitation de dernière génération mis-à-jour.\n\nLe LOGICIEL HYDRAO SMART SHOWER  ne pourra être tenus responsables en cas de dysfonctionnement du réseau Internet, des lignes téléphoniques ou du matériel informatique et de téléphonie liée notamment à l’encombrement du réseau empêchant l’accès au serveur.\n\n 6.    UN ACCÈS À INTERNET PEUT ÊTRE NÉCESSAIRE. \nVous pouvez être amené à payer des frais liés à l’accès à Internet, au transfert de données et à d’autres services conformément aux termes du plan de service de données et de tout autre contrat conclu avec votre opérateur réseau en raison de l’utilisation du logiciel. Les frais de votre opérateur réseau vous incombent.\n\n\n7.    PROPRIETE INTELLECTUELLE ET CONTREFACONS\nLe logiciel n’est pas vendu mais concédé sous licence. Le présent contrat vous confère certains droits d’utilisation du logiciel. HYDRAO - Smart & Blue est propriétaire des droits de propriété intellectuelle et détient les droits d’usage sur tous les éléments accessibles sur le logiciel, notamment les textes, images, graphismes, logos, vidéos, icônes et sons. Sauf si la réglementation applicable vous confère d’autres droits, nonobstant la présente limitation, vous n’êtes autorisé à utiliser le logiciel qu’en conformité avec les termes du présent contrat. À cette fin, vous devez vous conformer aux restrictions techniques contenues dans le logiciel qui vous permettent de l’utiliser uniquement d’une certaine façon. Vous n’êtes pas autorisé à :\n•       contourner les restrictions techniques contenues dans le logiciel ;\n•       reconstituer la logique du logiciel, le décompiler ou le désassembler, sauf dans la mesure où ces opérations seraient expressément permises par la réglementation applicable nonobstant la présente limitation ;\n•       effectuer plus de copies du logiciel que ce qui est autorisé dans le présent contrat ou par la réglementation applicable, nonobstant la présente limitation ;\n•       publier le logiciel en vue d’une reproduction par autrui ;\n•       louer ou prêter le logiciel ;\n•       transférer le logiciel ou le présent contrat à un tiers ; \n•       utiliser le logiciel en association avec des services d’hébergement commercial.\nToute exploitation non autorisée du logiciel ou de l’un des quelconques éléments qu’il contient sera considérée comme constitutive d’une contrefaçon et poursuivie conformément aux dispositions des articles L.335-2 et suivants du Code de Propriété Intellectuelle.\n\n\n8.    LIMITATIONS DE RESPONSABILITE.\nHYDRAO agit en tant qu’éditeur du logiciel. Le LOGICIEL HYDRAO SMART SHOWER   est responsable de la qualité et de la véracité du contenu qu’il publie.\nLe LOGICIEL HYDRAO SMART SHOWER   ne pourra être tenu responsable des dommages directs et indirects causés au matériel de l’utilisateur, lors de l’accès au LOGICIEL HYDRAO SMART SHOWER  , et résultant soit de l’utilisation d’un matériel ne répondant pas aux spécifications indiquées au point 5, soit de l’apparition d’un bug ou d’une incompatibilité.\nLe LOGICIEL HYDRAO SMART SHOWER   ne pourra également être tenu responsable des dommages indirects consécutifs à l’utilisation du LOGICIEL HYDRAO SMART SHOWER  . \n\n\n9.    GESTION DES DONNEES PERSONNELLES.\nLe client est informé des réglementations concernant la communication marketing, la loi du 21 Juin 2014 pour la confiance dans l’Economie Numérique, la Loi Informatique et Liberté du 06 Août 2004 ainsi que du Règlement Général sur la Protection des Données (RGPD : n° 2016-679).\n\n\n9.1.   Responsables de la collecte des données personnelles\nPour les données personnelles collectées dans le cadre de la création du compte personnel de l’utilisateur et de son utilisation de l’application, le responsable du traitement des données personnelles est : Johann Poignant. Le LOGICIEL HYDRAO SMART SHOWER   est représenté par Gabriel Della-Monica, son représentant légal.\n\nEn tant que responsable du traitement des données qu’il collecte, le LOGICIEL HYDRAO SMART SHOWER   s’engage à respecter le cadre des dispositions légales en vigueur. Il lui appartient notamment d’établir les finalités de ses traitements de données, de fournir à ses clients, à partir de la collecte de leurs consentements, une information complète sur le traitement de leurs données personnelles et de maintenir un registre des traitements conforme à la réalité. Chaque fois que le LOGICIEL HYDRAO SMART SHOWER   traite des données personnelles, le LOGICIEL HYDRAO SMART SHOWER   prend toutes les mesures raisonnables pour s’assurer de l’exactitude et de la pertinence des données personnelles collectées au regard des finalités pour lesquelles le LOGICIEL HYDRAO SMART SHOWER   les traite.\n\n\n9.2.   Finalité des données collectées\nle LOGICIEL HYDRAO SMART SHOWER est susceptible de traiter tout ou partie des données :\n•       Le nom d’utilisateur pour fournir une continuité de service en cas de désinstallation de l’application\n•       de la consommation d’eau de distribution pour aider l’utilisateur à comprendre et réduire leur consommation\n•       des coûts liés à l’eau domestique pour informer l’utilisateur du coût financier de sa consommation \n•       des données d’utilisation de l’application à des fins d’aides au diagnostic en cas de dysfonctionnement et d’aides pour l’amélioration de nos services\n•       les communications de l’utilisateur\nLe LOGICIEL HYDRAO SMART SHOWER   ne commercialise pas vos données personnelles qui sont donc uniquement utilisées par nécessité ou à des fins statistiques et d’analyses.\n\n\n9.3.   Droit d’accès, de rectification et d’opposition\nConformément à la réglementation européenne en vigueur, les utilisateurs du LOGICIEL HYDRAO SMART SHOWER   disposent des droits suivants :\n•       droit d’accès (article 15 RGPD) et de rectification (article 16 RGPD), de mise à jour, de complétude des données des utilisateurs droit de verrouillage ou d’effacement des données des utilisateurs à caractère personnel (article 17 du RGPD), lorsqu’elles sont inexactes, incomplètes, équivoques, périmées, ou dont la collecte, l’utilisation, la communication ou la conservation est interdite\n•       droit de retirer à tout moment un consentement (article 13-2c RGPD)\n•       droit à la limitation du traitement des données des utilisateurs (article 18 RGPD)\n•       droit d’opposition au traitement des données des utilisateurs (article 21 RGPD)\n•       droit à la portabilité des données que les utilisateurs auront fournies, lorsque ces données font l’objet de traitements automatisés fondés sur leur consentement ou sur un contrat (article 20 RGPD)\n•       droit de définir le sort des données des utilisateurs après leur mort et de choisir à qui HYDRAO - Smart & Bluedevra communiquer (ou non) ses données à un tiers qu’ils aura préalablement désigné\nDès que HYDRAO a connaissance du décès d’un utilisateur et à défaut d’instructions de sa part, HYDRAO s’engage à détruire ses données, sauf si leur conservation s’avère nécessaire à des fins probatoires ou pour répondre à une obligation légale.\n \nSi l’utilisateur souhaite savoir comment HYDRAO - Smart & Blue utilise ses données personnelles, demander à les rectifier ou s’oppose à leur traitement, l’utilisateur peut contacter HYDRAO par mail à l’adresse contact@hydrao.com.\nDans ce cas, l’utilisateur doit indiquer les données personnelles qu’il souhaiterait que HYDRAO corrige, mette à jour ou supprime, en s’identifiant précisément avec une copie d’une pièce d’identité (carte d’identité ou passeport) ainsi qu’une copie d’écran de l’application avec l’identifiant du pommeau de douche utilisé (voir section paramètres/Mon pommeau dans le LOGICIEL HYDRAO SMART SHOWER  ).\n\nLes demandes de suppression de données personnelles seront soumises aux obligations qui sont imposées à HYDRAO - Smart & Blue par la loi, notamment en matière de conservation ou d’archivage des documents. Enfin, les utilisateurs du LOGICIEL HYDRAO SMART SHOWER   peuvent déposer une réclamation auprès des autorités de contrôle, et notamment de la CNIL (https://www.cnil.fr/fr/plaintes).\n\n\n9.4.   Non-communication des données personnelles\nHYDRAO s’interdit de traiter, héberger ou transférer les informations collectées sur ses clients vers un pays situé en dehors de l’Union européenne ou reconnu comme « non adéquat » par la commission européenne sans en informer préalablement le client. Pour autant, HYDRAO reste libre du choix de ses sous-traitants techniques et commerciaux à la condition qu’ils présentent les garanties suffisantes au regard des exigences du Règlement Général sur la Protection des Données (RGPD : n° 2016-679).\nHYDRAO s’engage à prendre toutes les précautions nécessaires afin de préserver la sécurité des informations personnelles et notamment qu’elles ne soient pas communiquées à des personnes non autorisées. Cependant, si un incident impactant l’intégrité ou la confidentialité des informations du client est portée à la connaissance de HYDRAO, celle-ci devra dans les meilleurs délais informer le client et lui communiquer les mesures de corrections prises. Par ailleurs HYDRAO ne collecte aucune « données sensibles ».\nLes données personnelles de l’utilisateur peuvent être traitées par des filiales de HYDRAO et des sous-traitants (prestataires de services), exclusivement afin de réaliser les finalités de la présente politique.\nDans la limite de leurs attributions respectives et pour les finalités rappelées ci-dessus, les principales personnes susceptibles d’avoir accès aux données des utilisateurs de HYDRAO sont principalement les agents de notre service technique.\n\n\nTypes de données collectées\nConcernant les utilisateurs du LOGICIEL HYDRAO SMART SHOWER  , nous collectons les données suivantes qui sont indispensables au fonctionnement du service, et qui seront conservées pendant une période maximale de 36 mois après la dernière connexion du pommeau au travers de l’application à nos serveurs :\n•       nom d’utilisateur et mots de passe (crypté)\n•       la consommation d’eau (volume, température, débit, horaire)\n•       les seuils programmés\n•       le coût de l’eau domestique et du chauffage de l’eau renseignés dans l’application\n•       vos communications avec des tiers via le LOGICIEL HYDRAO SMART SHOWER  \n•       les publications ou commentaires que vous fournissez à HYDRAO\n•       vos données d’utilisation et de connexion \n•       le modèle et l’OS du téléphone utilisé     \n•       les coordonnées GPS approximative du téléphone connecté au pommeau de douche\n\n\n10.    NOTIFICATIONS D’INCIDENTS\nQuels que soient les efforts fournis, aucune méthode de transmission sur Internet et aucune méthode de stockage électronique n’est complètement sûre. Nous ne pouvons en conséquence pas garantir une sécurité absolue. Si nous prenions connaissance d’une brèche de la sécurité, nous avertirions les utilisateurs concernés afin qu’ils puissent prendre les mesures appropriées. Nos procédures de notification d’incident tiennent compte de nos obligations légales, qu’elles se situent au niveau national ou européen. Nous nous engageons à informer pleinement nos clients de toutes les questions relevant de la sécurité de leur compte et à leur fournir toutes les informations nécessaires pour les aider à respecter leurs propres obligations réglementaires en matière de reporting.\nAucune information personnelle de l’utilisateur du LOGICIEL HYDRAO SMART SHOWER   n’est publiée à l’insu de l’utilisateur, échangée, transférée, cédée ou vendue sur un support quelconque à des tiers. Des statistiques globales calculées à partir de données anonymisées peuvent être diffusées à des fins publicitaires de nos produits. Seule l’hypothèse du rachat du LOGICIEL HYDRAO SMART SHOWER   et de ses droits permettrait la transmission des dites informations à l’éventuel acquéreur qui serait à son tour tenu de la même obligation de conservation et de modification des données vis à vis de l’utilisateur du LOGICIEL HYDRAO SMART SHOWER   .\nPour assurer la sécurité et la confidentialité des données personnelles, le LOGICIEL HYDRAO SMART SHOWER   utilise des réseaux protégés par des dispositifs standards tels que par pare-feu, la pseudo-anonymisation, d’encryption et mot de passe.\nLors du traitement des données personnelles, le LOGICIEL HYDRAO SMART SHOWER   prend toutes les mesures raisonnables visant à les protéger contre toute perte, utilisation détournée, accès non autorisé, divulgation, altération ou destruction.\n\n\n11.   TRANSFERT À UN AUTRE DISPOSITIF. \nVous êtes autorisé à désinstaller le logiciel et à l’installer sur un autre dispositif pour votre propre usage. Vous n’êtes pas autorisé à procéder de la sorte afin de partager cette licence entre plusieurs dispositifs en dehors du présent contrat.\n\n\n12.   RESTRICTIONS À L’EXPORTATION. \nLe logiciel est soumis aux lois et réglementations Française en matière d’exportation. Vous devez vous conformer à toutes les lois et réglementations nationales et internationales en matière d’exportation concernant le logiciel. Ces lois comportent des restrictions sur les destinations, les utilisateurs finaux et les utilisations finales. \n\n\n13.   MENTIONS DE DROITS D’AUTEUR. \nHYDRAO Smart & Blue est une marque déposée de Smart & Blue SAS. \n\n\n14. INTÉGRALITÉ DE L’ACCORD. \nLe présent contrat ainsi que les termes concernant les suppléments, les mises à jour, les services Internet et d’assistance technique que vous utilisez constituent l’intégralité des accords en ce qui concerne le logiciel et les services d’assistance technique.\n\n\n15..   EFFET JURIDIQUE.\n Le présent contrat décrit certains droits légaux. Vous pouvez bénéficier d’autres droits prévus par les lois de votre pays. Vous pouvez également bénéficier de certains droits à l’égard de la partie auprès de laquelle vous avez acquis le logiciel. Le présent contrat ne modifie pas les droits que vous confèrent les lois de votre pays si celles-ci ne le permettent pas.\n\n\n16.   EXCLUSIONS DE GARANTIE. LE LOGICIEL EST CONCÉDÉ SOUS LICENCE « EN L’ÉTAT », « AVEC TOUS SES DÉFAUTS » ET « TEL QUE DISPONIBLE ». VOUS ASSUMEZ TOUS LES RISQUES LIÉS À SON UTILISATION. SI VOUS LE SOUHAITEZ, VOUS POUVEZ TRANSMETTRE À GOOGLE/APPLE UNE DEMANDE DE REMBOURSEMENT DU PRIX D’ACHAT. DANS LES LIMITES PERMISES PAR LA RÉGLEMENTATION APPLICABLE, GOOGLE/APPLE N’AURA AUCUNE AUTRE OBLIGATION DE GARANTIE QUELLE QU’ELLE SOIT. HYDRAO ET LES OPÉRATEURS DE TÉLÉPHONIE MOBILE DONT LES RÉSEAUX SONT UTILISÉS POUR LA DISTRIBUTION DU LOGICIEL, AINSI QUE CHACUN DE NOS AFFILIÉS ET FOURNISSEURS RESPECTIFS (LES « PARTIES COUVERTES ») N’ACCORDENT AUCUNE GARANTIE OU CONDITION EXPRESSE EN CE QUI CONCERNE LE LOGICIEL. VOUS ASSUMEZ TOUS LES RISQUES LIÉS À LA QUALITÉ ET À L’EXÉCUTION DU LOGICIEL. EN CAS DE DÉFECTUOSITÉ DU LOGICIEL, VOUS ASSUMEZ TOUS LES COÛTS LIÉS AUX OPÉRATIONS D’ENTRETIEN OU DE RÉPARATION NÉCESSAIRES. VOUS POUVEZ BÉNÉFICIER DE DROITS SUPPLÉMENTAIRES EN VERTU DU DROIT DE LA CONSOMMATION DE VOTRE PAYS, QUE CE CONTRAT NE PEUT MODIFIER. DANS LA LIMITE AUTORISÉE PAR LA LÉGISLATION LOCALE, LES PARTIES COUVERTES EXCLUENT LES GARANTIES IMPLICITES DE QUALITÉ, D’ADÉQUATION À UN USAGE PARTICULIER ET D’ABSENCE DE CONTREFAÇON.\n\n\n17.   LIMITATION ET EXCLUSION DES RECOURS ET DOMMAGES-INTÉRÊTS. \nDANS LA MESURE OÙ CELA N’EST PAS CONTRAIRE À LA LOI, VOUS NE POUVEZ OBTENIR UNE INDEMNISATION D’HYDRAO QU’EN CAS DE DOMMAGES DIRECTS, LIMITÉE À UN EURO (€ 1,00). VOUS RECONNAISSEZ QUE VOUS NE POUVEZ PRÉTENDRE À AUCUNE INDEMNISATION DE LA PART DES PARTIES COUVERTES POUR LES AUTRES DOMMAGES, Y COMPRIS LES DOMMAGES SPÉCIAUX, INDIRECTS, INCIDENTS OU ACCESSOIRES ET LES PERTES DE BÉNÉFICES.\n\nCette limitation concerne notamment :\n•       toute affaire liée au logiciel, aux services ou au contenu (y compris le code) figurant sur des sites Internet tiers ou dans des programmes tiers ; et\n•       les réclamations pour manquement aux termes du contrat ou de la garantie ; protection des consommateurs ; tromperie ; concurrence déloyale ; responsabilité sans faute, négligence, mauvaise interprétation, omission, trouble de jouissance ou autre délit ; violation d’une loi ou réglementation ; ou enrichissement injuste, dans la limite autorisée par la réglementation applicable.\n\nElle s’applique également, même si :\n•       la réparation, le remplacement ou le remboursement du logiciel ne compense pas intégralement tout préjudice subi ;\n•       les parties couvertes avaient ou auraient dû avoir connaissance de l’éventualité de tels dommages.\nLa limitation ou l’exclusion ci-dessus peut également ne pas vous être applicable si votre pays n’autorise pas l’exclusion ou la limitation de responsabilité pour les dommages incidents, indirects ou de quelque nature que ce soit.\n\n\n';

  @override
  String get legalNoticeSection1Title => '1. Présentation';

  @override
  String get legalNoticeSection1Text => 'Propriétaire : Smart & Blue \nResponsable publication : HYDRAO\ncontact : sav@hydrao.com';

  @override
  String get legalNoticeSection2Title => '2. Conditions d\'utilisation de nos services';

  @override
  String get legalNoticeSection2Text => 'L’utilisation de nos services implique le respect des règles ci-après:\nN’utilisez pas nos services de façon impropre. Ne tentez pas de produire des interférences avec nos services ou d’y accéder en utilisant une méthode autre que l’interface et les instructions que nous mettons à votre disposition. Vous ne devez utiliser nos services que dans le respect des lois en vigueur, y compris les lois et réglementations applicables concernant le contrôle des exportations et réexportations. Nous pouvons suspendre ou cesser la fourniture de nos services si vous ne respectez pas les conditions ou règlements applicables, ou si nous examinons une suspicion d’utilisation impropre. \n\nNous sommes susceptibles de modifier ces conditions d’utilisation ou toute autre condition d’utilisation complémentaire s’appliquant à un service, par exemple, pour refléter des modifications de la loi ou de nos services. Nous vous recommandons de consulter régulièrement les conditions d’utilisation. Les modifications apportées à ces conditions d’utilisation seront signalées sur cette page. Si vous n’acceptez pas les modifications apportées aux conditions d’utilisation d’un service donné, vous devez cesser toute utilisation de ce service.\nCes conditions d’utilisation régissent votre relation avec HYDRAO – Smart & Blue. Elles ne créent pas de droit pour des tiers bénéficiaires.\nSi vous ne respectez pas ces conditions d’utilisation et que nous ne prenons pas immédiatement de mesure à ce sujet, cela ne signifie pas que nous renonçons à nos droits\nTERMES DU CONTRAT DE LICENCE LOGICIEL HYDRAO SMART SHOWER   pour Google Play Store et Apple Store\n\nLes présents termes du contrat de licence constituent un contrat entre HYDRAO – Smart & Blue, et vous. Lisez-les attentivement. Ils s’appliquent au logiciel visé ci-dessus. Ce contrat porte également sur les produits HYDRAO suivants :\n•       les mises à jour,\n•       les suppléments,\n•       les services Internet, et\n•       les services d’assistance technique\nde ce logiciel à moins que d’autres termes n’accompagnent ces produits, Si c’est le cas, ces derniers prévalent.\n\nEN UTILISANT LE LOGICIEL, VOUS ACCEPTEZ CES TERMES. SI VOUS NE LES ACCEPTEZ PAS, N’UTILISEZ PAS LE LOGICIEL. \n\nDans le cadre du présent contrat de licence, vous disposez des droits présentés ci-dessous.';

  @override
  String get legalNoticeSection3Title => '3. Installation et droits d\'utilisation';

  @override
  String get legalNoticeSection3Text => '3.1.    Installation et utilisation. Vous pouvez installer et utiliser une (1) copie du logiciel sur un dispositif utilisant le système d’exploitation Android que vous possédez ou contrôlez à des fins non commerciales. \n3.2.    Programmes tiers. Le logiciel peut inclure des programmes de tiers que HYDRAO, et de non tiers, vous concède sous licence en vertu du présent contrat. Les mentions éventuelles relatives aux programmes de tiers sont incluses pour votre information uniquement.';

  @override
  String get legalNoticeSection4Title => '4. Description des services fournis';

  @override
  String get legalNoticeSection4Text => 'Le LOGICIEL HYDRAO SMART SHOWER a pour objet de collecter des données sur les habitudes d’usage de l’eau utilisée pour la douche. Ces données sont analysées pour évaluer les produits HYDRAO SMART SHOWER  et ainsi proposer des évolutions les plus intéressantes pour aider les usagers à comprendre et réduire la consommation d’eau. Le LOGICIEL HYDRAO SMART SHOWER  s’efforce de fournir des informations aussi précises que possible. Toutefois, il ne pourra être tenu responsable des oublis, des inexactitudes et des carences dans la mise à jour, qu’elles soient de son fait ou du fait des tiers partenaires qui lui fournissent ces informations.\n\nToutes les informations indiquées sur le LOGICIEL HYDRAO SMART SHOWER  sont données à titre indicatif, et sont susceptibles d’évoluer. Par ailleurs, les renseignements figurant sur le LOGICIEL HYDRAO SMART SHOWER  ne sont pas exhaustifs. Ils sont donnés sous réserve de modifications ayant été apportées depuis leur mise en ligne.';

  @override
  String get legalNoticeSection5Title => '5. Limitations contractuelles sur les données techniques';

  @override
  String get legalNoticeSection5Text => 'Le logiciel utilise la technologie Flutter. Le logiciel ne pourra être tenu responsable de dommages matériels liés à l’utilisation du logiciel. De plus, l’utilisateur s’engage à utiliser le logiciel en utilisant un matériel récent, ne contenant pas de virus et avec un système d’exploitation de dernière génération mis-à-jour.\n\nLe LOGICIEL HYDRAO SMART SHOWER  ne pourra être tenus responsables en cas de dysfonctionnement du réseau Internet, des lignes téléphoniques ou du matériel informatique et de téléphonie liée notamment à l’encombrement du réseau empêchant l’accès au serveur.';

  @override
  String get legalNoticeSection6Title => '6. Un accès à Internet peut être nécessaire';

  @override
  String get legalNoticeSection6Text => 'Vous pouvez être amené à payer des frais liés à l’accès à Internet, au transfert de données et à d’autres services conformément aux termes du plan de service de données et de tout autre contrat conclu avec votre opérateur réseau en raison de l’utilisation du logiciel. Les frais de votre opérateur réseau vous incombent.';

  @override
  String get legalNoticeSection7Title => '7. Propriété intelletuelle et contrefaçons';

  @override
  String get legalNoticeSection7Text => 'Le logiciel n’est pas vendu mais concédé sous licence. Le présent contrat vous confère certains droits d’utilisation du logiciel. HYDRAO - Smart & Blue est propriétaire des droits de propriété intellectuelle et détient les droits d’usage sur tous les éléments accessibles sur le logiciel, notamment les textes, images, graphismes, logos, vidéos, icônes et sons. Sauf si la réglementation applicable vous confère d’autres droits, nonobstant la présente limitation, vous n’êtes autorisé à utiliser le logiciel qu’en conformité avec les termes du présent contrat. À cette fin, vous devez vous conformer aux restrictions techniques contenues dans le logiciel qui vous permettent de l’utiliser uniquement d’une certaine façon. Vous n’êtes pas autorisé à :\n•       contourner les restrictions techniques contenues dans le logiciel ;\n•       reconstituer la logique du logiciel, le décompiler ou le désassembler, sauf dans la mesure où ces opérations seraient expressément permises par la réglementation applicable nonobstant la présente limitation ;\n•       effectuer plus de copies du logiciel que ce qui est autorisé dans le présent contrat ou par la réglementation applicable, nonobstant la présente limitation ;\n•       publier le logiciel en vue d’une reproduction par autrui ;\n•       louer ou prêter le logiciel ;\n•       transférer le logiciel ou le présent contrat à un tiers ; \n•       utiliser le logiciel en association avec des services d’hébergement commercial.\nToute exploitation non autorisée du logiciel ou de l’un des quelconques éléments qu’il contient sera considérée comme constitutive d’une contrefaçon et poursuivie conformément aux dispositions des articles L.335-2 et suivants du Code de Propriété Intellectuelle.';

  @override
  String get legalNoticeSection8Title => '8. Limitations de responsabilité';

  @override
  String get legalNoticeSection8Text => 'HYDRAO agit en tant qu’éditeur du logiciel. Le LOGICIEL HYDRAO SMART SHOWER   est responsable de la qualité et de la véracité du contenu qu’il publie.\nLe LOGICIEL HYDRAO SMART SHOWER   ne pourra être tenu responsable des dommages directs et indirects causés au matériel de l’utilisateur, lors de l’accès au LOGICIEL HYDRAO SMART SHOWER  , et résultant soit de l’utilisation d’un matériel ne répondant pas aux spécifications indiquées au point 5, soit de l’apparition d’un bug ou d’une incompatibilité.\nLe LOGICIEL HYDRAO SMART SHOWER   ne pourra également être tenu responsable des dommages indirects consécutifs à l’utilisation du LOGICIEL HYDRAO SMART SHOWER.';

  @override
  String get legalNoticeSection9Title => '9. Gestion des données personnelles';

  @override
  String get legalNoticeSection9Text => 'Le client est informé des réglementations concernant la communication marketing, la loi du 21 Juin 2014 pour la confiance dans l’Economie Numérique, la Loi Informatique et Liberté du 06 Août 2004 ainsi que du Règlement Général sur la Protection des Données (RGPD : n° 2016-679).\n\n\n9.1.   Responsables de la collecte des données personnelles\nPour les données personnelles collectées dans le cadre de la création du compte personnel de l’utilisateur et de son utilisation de l’application, le responsable du traitement des données personnelles est : Johann Poignant. Le LOGICIEL HYDRAO SMART SHOWER   est représenté par Gabriel Della-Monica, son représentant légal.\n\nEn tant que responsable du traitement des données qu’il collecte, le LOGICIEL HYDRAO SMART SHOWER   s’engage à respecter le cadre des dispositions légales en vigueur. Il lui appartient notamment d’établir les finalités de ses traitements de données, de fournir à ses clients, à partir de la collecte de leurs consentements, une information complète sur le traitement de leurs données personnelles et de maintenir un registre des traitements conforme à la réalité. Chaque fois que le LOGICIEL HYDRAO SMART SHOWER   traite des données personnelles, le LOGICIEL HYDRAO SMART SHOWER   prend toutes les mesures raisonnables pour s’assurer de l’exactitude et de la pertinence des données personnelles collectées au regard des finalités pour lesquelles le LOGICIEL HYDRAO SMART SHOWER   les traite.\n\n\n9.2.   Finalité des données collectées\nle LOGICIEL HYDRAO SMART SHOWER est susceptible de traiter tout ou partie des données :\n•       Le nom d’utilisateur pour fournir une continuité de service en cas de désinstallation de l’application\n•       de la consommation d’eau de distribution pour aider l’utilisateur à comprendre et réduire leur consommation\n•       des coûts liés à l’eau domestique pour informer l’utilisateur du coût financier de sa consommation \n•       des données d’utilisation de l’application à des fins d’aides au diagnostic en cas de dysfonctionnement et d’aides pour l’amélioration de nos services\n•       les communications de l’utilisateur\nLe LOGICIEL HYDRAO SMART SHOWER   ne commercialise pas vos données personnelles qui sont donc uniquement utilisées par nécessité ou à des fins statistiques et d’analyses.\n\n\n9.3.   Droit d’accès, de rectification et d’opposition\nConformément à la réglementation européenne en vigueur, les utilisateurs du LOGICIEL HYDRAO SMART SHOWER   disposent des droits suivants :\n•       droit d’accès (article 15 RGPD) et de rectification (article 16 RGPD), de mise à jour, de complétude des données des utilisateurs droit de verrouillage ou d’effacement des données des utilisateurs à caractère personnel (article 17 du RGPD), lorsqu’elles sont inexactes, incomplètes, équivoques, périmées, ou dont la collecte, l’utilisation, la communication ou la conservation est interdite\n•       droit de retirer à tout moment un consentement (article 13-2c RGPD)\n•       droit à la limitation du traitement des données des utilisateurs (article 18 RGPD)\n•       droit d’opposition au traitement des données des utilisateurs (article 21 RGPD)\n•       droit à la portabilité des données que les utilisateurs auront fournies, lorsque ces données font l’objet de traitements automatisés fondés sur leur consentement ou sur un contrat (article 20 RGPD)\n•       droit de définir le sort des données des utilisateurs après leur mort et de choisir à qui HYDRAO - Smart & Bluedevra communiquer (ou non) ses données à un tiers qu’ils aura préalablement désigné\nDès que HYDRAO a connaissance du décès d’un utilisateur et à défaut d’instructions de sa part, HYDRAO s’engage à détruire ses données, sauf si leur conservation s’avère nécessaire à des fins probatoires ou pour répondre à une obligation légale.\n \nSi l’utilisateur souhaite savoir comment HYDRAO - Smart & Blue utilise ses données personnelles, demander à les rectifier ou s’oppose à leur traitement, l’utilisateur peut contacter HYDRAO par mail à l’adresse contact@hydrao.com.\nDans ce cas, l’utilisateur doit indiquer les données personnelles qu’il souhaiterait que HYDRAO corrige, mette à jour ou supprime, en s’identifiant précisément avec une copie d’une pièce d’identité (carte d’identité ou passeport) ainsi qu’une copie d’écran de l’application avec l’identifiant du pommeau de douche utilisé (voir section paramètres/Mon pommeau dans le LOGICIEL HYDRAO SMART SHOWER  ).\n\nLes demandes de suppression de données personnelles seront soumises aux obligations qui sont imposées à HYDRAO - Smart & Blue par la loi, notamment en matière de conservation ou d’archivage des documents. Enfin, les utilisateurs du LOGICIEL HYDRAO SMART SHOWER   peuvent déposer une réclamation auprès des autorités de contrôle, et notamment de la CNIL (https://www.cnil.fr/fr/plaintes).\n\n\n9.4.   Non-communication des données personnelles\nHYDRAO s’interdit de traiter, héberger ou transférer les informations collectées sur ses clients vers un pays situé en dehors de l’Union européenne ou reconnu comme « non adéquat » par la commission européenne sans en informer préalablement le client. Pour autant, HYDRAO reste libre du choix de ses sous-traitants techniques et commerciaux à la condition qu’ils présentent les garanties suffisantes au regard des exigences du Règlement Général sur la Protection des Données (RGPD : n° 2016-679).\nHYDRAO s’engage à prendre toutes les précautions nécessaires afin de préserver la sécurité des informations personnelles et notamment qu’elles ne soient pas communiquées à des personnes non autorisées. Cependant, si un incident impactant l’intégrité ou la confidentialité des informations du client est portée à la connaissance de HYDRAO, celle-ci devra dans les meilleurs délais informer le client et lui communiquer les mesures de corrections prises. Par ailleurs HYDRAO ne collecte aucune « données sensibles ».\nLes données personnelles de l’utilisateur peuvent être traitées par des filiales de HYDRAO et des sous-traitants (prestataires de services), exclusivement afin de réaliser les finalités de la présente politique.\nDans la limite de leurs attributions respectives et pour les finalités rappelées ci-dessus, les principales personnes susceptibles d’avoir accès aux données des utilisateurs de HYDRAO sont principalement les agents de notre service technique.\n\n\nTypes de données collectées\nConcernant les utilisateurs du LOGICIEL HYDRAO SMART SHOWER  , nous collectons les données suivantes qui sont indispensables au fonctionnement du service, et qui seront conservées pendant une période maximale de 36 mois après la dernière connexion du pommeau au travers de l’application à nos serveurs :\n•       nom d’utilisateur et mots de passe (crypté)\n•       la consommation d’eau (volume, température, débit, horaire)\n•       les seuils programmés\n•       le coût de l’eau domestique et du chauffage de l’eau renseignés dans l’application\n•       vos communications avec des tiers via le LOGICIEL HYDRAO SMART SHOWER  \n•       les publications ou commentaires que vous fournissez à HYDRAO\n•       vos données d’utilisation et de connexion \n•       le modèle et l’OS du téléphone utilisé     \n•       les coordonnées GPS approximative du téléphone connecté au pommeau de douche';

  @override
  String get legalNoticeSection10Title => '10. Notifications d\'incidents';

  @override
  String get legalNoticeSection10Text => 'Quels que soient les efforts fournis, aucune méthode de transmission sur Internet et aucune méthode de stockage électronique n’est complètement sûre. Nous ne pouvons en conséquence pas garantir une sécurité absolue. Si nous prenions connaissance d’une brèche de la sécurité, nous avertirions les utilisateurs concernés afin qu’ils puissent prendre les mesures appropriées. Nos procédures de notification d’incident tiennent compte de nos obligations légales, qu’elles se situent au niveau national ou européen. Nous nous engageons à informer pleinement nos clients de toutes les questions relevant de la sécurité de leur compte et à leur fournir toutes les informations nécessaires pour les aider à respecter leurs propres obligations réglementaires en matière de reporting.\nAucune information personnelle de l’utilisateur du LOGICIEL HYDRAO SMART SHOWER   n’est publiée à l’insu de l’utilisateur, échangée, transférée, cédée ou vendue sur un support quelconque à des tiers. Des statistiques globales calculées à partir de données anonymisées peuvent être diffusées à des fins publicitaires de nos produits. Seule l’hypothèse du rachat du LOGICIEL HYDRAO SMART SHOWER   et de ses droits permettrait la transmission des dites informations à l’éventuel acquéreur qui serait à son tour tenu de la même obligation de conservation et de modification des données vis à vis de l’utilisateur du LOGICIEL HYDRAO SMART SHOWER   .\nPour assurer la sécurité et la confidentialité des données personnelles, le LOGICIEL HYDRAO SMART SHOWER   utilise des réseaux protégés par des dispositifs standards tels que par pare-feu, la pseudo-anonymisation, d’encryption et mot de passe.\nLors du traitement des données personnelles, le LOGICIEL HYDRAO SMART SHOWER   prend toutes les mesures raisonnables visant à les protéger contre toute perte, utilisation détournée, accès non autorisé, divulgation, altération ou destruction.';

  @override
  String get legalNoticeSection11Title => '11. Transfert à un autre dispositif';

  @override
  String get legalNoticeSection11Text => 'Vous êtes autorisé à désinstaller le logiciel et à l’installer sur un autre dispositif pour votre propre usage. Vous n’êtes pas autorisé à procéder de la sorte afin de partager cette licence entre plusieurs dispositifs en dehors du présent contrat.';

  @override
  String get legalNoticeSection12Title => '12. Restrictions à l\'exportation';

  @override
  String get legalNoticeSection12Text => 'Le logiciel est soumis aux lois et réglementations Française en matière d’exportation. Vous devez vous conformer à toutes les lois et réglementations nationales et internationales en matière d’exportation concernant le logiciel. Ces lois comportent des restrictions sur les destinations, les utilisateurs finaux et les utilisations finales.';

  @override
  String get legalNoticeSection13Title => '13. Mentions de droits d\'auteur';

  @override
  String get legalNoticeSection13Text => 'HYDRAO Smart & Blue est une marque déposée de Smart & Blue SAS.';

  @override
  String get legalNoticeSection14Title => '14. Intégralité de l\'accord';

  @override
  String get legalNoticeSection14Text => 'Le présent contrat ainsi que les termes concernant les suppléments, les mises à jour, les services Internet et d’assistance technique que vous utilisez constituent l’intégralité des accords en ce qui concerne le logiciel et les services d’assistance technique.';

  @override
  String get legalNoticeSection15Title => '15. Effet juridique';

  @override
  String get legalNoticeSection15Text => 'Le présent contrat décrit certains droits légaux. Vous pouvez bénéficier d’autres droits prévus par les lois de votre pays. Vous pouvez également bénéficier de certains droits à l’égard de la partie auprès de laquelle vous avez acquis le logiciel. Le présent contrat ne modifie pas les droits que vous confèrent les lois de votre pays si celles-ci ne le permettent pas.';

  @override
  String get legalNoticeSection16Title => '16. Exclusions de garantie';

  @override
  String get legalNoticeSection16Text => 'Le logiciel est concédé sous licence « en l’état », « avec tous ses défauts » et « tel que disponible ». vous assumez tous les risques liés à son utilisation. Si vous le souhaitez, vous pouvez transmettre à Google/Apple une demande de remboursement du prix d’achat. Dans les limites permises par la réglementation applicable, Google/Apple n’aura aucune autre obligation de garantie quelle qu’elle soit. HYDRAO et les opérateurs de téléphonie mobile dont les réseaux sont utilisés pour la distribution du logiciel, ainsi que chacun de nos affiliés et fournisseurs respectifs (les « parties couvertes ») n’accordent aucune garantie ou condition expresse en ce qui concerne le logiciel. Vous assumez tous les risques liés à la qualité et à l’exécution du logiciel. En cas de défectuosité du logiciel, vous assumez tous les coûts liés aux opérations d’entretien ou de réparation nécessaires. Vous pouvez bénéficier de droits supplémentaires en vertu du droit de la consommation de votre pays, que ce contrat ne peut modifier. Dans la limite autorisée par la législation locale, les parties couvertes excluent les garanties implicites de qualité, d’adéquation à un usage particulier et d’absence de contrefaçon.';

  @override
  String get legalNoticeSection17Title => '17. Limitation et exclusion des recours et dommages-intérêts';

  @override
  String get legalNoticeSection17Text => 'Dans la mesure où cela n’est pas contraire à la loi, vous ne pouvez obtenir une indemnisation d’HYDRAO qu’en cas de dommages directs, limitée à un euro (€ 1,00). Vous reconnaissez que vous ne pouvez prétendre à aucune indemnisation de la part des parties couvertes pour les autres dommages, y compris les dommages spéciaux, indirects, incidents ou accessoires et les pertes de bénéfices.\n\nCette limitation concerne notamment :\n•       toute affaire liée au logiciel, aux services ou au contenu (y compris le code) figurant sur des sites Internet tiers ou dans des programmes tiers ; et\n•       les réclamations pour manquement aux termes du contrat ou de la garantie ; protection des consommateurs ; tromperie ; concurrence déloyale ; responsabilité sans faute, négligence, mauvaise interprétation, omission, trouble de jouissance ou autre délit ; violation d’une loi ou réglementation ; ou enrichissement injuste, dans la limite autorisée par la réglementation applicable.\n\nElle s’applique également, même si :\n•       la réparation, le remplacement ou le remboursement du logiciel ne compense pas intégralement tout préjudice subi ;\n•       les parties couvertes avaient ou auraient dû avoir connaissance de l’éventualité de tels dommages.\nLa limitation ou l’exclusion ci-dessus peut également ne pas vous être applicable si votre pays n’autorise pas l’exclusion ou la limitation de responsabilité pour les dommages incidents, indirects ou de quelque nature que ce soit.';
}
