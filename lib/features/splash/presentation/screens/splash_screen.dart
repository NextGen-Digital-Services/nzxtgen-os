import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/ambient_glow.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // 1800ms animation display loop
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Redirect based on onboarding state
    if (authProvider.hasCompletedOnboarding) {
      context.go(AppRoutes.home);
    } else {
      context.go(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const String logoText = 'NZXTGEN';

    return Scaffold(
      backgroundColor: isDark ? AppColors.baseCanvas : AppColors.lightBaseCanvas,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Slow drifting ambient glow blobs (materializing during sequence)
          const Positioned(
            top: -100,
            left: -100,
            child: AmbientGlow(color: AppColors.primaryAccent, size: 500),
          ),
          const Positioned(
            bottom: -100,
            right: -100,
            child: AmbientGlow(color: AppColors.secondary, size: 500),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. Logo mark scaling from 0.8 to 1.0 with spring physics
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryAccent.withValues(alpha: 0.12),
                    border: Border.all(
                      color: AppColors.primaryAccent.withValues(alpha: 0.25),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    size: 52,
                    color: isDark ? Colors.white : AppColors.primaryAccent,
                  ),
                )
                    .animate()
                    .scale(
                      duration: 600.ms,
                      curve: Curves.easeOutBack, // spring animation curve
                    )
                    .fadeIn(duration: 400.ms),
                const SizedBox(height: 24),

                // 2. Wordmark with staggered character-by-character reveal (each char fades + translateY)
                ShaderMask(
                  shaderCallback: (bounds) => AppColors.heroGradient.createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(logoText.length, (index) {
                      return Text(
                        logoText[index],
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: Colors.white, // Essential color override for ShaderMask
                          letterSpacing: -1.0,
                        ),
                      )
                          .animate()
                          .fadeIn(
                            delay: (200 + 40 * index).ms, // 40ms stagger offset
                            duration: 400.ms,
                          )
                          .slideY(
                            begin: 0.3,
                            end: 0,
                            delay: (200 + 40 * index).ms,
                            curve: Curves.easeOutCubic,
                          );
                    }),
                  ),
                ),
                const SizedBox(height: 12),

                // 3. Tagline in Overline style fading in below
                Text(
                  'TRANSFORM YOUR DIGITAL PRESENCE',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.5,
                    color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                  ),
                )
                    .animate()
                    .fadeIn(
                      delay: 700.ms,
                      duration: 600.ms,
                    )
                    .slideY(
                      begin: 0.2,
                      end: 0,
                      delay: 700.ms,
                      curve: Curves.easeOutCubic,
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
