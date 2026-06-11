import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_text_field.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'General';
  final List<String> _categories = ['General', 'Billing', 'Projects', 'Technical'];

  final List<Map<String, String>> _faqs = [
    {
      'cat': 'General',
      'q': 'What is NZXTGEN?',
      'a': 'NZXTGEN is an elite digital transformation agency. We engineer custom mobile applications, automate back-end data pipelines, and design high-converting SaaS branding vectors.'
    },
    {
      'cat': 'Billing',
      'q': 'How do payment milestones work?',
      'a': 'We structure billing across 4 stages (Retainer, Dev Kickoff, Beta Release, and Final Delivery). Invoices can be paid securely directly inside this mobile app.'
    },
    {
      'cat': 'Projects',
      'q': 'Do I own the complete source code files?',
      'a': 'Yes. Under our agency agreements, all vector Figma source design layouts and compiled binary repository codes are completely owned by you.'
    },
    {
      'cat': 'Technical',
      'q': 'What technology stacks do you use?',
      'a': 'We focus on high-performance frameworks like Flutter, Next.js, Supabase, TailwindCSS, and cloud architectures optimized for speed.'
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? AppColors.primaryAccent : AppColors.accentBright;

    final filteredFaqs = _faqs.where((faq) => faq['cat'] == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.baseCanvas : AppColors.lightBaseCanvas,
      appBar: AppBar(
        title: const Text('Support Desk', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 120.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SUPPORT HERO
              GlassCard(
                tier: GlassTier.tier2,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.headset_mic_outlined, color: AppColors.secondary, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'How can we help?',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          const Row(
                            children: [
                              Icon(Icons.circle, color: AppColors.secondary, size: 8),
                              SizedBox(width: 6),
                              Text(
                                'Team is online • SLA under 2h',
                                style: TextStyle(fontSize: 10.5, color: AppColors.textTertiary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // SUPPORT OPTIONS (2x2 grid)
              Text(
                'SUPPORT DECK OPTIONS',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1),
              ),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.25,
                children: [
                  _buildOptionCard(
                    context,
                    title: 'Live Chat',
                    desc: 'Chat with team',
                    icon: Icons.chat_bubble_outline,
                    badge: 'ONLINE NOW',
                    onTap: () => context.push(AppRoutes.chat),
                  ),
                  _buildOptionCard(
                    context,
                    title: 'Raise Ticket',
                    desc: 'File support inquiry',
                    icon: Icons.confirmation_number_outlined,
                    onTap: () {},
                  ),
                  _buildOptionCard(
                    context,
                    title: 'WhatsApp Feed',
                    desc: 'Direct mobile chat',
                    icon: Icons.chat,
                    onTap: () {},
                  ),
                  _buildOptionCard(
                    context,
                    title: 'Call Helpline',
                    desc: 'Schedule phone sync',
                    icon: Icons.phone_iphone_outlined,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // FAQ SECTION
              Text(
                'COMMON QUESTIONS',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1),
              ),
              const SizedBox(height: 12),
              GlassTextField(
                controller: _searchController,
                label: 'Search knowledge base',
                hint: 'Type search keywords...',
                prefixIcon: Icons.search,
              ),
              const SizedBox(height: 16),
              // Category chips
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = _selectedCategory == cat;

                    return ChoiceChip(
                      label: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : AppColors.textTertiary,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (val) {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      },
                      selectedColor: primaryAccent,
                      backgroundColor: isDark ? AppColors.surfaceLevel2 : AppColors.lightSurfaceLevel2,
                      side: BorderSide(color: isDark ? Colors.white10 : Colors.black12),
                      showCheckmark: false,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              ...List.generate(
                filteredFaqs.length,
                (index) {
                  final faq = filteredFaqs[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: _SupportFaqTile(q: faq['q']!, a: faq['a']!, accentColor: primaryAccent),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required String title,
    required String desc,
    required IconData icon,
    String? badge,
    required VoidCallback onTap,
  }) {
    return GlassCard(
      tier: GlassTier.tier2,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: AppColors.primaryAccent, size: 24),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: AppColors.secondary.withValues(alpha: 0.15),
                  ),
                  child: const Text('LIVE', style: TextStyle(fontSize: 8, color: AppColors.secondary, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
              const SizedBox(height: 2),
              Text(desc, style: const TextStyle(fontSize: 10.5, color: AppColors.textTertiary)),
            ],
          )
        ],
      ),
    );
  }
}

class _SupportFaqTile extends StatefulWidget {
  final String q;
  final String a;
  final Color accentColor;

  const _SupportFaqTile({
    required this.q,
    required this.a,
    required this.accentColor,
  });

  @override
  State<_SupportFaqTile> createState() => _SupportFaqTileState();
}

class _SupportFaqTileState extends State<_SupportFaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassCard(
      tier: GlassTier.tier2,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              Expanded(
                child: Text(
                  widget.q,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              AnimatedRotation(
                turns: _expanded ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Icon(Icons.keyboard_arrow_down, color: widget.accentColor),
              )
            ],
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                widget.a,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                  height: 1.5,
                ),
              ),
            ),
            crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          )
        ],
      ),
    );
  }
}
