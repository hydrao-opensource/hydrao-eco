import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/utils.dart';

const Color kBrandPrimary = Color(0xFF008DCC);
const double backgroundLigthen = 0.53;

class AppTheme {
  static Color scanSectionBackground = kBrandPrimary;
  static Color scanSectionTextColor = Colors.white;
  // static Color sectionTitleColor = Colors.black87.lighten(0.2);
  static Color sectionTitleColor = kBrandPrimary.darken(0.3);
  static Color sectionSpecialBackground = kBrandPrimary.lighten(0.3);
  static double sectionTitleFontSize = 14.0;
  static Color textColor = Colors.black87;
  static Color textWarningColor = Colors.deepOrange;
  static Color sectionBackground = Colors.white;
  static Color color = kBrandPrimary;

  // Thème clair
  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: kBrandPrimary,
      brightness: Brightness.light,
      surface: kBrandPrimary.lighten(backgroundLigthen), // couleur des écrans
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: kBrandPrimary.lighten(backgroundLigthen),
      // Couleur primaire de fallback (certains widgets l’utilisent encore)
      primaryColor: kBrandPrimary,
      appBarTheme: AppBarTheme(
        backgroundColor: kBrandPrimary.lighten(backgroundLigthen),
        foregroundColor: colorScheme.primary,
        centerTitle: true,
      ),
      // scrollbarTheme: ScrollbarThemeData(
      //   crossAxisMargin: 8, // espace entre contenu et scrollbar
      // ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      // Exemple de TextTheme custom si tu veux
      textTheme: const TextTheme(
        bodyMedium: TextStyle(fontSize: 14),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      expansionTileTheme: const ExpansionTileThemeData(
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        collapsedShape: Border(), // <-- retire la bordure par défaut
        shape: Border(), // <-- retire la bordure quand expandé
        tilePadding: EdgeInsets.zero,
        // childrenPadding: EdgeInsets.zero,
      ),
      dialogTheme: DialogThemeData(
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 10.0,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: kBrandPrimary.lighten(backgroundLigthen),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        // contentTextStyle: const TextStyle(
        //   fontSize: 15,
        //   color: Colors.black87,
        // ),
      ),

      sliderTheme: SliderThemeData(
        trackHeight: 6,
        // overlayShape: SliderComponentShape.noOverlay,
        overlayShape: RoundSliderOverlayShape(overlayRadius: 18),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        thumbColor: kBrandPrimary,
        activeTrackColor: kBrandPrimary,
        inactiveTrackColor: kBrandPrimary.withValues(alpha: 0.3),
        overlayColor: kBrandPrimary.withValues(alpha: 0.15),
        valueIndicatorColor: kBrandPrimary,
      ),
    );
  }

  // Thème sombre (optionnel)
  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: kBrandPrimary,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      primaryColor: kBrandPrimary,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        centerTitle: true,
      ),
    );
  }
}
