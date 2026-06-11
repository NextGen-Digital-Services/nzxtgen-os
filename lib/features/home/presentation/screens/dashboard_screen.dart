import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../core/widgets/ambient_glow.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Active', 'Completed', 'Pending'];

  final List<Map<String, dynamic>> _projects = [
    {
      'id': 'mobile',
      'name': 'Mobile App Pipeline MVP',
      'category': 'Mobile App Development',
      'progress': 0.60,
      'nextMilestone': 'Next: Local SQLite Integration due Jun 25',
      'status': 'Active',
      'statusType': StatusType.active,
      'color': Colors.cyan,
      'lastUpdate': '3h ago',
    },
    {
      'id': 'website',
      'name': 'Web Platform Conversion Sprint',
      'category': 'Website Development',
      'progress': 0.85,
      'nextMilestone': 'Next: Contentful CMS Deployment due Jun 20',
      'status': 'Active',
      'statusType': StatusType.active,
      'color': Colors.indigo,
      'lastUpdate': '1d ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = Provider.of<AuthProvider>(context);
    final primaryAccent = isDark ? AppColors.primaryAccent : AppColors.accentBright;

    // Check auth status
    if (!authProvider.isAuthenticated) {
      return _buildGuestLockState(context, isDark, primaryAccent);
    }

    final filteredProjects = _projects.where((p) {
      if (_selectedFilter == 'All') return true;
      return p['status'] == _selectedFilter;
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.baseCanvas : AppColors.lightBaseCanvas,
      appBar: AppBar(
        title: const Text('Workspace Portal', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background ambient spot
          const Positioned(
            top: 50,
            right: -100,
            child: AmbientGlow(color: AppColors.primaryAccent, size: 500),
          ),

          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 120.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SUMMARY STATS ROW
                        SizedBox(
                          height: 100,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            children: [
                              _buildSummaryCard(context, 'Total Invested', '₹70,000', primaryAccent),
                              const SizedBox(width: 12),
                              _buildSummaryCard(context, 'Active Projects', '2', Colors.white),
                              const SizedBox(width: 12),
                              _buildSummaryCard(context, 'Completed Projects', '0', Colors.white),
                              const SizedBox(width: 12),
                              _buildSummaryCard(context, 'Pending Amount', '₹50,000', AppColors.warning),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // PROJECTS SECTION
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'YOUR PROJECTS',
                              style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: AppColors.textTertiary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Filter chips
                        SizedBox(
                          height: 36,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _filters.length,
                            separatorBuilder: (context, index) => const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final filter = _filters[index];
                              final isSelected = _selectedFilter == filter;

                              return ChoiceChip(
                                label: Text(
                                  filter,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? Colors.white : AppColors.textTertiary,
                                  ),
                                ),
                                selected: isSelected,
                                onSelected: (val) {
                                  setState(() {
                                    _selectedFilter = filter;
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

                        // PROJECT CARDS LIST
                        if (filteredProjects.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 40.0),
                              child: Text('No projects matching filter.', style: TextStyle(color: AppColors.textTertiary)),
                            ),
                          )
                        else
                          ...List.generate(filteredProjects.length, (index) {
                            final p = filteredProjects[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16.0),
                              child: _buildProjectCard(context, p, isDark, primaryAccent),
                            );
                          }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // QUICK ACTIONS FLOATING ROW
          Positioned(
            bottom: 100, // Kept above bottom nav
            left: 20,
            right: 20,
            child: Center(
              child: GlassCard(
                tier: GlassTier.tier2,
                borderRadius: 9999, // Pill Container
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildFloatingActionItem(
                      icon: Icons.cloud_upload_outlined,
                      onTap: () {
                        // Redirect to project mobile details Files tab
                        context.push('/project/mobile');
                      },
                    ),
                    const SizedBox(width: 16),
                    _buildFloatingActionItem(
                      icon: Icons.chat_bubble_outline_rounded,
                      onTap: () => context.push(AppRoutes.chat),
                    ),
                    const SizedBox(width: 16),
                    _buildFloatingActionItem(
                      icon: Icons.receipt_long_outlined,
                      onTap: () => context.push(AppRoutes.payments),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String label, String value, Color textColor) {
    return GlassCard(
      tier: GlassTier.tier2,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textTertiary)),
          Text(
            value,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, Map<String, dynamic> p, bool isDark, Color accentColor) {
    return Container(
      height: 146,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
      ),
      child: GlassCard(
        tier: GlassTier.tier2,
        padding: EdgeInsets.zero,
        onTap: () {
          context.push('/project/${p['id']}');
        },
        child: Row(
          children: [
            // Left Accent Bar
            Container(
              width: 4,
              height: double.infinity,
              color: p['color'] as Color,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top row: category and progress
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: (p['color'] as Color).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            (p['category'] as String).toUpperCase(),
                            style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: p['color']),
                          ),
                        ),
                        Text(
                          '${((p['progress'] as double) * 100).toInt()}%',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: accentColor),
                        ),
                      ],
                    ),

                    // Title
                    Text(
                      p['name'],
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                    ),

                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: p['progress'] as double,
                        minHeight: 5,
                        backgroundColor: Colors.white10,
                        valueColor: AlwaysStoppedAnimation<Color>(p['color'] as Color),
                      ),
                    ),

                    // Milestone text
                    Text(
                      p['nextMilestone'],
                      style: const TextStyle(fontSize: 10.5, color: AppColors.textTertiary),
                    ),

                    // Bottom Row: status, overlapping avatar group, time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatusBadge(label: p['status'], type: p['statusType'] as StatusType),
                        Row(
                          children: [
                            // Overlapping avatars
                            SizedBox(
                              width: 50,
                              height: 20,
                              child: Stack(
                                children: [
                                  Positioned(left: 0, child: _buildMiniAvatar('F', Colors.purple)),
                                  Positioned(left: 12, child: _buildMiniAvatar('Z', Colors.teal)),
                                  Positioned(left: 24, child: _buildMiniAvatar('M', Colors.blue)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(p['lastUpdate'], style: const TextStyle(fontSize: 9.5, color: AppColors.textTertiary)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniAvatar(String initial, Color color) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: CircleAvatar(
        radius: 9,
        backgroundColor: color.withValues(alpha: 0.2),
        child: Text(
          initial,
          style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }

  Widget _buildFloatingActionItem({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColors.primaryAccent.withValues(alpha: 0.15),
      child: IconButton(
        icon: Icon(icon, color: AppColors.primaryAccent, size: 18),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildGuestLockState(BuildContext context, bool isDark, Color accentColor) {
    return Scaffold(
      backgroundColor: isDark ? AppColors.baseCanvas : AppColors.lightBaseCanvas,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 200,
            left: -100,
            child: AmbientGlow(color: accentColor, size: 500),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GlassCard(
                tier: GlassTier.tier3,
                showGlow: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: accentColor.withValues(alpha: 0.2)),
                      ),
                      child: Icon(Icons.lock_outline, size: 48, color: accentColor),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Portal Restricted',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Log in to view active project timelines, make payments, download shared documents, and open support tickets.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 28),
                    PrimaryButton(
                      text: 'Log In Workspace',
                      onPressed: () => context.push(AppRoutes.login),
                    ),
                    const SizedBox(height: 14),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.signup),
                      child: Text(
                        'Create Account',
                        style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
