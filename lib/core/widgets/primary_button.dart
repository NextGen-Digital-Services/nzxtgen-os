import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final Gradient? gradient;
  final Color? textColor;
  final double borderRadius;
  final double? width;
  final double height;
  final bool outline;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.gradient,
    this.textColor,
    this.borderRadius = 16.0,
    this.width,
    this.height = 56.0,
    this.outline = false,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.reverse();
    }
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultGradient = widget.gradient ??
        (isDark ? AppColors.premiumGradient : AppColors.hotGradient);

    final textStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
          color: widget.textColor ?? Colors.white,
          fontWeight: FontWeight.bold,
        );

    Widget buttonBody = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: widget.isLoading ? null : widget.onPressed,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: widget.outline ? null : (widget.onPressed == null ? null : defaultGradient),
            color: widget.onPressed == null
                ? (isDark ? Colors.white10 : Colors.black12)
                : (widget.outline ? Colors.transparent : null),
            border: widget.outline
                ? Border.all(
                    color: isDark ? AppColors.accentCyan : AppColors.accentPurple,
                    width: 2.0,
                  )
                : null,
            boxShadow: (widget.onPressed == null || widget.outline)
                ? null
                : [
                    BoxShadow(
                      color: (widget.gradient?.colors.first ?? AppColors.accentCyan).withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          color: widget.outline
                              ? (isDark ? AppColors.accentCyan : AppColors.accentPurple)
                              : (widget.textColor ?? Colors.white),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        widget.text,
                        style: widget.outline
                            ? textStyle?.copyWith(
                                color: isDark ? AppColors.accentCyan : AppColors.accentPurple,
                              )
                            : textStyle,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );

    return buttonBody;
  }
}
