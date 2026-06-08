import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Dark Mode Palette (Primary Focus)
  static const Color darkBg = Color(0xFF05050C);
  static const Color darkBgSecondary = Color(0xFF0F0F1E);
  static const Color darkCardBg = Color(0x1F1A1A2F); // Frosted Card Dark
  static const Color darkBorder = Color(0x1AFFFFFF); // Frosty Border Dark
  static const Color darkBorderFocused = Color(0x40FFFFFF);
  static const Color darkTextPrimary = Color(0xFFF8F9FA);
  static const Color darkTextSecondary = Color(0xFFA5A5B5);

  // Light Mode Palette
  static const Color lightBg = Color(0xFFF8F9FC);
  static const Color lightBgSecondary = Color(0xFFECEFF5);
  static const Color lightCardBg = Color(0x4DFFFFFF); // Frosted Card Light (30% opacity)
  static const Color lightBorder = Color(0x1A000000); // Frosty Border Light
  static const Color lightBorderFocused = Color(0x33000000);
  static const Color lightTextPrimary = Color(0xFF0C0C14);
  static const Color lightTextSecondary = Color(0xFF5E6070);

  // Neon & Luxury Brand Colors
  static const Color accentCyan = Color(0xFF00E5FF);
  static const Color accentPurple = Color(0xFF9E00FF);
  static const Color accentPink = Color(0xFFFF007F);
  static const Color accentGold = Color(0xFFFFB300);

  // Gradients
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [accentCyan, accentPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient hotGradient = LinearGradient(
    colors: [accentPink, accentPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0x0AFFFFFF), Color(0x02FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient lightCardGradient = LinearGradient(
    colors: [Color(0x33FFFFFF), Color(0x11FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassBorderDark = LinearGradient(
    colors: [Color(0x26FFFFFF), Color(0x05FFFFFF), Color(0x05FFFFFF), Color(0x1AFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.45, 0.55, 1.0],
  );

  static const LinearGradient glassBorderLight = LinearGradient(
    colors: [Color(0x33000000), Color(0x08000000), Color(0x08000000), Color(0x1F000000)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.45, 0.55, 1.0],
  );
}
