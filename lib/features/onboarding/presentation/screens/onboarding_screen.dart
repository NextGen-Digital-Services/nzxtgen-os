import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/primary_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingSlideData> _slides = [
    const OnboardingSlideData(
      title: 'Service Store',
      description: 'Subscribe to high-performance developers, marketing engines, and brand systems as if you were downloading applications from the App Store.',
      icon: Icons.storefront_outlined,
      gradient: AppColors.premiumGradient,
    ),
    const OnboardingSlideData(
      title: 'Workspace Pipeline',
      description: 'Track active dev sprints, review ticket backlogs, and coordinate deliverable progress bars inside your Notion/Linear-inspired client portal.',
      icon: Icons.developer_board_outlined,
      gradient: AppColors.hotGradient,
    ),
    const OnboardingSlideData(
      title: 'Developer CLI Keys',
      description: 'Generate secure API key tokens to integrate command-line triggers, LLM assistants, and automatic workflow tools directly into your CLI scripts.',
      icon: Icons.vpn_key_outlined,
      gradient: LinearGradient(
        colors: [AppColors.accentGold, AppColors.accentPink],
      ),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _completeOnboarding() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.completeOnboarding();
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? AppColors.accentCyan : AppColors.accentPurple;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background ambient spot
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            top: _currentPage == 0 ? -50 : (_currentPage == 1 ? -150 : -100),
            left: _currentPage == 0 ? -50 : (_currentPage == 1 ? -100 : -150),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: (_slides[_currentPage].gradient.colors.first).withValues(alpha: isDark ? 0.12 : 0.04),
                    blurRadius: 100,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                children: [
                  // App branding header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.auto_awesome, color: primaryAccent, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'NZXTGEN',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: _completeOnboarding,
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Sliding Cards
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemCount: _slides.length,
                      itemBuilder: (context, index) {
                        final slide = _slides[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40.0),
                          child: Center(
                            child: SingleChildScrollView(
                              child: GlassCard(
                                padding: const EdgeInsets.all(32),
                                borderRadius: 28,
                                showGlow: true,
                                glowColor: slide.gradient.colors.first,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            slide.gradient.colors.first.withValues(alpha: 0.15),
                                            slide.gradient.colors.last.withValues(alpha: 0.05),
                                          ],
                                        ),
                                        border: Border.all(
                                          color: slide.gradient.colors.first.withValues(alpha: 0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Icon(
                                        slide.icon,
                                        size: 64,
                                        color: Colors.white,
                                      ),
                                    )
                                        .animate(key: ValueKey(index))
                                        .scale(duration: 500.ms, curve: Curves.easeOutBack)
                                        .fadeIn(duration: 300.ms),
                                    const SizedBox(height: 28),
                                    Text(
                                      slide.title,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                            fontWeight: FontWeight.w800,
                                          ),
                                    )
                                        .animate(key: ValueKey(index + 10))
                                        .fadeIn(delay: 150.ms, duration: 300.ms)
                                        .slideY(begin: 0.1, end: 0, delay: 150.ms),
                                    const SizedBox(height: 12),
                                    Text(
                                      slide.description,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            fontSize: 14,
                                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                          ),
                                    )
                                        .animate(key: ValueKey(index + 20))
                                        .fadeIn(delay: 300.ms, duration: 300.ms)
                                        .slideY(begin: 0.1, end: 0, delay: 300.ms),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Carousel Indicators & Bottom Action
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _slides.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            width: _currentPage == index ? 20.0 : 8.0,
                            height: 8.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              gradient: _currentPage == index
                                  ? _slides[index].gradient
                                  : null,
                              color: _currentPage == index
                                  ? null
                                  : (isDark ? Colors.white24 : Colors.black12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      PrimaryButton(
                        text: _currentPage == _slides.length - 1 ? 'Launch Workspace' : 'Next Screen',
                        gradient: _slides[_currentPage].gradient,
                        onPressed: () {
                          if (_currentPage == _slides.length - 1) {
                            _completeOnboarding();
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeInOutCubic,
                            );
                          }
                        },
                      ),
                    ],
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

class OnboardingSlideData {
  final String title;
  final String description;
  final IconData icon;
  final Gradient gradient;

  const OnboardingSlideData({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
  });
}
