import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/ambient_glow.dart';

class AuthGateScreen extends StatelessWidget {
  const AuthGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? AppColors.primaryAccent : AppColors.accentBright;

    return Scaffold(
      backgroundColor: isDark ? AppColors.baseCanvas : AppColors.lightBaseCanvas,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Slow drifting ambient glow
          const Positioned(
            top: 100,
            left: -150,
            child: AmbientGlow(color: AppColors.primaryAccent, size: 600),
          ),
          const Positioned(
            bottom: -100,
            right: -150,
            child: AmbientGlow(color: AppColors.secondary, size: 600),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Header Branding
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryAccent.withValues(alpha: 0.12),
                            border: Border.all(color: primaryAccent.withValues(alpha: 0.2), width: 1.5),
                          ),
                          child: Icon(
                            Icons.auto_awesome,
                            size: 44,
                            color: isDark ? Colors.white : AppColors.primaryAccent,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'NZXTGEN',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                              ),
                        ),
                      ],
                    ),
                  ),

                  // Center Heading & Intro
                  Column(
                    children: [
                      Text(
                        'Welcome Back',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Unlock custom developers, automated systems, and elite design pipelines built for your business outcomes.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                              height: 1.5,
                            ),
                      ),
                    ],
                  ),

                  // Bottom Action Box (Glass Tier 3)
                  GlassCard(
                    tier: GlassTier.tier3,
                    borderRadius: 24,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        PrimaryButton(
                          text: 'Continue with Email',
                          variant: ButtonVariant.primary,
                          onPressed: () {
                            context.push(AppRoutes.login);
                          },
                        ),
                        const SizedBox(height: 14),
                        PrimaryButton(
                          text: 'Continue with Google',
                          variant: ButtonVariant.ghost,
                          icon: Icons.g_mobiledata_rounded,
                          onPressed: () {
                            // Mock Google sign in
                            context.go(AppRoutes.home);
                          },
                        ),
                        const SizedBox(height: 14),
                        PrimaryButton(
                          text: 'Continue with Apple ID',
                          variant: ButtonVariant.ghost,
                          icon: Icons.apple,
                          onPressed: () {
                            // Mock Apple sign in
                            context.go(AppRoutes.home);
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: Divider(color: isDark ? Colors.white12 : Colors.black12)),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(
                                'or',
                                style: TextStyle(color: AppColors.textTertiary, fontSize: 11),
                              ),
                            ),
                            Expanded(child: Divider(color: isDark ? Colors.white12 : Colors.black12)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            context.go(AppRoutes.home);
                          },
                          child: Center(
                            child: Text(
                              'Continue as Guest',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: primaryAccent,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'By continuing, you agree to our Terms and Privacy Policy',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textTertiary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
