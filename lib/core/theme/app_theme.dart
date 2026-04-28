import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    final textTheme = GoogleFonts.poppinsTextTheme(
      const TextTheme(
        displayLarge: AppTypography.h1,
        headlineMedium: AppTypography.h2,
        titleLarge: AppTypography.h3,
        bodyLarge: AppTypography.body,
        bodyMedium: AppTypography.caption,
        bodySmall: AppTypography.small,
        labelLarge: AppTypography.button,
        labelMedium: AppTypography.label,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.primaryDark,
        onSecondary: Colors.white,
        surface: AppColors.background,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
        onError: Colors.white,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary, size: 24),
      ),

      textTheme: textTheme,
      primaryTextTheme: GoogleFonts.poppinsTextTheme(base.primaryTextTheme),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.4),
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          elevation: 0,
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          minimumSize: const Size.fromHeight(48),
          side: const BorderSide(color: AppColors.borderLight, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
          minimumSize: const Size(
            AppTouchTarget.minimum,
            AppTouchTarget.minimum,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.base,
        ),
        hintStyle: GoogleFonts.poppins(color: AppColors.textHint, fontSize: 16),
        labelStyle: GoogleFonts.poppins(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        border: _inputBorder(AppColors.border),
        enabledBorder: _inputBorder(AppColors.border),
        focusedBorder: _inputBorder(AppColors.primary),
        errorBorder: _inputBorder(AppColors.error),
        focusedErrorBorder: _inputBorder(AppColors.error),
      ),

      cardTheme: CardThemeData(
        color: AppColors.background,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textHint,
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showUnselectedLabels: true,
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.background,
        surfaceTintColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
        showDragHandle: true,
      ),

      splashFactory: InkRipple.splashFactory,
    );
  }

  static OutlineInputBorder _inputBorder(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadius.md),
    borderSide: BorderSide(color: color, width: 1.5),
  );
}
