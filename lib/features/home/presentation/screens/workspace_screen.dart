import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';

class WorkspaceScreen extends StatelessWidget {
  const WorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? AppColors.accentCyan : AppColors.accentPurple;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Ambient neon spot
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
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0, bottom: 120.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App header details (replacing website global header)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'WORKSPACE',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                              color: primaryAccent,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Active Pipelines',
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
                          'NZXT-CORE-901',
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

                  // Sprint Milestones
                  _buildSprintCard(context, primaryAccent, isDark),
                  const SizedBox(height: 28),

                  // Subscriptions / Apps Purchased
                  Text(
                    'Subscribed Services',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildSubscriptionList(context, isDark, primaryAccent),
                  const SizedBox(height: 28),

                  // Ticket Logs (Linear style)
                  Text(
                    'Linear Ticket Logs',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildTicketLogs(context, isDark, primaryAccent),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSprintCard(BuildContext context, Color activeColor, bool isDark) {
    return GlassCard(
      borderRadius: 24,
      padding: const EdgeInsets.all(24),
      showGlow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Beta Release Sprint',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                '70% Complete',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: activeColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Custom progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              height: 8,
              width: double.infinity,
              color: isDark ? Colors.white10 : Colors.black12,
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: 0.7,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: activeColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 14,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'June 1 - June 15',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
              const Text(
                'Sprint 4',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionList(BuildContext context, bool isDark, Color activeColor) {
    final subItems = [
      {'title': 'Premium Web App Dev', 'status': 'Active • Sprinting', 'tier': 'Tier 2'},
      {'title': 'AI Automation Agent', 'status': 'Active • Deploying', 'tier': 'Growth'},
    ];

    return Column(
      children: List.generate(
        subItems.length,
        (index) {
          final item = subItems[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: GlassCard(
              borderRadius: 16,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: activeColor.withValues(alpha: 0.1),
                        ),
                        child: Icon(
                          index == 0 ? Icons.web : Icons.auto_awesome,
                          size: 18,
                          color: activeColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title']!,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['status']!,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                    ),
                    child: Text(
                      item['tier']!,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTicketLogs(BuildContext context, bool isDark, Color activeColor) {
    final tickets = [
      {'id': 'NZXT-129', 'title': 'Figma Design Component Map', 'status': 'Completed', 'priority': 'High'},
      {'id': 'NZXT-130', 'title': 'Implement Frosted Glass Shell', 'status': 'In Progress', 'priority': 'Medium'},
      {'id': 'NZXT-131', 'title': 'Setup API Supabase Gates', 'status': 'Backlog', 'priority': 'Low'},
    ];

    return Column(
      children: List.generate(
        tickets.length,
        (index) {
          final t = tickets[index];
          final status = t['status'];
          final priority = t['priority'];

          Widget statusIcon;

          if (status == 'Completed') {
            statusIcon = const Icon(Icons.check_circle, color: Colors.green, size: 16);
          } else if (status == 'In Progress') {
            statusIcon = SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(activeColor)),
            );
          } else {
            statusIcon = const Icon(Icons.circle_outlined, color: Colors.grey, size: 16);
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: GlassCard(
              borderRadius: 16,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  statusIcon,
                  const SizedBox(width: 12),
                  Text(
                    t['id']!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      t['title']!,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Priority indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                    ),
                    child: Text(
                      priority!,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
