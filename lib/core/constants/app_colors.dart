import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Redesigned Dark Mode Palette (Primary Focus)
  static const Color darkBg = Color(0xFF050816);           // Deep Space Black
  static const Color darkBgSecondary = Color(0xFF0B1120);  // Graphite Black
  static const Color darkCardBg = Color(0x1F0B1120);       // Frosted Glass graphite (12% opacity)
  static const Color darkBorder = Color(0x15FFFFFF);       // Frosty border
  static const Color darkBorderFocused = Color(0x3A00E5FF); // Electric Cyan border when focused
  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Soft Gray

  // Light Mode Palette (Kept clean and high-contrast)
  static const Color lightBg = Color(0xFFF8F9FC);
  static const Color lightBgSecondary = Color(0xFFECEFF5);
  static const Color lightCardBg = Color(0x4DFFFFFF);       // Frosted Card Light (30% opacity)
  static const Color lightBorder = Color(0x1A000000);       // Frosty Border Light
  static const Color lightBorderFocused = Color(0x333B82F6);
  static const Color lightTextPrimary = Color(0xFF0C0C14);
  static const Color lightTextSecondary = Color(0xFF5E6070);

  // Redesigned Neon & Luxury Brand Colors
  static const Color accentCyan = Color(0xFF00E5FF);       // Electric Cyan
  static const Color accentBlue = Color(0xFF3B82F6);       // Royal Blue
  static const Color accentPurple = Color(0xFF8B5CF6);     // Purple Glow

  // Semantic Status Colors
  static const Color success = Color(0xFF10B981);          // Emerald
  static const Color warning = Color(0xFFF59E0B);          // Amber
  static const Color error = Color(0xFFEF4444);            // Rose Red

  // Gradients
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [accentCyan, accentBlue, accentPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient hotGradient = LinearGradient(
    colors: [accentBlue, accentPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0x0EFFFFFF), Color(0x03FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient lightCardGradient = LinearGradient(
    colors: [Color(0x3AFFFFFF), Color(0x15FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassBorderDark = LinearGradient(
    colors: [Color(0x26FFFFFF), Color(0x05FFFFFF), Color(0x05FFFFFF), Color(0x1DFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.45, 0.55, 1.0],
  );

  static const LinearGradient glassBorderLight = LinearGradient(
    colors: [Color(0x22000000), Color(0x04000000), Color(0x04000000), Color(0x12000000)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.45, 0.55, 1.0],
  );
}
