import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../services/data/services_data.dart';
import 'main_navigation_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = Provider.of<AuthProvider>(context);
    final primaryAccent = isDark ? AppColors.accentCyan : AppColors.accentPurple;

    final name = authProvider.isAuthenticated ? (authProvider.username ?? 'Alex') : 'Guest';

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Glow Spots (Apple/Linear luxury style)
          Positioned(
            top: -80,
            left: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accentCyan.withValues(alpha: isDark ? 0.08 : 0.03),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentCyan.withValues(alpha: isDark ? 0.08 : 0.03),
                    blurRadius: 90,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 250,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accentPurple.withValues(alpha: isDark ? 0.06 : 0.02),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentPurple.withValues(alpha: isDark ? 0.06 : 0.02),
                    blurRadius: 100,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 16.0, bottom: 120.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Personalized Welcome Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NZXTGEN DIGITAL',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.5,
                              color: primaryAccent,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Hello, $name',
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 26,
                                ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          // Route to Profile tab (Index 4)
                          final navState = context.findAncestorStateOfType<MainNavigationScreenState>();
                          navState?.setIndex(4);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: primaryAccent.withValues(alpha: 0.3), width: 1.5),
                          ),
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: primaryAccent.withValues(alpha: 0.1),
                            child: Icon(Icons.person_outline, color: primaryAccent, size: 18),
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 28),

                  // 2. Featured Services
                  _buildSectionHeader(context, 'Featured Solutions', 'See all', () {
                    final navState = context.findAncestorStateOfType<MainNavigationScreenState>();
                    navState?.setIndex(1); // Services Tab
                  }),
                  const SizedBox(height: 14),
                  _buildFeaturedServices(context, isDark, primaryAccent),
                  const SizedBox(height: 32),

                  // 3. Client Results / Stats Grid
                  Text(
                    'Client Performance',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 14),
                  _buildResultsStats(context, isDark, primaryAccent),
                  const SizedBox(height: 32),

                  // 4. Why Choose NZXTGEN
                  Text(
                    'Why Partner With Us',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 14),
                  _buildWhyChoose(context, isDark, primaryAccent),
                  const SizedBox(height: 32),

                  // 5. Portfolio Highlights
                  Text(
                    'Recent Highlights',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 14),
                  _buildPortfolioHighlights(isDark),
                  const SizedBox(height: 32),

                  // 6. Testimonials Bubble
                  Text(
                    'Client Testimonials',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 14),
                  _buildTestimonials(context, isDark, primaryAccent),
                  const SizedBox(height: 32),

                  // 7. Process Overview Timeline
                  Text(
                    'Our Sprint Cycle',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 14),
                  _buildProcessOverview(context, isDark, primaryAccent),
                  const SizedBox(height: 36),

                  // 8. Main Bottom CTA
                  _buildBottomCTA(context, isDark, primaryAccent),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String actionText,
    VoidCallback onAction,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        GestureDetector(
          onTap: onAction,
          child: Text(
            actionText,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.accentBlue,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedServices(BuildContext context, bool isDark, Color accentColor) {
    // Select 3 key services to feature
    final featured = ServicesData.services.where((s) => 
      s.id == 'website-development' || s.id == 'app-development' || s.id == 'ai-automation'
    ).toList();

    return SizedBox(
      height: 170,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: featured.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final s = featured[index];
          return GestureDetector(
            onTap: () {
              // Direct route push internally or context navigate
              final navState = context.findAncestorStateOfType<MainNavigationScreenState>();
              navState?.setIndex(1); // switch to services first then navigate
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Scaffold(body: s.id == 'website-development' || s.id == 'app-development' || s.id == 'ai-automation' ? ServicesData.services.firstWhere((element) => element.id == s.id) as Widget : Container())),
              );
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: GlassCard(
                  padding: const EdgeInsets.all(20),
                  borderRadius: 24,
                  showGlow: index == 0,
                  glowColor: accentColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(s.icon, color: accentColor, size: 20),
                          ),
                          Icon(Icons.arrow_forward_ios, size: 12, color: accentColor.withValues(alpha: 0.6)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            s.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
    );
  }

  Widget _buildResultsStats(BuildContext context, bool isDark, Color accentColor) {
    final stats = [
      {'val': '99+', 'label': 'PageSpeed Score'},
      {'val': '+140%', 'label': 'Conversion Avg.'},
      {'val': '24h', 'label': 'Sprint SLA'},
    ];

    return GlassCard(
      borderRadius: 24,
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: stats.map((st) {
          return Column(
            children: [
              Text(
                st['val']!,
                style: GoogleFonts.outfit(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: accentColor,
                  shadows: [
                    Shadow(color: accentColor.withValues(alpha: 0.3), blurRadius: 10),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                st['label']!,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 450.ms);
  }

  Widget _buildWhyChoose(BuildContext context, bool isDark, Color accentColor) {
    final pillars = [
      {'icon': Icons.flash_on_outlined, 'title': 'High Performance', 'desc': 'Figma to pixel-perfect ARM compilations.'},
      {'icon': Icons.chat_bubble_outline_outlined, 'title': 'Slack Integrated', 'desc': 'Direct support feeds on our private channels.'},
      {'icon': Icons.security_outlined, 'title': 'Zero Lock-In', 'desc': 'All code builds are fully owned by you.'},
    ];

    return Column(
      children: pillars.map((p) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: GlassCard(
            borderRadius: 18,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(p['icon'] as IconData, color: accentColor, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p['title'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        p['desc'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    ).animate().fadeIn(delay: 250.ms, duration: 400.ms);
  }

  Widget _buildPortfolioHighlights(bool isDark) {
    final images = [
      'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=400&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=400&auto=format&fit=crop&q=80',
    ];

    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: images.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return Container(
            width: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                images[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTestimonials(BuildContext context, bool isDark, Color accentColor) {
    return GlassCard(
      borderRadius: 24,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: accentColor.withValues(alpha: 0.15),
                child: Text('S', style: TextStyle(fontWeight: FontWeight.bold, color: accentColor)),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sarah Jenkins', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                    Text('COO, Veloce E-Commerce', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ),
              const Icon(Icons.star, color: Colors.amber, size: 14),
              const SizedBox(width: 4),
              const Text('5.0', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '"NZXTGEN completely restructured our workflow API. They automated our customer leads categorizations and built an offline sync engine saving our operation teams over 30 hours every single week."',
            style: TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              height: 1.5,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessOverview(BuildContext context, bool isDark, Color accentColor) {
    final steps = [
      {'step': '01', 'title': 'Design Draft', 'desc': 'Blank canvas wireframing & Figma layouts.'},
      {'step': '02', 'title': 'Direct Sprints', 'desc': 'Weekly deliverables pushes & beta gates.'},
      {'step': '03', 'title': 'Launch & QA', 'desc': 'Audited indexations & 99+ speed optimizations.'},
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: steps.map((s) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s['step']!,
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: accentColor.withValues(alpha: 0.4),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  s['title']!,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  s['desc']!,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomCTA(BuildContext context, bool isDark, Color accentColor) {
    return GlassCard(
      borderRadius: 24,
      padding: const EdgeInsets.all(24),
      showGlow: true,
      glowColor: AppColors.accentBlue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Ready to Redefine Your Growth Pipeline?',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Partner with senior developers, automated agents, and branding professionals.',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            text: 'Explore Capabilities',
            onPressed: () {
              // Switch to services screen (Tab 1)
              final navState = context.findAncestorStateOfType<MainNavigationScreenState>();
              navState?.setIndex(1);
            },
          ),
        ],
      ),
    );
  }
}
