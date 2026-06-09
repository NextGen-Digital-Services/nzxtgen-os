import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = Provider.of<AuthProvider>(context);
    final primaryAccent = isDark ? AppColors.accentCyan : AppColors.accentPurple;

    // Check auth status to show auth lock state
    if (!authProvider.isAuthenticated) {
      return _buildGuestLockState(context, isDark, primaryAccent);
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background ambient spot
          Positioned(
            top: 50,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryAccent.withValues(alpha: 0.05),
                boxShadow: [
                  BoxShadow(
                    color: primaryAccent.withValues(alpha: 0.05),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MY PORTAL',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                              color: primaryAccent,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Client Dashboard',
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: primaryAccent.withValues(alpha: 0.3),
                          ),
                          color: primaryAccent.withValues(alpha: 0.06),
                        ),
                        child: Text(
                          'NZXT-MEMBER',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: primaryAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // 1. Active Projects & Phase Tracker (Planning -> Completed)
                  Text(
                    'Active Project Timeline',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildProjectStatusTracker(context, isDark, primaryAccent),
                  const SizedBox(height: 28),

                  // 2. My Services
                  Text(
                    'My Active Services',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildMyServices(context, isDark, primaryAccent),
                  const SizedBox(height: 28),

                  // 3. Pending Payments
                  Text(
                    'Pending Payments',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildPendingPayments(context, isDark, primaryAccent),
                  const SizedBox(height: 28),

                  // 4. Recent Documents
                  Text(
                    'Recent Shared Documents',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildRecentDocuments(context, isDark, primaryAccent),
                  const SizedBox(height: 28),

                  // 5. Open Support Tickets (Linear style)
                  Text(
                    'Open Support Tickets',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildSupportTickets(context, isDark, primaryAccent),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestLockState(BuildContext context, bool isDark, Color accentColor) {
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background ambient lights
          Positioned(
            top: 200,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withValues(alpha: 0.05),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.05),
                    blurRadius: 100,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GlassCard(
                padding: const EdgeInsets.all(32),
                borderRadius: 28,
                showGlow: true,
                glowColor: accentColor,
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
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Log in to view active project timelines, make payments, download shared documents, and open support tickets.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 28),
                    PrimaryButton(
                      text: 'Log In Workspace',
                      onPressed: () => context.go(AppRoutes.login),
                    ),
                    const SizedBox(height: 14),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.signup),
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

  Widget _buildProjectStatusTracker(BuildContext context, bool isDark, Color accentColor) {
    final stages = [
      {'name': 'Planning', 'active': true},
      {'name': 'Design', 'active': true},
      {'name': 'Dev', 'active': true},
      {'name': 'Testing', 'active': false},
      {'name': 'Completed', 'active': false},
    ];

    return GlassCard(
      borderRadius: 24,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mobile App Release',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                '60% Complete',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: accentColor),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Steps indicator
          Row(
            children: List.generate(stages.length, (index) {
              final s = stages[index];
              final isActive = s['active'] as bool;
              final isLast = index == stages.length - 1;

              return Expanded(
                child: Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isActive ? accentColor : (isDark ? Colors.white24 : Colors.black12),
                              width: 2,
                            ),
                            color: isActive ? accentColor : Colors.transparent,
                          ),
                          child: isActive
                              ? const Icon(Icons.check, size: 10, color: Colors.black)
                              : null,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          s['name'] as String,
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                            color: isActive 
                                ? (isDark ? Colors.white : Colors.black)
                                : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          ),
                        ),
                      ],
                    ),
                    if (!isLast)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 14.0),
                          child: Container(
                            height: 2,
                            color: isActive 
                                ? accentColor.withValues(alpha: 0.5) 
                                : (isDark ? Colors.white12 : Colors.black12),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMyServices(BuildContext context, bool isDark, Color accentColor) {
    final purchased = [
      {'title': 'App Development MVP', 'billing': 'Monthly Sprinting', 'price': '\$6,499/mo', 'icon': Icons.phone_iphone},
      {'title': 'Premium SEO Engine', 'billing': 'Monthly Authority', 'price': '\$3,499/mo', 'icon': Icons.search},
    ];

    return Column(
      children: purchased.map((s) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: GlassCard(
            borderRadius: 18,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(s['icon'] as IconData, color: accentColor, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                      const SizedBox(height: 4),
                      Text(
                        s['billing'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  s['price'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPendingPayments(BuildContext context, bool isDark, Color accentColor) {
    return GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Next Invoicing Milestone', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              SizedBox(height: 4),
              Text('Development Completion Stage (50%)', style: TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
          Row(
            children: [
              const Text('\$3,250', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
              const SizedBox(width: 12),
              PrimaryButton(
                text: 'Pay',
                width: 65,
                height: 32,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentDocuments(BuildContext context, bool isDark, Color accentColor) {
    final docs = [
      {'name': 'NZXT-Service_Agreement.pdf', 'size': '1.2 MB'},
      {'name': 'Figma-Architecture_Specs.pdf', 'size': '4.8 MB'},
    ];

    return Column(
      children: docs.map((d) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: GlassCard(
            borderRadius: 16,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                const Icon(Icons.insert_drive_file_outlined, color: AppColors.accentBlue, size: 20),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    d['name']!,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  d['size']!,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.download_rounded, color: accentColor, size: 16),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSupportTickets(BuildContext context, bool isDark, Color accentColor) {
    final tickets = [
      {'id': 'TKT-901', 'title': 'Stripe webhook payment verification delay', 'status': 'Pending Audit', 'priority': 'High'},
      {'id': 'TKT-902', 'title': 'Configure custom domains for dev host', 'status': 'Closed', 'priority': 'Medium'},
    ];

    return Column(
      children: tickets.map((t) {
        final status = t['status']!;
        final isClosed = status == 'Closed';

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: GlassCard(
            borderRadius: 16,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(
                  isClosed ? Icons.check_circle : Icons.error_outline,
                  color: isClosed ? AppColors.success : AppColors.warning,
                  size: 16,
                ),
                const SizedBox(width: 12),
                Text(
                  t['id']!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11.5,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    t['title']!,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                  ),
                  child: Text(
                    t['priority']!,
                    style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
