import 'package:flutter/material.dart';

/// Système d'espacement basé sur Tailwind converti en Flutter
/// Espacement basé sur 4px (xs=4, sm=8, md=16, etc.)
class AppSpacing {
  // Espacement de base (basé sur 4px)
  static const double xs = 4.0;    // 1 * 4px
  static const double sm = 8.0;    // 2 * 4px
  static const double md = 16.0;   // 4 * 4px
  static const double lg = 24.0;   // 6 * 4px
  static const double xl = 32.0;   // 8 * 4px
  static const double xxl = 48.0;  // 12 * 4px
  static const double xxxl = 64.0; // 16 * 4px

  // Espacement spécifique
  static const double space1 = 4.0;
  static const double space2 = 8.0;
  static const double space3 = 12.0;
  static const double space4 = 16.0;
  static const double space5 = 20.0;
  static const double space6 = 24.0;
  static const double space7 = 28.0;
  static const double space8 = 32.0;
  static const double space9 = 36.0;
  static const double space10 = 40.0;
  static const double space11 = 44.0;
  static const double space12 = 48.0;
  static const double space14 = 56.0;
  static const double space16 = 64.0;
  static const double space20 = 80.0;
  static const double space24 = 96.0;
  static const double space28 = 112.0;
  static const double space32 = 128.0;
  static const double space36 = 144.0;
  static const double space40 = 160.0;
  static const double space44 = 176.0;
  static const double space48 = 192.0;
  static const double space52 = 208.0;
  static const double space56 = 224.0;
  static const double space60 = 240.0;
  static const double space64 = 256.0;
  static const double space72 = 288.0;
  static const double space80 = 320.0;
  static const double space96 = 384.0;

  // Padding et margin standards
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  static const EdgeInsets paddingHorizontalXs = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets paddingHorizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHorizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingHorizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets paddingHorizontalXl = EdgeInsets.symmetric(horizontal: xl);

  static const EdgeInsets paddingVerticalXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets paddingVerticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVerticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVerticalLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets paddingVerticalXl = EdgeInsets.symmetric(vertical: xl);

  // Marges standards
  static const EdgeInsets marginXs = EdgeInsets.all(xs);
  static const EdgeInsets marginSm = EdgeInsets.all(sm);
  static const EdgeInsets marginMd = EdgeInsets.all(md);
  static const EdgeInsets marginLg = EdgeInsets.all(lg);
  static const EdgeInsets marginXl = EdgeInsets.all(xl);
}

/// Rayons de bordure avec les valeurs exactes
class AppBorderRadius {
  // Rayons de base
  static const double none = 0.0;
  static const double xs = 2.0;
  static const double sm = 4.0;
  static const double md = 6.0;
  static const double lg = 8.0;
  static const double xl = 12.0;
  static const double xxl = 16.0;
  static const double xxxl = 24.0;
  static const double full = 9999.0;

  // BorderRadius standards
  static const BorderRadius noneRadius = BorderRadius.zero;
  static const BorderRadius xsRadius = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius smRadius = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdRadius = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgRadius = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlRadius = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius xxlRadius = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius xxxlRadius = BorderRadius.all(Radius.circular(xxxl));
  static const BorderRadius fullRadius = BorderRadius.all(Radius.circular(full));

  // Rayons spécifiques (coins)
  static const BorderRadius topLeft = BorderRadius.only(topLeft: Radius.circular(lg));
  static const BorderRadius topRight = BorderRadius.only(topRight: Radius.circular(lg));
  static const BorderRadius bottomLeft = BorderRadius.only(bottomLeft: Radius.circular(lg));
  static const BorderRadius bottomRight = BorderRadius.only(bottomRight: Radius.circular(lg));
}

/// Ombres avec les paramètres précis
class AppShadows {
  // Ombres de base
  static const BoxShadow sm = BoxShadow(
    color: Color(0x0A000000),
    offset: Offset(0, 1),
    blurRadius: 2,
    spreadRadius: 0,
  );

  static const BoxShadow md = BoxShadow(
    color: Color(0x0A000000),
    offset: Offset(0, 4),
    blurRadius: 6,
    spreadRadius: -1,
  );

  static const BoxShadow lg = BoxShadow(
    color: Color(0x0A000000),
    offset: Offset(0, 10),
    blurRadius: 15,
    spreadRadius: -3,
  );

  static const BoxShadow xl = BoxShadow(
    color: Color(0x0A000000),
    offset: Offset(0, 20),
    blurRadius: 25,
    spreadRadius: -5,
  );

  static const BoxShadow xxl = BoxShadow(
    color: Color(0x0A000000),
    offset: Offset(0, 25),
    blurRadius: 50,
    spreadRadius: -12,
  );

  // Ombres colorées
  static const BoxShadow primary = BoxShadow(
    color: Color(0x1AF43F5E),
    offset: Offset(0, 4),
    blurRadius: 6,
    spreadRadius: -1,
  );

  static const BoxShadow destructive = BoxShadow(
    color: Color(0x1AEF4444),
    offset: Offset(0, 4),
    blurRadius: 6,
    spreadRadius: -1,
  );

  static const BoxShadow success = BoxShadow(
    color: Color(0x1A10B981),
    offset: Offset(0, 4),
    blurRadius: 6,
    spreadRadius: -1,
  );

  // Ombres pour le mode sombre
  static const BoxShadow darkSm = BoxShadow(
    color: Color(0x1A000000),
    offset: Offset(0, 1),
    blurRadius: 2,
    spreadRadius: 0,
  );

  static const BoxShadow darkMd = BoxShadow(
    color: Color(0x1A000000),
    offset: Offset(0, 4),
    blurRadius: 6,
    spreadRadius: -1,
  );

  static const BoxShadow darkLg = BoxShadow(
    color: Color(0x1A000000),
    offset: Offset(0, 10),
    blurRadius: 15,
    spreadRadius: -3,
  );
}

/// Extension pour faciliter l'utilisation des espacements
extension AppSpacingExtension on double {
  /// Convertit en EdgeInsets symétrique
  EdgeInsets get padding => EdgeInsets.all(this);
  
  /// Convertit en EdgeInsets horizontal
  EdgeInsets get paddingHorizontal => EdgeInsets.symmetric(horizontal: this);
  
  /// Convertit en EdgeInsets vertical
  EdgeInsets get paddingVertical => EdgeInsets.symmetric(vertical: this);
  
  /// Convertit en BorderRadius
  BorderRadius get borderRadius => BorderRadius.circular(this);
}

