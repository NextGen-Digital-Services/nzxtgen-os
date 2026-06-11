import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/ambient_glow.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? AppColors.primaryAccent : AppColors.accentBright;

    return Scaffold(
      backgroundColor: isDark ? AppColors.baseCanvas : AppColors.lightBaseCanvas,
      appBar: AppBar(
        title: const Text('About NZXTGEN', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Slow drifting ambient glow
          const Positioned(
            top: 200,
            left: -150,
            child: AmbientGlow(color: AppColors.primaryAccent, size: 500),
          ),

          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 60.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. HERO SECTION (Full-bleed height 240px)
                Container(
                  height: 240,
                  decoration: const BoxDecoration(
                    gradient: AppColors.premiumGradient, // #6C63FF -> #FF4F9A
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(color: Colors.black26), // overlay
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'NZXTGEN',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Transforming businesses through digital excellence',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. MISSION STATEMENT
                      GlassCard(
                        tier: GlassTier.tier2,
                        child: Column(
                          children: [
                            const Icon(Icons.format_quote, size: 36, color: AppColors.tertiary),
                            const SizedBox(height: 8),
                            Text(
                              'To accelerate operational intelligence for businesses worldwide by engineering custom software pipelines, scalable mobile architectures, and automated agent scripts that eliminate repetitive manual entries.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: isDark ? Colors.white : Colors.black,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 3. STATS ROW
                      Row(
                        children: [
                          _buildStatColumn(context, '200+', 'Active Clients', primaryAccent),
                          _buildStatColumn(context, '50+', 'Projects Delivered', primaryAccent),
                          _buildStatColumn(context, '5+', 'Years Experience', primaryAccent),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // 4. TEAM SECTION
                      Text(
                        'The Team Behind NZXTGEN',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 180,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            _buildTeamCard(
                              context,
                              name: 'Fahad Riaz',
                              role: 'Founder & Head Engineer',
                              bio: 'Specializes in high-performance Flutter architectures and secure database sync hooks.',
                              color: Colors.purple,
                            ),
                            const SizedBox(width: 12),
                            _buildTeamCard(
                              context,
                              name: 'Zainab Riaz',
                              role: 'Co-Founder & UI/UX Lead',
                              bio: 'Crafts luxury visual systems and responsive grid wireframes on Figma.',
                              color: Colors.teal,
                            ),
                            const SizedBox(width: 12),
                            _buildTeamCard(
                              context,
                              name: 'Marcus Aurelius',
                              role: 'Solutions Architect',
                              bio: 'Coordinates workflows pipeline, Zapier agents, and API gateway routes.',
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // 5. VALUES SECTION
                      Text(
                        'Core Agency Values',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 14),
                      _buildValueCard(
                        context,
                        title: 'Technical Rigor',
                        desc: 'We target 99+ on Google PageSpeed and smooth 60 FPS scrolling speeds on all mobile viewports.',
                        icon: Icons.speed,
                      ),
                      const SizedBox(height: 12),
                      _buildValueCard(
                        context,
                        title: 'Complete Ownership',
                        desc: 'All source Figma vectors, raw compiled assets, and repository code databases belong fully to you.',
                        icon: Icons.code,
                      ),
                      const SizedBox(height: 12),
                      _buildValueCard(
                        context,
                        title: 'Radical Transparency',
                        desc: 'Weekly direct deliverables logs, shared Trello boards, and immediate Slack channel communications.',
                        icon: Icons.chat_bubble_outline,
                      ),
                      const SizedBox(height: 32),

                      // 6. CTA SECTION
                      GlassCard(
                        tier: GlassTier.tier3,
                        showGlow: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Ready to transform your business?',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Schedule a consult sprint with our solutions engineer to design your database flows.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
                            ),
                            const SizedBox(height: 20),
                            PrimaryButton(
                              text: 'Explore Capabilities',
                              onPressed: () {
                                context.pop(); // Go back to profile
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(BuildContext context, String value, String label, Color accentColor) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamCard(
    BuildContext context, {
    required String name,
    required String role,
    required String bio,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassCard(
      tier: GlassTier.tier2,
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: color.withValues(alpha: 0.15),
                child: Text(
                  name.substring(0, 1),
                  style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    Text(role, style: const TextStyle(fontSize: 8.5, color: AppColors.textTertiary)),
                  ],
                ),
              ),
            ],
          ),
          Text(
            bio,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValueCard(
    BuildContext context, {
    required String title,
    required String desc,
    required IconData icon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassCard(
      tier: GlassTier.tier2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.tertiary, size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
