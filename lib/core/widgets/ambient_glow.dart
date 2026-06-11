import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AmbientGlow extends StatefulWidget {
  final Color color;
  final double size;

  const AmbientGlow({
    super.key,
    this.color = AppColors.primaryAccent,
    this.size = 600.0,
  });

  @override
  State<AmbientGlow> createState() => _AmbientGlowState();
}

class _AmbientGlowState extends State<AmbientGlow> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _driftAnimationX;
  late Animation<double> _driftAnimationY;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // 8-12 second loop for slow drift
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    _driftAnimationX = Tween<double>(begin: -30.0, end: 30.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOutSine),
      ),
    );

    _driftAnimationY = Tween<double>(begin: -20.0, end: 40.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOutSine),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOutSine),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final double opacity = isDark ? 0.14 : 0.04;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_driftAnimationX.value, _driftAnimationY.value),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
        );
      },
      child: IgnorePointer(
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                widget.color.withValues(alpha: opacity),
                widget.color.withValues(alpha: 0.0),
              ],
              stops: const [0.0, 0.8],
            ),
          ),
        ),
      ),
    );
  }
}
