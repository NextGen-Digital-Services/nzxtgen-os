import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Gradient? borderGradient;
  final Gradient? backgroundGradient;
  final double borderWidth;
  final VoidCallback? onTap;
  final bool showGlow;
  final Color? glowColor;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 24.0,
    this.blur = 15.0,
    this.padding = const EdgeInsets.all(20.0),
    this.margin,
    this.borderGradient,
    this.backgroundGradient,
    this.borderWidth = 1.0,
    this.onTap,
    this.showGlow = false,
    this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultBackgroundGradient = isDark
        ? AppColors.darkCardGradient
        : AppColors.lightCardGradient;

    final defaultBorderGradient = isDark
        ? AppColors.glassBorderDark
        : AppColors.glassBorderLight;

    Widget cardContent = Container(
      margin: margin,
      decoration: BoxDecoration(
        boxShadow: showGlow
            ? [
                BoxShadow(
                  color: (glowColor ?? AppColors.accentCyan).withValues(alpha: isDark ? 0.15 : 0.08),
                  blurRadius: 30,
                  spreadRadius: -5,
                )
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: CustomPaint(
            painter: _GlassBorderPainter(
              borderRadius: borderRadius,
              borderWidth: borderWidth,
              gradient: borderGradient ?? defaultBorderGradient,
            ),
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                gradient: backgroundGradient ?? defaultBackgroundGradient,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: (isDark ? AppColors.accentCyan : AppColors.accentPurple).withValues(alpha: 0.1),
        highlightColor: Colors.transparent,
        child: cardContent,
      );
    }

    return cardContent;
  }
}

class _GlassBorderPainter extends CustomPainter {
  final double borderRadius;
  final double borderWidth;
  final Gradient gradient;

  _GlassBorderPainter({
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
  bool shouldRepaint(_GlassBorderPainter oldDelegate) {
    return oldDelegate.borderRadius != borderRadius ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.gradient != gradient;
  }
}
