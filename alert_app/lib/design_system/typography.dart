import 'package:flutter/material.dart';

/// Système de typographie détaillée avec hiérarchie complète
/// Tailles et poids de police précis, hauteurs de ligne et espacement des lettres
class AppTypography {
  // Famille de police
  static const String fontFamily = 'Inter';
  
  // Tailles de police
  static const double fontSizeXs = 12.0;
  static const double fontSizeSm = 14.0;
  static const double fontSizeBase = 16.0;
  static const double fontSizeLg = 18.0;
  static const double fontSizeXl = 20.0;
  static const double fontSize2xl = 24.0;
  static const double fontSize3xl = 30.0;
  static const double fontSize4xl = 36.0;
  static const double fontSize5xl = 48.0;
  static const double fontSize6xl = 60.0;
  static const double fontSize7xl = 72.0;
  static const double fontSize8xl = 96.0;
  static const double fontSize9xl = 128.0;

  // Poids de police
  static const FontWeight fontWeightThin = FontWeight.w100;
  static const FontWeight fontWeightExtraLight = FontWeight.w200;
  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightNormal = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;
  static const FontWeight fontWeightExtraBold = FontWeight.w800;
  static const FontWeight fontWeightBlack = FontWeight.w900;

  // Hauteurs de ligne
  static const double lineHeightNone = 1.0;
  static const double lineHeightTight = 1.25;
  static const double lineHeightSnug = 1.375;
  static const double lineHeightNormal = 1.5;
  static const double lineHeightRelaxed = 1.625;
  static const double lineHeightLoose = 2.0;

  // Espacement des lettres
  static const double letterSpacingTighter = -0.05;
  static const double letterSpacingTight = -0.025;
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingWide = 0.025;
  static const double letterSpacingWider = 0.05;
  static const double letterSpacingWidest = 0.1;

  // Hiérarchie typographique
  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize4xl,
    fontWeight: fontWeightBold,
    height: lineHeightTight,
    letterSpacing: letterSpacingTight,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize3xl,
    fontWeight: fontWeightBold,
    height: lineHeightTight,
    letterSpacing: letterSpacingTight,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize2xl,
    fontWeight: fontWeightSemiBold,
    height: lineHeightSnug,
    letterSpacing: letterSpacingNormal,
  );

  static const TextStyle h4 = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeXl,
    fontWeight: fontWeightSemiBold,
    height: lineHeightSnug,
    letterSpacing: letterSpacingNormal,
  );

  static const TextStyle h5 = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeLg,
    fontWeight: fontWeightMedium,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
  );

  static const TextStyle h6 = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeBase,
    fontWeight: fontWeightMedium,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeLg,
    fontWeight: fontWeightNormal,
    height: lineHeightRelaxed,
    letterSpacing: letterSpacingNormal,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeBase,
    fontWeight: fontWeightNormal,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeSm,
    fontWeight: fontWeightNormal,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeXs,
    fontWeight: fontWeightNormal,
    height: lineHeightNormal,
    letterSpacing: letterSpacingWide,
  );

  static const TextStyle overline = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeXs,
    fontWeight: fontWeightMedium,
    height: lineHeightNormal,
    letterSpacing: letterSpacingWidest,
  );

  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeBase,
    fontWeight: fontWeightMedium,
    height: lineHeightNone,
    letterSpacing: letterSpacingWide,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeSm,
    fontWeight: fontWeightMedium,
    height: lineHeightNone,
    letterSpacing: letterSpacingWide,
  );

  static const TextStyle buttonLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeLg,
    fontWeight: fontWeightMedium,
    height: lineHeightNone,
    letterSpacing: letterSpacingWide,
  );
}

/// Extension pour faciliter l'utilisation de la typographie
extension AppTypographyExtension on TextStyle {
  /// Applique la couleur primaire
  TextStyle get primary => copyWith(color: const Color(0xFFF43F5E));
  
  /// Applique la couleur secondaire
  TextStyle get secondary => copyWith(color: const Color(0xFF64748B));
  
  /// Applique la couleur destructive
  TextStyle get destructive => copyWith(color: const Color(0xFFEF4444));
  
  /// Applique la couleur muted
  TextStyle get muted => copyWith(color: const Color(0xFF64748B));
  
  /// Applique la couleur accent
  TextStyle get accent => copyWith(color: const Color(0xFF0F172A));
}

