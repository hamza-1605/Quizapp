import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app/core/theme/app_colors.dart';

abstract class AppTheme {
  static ThemeData get dark {
    final scheme = ColorScheme.dark(
      primary: AppColors.gold,
      onPrimary: AppColors.navyDeep,
      secondary: AppColors.gold,
      onSecondary: AppColors.navyDeep,
      surface: AppColors.navy,
      onSurface: Colors.white,
      onSurfaceVariant: AppColors.textMuted,
      surfaceContainerHigh: AppColors.panel,
      surfaceContainerHighest: AppColors.panel,
      primaryContainer: AppColors.panel,
      onPrimaryContainer: AppColors.gold,
      secondaryContainer: AppColors.panel,
      onSecondaryContainer: AppColors.gold,
      outline: AppColors.outline,
      outlineVariant: AppColors.outline.withValues(alpha: 0.4),
      error: AppColors.wrongLight,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      // Every page draws its own background (see AppScaffold).
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.navyDeep,
          disabledBackgroundColor: Colors.white12,
          disabledForegroundColor: Colors.white38,
          minimumSize: const Size(64, 52),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.gold,
          side: const BorderSide(color: AppColors.gold),
          minimumSize: const Size(64, 52),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.gold),
      ),
      
      chipTheme: ChipThemeData(
        selectedColor: AppColors.gold,
        backgroundColor: AppColors.panel,
        checkmarkColor: AppColors.navyDeep,
        side: const BorderSide(color: AppColors.outline),
        labelStyle: const TextStyle(color: Colors.white),
        secondaryLabelStyle: const TextStyle(color: AppColors.navyDeep),
      ),
    );
  }
}