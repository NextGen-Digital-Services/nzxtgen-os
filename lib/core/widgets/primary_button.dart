import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum ButtonVariant {
  primary,
  secondary,
  ghost,
  destructive,
}

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool isIconTrailing;
  final ButtonVariant variant;
  final double borderRadius;
  final double? width;
  final double height;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.isIconTrailing = false,
    this.variant = ButtonVariant.primary,
    this.borderRadius = 10.0, // Default SM (10px) for primary/secondary
    this.width,
    this.height = 54.0,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    // Spring physics simulation: fast shrink, spring back
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.decelerate),
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
      setState(() {
        _isPressed = true;
      });
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.reverse();
      setState(() {
        _isPressed = false;
      });
    }
  }

  void _onTapCancel() {
    _controller.reverse();
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDisabled = widget.onPressed == null;

    // Determine colors based on variant and state
    Color? buttonColor;
    Gradient? buttonGradient;
    Border? border;
    Color textColor = AppColors.textPrimary;
    List<BoxShadow> shadows = [];

    if (isDisabled) {
      buttonColor = isDark ? const Color(0xFF2A2A3A) : Colors.black12;
      textColor = isDark ? AppColors.textSecondary.withValues(alpha: 0.4) : Colors.black26;
    } else {
      switch (widget.variant) {
        case ButtonVariant.primary:
          buttonGradient = AppColors.heroGradient;
          textColor = AppColors.textInverse; // inverse text on bright surfaces
          shadows = [
            BoxShadow(
              color: AppColors.primaryAccent.withValues(alpha: 0.35),
              blurRadius: 24,
              offset: const Offset(0, 4),
            ),
          ];
          break;
        case ButtonVariant.secondary:
          buttonColor = widget.variant == ButtonVariant.secondary && _isPressed
              ? AppColors.primaryAccent.withValues(alpha: 0.20)
              : AppColors.primaryAccent.withValues(alpha: 0.12);
          border = Border.all(color: AppColors.primaryAccent.withValues(alpha: 0.30));
          textColor = AppColors.primaryAccent;
          break;
        case ButtonVariant.ghost:
          buttonColor = _isPressed ? (isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06)) : Colors.transparent;
          border = Border.all(color: isDark ? const Color(0x1EFFFFFF) : const Color(0x1E000000));
          textColor = AppColors.textSecondary;
          break;
        case ButtonVariant.destructive:
          buttonColor = AppColors.error.withValues(alpha: 0.12);
          border = Border.all(color: AppColors.error.withValues(alpha: 0.30));
          textColor = AppColors.error;
          break;
      }
    }

    final TextStyle textStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
      color: textColor,
    );

    Widget content = widget.isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(textColor),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null && !widget.isIconTrailing) ...[
                Icon(widget.icon, size: 16, color: textColor),
                const SizedBox(width: 8),
              ],
              Text(widget.text, style: textStyle),
              if (widget.icon != null && widget.isIconTrailing) ...[
                const SizedBox(width: 8),
                Icon(widget.icon, size: 16, color: textColor),
              ],
            ],
          );

    return AnimatedBuilder(
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
        onTap: (isDisabled || widget.isLoading) ? null : widget.onPressed,
        child: Container(
          width: widget.width ?? double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            color: buttonColor,
            gradient: buttonGradient,
            border: border,
            boxShadow: shadows,
          ),
          child: Center(
            child: content,
          ),
        ),
      ),
    );
  }
}
