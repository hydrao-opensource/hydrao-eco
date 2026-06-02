import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrao_flutter_offline/core/form_fields.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/domains/form_domain.dart';
import 'package:hydrao_flutter_offline/domains/user_domain.dart';
import 'package:hydrao_flutter_offline/domains/user_state.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/models/backup.dart';
import 'package:hydrao_flutter_offline/providers.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';
import 'package:hydrao_flutter_offline/theme.dart';
import 'package:hydrao_flutter_offline/ui/dialogs/login_dialog.dart';
import 'package:hydrao_flutter_offline/ui/widgets/custom_expansion_tile.dart';
import 'package:hydrao_flutter_offline/ui/widgets/labeled_switch.dart';
import 'package:hydrao_flutter_offline/utils.dart';

const _logTag = "[CONFIGURE_SHOWERHEAD_FORM] ";

enum From { file, cloud }

enum Field { full, settings, showerheads, showers }

class ImportBackupForm extends ConsumerStatefulWidget {
  final HydraoBackup localData;
  final From from;

  const ImportBackupForm({
    super.key,
    required this.localData,
    required this.from,
  });

  @override
  ConsumerState<ImportBackupForm> createState() => ImportBackupFormState();
}

class ImportBackupFormState extends ConsumerState<ImportBackupForm> {
  bool cloudInitialized = false;
  bool isDisposed = false;
  bool downloadFailed = false;
  File? backupFile;
  bool importSettings = false;
  List<String> shsToImport = [];
  List<String> showersToImport = [];
  HydraoBackup? fullBackup;
  HydraoBackupChanges? localChanges;
  HydraoBackup? currentBackup;
  late FormDomain<HydraoBackup> formDomain;
  late UserDomain userDomain;

  @override
  void initState() {
    super.initState();

    formDomain = ref.read(backupFormStateProvider.notifier);
    userDomain = ref.read(userDomainProvider.notifier);
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }

  void resetFile() {
    setState(() {
      backupFile = null;
      fullBackup = null;
      importSettings = false;
      shsToImport = [];
      showersToImport = [];
    });
  }

  Future<void> _onFileSelected(String? filePath) async {
    if (filePath != null) {
      String fileName = filePath.split('/').last;
      appLogger.i('$_logTag file selected: $fileName / path=$filePath');

      final File file = File(filePath);

      if (!await file.exists()) {
        resetFile();
        return;
      }

      final backupJson = await file.readAsString();
      final HydraoBackup? selectedBackup = HydraoBackup.fromJson(backupJson);
      if (selectedBackup == null) {
        resetFile();
        return;
      }
      setState(() {
        backupFile = file;
        fullBackup = selectedBackup;
        localChanges = fullBackup?.compare(widget.localData);
        appLogger.d(
          '$_logTag sh actions=${localChanges?.shActions} / sh uuids=${localChanges?.getShowerheadUuids()} / shower uuids=${localChanges?.getShowersUuids()}',
        );
      });
      _onFieldChanged(Field.full, null);
    } else {
      appLogger.i('$_logTag reset file selected');
      resetFile();
    }
  }

  void _onFieldChanged(Field field, dynamic value, {String? key}) {
    // if (!mounted) return;
    appLogger.d(
      '$_logTag field "${field.toString()}" changed : value=$value / key=$key',
    );
    switch (field) {
      case Field.full:
        setState(() {
          importSettings = localChanges!.settingsStatus == ChangeStatus.insert;
          shsToImport = localChanges!.getShowerheadUuids();
          showersToImport = localChanges!.getShowersUuids();
        });
        break;

      case Field.settings:
        setState(() {
          importSettings = value as bool;
        });
        break;
      case Field.showerheads:
        setState(() {
          if (value == true) {
            if (!shsToImport.contains(key)) {
              shsToImport.add(key!);
              int newShowersCount =
                  localChanges?.getShowerheadShowersCount(key) ?? 0;
              if (newShowersCount > 0 && !showersToImport.contains(key)) {
                showersToImport.add(key);
              }
            }
          } else if (shsToImport.contains(key)) {
            shsToImport.remove(key);
          }
        });
        break;
      case Field.showers:
        setState(() {
          if (value == true) {
            if (!showersToImport.contains(key)) {
              showersToImport.add(key!);
            }
          } else if (showersToImport.contains(key)) {
            showersToImport.remove(key);
          }
        });
        break;
    }

    refreshFormState();
  }

  void refreshFormState() {
    bool hasChanges =
        importSettings == true ||
        showersToImport.isNotEmpty ||
        shsToImport.isNotEmpty;

    // update state
    if (hasChanges) {
      currentBackup = localChanges?.filter(
        importSettings,
        shsToImport,
        showersToImport,
      );
      formDomain.setChanges(currentBackup);
    } else {
      currentBackup = null;
      formDomain.resetChanges();
    }

    // validate values
    var errors = _checkErrors();
    formDomain.updateErrors(errors);
  }

  Map<String, String> _checkErrors() {
    final t = AppLocalizations.of(context)!;

    Map<String, String> errors = {};

    // wrong file
    if (fullBackup == null) {
      errors["file"] = t.importBackupWrongFile;
    }

    // check at least one data selected
    if (fullBackup != null) {
      if (importSettings == false &&
          shsToImport.isEmpty &&
          showersToImport.isEmpty) {
        errors["content"] = t.importBackupMinContentError;
      }
    }

    appLogger.d('$_logTag checkErrors : $errors');
    return errors;
  }

  Future<void> downloadBackup() async {
    appLogger.d('try to download backup...');
    try {
      final backup = await userDomain.downloadBackup();
      appLogger.d('download backup... SUCCESS');
      if (!mounted) return;
      setState(() {
        fullBackup = backup;
        localChanges = fullBackup?.compare(widget.localData);
      });
      _onFieldChanged(Field.full, null);
    } catch (e) {
      appLogger.d('download backup... FAILED : $e');
      if (!mounted) return;
      setState(() {
        fullBackup = null;
        downloadFailed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.from == From.cloud && cloudInitialized == false) {
        final userState = ref.watch(userDomainProvider);
        if (userState.authStatus != AuthStatus.logged &&
            fullBackup == null &&
            downloadFailed == false) {
          showLoginDialog(context: context);
          cloudInitialized = true;
        }
      }
    });

    List<Widget> contents = [];
    if (widget.from == From.file) {
      contents.add(buildFileSection());
    } else if (widget.from == From.cloud) {
      contents.add(buildCloudSection());
    }

    if (fullBackup != null) {
      //TODO message on load success
      //  if (fullBackup != null && backupFile != null)
      //     Text(
      //       backupFile!.path.split('/').last,
      //       style: TextStyle(fontWeight: FontWeight.bold),
      //     ),

      if (fullBackup!.schemaVersion != widget.localData.schemaVersion) {
        contents.add(SizedBox(height: 15));
        contents.add(buildWarningPanel(t.importBackupVersionWarning));
      }

      // detect changes of os (Android => iOS, iOS => android)
      if (localChanges != null &&
          localChanges!.showerheadsToImport.isNotEmpty) {
        List<Showerhead> wrongOs = [];
        for (var sh in localChanges!.showerheadsToImport) {
          if (Platform.isAndroid && !sh.id.looksLikeMacAddress()) {
            wrongOs.add(sh);
          } else if (Platform.isIOS && sh.id.looksLikeMacAddress()) {
            wrongOs.add(sh);
          }
        }

        if (wrongOs.isNotEmpty) {
          contents.add(SizedBox(height: 15));
          contents.add(buildWarningPanel(t.importBackupOsChangeWarning));
        }
      }

      // error message
      // String? contentError = formDomain.getFieldError('content');
      // if (contentError != null) {
      //   contents.add(SizedBox(height: 15));
      //   contents.add(
      //     SizedBox(
      //       width: 250,
      //       child: Text(contentError, style: TextStyle(color: Colors.red)),
      //     ),
      //   );
      // }

      // manage backup content

      if (fullBackup?.settings != null) {
        contents.add(SizedBox(height: 15));
        contents.add(buildSettingsSection());
      }

      localChanges?.shActions.forEach((uuid, status) {
        contents.add(SizedBox(height: 15));
        contents.add(buildShowerheadSection(uuid, status));
      });
    }

    return Column(mainAxisSize: MainAxisSize.min, children: contents);
  }

  Widget buildFileSection() {
    final t = AppLocalizations.of(context)!;

    return CustomExpansionTile(
      title: t.importBackupDataSourceSectionTitle,
      expanded: true,
      expandable: false,
      backgroundColor: Theme.of(context).colorScheme.primary.lighten(0.3),
      foregroundColor: Colors.white,
      children: [
        buildFileField(
          t,
          _onFileSelected,
          extensions: ['json'],
          label: t.importBackupFromFileField,
          errorMessage: formDomain.getFieldError("file"),
          labelColor: Colors.white,
          fieldWidth: 120,
        ),
      ],
    );
  }

  Widget buildCloudSection() {
    final t = AppLocalizations.of(context)!;
    final userState = ref.watch(userDomainProvider);
    const whiteStyle = TextStyle(color: Colors.white);

    // reactive behaviors
    if (!isDisposed) {
      ref.listen<UserState>(userDomainProvider, (previous, next) async {
        appLogger.t(
          '$_logTag state previous=${previous?.authStatus.toString()} / next=${next.authStatus.toString()}',
        );

        if (next.authStatus == AuthStatus.logged &&
            fullBackup == null &&
            downloadFailed == false) {
          await downloadBackup();
        }
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (userState.authStatus == AuthStatus.logged && fullBackup == null) {
        await downloadBackup();
      }
    });

    Widget loginButton = TextButton(
      onPressed: () async {
        // await userDomain.login("test_dev_timezone@yopmail.com", "1234567890");
        showLoginDialog(context: context);
      },
      child: Text(t.login, style: whiteStyle),
    );

    Widget logoutButton = userState.authStatus != AuthStatus.logged
        ? SizedBox.shrink()
        : TextButton(
            onPressed: () async {
              await userDomain.logout();
              setState(() {
                downloadFailed = false;
                fullBackup = null;
              });
            },
            child: Text(t.logout, style: TextStyle(color: Colors.white)),
          );

    Widget loggedContent = (downloadFailed == false && fullBackup == null)
        ? Text(t.importBackupCloudDownloadingBackup, style: whiteStyle)
        : (downloadFailed == true)
        ? Text(t.importBackupCloudDownloadFailed, style: whiteStyle)
        : Text(t.importBackupSelectDataToImport, style: whiteStyle);

    Widget content = switch (userState.authStatus) {
      AuthStatus.logged => loggedContent,
      AuthStatus.expired => loginButton,
      AuthStatus.logging => Text(t.connecting, style: whiteStyle),
      AuthStatus.unlogged => loginButton,
    };

    return CustomExpansionTile(
      title: t.importBackupCloudSectionTitle,
      expanded: true,
      expandable: false,
      backgroundColor: Theme.of(context).colorScheme.primary.lighten(0.3),
      foregroundColor: Colors.white,
      globalPadding: 5,
      headerPadding: EdgeInsetsGeometry.only(left: 5, right: 5, top: 8),
      contentPadding: EdgeInsetsGeometry.only(left: 10, bottom: 10, right: 10),
      trailingButton: logoutButton,
      contentAlignement: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              userState.email ?? t.importBackupCloudNoEmail,
              style: TextStyle(color: Colors.white60),
              textAlign: TextAlign.start,
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [content]),
      ],
    );
  }

  Widget buildSettingsSection() {
    final t = AppLocalizations.of(context)!;

    return CustomExpansionTile(
      title: t.importBackupSettingsSectionTitle,
      expanded: true,
      children: [
        Row(
          children: [
            SizedBox(
              width: 150,
              child: LabeledSwitch(
                switchOnRight: false,
                value: importSettings,
                enabled: localChanges?.settingsStatus != ChangeStatus.noChange,
                label: t.import,
                onChanged: (newValue) {
                  _onFieldChanged(Field.settings, newValue);
                },
              ),
            ),
            SizedBox(width: 8),
            buildChangeLabel(
              localChanges?.settingsStatus ?? ChangeStatus.noChange,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildShowerheadSection(String uuid, ChangeStatus status) {
    final t = AppLocalizations.of(context)!;

    String? shName = localChanges?.getShowerheadName(uuid);
    int newShowersCount = localChanges?.getShowerheadShowersCount(uuid) ?? 0;
    ChangeStatus showersStatus = newShowersCount > 0
        ? ChangeStatus.insert
        : ChangeStatus.noChange;
    String showersMessage = newShowersCount > 0
        ? t.importBackupShowerNewCount(newShowersCount)
        : t.importBackupShowerNone;

    bool canSelectShowers =
        shsToImport.contains(uuid) || status != ChangeStatus.insert;

    return CustomExpansionTile(
      title: shName ?? "",
      expanded: true,
      children: [
        Row(
          children: [
            SizedBox(
              width: 150,
              child: LabeledSwitch(
                switchOnRight: false,
                value: shsToImport.contains(uuid),
                enabled: status != ChangeStatus.noChange,
                label: t.importBackupShowerhead,
                onChanged: (newValue) {
                  _onFieldChanged(Field.showerheads, newValue, key: uuid);
                },
              ),
            ),
            SizedBox(width: 8),
            buildChangeLabel(status),
          ],
        ),
        SizedBox(height: 2),
        Row(
          children: [
            SizedBox(
              width: 150,
              child: LabeledSwitch(
                switchOnRight: false,
                value: showersToImport.contains(uuid),
                enabled:
                    canSelectShowers && showersStatus != ChangeStatus.noChange,
                label: t.importBackupShowers,
                onChanged: (newValue) {
                  _onFieldChanged(Field.showers, newValue, key: uuid);
                },
              ),
            ),
            SizedBox(width: 8),
            buildChangeLabel(showersStatus, text: showersMessage),
          ],
        ),
      ],
    );
  }

  Widget buildChangeLabel(ChangeStatus status, {String? text}) {
    final t = AppLocalizations.of(context)!;

    Color? textColor;
    String? message;
    switch (status) {
      case ChangeStatus.insert:
        message = t.importBackupNewStatus;
        textColor = AppTheme.color;
        break;
      case ChangeStatus.update:
        message = t.importBackupConflictStatus;
        textColor = AppTheme.textWarningColor;
        break;
      case ChangeStatus.noChange:
        message = t.importBackupNoChangeStatus;
        textColor = AppTheme.textColor.withValues(alpha: 0.3);
        break;
    }
    if (text != null) {
      message = text;
    }

    return Text(
      message.toUpperCase(),
      style: TextStyle(color: textColor, fontSize: 13),
    );
  }

  Widget buildWarningPanel(String message) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: AppTheme.sectionBackground,
        borderRadius: BorderRadius.circular(8),
        border: BoxBorder.all(color: AppTheme.textWarningColor),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: AppTheme.textWarningColor),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: AppTheme.textWarningColor, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
