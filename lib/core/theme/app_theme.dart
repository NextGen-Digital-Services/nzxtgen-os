import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.baseCanvas,
      primaryColor: AppColors.primaryAccent,
      cardColor: AppColors.surfaceLevel1,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryAccent,
        secondary: AppColors.secondary,
        tertiary: AppColors.tertiary,
        surface: AppColors.surfaceLevel1,
        error: AppColors.error,
      ),
      textTheme: TextTheme(
        // Display XL - Space Grotesk
        displayLarge: GoogleFonts.spaceGrotesk(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          letterSpacing: -1.5,
          height: 1.1,
          color: AppColors.textPrimary,
        ),
        // Display L - Space Grotesk
        displayMedium: GoogleFonts.spaceGrotesk(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          letterSpacing: -1.2,
          height: 1.1,
          color: AppColors.textPrimary,
        ),
        // Display M - Space Grotesk
        displaySmall: GoogleFonts.spaceGrotesk(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: -1.0,
          height: 1.15,
          color: AppColors.textPrimary,
        ),
        // Heading 1 - Space Grotesk
        headlineLarge: GoogleFonts.spaceGrotesk(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.8,
          height: 1.2,
          color: AppColors.textPrimary,
        ),
        // Heading 2 - Space Grotesk
        headlineMedium: GoogleFonts.spaceGrotesk(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.6,
          height: 1.25,
          color: AppColors.textPrimary,
        ),
        // Heading 3 - Inter
        headlineSmall: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.4,
          height: 1.3,
          color: AppColors.textPrimary,
        ),
        // Heading 4 - Inter
        titleLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
          height: 1.35,
          color: AppColors.textPrimary,
        ),
        // Body Large - Inter
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          letterSpacing: -0.1,
          height: 1.6,
          color: AppColors.textPrimary,
        ),
        // Body Regular - Inter
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          letterSpacing: 0,
          height: 1.6,
          color: AppColors.textSecondary,
        ),
        // Body Small - Inter
        bodySmall: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.normal,
          letterSpacing: 0.1,
          height: 1.55,
          color: AppColors.textSecondary,
        ),
        // Caption - Inter
        labelSmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
          height: 1.5,
          color: AppColors.textTertiary,
        ),
        // Label - Inter
        labelLarge: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          height: 1.4,
          color: AppColors.textPrimary,
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLevel2,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        hintStyle: const TextStyle(color: AppColors.textTertiary, fontSize: 14),
        labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0x14FFFFFF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0x14FFFFFF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primaryAccent, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 2.0),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBaseCanvas,
      primaryColor: AppColors.primaryAccent,
      cardColor: AppColors.lightSurfaceLevel1,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryAccent,
        secondary: AppColors.secondary,
        tertiary: AppColors.tertiary,
        surface: AppColors.lightSurfaceLevel1,
        error: AppColors.error,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.spaceGrotesk(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          letterSpacing: -1.5,
          height: 1.1,
          color: AppColors.lightTextPrimary,
        ),
        displayMedium: GoogleFonts.spaceGrotesk(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          letterSpacing: -1.2,
          height: 1.1,
          color: AppColors.lightTextPrimary,
        ),
        displaySmall: GoogleFonts.spaceGrotesk(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: -1.0,
          height: 1.15,
          color: AppColors.lightTextPrimary,
        ),
        headlineLarge: GoogleFonts.spaceGrotesk(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.8,
          height: 1.2,
          color: AppColors.lightTextPrimary,
        ),
        headlineMedium: GoogleFonts.spaceGrotesk(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.6,
          height: 1.25,
          color: AppColors.lightTextPrimary,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.4,
          height: 1.3,
          color: AppColors.lightTextPrimary,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
          height: 1.35,
          color: AppColors.lightTextPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          letterSpacing: -0.1,
          height: 1.6,
          color: AppColors.lightTextPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          letterSpacing: 0,
          height: 1.6,
          color: AppColors.lightTextSecondary,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.normal,
          letterSpacing: 0.1,
          height: 1.55,
          color: AppColors.lightTextSecondary,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
          height: 1.5,
          color: AppColors.lightTextSecondary.withValues(alpha: 0.7),
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          height: 1.4,
          color: AppColors.lightTextPrimary,
        ),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.lightTextPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurfaceLevel2,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        hintStyle: TextStyle(color: AppColors.lightTextSecondary.withValues(alpha: 0.5), fontSize: 14),
        labelStyle: const TextStyle(color: AppColors.lightTextSecondary, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0x1A000000)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0x1A000000)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primaryAccent, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 2.0),
        ),
      ),
    );
  }
}
