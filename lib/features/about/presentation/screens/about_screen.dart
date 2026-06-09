import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? AppColors.accentCyan : AppColors.accentPurple;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background ambient light
          Positioned(
            top: 150,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accentBlue.withValues(alpha: isDark ? 0.05 : 0.02),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentBlue.withValues(alpha: isDark ? 0.05 : 0.02),
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
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0, bottom: 120.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    'ABOUT NZXTGEN',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      color: primaryAccent,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'The Agency',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 28),

                  // 1. Two premium photo frames at the top (Horizontal)
                  Row(
                    children: [
                      Expanded(
                        child: _buildPhotoFrame(
                          context,
                          name: 'Fahad Riaz',
                          role: 'Founder',
                          title: 'Meet The Founder',
                          imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&auto=format&fit=crop&q=80', // placeholder premium headshot
                          isDark: isDark,
                          accentColor: primaryAccent,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildPhotoFrame(
                          context,
                          name: 'Zainab Riaz',
                          role: 'Co-Founder',
                          title: 'Meet The Co-Founder',
                          imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&auto=format&fit=crop&q=80', // placeholder premium headshot
                          isDark: isDark,
                          accentColor: AppColors.accentBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // 2. Company Storytelling Sections (Deep Trust Builders)
                  Text(
                    'Our Foundation',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 16),

                  _AboutAccordion(
                    title: 'Our Mission',
                    content: 'To accelerate operational intelligence for businesses worldwide by engineering custom software pipelines, scalable mobile architectures, and automated agent scripts that eliminate repetitive manual entries.',
                    isDark: isDark,
                    accentColor: primaryAccent,
                  ),
                  const SizedBox(height: 12),

                  _AboutAccordion(
                    title: 'Our Vision',
                    content: 'A future where companies scale compounding ROI on zero software per-user license lock-ins. We envision fully optimized businesses powered by localized LLM interfaces, native high-performance apps, and unified database layers.',
                    isDark: isDark,
                    accentColor: primaryAccent,
                  ),
                  const SizedBox(height: 12),

                  _AboutAccordion(
                    title: 'Why We Started NZXTGEN',
                    content: 'Commercial agency channels are bloated with off-the-shelf CRM configurations and basic template-based web designs. We founded NZXTGEN to build custom solutions that adapt to your pipelines, not the other way around. No shortcuts, clean source files, complete client ownership.',
                    isDark: isDark,
                    accentColor: primaryAccent,
                  ),
                  const SizedBox(height: 12),

                  _AboutAccordion(
                    title: 'Core Values',
                    content: '• Complete Ownership: All source Figma vectors and compiled binaries belong to you.\n• Radical Speed: Sprints are completed in short cycles with weekly direct deliverables.\n• Technical Rigor: We target 99+ on PageSpeed and smooth 60 FPS on mobile devices.',
                    isDark: isDark,
                    accentColor: primaryAccent,
                  ),
                  const SizedBox(height: 12),

                  _AboutAccordion(
                    title: 'What Makes Us Different',
                    content: 'We operate like an extension of your product team. You get a dedicated project manager, direct Slack channel logs, custom metrics audits, and vector assets right from day one.',
                    isDark: isDark,
                    accentColor: primaryAccent,
                  ),
                  const SizedBox(height: 12),

                  _AboutAccordion(
                    title: 'Client Commitment',
                    content: 'We provide strict 24/7 priority SLAs on all enterprise configurations, backed by continuous post-deployment support and weekly code updates.',
                    isDark: isDark,
                    accentColor: primaryAccent,
                  ),
                  const SizedBox(height: 12),

                  _AboutAccordion(
                    title: 'Future Goals',
                    content: 'Scaling neural agent automation pipelines to handle end-to-end customer support actions for 1,000+ client operations in real-time.',
                    isDark: isDark,
                    accentColor: primaryAccent,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoFrame(
    BuildContext context, {
    required String name,
    required String role,
    required String title,
    required String imageUrl,
    required bool isDark,
    required Color accentColor,
  }) {
    return GlassCard(
      padding: EdgeInsets.zero,
      borderRadius: 24,
      showGlow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Frame header
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 8),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Photo area
          AspectRatio(
            aspectRatio: 1.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.person, size: 40, color: accentColor);
                    },
                  ),
                ),
              ),
            ),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  role.toUpperCase(),
                  style: TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutAccordion extends StatefulWidget {
  final String title;
  final String content;
  final bool isDark;
  final Color accentColor;

  const _AboutAccordion({
    required this.title,
    required this.content,
    required this.isDark,
    required this.accentColor,
  });

  @override
  State<_AboutAccordion> createState() => _AboutAccordionState();
}

class _AboutAccordionState extends State<_AboutAccordion> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 18,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      onTap: () {
        setState(() {
          _expanded = !_expanded;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              AnimatedRotation(
                turns: _expanded ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.expand_more_rounded,
                  color: widget.accentColor,
                ),
              ),
            ],
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                widget.content,
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.6,
                  color: widget.isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ),
            crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}
