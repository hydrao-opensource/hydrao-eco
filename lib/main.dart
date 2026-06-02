import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydrao_flutter_offline/core/logger.dart';
import 'package:hydrao_flutter_offline/firebase_options.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/l10n/l10n.dart';
import 'package:hydrao_flutter_offline/screen.dart';
import 'package:hydrao_flutter_offline/theme.dart';
import 'package:timeago/timeago.dart' as timeago;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // logger
  await initLogger();

  // crashlytics
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Rediriger les erreurs Flutter vers Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Rediriger les erreurs Dart non-catchées (zones)
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Ajout des messages pour le français
  timeago.setLocaleMessages('fr', timeago.FrMessages());
  timeago.setLocaleMessages('fr_short', timeago.FrShortMessages());

  runApp(const ProviderScope(child: HydraoApp()));
}

class HydraoApp extends StatelessWidget {
  const HydraoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext contex) {
    return MaterialApp(
      title: 'Hydrao Eco', //TODO a revoir
      supportedLocales: L10n.all, // supported locales
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.light,
      locale: const bool.fromEnvironment('FORCE_EN')
          ? Locale('en')
          : null, // to force app in english
      home: const AppScreen(),
    );
  }
}
