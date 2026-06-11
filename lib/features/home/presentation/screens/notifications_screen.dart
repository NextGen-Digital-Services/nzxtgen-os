import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Unread', 'Projects', 'Payments', 'Support'];

  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'Milestone Achieved',
      'body': 'UX Architecture & Figma Sprints has been marked as Completed by Lead Engineer.',
      'type': 'Projects',
      'time': '2h ago',
      'unread': true,
      'icon': Icons.golf_course,
      'color': AppColors.secondary,
    },
    {
      'id': '2',
      'title': 'Invoice Issued',
      'body': 'Invoice INV-2026-004 for Stage 2 (₹50,000) has been generated.',
      'type': 'Payments',
      'time': '1d ago',
      'unread': true,
      'icon': Icons.payment_outlined,
      'color': Colors.green,
    },
    {
      'id': '3',
      'title': 'Support Team Message',
      'body': 'Marcus Aurelius added a response to ticket TKT-901.',
      'type': 'Support',
      'time': '2d ago',
      'unread': false,
      'icon': Icons.message_outlined,
      'color': AppColors.primaryAccent,
    },
    {
      'id': '4',
      'title': 'Sprint Kickoff Alert',
      'body': 'Fahad Riaz initialized repository sprint folders for Mobile MVP.',
      'type': 'Projects',
      'time': '3d ago',
      'unread': false,
      'icon': Icons.developer_board_outlined,
      'color': AppColors.secondary,
    },
  ];

  void _markAllRead() {
    setState(() {
      for (var notif in _notifications) {
        notif['unread'] = false;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read.'), backgroundColor: AppColors.secondary),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? AppColors.primaryAccent : AppColors.accentBright;

    final filtered = _notifications.where((n) {
      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Unread') return n['unread'] == true;
      return n['type'] == _selectedFilter;
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.baseCanvas : AppColors.lightBaseCanvas,
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _markAllRead,
            child: Text(
              'Mark all read',
              style: TextStyle(color: primaryAccent, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter chips horizontal list
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: SizedBox(
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
            ),

            // Notifications Feed
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_none, size: 48, color: AppColors.textTertiary),
                          const SizedBox(height: 12),
                          const Text('No notifications found', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final n = filtered[index];
                        final isUnread = n['unread'] == true;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          child: GlassCard(
                            tier: GlassTier.tier2,
                            padding: const EdgeInsets.all(16.0),
                            onTap: () {
                              setState(() {
                                n['unread'] = false;
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left icon with container
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: (n['color'] as Color).withValues(alpha: 0.15),
                                  ),
                                  child: Icon(n['icon'], color: n['color'], size: 20),
                                ),
                                const SizedBox(width: 14),

                                // Notification copy details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            n['title'],
                                            style: TextStyle(
                                              fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                                              fontSize: 13,
                                            ),
                                          ),
                                          Text(
                                            n['time'],
                                            style: const TextStyle(fontSize: 10, color: AppColors.textTertiary),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        n['body'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Unread Dot
                                if (isUnread) ...[
                                  const SizedBox(width: 12),
                                  Container(
                                    width: 8,
                                    height: 8,
                                    margin: const EdgeInsets.only(top: 4),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.tertiary, // Plasma Pink dot
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
