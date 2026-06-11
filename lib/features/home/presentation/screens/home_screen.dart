import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../core/widgets/ambient_glow.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../services/data/services_data.dart';
import '../../../services/presentation/screens/quote_order_flow.dart';
import 'main_navigation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _carouselController = PageController();
  int _carouselIndex = 0;
  Timer? _carouselTimer;

  @override
  void initState() {
    super.initState();
    _startCarouselTimer();
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _carouselController.dispose();
    super.dispose();
  }

  void _startCarouselTimer() {
    _carouselTimer?.cancel();
    _carouselTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted && _carouselController.hasClients) {
        setState(() {
          _carouselIndex = (_carouselIndex + 1) % 3;
        });
        _carouselController.animateToPage(
          _carouselIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _triggerSearchOverlay() {
    showSearch(
      context: context,
      delegate: _CustomSearchDelegate(),
    );
  }

  void _openQuoteSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const QuoteOrderFlow(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = Provider.of<AuthProvider>(context);
    final primaryAccent = isDark ? AppColors.primaryAccent : AppColors.accentBright;
    final name = authProvider.isAuthenticated ? (authProvider.username ?? 'Alex') : 'Guest';

    return Scaffold(
      backgroundColor: isDark ? AppColors.baseCanvas : AppColors.lightBaseCanvas,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background ambient highlights
          const Positioned(
            top: -100,
            left: -100,
            child: AmbientGlow(color: AppColors.primaryAccent, size: 600),
          ),
          const Positioned(
            bottom: 150,
            right: -150,
            child: AmbientGlow(color: AppColors.secondary, size: 600),
          ),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. HEADER ZONE (integrated scroll content)
              SliverToBoxAdapter(
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good Morning,',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                color: primaryAccent,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              name,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            // Notification bell with badge
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.notifications_none_rounded, size: 24),
                                  onPressed: () => context.push(AppRoutes.notifications),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.tertiary, // Plasma Pink badge
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 8),
                            // Avatar
                            GestureDetector(
                              onTap: () {
                                final navState = context.findAncestorStateOfType<MainNavigationScreenState>();
                                navState?.setIndex(4); // Switch to Profile tab
                              },
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: primaryAccent.withValues(alpha: 0.15),
                                child: Text(
                                  name.substring(0, 1).toUpperCase(),
                                  style: TextStyle(fontWeight: FontWeight.bold, color: primaryAccent, fontSize: 13),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 2. STICKY SEARCH BAR
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickySearchBarDelegate(
                  onTap: _triggerSearchOverlay,
                  isDark: isDark,
                  primaryAccent: primaryAccent,
                ),
              ),

              // 3. PAGE BODY SECTIONS
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // HERO CAROUSEL BANNER
                      _buildHeroCarousel(isDark, primaryAccent),
                      const SizedBox(height: 28),

                      // ACTIVE SERVICES / QUICK STATS
                      _buildSectionLabel('YOUR OVERVIEW'),
                      const SizedBox(height: 12),
                      _buildQuickStats(context, isDark, primaryAccent),
                      const SizedBox(height: 28),

                      // FEATURED SERVICES
                      _buildSectionHeader('EXPLORE SERVICES', 'See All', () {
                        final navState = context.findAncestorStateOfType<MainNavigationScreenState>();
                        navState?.setIndex(1); // Services tab
                      }),
                      const SizedBox(height: 12),
                      _buildFeaturedServices(context, isDark, primaryAccent),
                      const SizedBox(height: 28),

                      // ACTIVE PROJECTS PREVIEW
                      _buildSectionHeader('ACTIVE PROJECTS', 'View All', () {
                        final navState = context.findAncestorStateOfType<MainNavigationScreenState>();
                        navState?.setIndex(2); // Dashboard Tab
                      }),
                      const SizedBox(height: 12),
                      _buildProjectsPreview(context, isDark, primaryAccent),
                      const SizedBox(height: 28),

                      // RECENT MESSAGES
                      _buildSectionHeader('RECENT MESSAGES', 'Go to Support', () {
                        final navState = context.findAncestorStateOfType<MainNavigationScreenState>();
                        navState?.setIndex(3); // Support Tab
                      }),
                      const SizedBox(height: 12),
                      _buildRecentMessagesPreview(context, isDark, primaryAccent),
                      const SizedBox(height: 28),

                      // CLIENT SUCCESS CAROUSEL
                      _buildSectionLabel('CLIENT SUCCESS'),
                      const SizedBox(height: 12),
                      _buildSuccessReviews(isDark, primaryAccent),
                      const SizedBox(height: 28),

                      // QUICK ACTIONS GRID
                      _buildSectionLabel('QUICK ACTIONS'),
                      const SizedBox(height: 12),
                      _buildQuickActionsGrid(context, primaryAccent),

                      // Space for Bottom Nav clearance
                      const SizedBox(height: 110),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
        color: AppColors.textTertiary,
      ),
    );
  }

  Widget _buildSectionHeader(String label, String actionText, VoidCallback onAction) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSectionLabel(label),
        GestureDetector(
          onTap: onAction,
          child: Text(
            actionText,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryAccent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCarousel(bool isDark, Color accentColor) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView(
            controller: _carouselController,
            onPageChanged: (index) {
              setState(() {
                _carouselIndex = index;
              });
            },
            children: [
              // Active Project Card (Glass Tier 3)
              GlassCard(
                tier: GlassTier.tier3,
                showGlow: true,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('ACTIVE DEVELOPMENT', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textTertiary)),
                          Text(
                            'Your project is on track',
                            style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          // Mini linear progress
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: const LinearProgressIndicator(
                              value: 0.6,
                              minHeight: 4,
                              backgroundColor: Colors.white10,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
                            ),
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () {
                              context.push('/project/mobile');
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.white10,
                              ),
                              child: const Text('View Details', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.rocket_launch, size: 52, color: AppColors.secondary),
                  ],
                ),
              ),

              // Promotional Card (Gradient)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: AppColors.heroGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryAccent.withValues(alpha: 0.35),
                      blurRadius: 24,
                    )
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('SPECIAL OFFER', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textInverse)),
                          Text(
                            '20% off AI Automation\nthis month',
                            style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textInverse),
                          ),
                          GestureDetector(
                            onTap: () {
                              final navState = context.findAncestorStateOfType<MainNavigationScreenState>();
                              navState?.setIndex(1);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: AppColors.textInverse,
                              ),
                              child: const Text('Get Quote', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.auto_awesome, size: 52, color: AppColors.textInverse),
                  ],
                ),
              ),

              // Trust Card
              GlassCard(
                tier: GlassTier.tier3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ...List.generate(5, (index) => const Icon(Icons.star, color: Colors.amber, size: 14)),
                        const SizedBox(width: 8),
                        Text(
                          '4.9/5 by 200+ clients',
                          style: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      '"NZXTGEN completely restructured our workflow API. They automated our customer leads saving over 30 hours weekly."',
                      style: GoogleFonts.inter(fontSize: 12, fontStyle: FontStyle.italic, color: AppColors.textSecondary, height: 1.4),
                    ),
                    const Text('Sarah Jenkins  •  COO, Veloce E-Commerce', style: TextStyle(fontSize: 9, color: AppColors.textTertiary)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (idx) => Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _carouselIndex == idx ? accentColor : (isDark ? Colors.white24 : Colors.black12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context, bool isDark, Color accentColor) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Row(
      children: [
        _buildStatCard(
          context,
          icon: Icons.developer_board,
          label: 'Active Projects',
          value: auth.isAuthenticated ? '1' : '0',
          onTap: () {
            final navState = context.findAncestorStateOfType<MainNavigationScreenState>();
            navState?.setIndex(2); // Dashboard Tab
          },
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          context,
          icon: Icons.receipt_long,
          label: 'Unpaid Invoices',
          value: auth.isAuthenticated ? '1' : '0',
          isWarning: auth.isAuthenticated,
          onTap: () {
            if (auth.isAuthenticated) {
              context.push(AppRoutes.payments);
            } else {
              final navState = context.findAncestorStateOfType<MainNavigationScreenState>();
              navState?.setIndex(2); // Restrict to portal
            }
          },
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          context,
          icon: Icons.chat_bubble_outline_rounded,
          label: 'Unread Chats',
          value: auth.isAuthenticated ? '2' : '0',
          onTap: () {
            final navState = context.findAncestorStateOfType<MainNavigationScreenState>();
            navState?.setIndex(3); // Support Tab
          },
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool isWarning = false,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GlassCard(
        tier: GlassTier.tier2,
        padding: const EdgeInsets.all(14),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 20,
              color: isWarning ? AppColors.warning : AppColors.primaryAccent,
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isWarning ? AppColors.warning : Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: AppColors.textTertiary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedServices(BuildContext context, bool isDark, Color accentColor) {
    // Show 3 key services
    final keys = ['website-development', 'app-development', 'ai-automation'];
    final featured = ServicesData.services.where((s) => keys.contains(s.id)).toList();

    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: featured.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final s = featured[index];

          return Container(
            width: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
            ),
            child: GlassCard(
              tier: GlassTier.tier2,
              padding: const EdgeInsets.all(16),
              onTap: () {
                context.push('/services/${s.id}');
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(s.icon, color: accentColor, size: 18),
                      ),
                      const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.textTertiary),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            s.pricing.isNotEmpty ? s.pricing.first.price : 'Custom',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: accentColor),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.circle, size: 3, color: AppColors.textTertiary),
                          const SizedBox(width: 8),
                          Text(
                            s.timeline.isNotEmpty ? s.timeline.first.duration : 'Flexible',
                            style: const TextStyle(fontSize: 10, color: AppColors.textTertiary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProjectsPreview(BuildContext context, bool isDark, Color accentColor) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (!auth.isAuthenticated) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
        ),
        child: const Center(
          child: Text('No active projects. Log in to track deliverables.', style: TextStyle(fontSize: 12, color: AppColors.textTertiary)),
        ),
      );
    }

    return GlassCard(
      tier: GlassTier.tier2,
      child: Column(
        children: [
          _buildProjectPreviewRow(
            context,
            name: 'Mobile App Sprint MVP',
            category: 'FLUTTER',
            progress: 0.60,
            deadline: 'Jul 15, 2026',
            status: 'Active',
            onTap: () => context.push('/project/mobile'),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectPreviewRow(
    BuildContext context, {
    required String name,
    required String category,
    required double progress,
    required String deadline,
    required String status,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      category,
                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.secondary),
                    ),
                    const SizedBox(width: 8),
                    const StatusBadge(label: 'Active', type: StatusType.active),
                  ],
                ),
                const SizedBox(height: 6),
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 3,
                    backgroundColor: Colors.white10,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryAccent),
                  ),
                ),
                const SizedBox(height: 4),
                Text('Due: $deadline', style: const TextStyle(fontSize: 10, color: AppColors.textTertiary)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textTertiary),
        ],
      ),
    );
  }

  Widget _buildRecentMessagesPreview(BuildContext context, bool isDark, Color accentColor) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (!auth.isAuthenticated) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
        ),
        child: const Center(
          child: Text('No recent messages. Sign in to chat.', style: TextStyle(fontSize: 12, color: AppColors.textTertiary)),
        ),
      );
    }

    return GlassCard(
      tier: GlassTier.tier2,
      child: Column(
        children: [
          _buildMessagePreviewRow(
            context,
            sender: 'Marcus Aurelius',
            role: 'Support Agent',
            text: 'Your active API key tokens will remain valid.',
            time: '02:11 PM',
            unread: true,
            onTap: () => context.push(AppRoutes.chat),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagePreviewRow(
    BuildContext context, {
    required String sender,
    required String role,
    required String text,
    required String time,
    required bool unread,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primaryAccent.withValues(alpha: 0.15),
            child: Text(sender.substring(0, 1), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryAccent)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(sender, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                    Text(time, style: const TextStyle(fontSize: 9.5, color: AppColors.textTertiary)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11.5, color: AppColors.textTertiary),
                ),
              ],
            ),
          ),
          if (unread) ...[
            const SizedBox(width: 12),
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.tertiary),
            )
          ]
        ],
      ),
    );
  }

  Widget _buildSuccessReviews(bool isDark, Color accentColor) {
    final reviews = [
      {'stars': 5, 'text': 'NZXTGEN automated our operations in Make, saving our team 30 hours weekly.', 'name': 'Sarah Jenkins, Veloce'},
      {'stars': 5, 'text': 'Their Flutter code is incredibly clean and fast. Outstanding execution!', 'name': 'Daniel Craig, HoloSaaS'},
    ];

    return SizedBox(
      height: 110,
      child: PageView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final r = reviews[index];
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: GlassCard(
              tier: GlassTier.tier2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(r['stars'] as int, (index) => const Icon(Icons.star, color: Colors.amber, size: 12)),
                  ),
                  Text(
                    '"${r['text']}"',
                    style: const TextStyle(fontSize: 11.5, fontStyle: FontStyle.italic, color: AppColors.textSecondary, height: 1.4),
                  ),
                  Text(
                    r['name'] as String,
                    style: const TextStyle(fontSize: 9.5, color: AppColors.textTertiary),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context, Color accentColor) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.2,
      children: [
        _buildQuickActionItem(
          title: 'Get a Quote',
          icon: Icons.description_outlined,
          onTap: _openQuoteSheet,
        ),
        _buildQuickActionItem(
          title: 'Upload Files',
          icon: Icons.cloud_upload_outlined,
          onTap: () {
            final navState = context.findAncestorStateOfType<MainNavigationScreenState>();
            navState?.setIndex(2); // Dashboard Tab -> Files tab
          },
        ),
        _buildQuickActionItem(
          title: 'Contact Support',
          icon: Icons.chat_bubble_outline_rounded,
          onTap: () => context.push(AppRoutes.chat),
        ),
        _buildQuickActionItem(
          title: 'View Invoices',
          icon: Icons.receipt_long_outlined,
          onTap: () => context.push(AppRoutes.payments),
        ),
      ],
    );
  }

  Widget _buildQuickActionItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GlassCard(
      tier: GlassTier.tier2,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryAccent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _StickySearchBarDelegate extends SliverPersistentHeaderDelegate {
  final VoidCallback onTap;
  final bool isDark;
  final Color primaryAccent;

  _StickySearchBarDelegate({
    required this.onTap,
    required this.isDark,
    required this.primaryAccent,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: isDark ? AppColors.baseCanvas : AppColors.lightBaseCanvas,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      alignment: Alignment.center,
      child: GlassCard(
        tier: GlassTier.tier1,
        borderRadius: 9999, // Pill shape
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        onTap: onTap,
        child: Row(
          children: [
            const Icon(Icons.search, size: 18, color: AppColors.textTertiary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Search services, projects, support...',
                style: TextStyle(
                  fontSize: 12.5,
                  color: isDark ? AppColors.textTertiary : AppColors.lightTextSecondary.withValues(alpha: 0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 72.0;

  @override
  double get minExtent => 72.0;

  @override
  bool shouldRebuild(covariant _StickySearchBarDelegate oldDelegate) {
    return oldDelegate.isDark != isDark || oldDelegate.primaryAccent != primaryAccent;
  }
}

class _CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new, size: 18),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSuggestionsOrResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSuggestionsOrResults(context);
  }

  Widget _buildSuggestionsOrResults(BuildContext context) {
    final results = ServicesData.services.where((s) {
      return s.title.toLowerCase().contains(query.toLowerCase()) ||
          s.category.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (results.isEmpty) {
      return Center(
        child: Text(
          'No matches found for "$query"',
          style: const TextStyle(color: AppColors.textTertiary),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final s = results[index];
        return ListTile(
          title: Text(s.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(s.category, style: const TextStyle(fontSize: 11)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          onTap: () {
            close(context, null);
            context.push('/services/${s.id}');
          },
        );
      },
    );
  }
}
