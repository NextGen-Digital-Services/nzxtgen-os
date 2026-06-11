import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum GlassTier {
  tier1, // Ultra Light (nav bars, persistent UI)
  tier2, // Standard (cards, panels)
  tier3, // Rich (hero cards, featured service cards)
  tier4, // Modal/Sheet (bottom sheets, full-screen overlays)
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final GlassTier tier;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool showGlow;
  final double? width;
  final double? height;
  final double borderWidth;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 18.0,
    this.tier = GlassTier.tier2,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.onTap,
    this.showGlow = false,
    this.width,
    this.height,
    this.borderWidth = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 1. Background colors & blur based on tier
    Color bgColor;
    double blurValue;
    List<BoxShadow> shadows = [];
    Gradient borderGradient;

    switch (tier) {
      case GlassTier.tier1:
        bgColor = isDark ? const Color(0x0AFFFFFF) : const Color(0x0A000000); // 4%
        blurValue = 20.0;
        borderGradient = LinearGradient(
          colors: isDark
              ? [const Color(0x1AFFFFFF), const Color(0x0AFFFFFF)]
              : [const Color(0x1C000000), const Color(0x06000000)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        break;
      case GlassTier.tier2:
        bgColor = isDark ? const Color(0x0FFFFFFF) : const Color(0x0F000000); // 6%
        blurValue = 16.0;
        borderGradient = LinearGradient(
          colors: isDark
              ? [const Color(0x14FFFFFF), const Color(0x14FFFFFF)] // 8% solid approx
              : [const Color(0x14000000), const Color(0x14000000)],
        );
        shadows = [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ];
        break;
      case GlassTier.tier3:
        bgColor = isDark ? const Color(0x14FFFFFF) : const Color(0x14000000); // 8%
        blurValue = 24.0;
        borderGradient = const LinearGradient(
          colors: [
            Color(0x26FFFFFF), // 15% top-left highlight border
            Color(0x1FFFFFFF), // 12% bottom-right border
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        shadows = [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.15),
            offset: const Offset(0, 8),
            blurRadius: 32,
          ),
          if (showGlow)
            BoxShadow(
              color: AppColors.primaryAccent.withValues(alpha: 0.35),
              blurRadius: 24,
            ),
        ];
        break;
      case GlassTier.tier4:
        bgColor = isDark ? const Color(0xD90A0A0F) : const Color(0xD9FAFAFA); // 85% opacity
        blurValue = 40.0;
        borderGradient = const LinearGradient(
          colors: [
            Color(0x1AFFFFFF),
            Color(0x1AFFFFFF),
          ],
        );
        shadows = [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.6 : 0.2),
            offset: const Offset(0, 16),
            blurRadius: 64,
          ),
        ];
        break;
    }

    Widget cardBody = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: shadows,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
          child: CustomPaint(
            painter: _GlassCardBorderPainter(
              borderRadius: borderRadius,
              borderWidth: borderWidth,
              gradient: borderGradient,
            ),
            child: Container(
              padding: padding,
              color: bgColor,
              child: child,
            ),
          ),
        ),
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: AppColors.primaryAccent.withValues(alpha: 0.15),
          highlightColor: Colors.transparent,
          child: cardBody,
        ),
      );
    }

    return cardBody;
  }
}

class _GlassCardBorderPainter extends CustomPainter {
  final double borderRadius;
  final double borderWidth;
  final Gradient gradient;

  _GlassCardBorderPainter({
    required this.borderRadius,
    required this.borderWidth,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke
      ..shader = gradient.createShader(rect);

    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(borderRadius),
    );

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(_GlassCardBorderPainter oldDelegate) {
    return oldDelegate.borderRadius != borderRadius ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.gradient != gradient;
  }
}
