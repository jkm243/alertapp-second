import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';
import 'spacing.dart';

/// Thème Flutter complet avec ThemeData
class AppTheme {
  /// Thème clair
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: _lightColorScheme,
      textTheme: _lightTextTheme,
      appBarTheme: _lightAppBarTheme,
      elevatedButtonTheme: _lightElevatedButtonTheme,
      outlinedButtonTheme: _lightOutlinedButtonTheme,
      textButtonTheme: _lightTextButtonTheme,
      inputDecorationTheme: _lightInputDecorationTheme,
      cardTheme: _lightCardTheme,
      bottomNavigationBarTheme: _lightBottomNavigationBarTheme,
      drawerTheme: _lightDrawerTheme,
      dividerTheme: _lightDividerTheme,
      iconTheme: _lightIconTheme,
      primaryIconTheme: _lightPrimaryIconTheme,
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      cardColor: AppColors.card,
      dividerColor: AppColors.border,
      focusColor: const Color(0x33F43F5E),
      hoverColor: const Color(0x1AF43F5E),
      highlightColor: const Color(0x1AF43F5E),
      splashColor: const Color(0x1AF43F5E),
      unselectedWidgetColor: AppColors.mutedForeground,
      disabledColor: const Color(0x8064748B),
      buttonTheme: _lightButtonTheme,
      toggleButtonsTheme: _lightToggleButtonsTheme,
      chipTheme: _lightChipTheme,
      sliderTheme: _lightSliderTheme,
      switchTheme: _lightSwitchTheme,
      radioTheme: _lightRadioTheme,
      checkboxTheme: _lightCheckboxTheme,
      dialogTheme: _lightDialogTheme,
      bottomSheetTheme: _lightBottomSheetTheme,
      snackBarTheme: _lightSnackBarTheme,
      tooltipTheme: _lightTooltipTheme,
      popupMenuTheme: _lightPopupMenuTheme,
      listTileTheme: _lightListTileTheme,
      expansionTileTheme: _lightExpansionTileTheme,
      dataTableTheme: _lightDataTableTheme,
      progressIndicatorTheme: _lightProgressIndicatorTheme,
      pageTransitionsTheme: _pageTransitionsTheme,
    );
  }

  /// Thème sombre
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: _darkColorScheme,
      textTheme: _darkTextTheme,
      appBarTheme: _darkAppBarTheme,
      elevatedButtonTheme: _darkElevatedButtonTheme,
      outlinedButtonTheme: _darkOutlinedButtonTheme,
      textButtonTheme: _darkTextButtonTheme,
      inputDecorationTheme: _darkInputDecorationTheme,
      cardTheme: _darkCardTheme,
      bottomNavigationBarTheme: _darkBottomNavigationBarTheme,
      drawerTheme: _darkDrawerTheme,
      dividerTheme: _darkDividerTheme,
      iconTheme: _darkIconTheme,
      primaryIconTheme: _darkPrimaryIconTheme,
      scaffoldBackgroundColor: AppColorsDark.background,
      canvasColor: AppColorsDark.background,
      cardColor: AppColorsDark.card,
      dividerColor: AppColorsDark.border,
      focusColor: const Color(0x33F43F5E),
      hoverColor: const Color(0x1AF43F5E),
      highlightColor: const Color(0x1AF43F5E),
      splashColor: const Color(0x1AF43F5E),
      unselectedWidgetColor: AppColorsDark.mutedForeground,
      disabledColor: const Color(0x8094A3B8),
      buttonTheme: _darkButtonTheme,
      toggleButtonsTheme: _darkToggleButtonsTheme,
      chipTheme: _darkChipTheme,
      sliderTheme: _darkSliderTheme,
      switchTheme: _darkSwitchTheme,
      radioTheme: _darkRadioTheme,
      checkboxTheme: _darkCheckboxTheme,
      dialogTheme: _darkDialogTheme,
      bottomSheetTheme: _darkBottomSheetTheme,
      snackBarTheme: _darkSnackBarTheme,
      tooltipTheme: _darkTooltipTheme,
      popupMenuTheme: _darkPopupMenuTheme,
      listTileTheme: _darkListTileTheme,
      expansionTileTheme: _darkExpansionTileTheme,
      dataTableTheme: _darkDataTableTheme,
      progressIndicatorTheme: _darkProgressIndicatorTheme,
      pageTransitionsTheme: _pageTransitionsTheme,
    );
  }

  // ColorScheme clair
  static ColorScheme get _lightColorScheme {
    return const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: AppColors.secondaryForeground,
      tertiary: AppColors.accent,
      onTertiary: AppColors.accentForeground,
      error: AppColors.destructive,
      onError: AppColors.destructiveForeground,
      surface: AppColors.background,
      onSurface: AppColors.foreground,
      surfaceContainerHighest: AppColors.card,
      onSurfaceVariant: AppColors.mutedForeground,
      outline: AppColors.border,
      outlineVariant: AppColors.input,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: AppColors.foreground,
      onInverseSurface: AppColors.background,
      inversePrimary: AppColors.primary,
      surfaceTint: AppColors.primary,
    );
  }

  // ColorScheme sombre
  static ColorScheme get _darkColorScheme {
    return const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColorsDark.secondary,
      onSecondary: AppColorsDark.secondaryForeground,
      tertiary: AppColorsDark.accent,
      onTertiary: AppColorsDark.accentForeground,
      error: AppColors.destructive,
      onError: AppColors.destructiveForeground,
      surface: AppColorsDark.background,
      onSurface: AppColorsDark.foreground,
      surfaceContainerHighest: AppColorsDark.card,
      onSurfaceVariant: AppColorsDark.mutedForeground,
      outline: AppColorsDark.border,
      outlineVariant: AppColorsDark.input,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: AppColorsDark.foreground,
      onInverseSurface: AppColorsDark.background,
      inversePrimary: AppColors.primary,
      surfaceTint: AppColors.primary,
    );
  }

  // TextTheme clair
  static TextTheme get _lightTextTheme {
    return const TextTheme(
      displayLarge: AppTypography.h1,
      displayMedium: AppTypography.h2,
      displaySmall: AppTypography.h3,
      headlineLarge: AppTypography.h4,
      headlineMedium: AppTypography.h5,
      headlineSmall: AppTypography.h6,
      titleLarge: AppTypography.h5,
      titleMedium: AppTypography.h6,
      titleSmall: AppTypography.bodyLarge,
      bodyLarge: AppTypography.bodyLarge,
      bodyMedium: AppTypography.body,
      bodySmall: AppTypography.bodySmall,
      labelLarge: AppTypography.button,
      labelMedium: AppTypography.buttonSmall,
      labelSmall: AppTypography.caption,
    );
  }

  // TextTheme sombre
  static TextTheme get _darkTextTheme {
    return TextTheme(
      displayLarge: AppTypography.h1.copyWith(color: AppColorsDark.foreground),
      displayMedium: AppTypography.h2.copyWith(color: AppColorsDark.foreground),
      displaySmall: AppTypography.h3.copyWith(color: AppColorsDark.foreground),
      headlineLarge: AppTypography.h4.copyWith(color: AppColorsDark.foreground),
      headlineMedium: AppTypography.h5.copyWith(color: AppColorsDark.foreground),
      headlineSmall: AppTypography.h6.copyWith(color: AppColorsDark.foreground),
      titleLarge: AppTypography.h5.copyWith(color: AppColorsDark.foreground),
      titleMedium: AppTypography.h6.copyWith(color: AppColorsDark.foreground),
      titleSmall: AppTypography.bodyLarge.copyWith(color: AppColorsDark.foreground),
      bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColorsDark.foreground),
      bodyMedium: AppTypography.body.copyWith(color: AppColorsDark.foreground),
      bodySmall: AppTypography.bodySmall.copyWith(color: AppColorsDark.foreground),
      labelLarge: AppTypography.button.copyWith(color: AppColorsDark.foreground),
      labelMedium: AppTypography.buttonSmall.copyWith(color: AppColorsDark.foreground),
      labelSmall: AppTypography.caption.copyWith(color: AppColorsDark.mutedForeground),
    );
  }

  // AppBarTheme clair
  static AppBarTheme get _lightAppBarTheme {
    return AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTypography.h6.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      toolbarHeight: 64.0,
    );
  }

  // AppBarTheme sombre
  static AppBarTheme get _darkAppBarTheme {
    return AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTypography.h6.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      toolbarHeight: 64.0,
    );
  }

  // ElevatedButtonTheme clair
  static ElevatedButtonThemeData get _lightElevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: AppColors.primary.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: AppBorderRadius.mdRadius,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        textStyle: AppTypography.button,
      ),
    );
  }

  // ElevatedButtonTheme sombre
  static ElevatedButtonThemeData get _darkElevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: AppColors.primary.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: AppBorderRadius.mdRadius,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        textStyle: AppTypography.button,
      ),
    );
  }

  // OutlinedButtonTheme clair
  static OutlinedButtonThemeData get _lightOutlinedButtonTheme {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        shape: RoundedRectangleBorder(
          borderRadius: AppBorderRadius.mdRadius,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        textStyle: AppTypography.button,
      ),
    );
  }

  // OutlinedButtonTheme sombre
  static OutlinedButtonThemeData get _darkOutlinedButtonTheme {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        shape: RoundedRectangleBorder(
          borderRadius: AppBorderRadius.mdRadius,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        textStyle: AppTypography.button,
      ),
    );
  }

  // TextButtonTheme clair
  static TextButtonThemeData get _lightTextButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: AppBorderRadius.mdRadius,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        textStyle: AppTypography.button,
      ),
    );
  }

  // TextButtonTheme sombre
  static TextButtonThemeData get _darkTextButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: AppBorderRadius.mdRadius,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        textStyle: AppTypography.button,
      ),
    );
  }

  // InputDecorationTheme clair
  static InputDecorationTheme get _lightInputDecorationTheme {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.background,
      border: OutlineInputBorder(
        borderRadius: AppBorderRadius.mdRadius,
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.mdRadius,
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.mdRadius,
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.mdRadius,
        borderSide: const BorderSide(color: AppColors.destructive),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.mdRadius,
        borderSide: const BorderSide(color: AppColors.destructive, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      hintStyle: AppTypography.body.copyWith(
        color: AppColors.mutedForeground,
      ),
      labelStyle: AppTypography.body.copyWith(
        color: AppColors.foreground,
      ),
      errorStyle: AppTypography.caption.copyWith(
        color: AppColors.destructive,
      ),
    );
  }

  // InputDecorationTheme sombre
  static InputDecorationTheme get _darkInputDecorationTheme {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColorsDark.background,
      border: OutlineInputBorder(
        borderRadius: AppBorderRadius.mdRadius,
        borderSide: const BorderSide(color: AppColorsDark.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.mdRadius,
        borderSide: const BorderSide(color: AppColorsDark.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.mdRadius,
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.mdRadius,
        borderSide: const BorderSide(color: AppColors.destructive),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppBorderRadius.mdRadius,
        borderSide: const BorderSide(color: AppColors.destructive, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      hintStyle: AppTypography.body.copyWith(
        color: AppColorsDark.mutedForeground,
      ),
      labelStyle: AppTypography.body.copyWith(
        color: AppColorsDark.foreground,
      ),
      errorStyle: AppTypography.caption.copyWith(
        color: AppColors.destructive,
      ),
    );
  }

  // CardTheme clair
  static CardThemeData get _lightCardTheme {
    return CardThemeData(
      color: AppColors.card,
      elevation: 2,
      shadowColor: const Color(0x1A000000),
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderRadius.lgRadius,
        side: const BorderSide(color: AppColors.border),
      ),
      margin: const EdgeInsets.all(AppSpacing.sm),
    );
  }

  // CardTheme sombre
  static CardThemeData get _darkCardTheme {
    return CardThemeData(
      color: AppColorsDark.card,
      elevation: 2,
      shadowColor: const Color(0x4D000000),
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderRadius.lgRadius,
        side: const BorderSide(color: AppColorsDark.border),
      ),
      margin: const EdgeInsets.all(AppSpacing.sm),
    );
  }

  // BottomNavigationBarTheme clair
  static BottomNavigationBarThemeData get _lightBottomNavigationBarTheme {
    return const BottomNavigationBarThemeData(
      backgroundColor: AppColors.background,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.mutedForeground,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    );
  }

  // BottomNavigationBarTheme sombre
  static BottomNavigationBarThemeData get _darkBottomNavigationBarTheme {
    return const BottomNavigationBarThemeData(
      backgroundColor: AppColorsDark.background,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColorsDark.mutedForeground,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    );
  }

  // DrawerTheme clair
  static DrawerThemeData get _lightDrawerTheme {
    return const DrawerThemeData(
      backgroundColor: AppColors.background,
      elevation: 16,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(AppBorderRadius.lg),
          bottomRight: Radius.circular(AppBorderRadius.lg),
        ),
      ),
    );
  }

  // DrawerTheme sombre
  static DrawerThemeData get _darkDrawerTheme {
    return const DrawerThemeData(
      backgroundColor: AppColorsDark.background,
      elevation: 16,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(AppBorderRadius.lg),
          bottomRight: Radius.circular(AppBorderRadius.lg),
        ),
      ),
    );
  }

  // DividerTheme clair
  static DividerThemeData get _lightDividerTheme {
    return const DividerThemeData(
      color: AppColors.border,
      thickness: 1,
      space: 1,
    );
  }

  // DividerTheme sombre
  static DividerThemeData get _darkDividerTheme {
    return const DividerThemeData(
      color: AppColorsDark.border,
      thickness: 1,
      space: 1,
    );
  }

  // IconTheme clair
  static IconThemeData get _lightIconTheme {
    return const IconThemeData(
      color: AppColors.foreground,
      size: 24,
    );
  }

  // IconTheme sombre
  static IconThemeData get _darkIconTheme {
    return const IconThemeData(
      color: AppColorsDark.foreground,
      size: 24,
    );
  }

  // PrimaryIconTheme clair
  static IconThemeData get _lightPrimaryIconTheme {
    return const IconThemeData(
      color: AppColors.primary,
      size: 24,
    );
  }

  // PrimaryIconTheme sombre
  static IconThemeData get _darkPrimaryIconTheme {
    return const IconThemeData(
      color: AppColors.primary,
      size: 24,
    );
  }

  // ButtonTheme clair
  static ButtonThemeData get _lightButtonTheme {
    return const ButtonThemeData(
      buttonColor: AppColors.primary,
      disabledColor: AppColors.mutedForeground,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderRadius.mdRadius,
      ),
    );
  }

  // ButtonTheme sombre
  static ButtonThemeData get _darkButtonTheme {
    return const ButtonThemeData(
      buttonColor: AppColors.primary,
      disabledColor: AppColorsDark.mutedForeground,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderRadius.mdRadius,
      ),
    );
  }

  // ToggleButtonsTheme clair
  static ToggleButtonsThemeData get _lightToggleButtonsTheme {
    return ToggleButtonsThemeData(
      color: AppColors.foreground,
      selectedColor: Colors.white,
      fillColor: AppColors.primary,
      borderColor: AppColors.border,
      selectedBorderColor: AppColors.primary,
      borderRadius: AppBorderRadius.mdRadius,
    );
  }

  // ToggleButtonsTheme sombre
  static ToggleButtonsThemeData get _darkToggleButtonsTheme {
    return ToggleButtonsThemeData(
      color: AppColorsDark.foreground,
      selectedColor: Colors.white,
      fillColor: AppColors.primary,
      borderColor: AppColorsDark.border,
      selectedBorderColor: AppColors.primary,
      borderRadius: AppBorderRadius.mdRadius,
    );
  }

  // ChipTheme clair
  static ChipThemeData get _lightChipTheme {
    return ChipThemeData(
      backgroundColor: AppColors.muted,
      selectedColor: AppColors.primary,
      disabledColor: AppColors.mutedForeground.withOpacity(0.5),
      labelStyle: AppTypography.bodySmall,
      secondaryLabelStyle: AppTypography.bodySmall,
      brightness: Brightness.light,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderRadius.fullRadius,
      ),
    );
  }

  // ChipTheme sombre
  static ChipThemeData get _darkChipTheme {
    return ChipThemeData(
      backgroundColor: AppColorsDark.muted,
      selectedColor: AppColors.primary,
      disabledColor: AppColorsDark.mutedForeground.withOpacity(0.5),
      labelStyle: AppTypography.bodySmall.copyWith(color: AppColorsDark.foreground),
      secondaryLabelStyle: AppTypography.bodySmall.copyWith(color: AppColorsDark.foreground),
      brightness: Brightness.dark,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderRadius.fullRadius,
      ),
    );
  }

  // SliderTheme clair
  static SliderThemeData get _lightSliderTheme {
    return SliderThemeData(
      activeTrackColor: AppColors.primary,
      inactiveTrackColor: AppColors.border,
      thumbColor: AppColors.primary,
      overlayColor: AppColors.primary.withOpacity(0.2),
      valueIndicatorColor: AppColors.primary,
      valueIndicatorTextStyle: AppTypography.caption.copyWith(color: Colors.white),
    );
  }

  // SliderTheme sombre
  static SliderThemeData get _darkSliderTheme {
    return SliderThemeData(
      activeTrackColor: AppColors.primary,
      inactiveTrackColor: AppColorsDark.border,
      thumbColor: AppColors.primary,
      overlayColor: AppColors.primary.withOpacity(0.2),
      valueIndicatorColor: AppColors.primary,
      valueIndicatorTextStyle: AppTypography.caption.copyWith(color: Colors.white),
    );
  }

  // SwitchTheme clair
  static SwitchThemeData get _lightSwitchTheme {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }
        return AppColors.mutedForeground;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return AppColors.border;
      }),
    );
  }

  // SwitchTheme sombre
  static SwitchThemeData get _darkSwitchTheme {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }
        return AppColorsDark.mutedForeground;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return AppColorsDark.border;
      }),
    );
  }

  // RadioTheme clair
  static RadioThemeData get _lightRadioTheme {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return AppColors.mutedForeground;
      }),
    );
  }

  // RadioTheme sombre
  static RadioThemeData get _darkRadioTheme {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return AppColorsDark.mutedForeground;
      }),
    );
  }

  // CheckboxTheme clair
  static CheckboxThemeData get _lightCheckboxTheme {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
      side: const BorderSide(color: AppColors.border),
    );
  }

  // CheckboxTheme sombre
  static CheckboxThemeData get _darkCheckboxTheme {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
      side: const BorderSide(color: AppColorsDark.border),
    );
  }

  // DialogTheme clair
  static DialogThemeData get _lightDialogTheme {
    return DialogThemeData(
      backgroundColor: AppColors.background,
      elevation: 24,
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderRadius.lgRadius,
      ),
      titleTextStyle: AppTypography.h5,
      contentTextStyle: AppTypography.body,
    );
  }

  // DialogTheme sombre
  static DialogThemeData get _darkDialogTheme {
    return DialogThemeData(
      backgroundColor: AppColorsDark.background,
      elevation: 24,
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderRadius.lgRadius,
      ),
      titleTextStyle: AppTypography.h5.copyWith(color: AppColorsDark.foreground),
      contentTextStyle: AppTypography.body.copyWith(color: AppColorsDark.foreground),
    );
  }

  // BottomSheetTheme clair
  static BottomSheetThemeData get _lightBottomSheetTheme {
    return BottomSheetThemeData(
      backgroundColor: AppColors.background,
      elevation: 16,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppBorderRadius.lg),
          topRight: Radius.circular(AppBorderRadius.lg),
        ),
      ),
    );
  }

  // BottomSheetTheme sombre
  static BottomSheetThemeData get _darkBottomSheetTheme {
    return BottomSheetThemeData(
      backgroundColor: AppColorsDark.background,
      elevation: 16,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppBorderRadius.lg),
          topRight: Radius.circular(AppBorderRadius.lg),
        ),
      ),
    );
  }

  // SnackBarTheme clair
  static SnackBarThemeData get _lightSnackBarTheme {
    return SnackBarThemeData(
      backgroundColor: AppColors.foreground,
      contentTextStyle: AppTypography.body.copyWith(color: AppColors.background),
      actionTextColor: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderRadius.mdRadius,
      ),
    );
  }

  // SnackBarTheme sombre
  static SnackBarThemeData get _darkSnackBarTheme {
    return SnackBarThemeData(
      backgroundColor: AppColorsDark.foreground,
      contentTextStyle: AppTypography.body.copyWith(color: AppColorsDark.background),
      actionTextColor: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderRadius.mdRadius,
      ),
    );
  }

  // TooltipTheme clair
  static TooltipThemeData get _lightTooltipTheme {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: AppColors.foreground,
        borderRadius: AppBorderRadius.smRadius,
      ),
      textStyle: AppTypography.caption.copyWith(color: AppColors.background),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
    );
  }

  // TooltipTheme sombre
  static TooltipThemeData get _darkTooltipTheme {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: AppColorsDark.foreground,
        borderRadius: AppBorderRadius.smRadius,
      ),
      textStyle: AppTypography.caption.copyWith(color: AppColorsDark.background),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
    );
  }

  // PopupMenuTheme clair
  static PopupMenuThemeData get _lightPopupMenuTheme {
    return PopupMenuThemeData(
      color: AppColors.background,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderRadius.mdRadius,
      ),
      textStyle: AppTypography.body,
    );
  }

  // PopupMenuTheme sombre
  static PopupMenuThemeData get _darkPopupMenuTheme {
    return PopupMenuThemeData(
      color: AppColorsDark.background,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderRadius.mdRadius,
      ),
      textStyle: AppTypography.body.copyWith(color: AppColorsDark.foreground),
    );
  }

  // ListTileTheme clair
  static ListTileThemeData get _lightListTileTheme {
    return const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      titleTextStyle: AppTypography.body,
      subtitleTextStyle: AppTypography.bodySmall,
    );
  }

  // ListTileTheme sombre
  static ListTileThemeData get _darkListTileTheme {
    return ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      titleTextStyle: AppTypography.body.copyWith(color: AppColorsDark.foreground),
      subtitleTextStyle: AppTypography.bodySmall.copyWith(color: AppColorsDark.mutedForeground),
    );
  }

  // ExpansionTileTheme clair
  static ExpansionTileThemeData get _lightExpansionTileTheme {
    return const ExpansionTileThemeData(
      backgroundColor: AppColors.background,
      collapsedBackgroundColor: AppColors.background,
      textColor: AppColors.foreground,
      collapsedTextColor: AppColors.foreground,
      iconColor: AppColors.primary,
      collapsedIconColor: AppColors.mutedForeground,
    );
  }

  // ExpansionTileTheme sombre
  static ExpansionTileThemeData get _darkExpansionTileTheme {
    return const ExpansionTileThemeData(
      backgroundColor: AppColorsDark.background,
      collapsedBackgroundColor: AppColorsDark.background,
      textColor: AppColorsDark.foreground,
      collapsedTextColor: AppColorsDark.foreground,
      iconColor: AppColors.primary,
      collapsedIconColor: AppColorsDark.mutedForeground,
    );
  }

  // DataTableTheme clair
  static DataTableThemeData get _lightDataTableTheme {
    return DataTableThemeData(
      headingRowColor: WidgetStateProperty.all(AppColors.muted),
      dataRowColor: WidgetStateProperty.all(AppColors.background),
      headingTextStyle: AppTypography.bodySmall.copyWith(
        fontWeight: FontWeight.w600,
      ),
      dataTextStyle: AppTypography.bodySmall,
    );
  }

  // DataTableTheme sombre
  static DataTableThemeData get _darkDataTableTheme {
    return DataTableThemeData(
      headingRowColor: WidgetStateProperty.all(AppColorsDark.muted),
      dataRowColor: WidgetStateProperty.all(AppColorsDark.background),
      headingTextStyle: AppTypography.bodySmall.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColorsDark.foreground,
      ),
      dataTextStyle: AppTypography.bodySmall.copyWith(
        color: AppColorsDark.foreground,
      ),
    );
  }


  // ProgressIndicatorTheme clair
  static ProgressIndicatorThemeData get _lightProgressIndicatorTheme {
    return const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: AppColors.border,
      circularTrackColor: AppColors.border,
    );
  }

  // ProgressIndicatorTheme sombre
  static ProgressIndicatorThemeData get _darkProgressIndicatorTheme {
    return const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: AppColorsDark.border,
      circularTrackColor: AppColorsDark.border,
    );
  }


  // PageTransitionsTheme
  static PageTransitionsTheme get _pageTransitionsTheme {
    return const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
      },
    );
  }
}
