import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';

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
    // Let splash animations display fully
    await Future.delayed(const Duration(milliseconds: 2800));
    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (authProvider.hasCompletedOnboarding) {
      context.go(AppRoutes.home);
    } else {
      context.go(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background ambient neon glows
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentCyan.withValues(alpha: isDark ? 0.15 : 0.05),
                    blurRadius: 100,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentPurple.withValues(alpha: isDark ? 0.15 : 0.05),
                    blurRadius: 100,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Glowing circular logo container
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.accentCyan.withValues(alpha: 0.2),
                        AppColors.accentPurple.withValues(alpha: 0.2),
                      ],
                    ),
                    border: Border.all(
                      color: AppColors.accentCyan.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentCyan.withValues(alpha: 0.1),
                        blurRadius: 40,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_awesome_outlined,
                    size: 64,
                    color: Colors.white,
                  ),
                )
                    .animate()
                    .scale(duration: 800.ms, curve: Curves.elasticOut)
                    .then()
                    .shake(duration: 400.ms, hz: 4)
                    .then()
                    .boxShadow(
                      begin: const BoxShadow(color: Colors.transparent),
                      end: const BoxShadow(
                        color: AppColors.accentCyan,
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                      duration: 800.ms,
                    ),
                const SizedBox(height: 24),
                // Glowing text
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'NZXT',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            letterSpacing: 2,
                            fontWeight: FontWeight.w900,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                    ),
                    Text(
                      'GEN',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            letterSpacing: 2,
                            fontWeight: FontWeight.w900,
                            color: AppColors.accentCyan,
                            shadows: [
                              Shadow(
                                color: AppColors.accentCyan.withValues(alpha: 0.8),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 600.ms)
                    .slideY(begin: 0.2, end: 0.0, curve: Curves.easeOutCubic),
                const SizedBox(height: 8),
                Text(
                  'NEXT-GENERATION DIGITAL SERVICES',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        letterSpacing: 4,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                )
                    .animate()
                    .fadeIn(delay: 800.ms, duration: 600.ms)
                    .blurXY(begin: 10, end: 0, delay: 800.ms, duration: 600.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
