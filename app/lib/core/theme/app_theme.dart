import 'package:flutter/material.dart';

import '../../data/models/app_language.dart';
import 'app_background.dart';
import 'app_colors.dart';

abstract final class AppTheme {
  static const double minTapTarget = 64;

  static const double bodyTextSize = 18;

  static const double minTextSize = 16;

  static const double gutter = 20;

  static const double radius = 14;

  static ThemeData get light => forLanguage(AppLanguage.fallback);

  static ThemeData forLanguage(AppLanguage language) {
    final family = language.fontFamily;
    final fallback = [
      for (final other in AppLanguage.fontFamilies)
        if (other != family) other,
    ];

    TextStyle font(TextStyle style) =>
        style.copyWith(fontFamily: family, fontFamilyFallback: fallback);

    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.terracotta,
      primary: AppColors.terracotta,
      onPrimary: Colors.white,
      secondary: AppColors.marigold,
      surface: AppColors.cream,
      onSurface: AppColors.ink,
      error: AppColors.danger,
      outline: AppColors.border,
      outlineVariant: AppColors.border,
    );

    const shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,

      fontFamily: family,
      fontFamilyFallback: fallback,
      scaffoldBackgroundColor: Colors.transparent,
      canvasColor: AppColors.cream,
      dividerColor: AppColors.border,
      splashFactory: InkRipple.splashFactory,
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          for (final platform in TargetPlatform.values)
            platform: const PatternedPageTransitionsBuilder(),
        },
      ),
      dividerTheme: const DividerThemeData(color: AppColors.border),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.cream,
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.cream,
        surfaceTintColor: Colors.transparent,
      ),

      textTheme: const TextTheme(
        displaySmall: TextStyle(
          fontSize: 34,
          height: 1.2,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          height: 1.25,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          height: 1.3,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
        titleLarge: TextStyle(
          fontSize: 21,
          height: 1.3,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
        bodyLarge: TextStyle(fontSize: 20, height: 1.45, color: AppColors.ink),
        bodyMedium: TextStyle(fontSize: 18, height: 1.45, color: AppColors.ink),
        labelLarge: TextStyle(
          fontSize: 20,
          height: 1.2,
          fontWeight: FontWeight.w600,
        ),
      ).apply(fontFamily: family, fontFamilyFallback: fallback),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: font(
          const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
        ),
      ),

      cardTheme: const CardThemeData(
        color: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: shape,
      ),

      filledButtonTheme: FilledButtonThemeData(
        style:
            FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(minTapTarget),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: shape,
              textStyle: font(
                const TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
              ),
            ).copyWith(
              backgroundColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.disabled)
                    ? null
                    : states.contains(WidgetState.pressed) ||
                          states.contains(WidgetState.hovered)
                    ? AppColors.primaryPressed
                    : AppColors.terracotta,
              ),
              foregroundColor: WidgetStateProperty.resolveWith(
                (states) =>
                    states.contains(WidgetState.disabled) ? null : Colors.white,
              ),
              overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(minTapTarget),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          foregroundColor: AppColors.ink,
          side: const BorderSide(color: AppColors.border, width: 2),
          shape: shape,
          textStyle: font(
            const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(minTapTarget, minTapTarget),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          foregroundColor: AppColors.terracotta,
          textStyle: font(
            const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size.square(minTapTarget),
          foregroundColor: AppColors.terracotta,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 20,
        ),
        hintMaxLines: 4,
        helperMaxLines: 4,
        errorMaxLines: 4,
        hintStyle: font(const TextStyle(color: AppColors.muted, fontSize: 18)),
        labelStyle: font(const TextStyle(color: AppColors.muted, fontSize: 18)),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          borderSide: BorderSide(color: AppColors.border, width: 2),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          borderSide: BorderSide(color: AppColors.border, width: 2),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          borderSide: BorderSide(color: AppColors.terracotta, width: 3),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          borderSide: BorderSide(color: AppColors.danger, width: 2),
        ),
        errorStyle: font(
          const TextStyle(color: AppColors.danger, fontSize: 17),
        ),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.terracotta,
        linearTrackColor: AppColors.border,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.ink,
        contentTextStyle: font(
          const TextStyle(color: Colors.white, fontSize: 18),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
