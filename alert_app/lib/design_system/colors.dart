import 'package:flutter/material.dart';

/// Système de couleurs complet avec palette HSL convertie en couleurs Flutter
/// Mode clair et sombre avec toutes les variables CSS
class AppColors {
  // Couleur principale : Rouge #F43F5E
  static const Color primary = Color(0xFFF43F5E);
  
  // Couleurs primaires avec variations HSL
  static const Color primary50 = Color(0xFFFEF2F2);
  static const Color primary100 = Color(0xFFFEE2E2);
  static const Color primary200 = Color(0xFFFECACA);
  static const Color primary300 = Color(0xFFFCA5A5);
  static const Color primary400 = Color(0xFFF87171);
  static const Color primary500 = Color(0xFFF43F5E);
  static const Color primary600 = Color(0xFFDC2626);
  static const Color primary700 = Color(0xFFB91C1C);
  static const Color primary800 = Color(0xFF991B1B);
  static const Color primary900 = Color(0xFF7F1D1D);
  static const Color primary950 = Color(0xFF450A0A);

  // Couleurs d'état
  static const Color destructive = Color(0xFFEF4444);
  static const Color destructiveForeground = Color(0xFFFEF2F2);
  
  static const Color muted = Color(0xFFF1F5F9);
  static const Color mutedForeground = Color(0xFF64748B);
  
  static const Color accent = Color(0xFFF1F5F9);
  static const Color accentForeground = Color(0xFF0F172A);
  
  static const Color popover = Color(0xFFFFFFFF);
  static const Color popoverForeground = Color(0xFF0F172A);
  
  static const Color card = Color(0xFFFFFFFF);
  static const Color cardForeground = Color(0xFF0F172A);
  
  static const Color border = Color(0xFFE2E8F0);
  static const Color input = Color(0xFFE2E8F0);
  
  static const Color background = Color(0xFFFFFFFF);
  static const Color foreground = Color(0xFF0F172A);
  
  static const Color secondary = Color(0xFFF1F5F9);
  static const Color secondaryForeground = Color(0xFF0F172A);
  
  static const Color ring = Color(0xFFF43F5E);

  // Couleurs de succès
  static const Color success = Color(0xFF10B981);
  static const Color successForeground = Color(0xFFFFFFFF);
  static const Color successBackground = Color(0xFFECFDF5);
  
  // Couleurs d'avertissement
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningForeground = Color(0xFFFFFFFF);
  static const Color warningBackground = Color(0xFFFEF3C7);
  
  // Couleurs d'information
  static const Color info = Color(0xFF3B82F6);
  static const Color infoForeground = Color(0xFFFFFFFF);
  static const Color infoBackground = Color(0xFFEFF6FF);
}

/// Couleurs pour le mode sombre
class AppColorsDark {
  static const Color primary = Color(0xFFF43F5E);
  
  static const Color destructive = Color(0xFFEF4444);
  static const Color destructiveForeground = Color(0xFFFEF2F2);
  
  static const Color muted = Color(0xFF1E293B);
  static const Color mutedForeground = Color(0xFF94A3B8);
  
  static const Color accent = Color(0xFF1E293B);
  static const Color accentForeground = Color(0xFFF8FAFC);
  
  static const Color popover = Color(0xFF0F172A);
  static const Color popoverForeground = Color(0xFFF8FAFC);
  
  static const Color card = Color(0xFF0F172A);
  static const Color cardForeground = Color(0xFFF8FAFC);
  
  static const Color border = Color(0xFF1E293B);
  static const Color input = Color(0xFF1E293B);
  
  static const Color background = Color(0xFF0A0A0A);
  static const Color foreground = Color(0xFFF8FAFC);
  
  static const Color secondary = Color(0xFF1E293B);
  static const Color secondaryForeground = Color(0xFFF8FAFC);
  
  static const Color ring = Color(0xFFF43F5E);
}

/// Extension pour faciliter l'utilisation des couleurs
extension AppColorsExtension on Color {
  /// Retourne la couleur avec opacité
  Color withOpacity(double opacity) {
    return Color.fromRGBO(red, green, blue, opacity);
  }
  
  /// Retourne la couleur avec alpha
  Color withAlpha(int alpha) {
    return Color.fromARGB(alpha, red, green, blue);
  }
}

