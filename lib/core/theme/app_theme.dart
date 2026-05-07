import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

class SplitzTheme {
  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: SplitzColors.darkBg,
      colorScheme: const ColorScheme.dark(
        primary: SplitzColors.accentPrimary,
        secondary: SplitzColors.accentSecondary,
        surface: SplitzColors.darkSurface,
        error: SplitzColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: SplitzColors.darkText,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: SplitzColors.darkBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: SplitzTypography.headlineMedium.copyWith(
          color: SplitzColors.darkText,
        ),
        iconTheme: const IconThemeData(color: SplitzColors.darkText),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      cardTheme: CardThemeData(
        color: SplitzColors.darkCardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: SplitzSpacing.borderRadiusLg,
          side: const BorderSide(color: SplitzColors.darkBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SplitzColors.darkSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: SplitzSpacing.borderRadiusMd,
          borderSide: const BorderSide(color: SplitzColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: SplitzSpacing.borderRadiusMd,
          borderSide: const BorderSide(color: SplitzColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: SplitzSpacing.borderRadiusMd,
          borderSide: const BorderSide(color: SplitzColors.accentPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: SplitzSpacing.borderRadiusMd,
          borderSide: const BorderSide(color: SplitzColors.error),
        ),
        hintStyle: SplitzTypography.bodyMedium.copyWith(
          color: SplitzColors.darkTextTertiary,
        ),
        labelStyle: SplitzTypography.bodyMedium.copyWith(
          color: SplitzColors.darkTextSecondary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SplitzColors.accentPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: SplitzSpacing.borderRadiusMd,
          ),
          textStyle: SplitzTypography.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: SplitzColors.accentPrimary,
          textStyle: SplitzTypography.labelLarge,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: SplitzColors.darkBgSecondary,
        selectedItemColor: SplitzColors.accentPrimary,
        unselectedItemColor: SplitzColors.darkTextTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: SplitzColors.darkSurface,
        contentTextStyle: SplitzTypography.bodyMedium.copyWith(
          color: SplitzColors.darkText,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: SplitzSpacing.borderRadiusMd,
        ),
        behavior: SnackBarBehavior.floating,
      ),
      dividerTheme: const DividerThemeData(
        color: SplitzColors.darkBorder,
        thickness: 1,
        space: 0,
      ),
      textTheme: TextTheme(
        displayLarge: SplitzTypography.displayLarge.copyWith(color: SplitzColors.darkText),
        displayMedium: SplitzTypography.displayMedium.copyWith(color: SplitzColors.darkText),
        displaySmall: SplitzTypography.displaySmall.copyWith(color: SplitzColors.darkText),
        headlineLarge: SplitzTypography.headlineLarge.copyWith(color: SplitzColors.darkText),
        headlineMedium: SplitzTypography.headlineMedium.copyWith(color: SplitzColors.darkText),
        headlineSmall: SplitzTypography.headlineSmall.copyWith(color: SplitzColors.darkText),
        titleLarge: SplitzTypography.titleLarge.copyWith(color: SplitzColors.darkText),
        titleMedium: SplitzTypography.titleMedium.copyWith(color: SplitzColors.darkText),
        titleSmall: SplitzTypography.titleSmall.copyWith(color: SplitzColors.darkTextSecondary),
        bodyLarge: SplitzTypography.bodyLarge.copyWith(color: SplitzColors.darkText),
        bodyMedium: SplitzTypography.bodyMedium.copyWith(color: SplitzColors.darkTextSecondary),
        bodySmall: SplitzTypography.bodySmall.copyWith(color: SplitzColors.darkTextTertiary),
        labelLarge: SplitzTypography.labelLarge.copyWith(color: SplitzColors.darkText),
        labelMedium: SplitzTypography.labelMedium.copyWith(color: SplitzColors.darkTextSecondary),
        labelSmall: SplitzTypography.labelSmall.copyWith(color: SplitzColors.darkTextTertiary),
      ),
    );
  }

  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      scaffoldBackgroundColor: SplitzColors.lightBg,
      colorScheme: const ColorScheme.light(
        primary: SplitzColors.accentPrimary,
        secondary: SplitzColors.accentSecondary,
        surface: SplitzColors.lightSurface,
        error: SplitzColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: SplitzColors.lightText,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: SplitzColors.lightBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: SplitzTypography.headlineMedium.copyWith(
          color: SplitzColors.lightText,
        ),
        iconTheme: const IconThemeData(color: SplitzColors.lightText),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        color: SplitzColors.lightCardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: SplitzSpacing.borderRadiusLg,
          side: const BorderSide(color: SplitzColors.lightBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SplitzColors.lightSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: SplitzSpacing.borderRadiusMd,
          borderSide: const BorderSide(color: SplitzColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: SplitzSpacing.borderRadiusMd,
          borderSide: const BorderSide(color: SplitzColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: SplitzSpacing.borderRadiusMd,
          borderSide: const BorderSide(color: SplitzColors.accentPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: SplitzSpacing.borderRadiusMd,
          borderSide: const BorderSide(color: SplitzColors.error),
        ),
        hintStyle: SplitzTypography.bodyMedium.copyWith(
          color: SplitzColors.lightTextTertiary,
        ),
        labelStyle: SplitzTypography.bodyMedium.copyWith(
          color: SplitzColors.lightTextSecondary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SplitzColors.accentPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: SplitzSpacing.borderRadiusMd,
          ),
          textStyle: SplitzTypography.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: SplitzColors.accentPrimary,
          textStyle: SplitzTypography.labelLarge,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: SplitzColors.lightSurface,
        selectedItemColor: SplitzColors.accentPrimary,
        unselectedItemColor: SplitzColors.lightTextTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: SplitzColors.lightSurface,
        contentTextStyle: SplitzTypography.bodyMedium.copyWith(
          color: SplitzColors.lightText,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: SplitzSpacing.borderRadiusMd,
        ),
        behavior: SnackBarBehavior.floating,
      ),
      dividerTheme: const DividerThemeData(
        color: SplitzColors.lightBorder,
        thickness: 1,
        space: 0,
      ),
      textTheme: TextTheme(
        displayLarge: SplitzTypography.displayLarge.copyWith(color: SplitzColors.lightText),
        displayMedium: SplitzTypography.displayMedium.copyWith(color: SplitzColors.lightText),
        displaySmall: SplitzTypography.displaySmall.copyWith(color: SplitzColors.lightText),
        headlineLarge: SplitzTypography.headlineLarge.copyWith(color: SplitzColors.lightText),
        headlineMedium: SplitzTypography.headlineMedium.copyWith(color: SplitzColors.lightText),
        headlineSmall: SplitzTypography.headlineSmall.copyWith(color: SplitzColors.lightText),
        titleLarge: SplitzTypography.titleLarge.copyWith(color: SplitzColors.lightText),
        titleMedium: SplitzTypography.titleMedium.copyWith(color: SplitzColors.lightText),
        titleSmall: SplitzTypography.titleSmall.copyWith(color: SplitzColors.lightTextSecondary),
        bodyLarge: SplitzTypography.bodyLarge.copyWith(color: SplitzColors.lightText),
        bodyMedium: SplitzTypography.bodyMedium.copyWith(color: SplitzColors.lightTextSecondary),
        bodySmall: SplitzTypography.bodySmall.copyWith(color: SplitzColors.lightTextTertiary),
        labelLarge: SplitzTypography.labelLarge.copyWith(color: SplitzColors.lightText),
        labelMedium: SplitzTypography.labelMedium.copyWith(color: SplitzColors.lightTextSecondary),
        labelSmall: SplitzTypography.labelSmall.copyWith(color: SplitzColors.lightTextTertiary),
      ),
    );
  }
}
