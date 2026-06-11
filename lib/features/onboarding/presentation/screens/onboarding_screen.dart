import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/ambient_glow.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

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

  void _navigateToAuthGate() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.completeOnboarding();
    context.go(AppRoutes.authGate);
  }

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
            top: 200,
            left: -150,
            child: AmbientGlow(color: AppColors.primaryAccent, size: 600),
          ),
          const Positioned(
            bottom: 50,
            right: -150,
            child: AmbientGlow(color: AppColors.secondary, size: 600),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                children: [
                  // Header branding + Skip link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.auto_awesome, color: primaryAccent, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'NZXTGEN',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      if (_currentPage < 2)
                        TextButton(
                          onPressed: _navigateToAuthGate,
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        )
                      else
                        const SizedBox(height: 38), // placeholder to balance size
                    ],
                  ),

                  // Horizontal Page Slides
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      children: [
                        _buildSlide1(isDark, primaryAccent),
                        _buildSlide2(isDark, primaryAccent),
                        _buildSlide3(isDark, primaryAccent),
                      ],
                    ),
                  ),

                  // Bottom action buttons and indicators
                  Column(
                    children: [
                      // Dots Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            width: _currentPage == index ? 20.0 : 8.0,
                            height: 8.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              color: _currentPage == index
                                  ? primaryAccent
                                  : (isDark ? Colors.white24 : Colors.black12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // CTA Actions
                      if (_currentPage == 2) ...[
                        PrimaryButton(
                          text: 'Get Started',
                          variant: ButtonVariant.primary,
                          onPressed: _navigateToAuthGate,
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            context.push(AppRoutes.login);
                          },
                          child: RichText(
                            text: TextSpan(
                              text: 'Already have a workspace? ',
                              style: TextStyle(fontSize: 12.5, color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary),
                              children: [
                                TextSpan(
                                  text: 'Sign in',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: primaryAccent),
                                )
                              ],
                            ),
                          ),
                        ),
                      ] else ...[
                        PrimaryButton(
                          text: 'Continue',
                          variant: ButtonVariant.primary,
                          onPressed: () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeOutCubic,
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        const SizedBox(height: 18), // balancing spacing
                      ]
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

  Widget _buildSlide1(bool isDark, Color accentColor) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Floating 3D geometric structure
          _buildFloatingShape(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: AppColors.heroGradient,
                  ),
                ),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: isDark ? AppColors.baseCanvas : AppColors.lightBaseCanvas,
                    boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 16)],
                  ),
                  child: const Icon(Icons.web_outlined, size: 48, color: AppColors.secondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          ShaderMask(
            shaderCallback: (bounds) => AppColors.heroGradient.createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            ),
            child: Text(
              'Build Your Vision',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -1.0,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Partner with senior developer pipelines to build gorgeous, high-performance websites and bespoke mobile apps.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Websites • Mobile Apps • CRM Systems',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textTertiary, letterSpacing: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide2(bool isDark, Color accentColor) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Neural Network connections float
          _buildFloatingShape(
            child: CustomPaint(
              size: const Size(180, 140),
              painter: _NeuralNetworkPainter(accentColor),
            ),
          ),
          const SizedBox(height: 50),
          ShaderMask(
            shaderCallback: (bounds) => AppColors.heroGradient.createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            ),
            child: Text(
              'Automate Your Growth',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -1.0,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Scale operations by deploying AI agents and high-ROAS marketing campaigns across Meta and Google.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'AI Automation • Paid Ads • SEO',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textTertiary, letterSpacing: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide3(bool isDark, Color accentColor) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Brand composition float
          _buildFloatingShape(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.rotate(
                  angle: -0.15,
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: AppColors.premiumGradient,
                    ),
                    child: const Icon(Icons.brush, size: 40, color: Colors.white),
                  ),
                ),
                Transform.rotate(
                  angle: 0.1,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: isDark ? AppColors.surfaceLevel3 : AppColors.lightSurfaceLevel2,
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 12)],
                    ),
                    child: Center(
                      child: Text(
                        'Aa',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AppColors.tertiary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          ShaderMask(
            shaderCallback: (bounds) => AppColors.premiumGradient.createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            ),
            child: Text(
              'Stand Out with Brand',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -1.0,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Establish world-class brand guidelines, pitch deck designs, and memorable typography systems.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Branding • Graphic Design • Identity',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textTertiary, letterSpacing: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingShape({required Widget child}) {
    return child
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .slideY(begin: -0.05, end: 0.05, duration: 2.seconds, curve: Curves.easeInOutSine)
        .then()
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .rotate(begin: -0.02, end: 0.02, duration: 3.seconds, curve: Curves.easeInOutSine);
  }
}

class _NeuralNetworkPainter extends CustomPainter {
  final Color accentColor;

  _NeuralNetworkPainter(this.accentColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = accentColor.withValues(alpha: 0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final paintDot = Paint()
      ..color = AppColors.secondary
      ..style = PaintingStyle.fill;

    final points = [
      Offset(size.width * 0.2, size.height * 0.5),
      Offset(size.width * 0.5, size.height * 0.2),
      Offset(size.width * 0.5, size.height * 0.8),
      Offset(size.width * 0.8, size.height * 0.5),
    ];

    // Connect them
    canvas.drawLine(points[0], points[1], paintLine);
    canvas.drawLine(points[0], points[2], paintLine);
    canvas.drawLine(points[1], points[3], paintLine);
    canvas.drawLine(points[2], points[3], paintLine);
    canvas.drawLine(points[1], points[2], paintLine);

    // Draw dots
    for (var pt in points) {
      canvas.drawCircle(pt, 6.0, paintDot);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
