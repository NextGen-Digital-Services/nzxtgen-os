import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Background Hierarchy (Dark Mode Primary)
  static const Color baseCanvas = Color(0xFF0A0A0F);      // Near-black with micro blue cast
  static const Color surfaceLevel1 = Color(0xFF0F0F17);   // Cards, panels
  static const Color surfaceLevel2 = Color(0xFF141420);   // Elevated cards, modals
  static const Color surfaceLevel3 = Color(0xFF1A1A2E);   // Tooltips, popovers
  static const Color surfaceLevel4 = Color(0xFF1F1F38);   // Highest elevation

  // Accent Color - Electric Indigo System
  static const Color primaryAccent = Color(0xFF6C63FF);   // Electric Indigo
  static const Color accentBright = Color(0xFF7B73FF);    // Hover, active states
  static const Color accentGlow = Color(0x666C63FF);      // 40% opacity glow
  static const Color accentMuted = Color(0x266C63FF);     // 15% opacity subtle bg
  static const Color accentUltralight = Color(0x146C63FF); // 8% opacity chip bg

  // Secondary Accent - Cyber Teal
  static const Color secondary = Color(0xFF00D4AA);       // Cyber Teal (Success, secondary CTA)
  static const Color secondaryMuted = Color(0x3300D4AA);  // 20% opacity subtle bg

  // Tertiary Accent - Plasma Pink
  static const Color tertiary = Color(0xFFFF4F9A);        // Plasma Pink (alerts, premium badges)
  static const Color tertiaryMuted = Color(0x26FF4F9A);   // 15% opacity subtle bg

  // Text Colors (Dark Mode)
  static const Color textPrimary = Color(0xFFF0F0FF);     // Near-white with micro indigo cast
  static const Color textSecondary = Color(0xFFA0A0C0);   // Muted
  static const Color textTertiary = Color(0xFF606080);    // Disabled, placeholders
  static const Color textAccent = Color(0xFF6C63FF);
  static const Color textInverse = Color(0xFF0A0A0F);     // On light surfaces

  // Semantic Colors
  static const Color success = Color(0xFF00D4AA);
  static const Color warning = Color(0xFFFFB547);
  static const Color error = Color(0xFFFF4757);
  static const Color info = Color(0xFF6C63FF);

  // Light Mode Tokens
  static const Color lightBaseCanvas = Color(0xFFFAFAFA);
  static const Color lightSurfaceLevel1 = Color(0xFFFFFFFF);
  static const Color lightSurfaceLevel2 = Color(0xFFF4F4F8);
  static const Color lightTextPrimary = Color(0xFF0A0A0F);
  static const Color lightTextSecondary = Color(0xFF4A4A6A);

  // Gradient System
  static const LinearGradient heroGradient = LinearGradient(
    colors: [primaryAccent, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient premiumGradient = LinearGradient(
    colors: [primaryAccent, tertiary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [surfaceLevel1, baseCanvas],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [
      Color(0x0FFFFFFF), // rgba(255,255,255,0.06)
      Color(0x05FFFFFF), // rgba(255,255,255,0.02)
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassBorderDark = LinearGradient(
    colors: [
      Color(0x1AFFFFFF), // rgba(255,255,255,0.10)
      Color(0x0AFFFFFF), // rgba(255,255,255,0.04)
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassBorderLight = LinearGradient(
    colors: [
      Color(0x1C000000),
      Color(0x06000000),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
