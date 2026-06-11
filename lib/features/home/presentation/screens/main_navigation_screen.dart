import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../services/presentation/screens/services_screen.dart';
import 'home_screen.dart';
import 'dashboard_screen.dart';
import 'support_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => MainNavigationScreenState();
}

class MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    HomeScreen(),
    ServicesScreen(),
    DashboardScreen(),
    SupportScreen(),
    ProfileScreen(),
  ];

  void setIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? AppColors.primaryAccent : AppColors.accentBright;

    // Alignment logic for the sliding pill background
    // Alignment ranges from -1.0 (left) to 1.0 (right)
    final double alignmentX = -1.0 + (_currentIndex * 0.5);

    return Scaffold(
      extendBody: true, // Allow body to scroll behind bottom bar
      backgroundColor: isDark ? AppColors.baseCanvas : AppColors.lightBaseCanvas,
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: GlassCard(
            tier: GlassTier.tier1,
            padding: const EdgeInsets.symmetric(vertical: 6),
            borderRadius: 24,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Sliding Active Indicator Pill
                Positioned.fill(
                  child: Align(
                    alignment: Alignment(alignmentX, 0.0),
                    child: FractionallySizedBox(
                      widthFactor: 0.2,
                      child: Container(
                        height: 38,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: activeColor.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                  ),
                ),

                // Navigation Row Items
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      index: 0,
                      icon: Icons.home_outlined,
                      activeIcon: Icons.home_rounded,
                      label: 'Home',
                      isDark: isDark,
                    ),
                    _buildNavItem(
                      index: 1,
                      icon: Icons.grid_view,
                      activeIcon: Icons.grid_view_rounded,
                      label: 'Services',
                      isDark: isDark,
                    ),
                    _buildNavItem(
                      index: 2,
                      icon: Icons.analytics_outlined,
                      activeIcon: Icons.analytics_rounded,
                      label: 'Portal',
                      isDark: isDark,
                    ),
                    _buildNavItem(
                      index: 3,
                      icon: Icons.headset_mic_outlined,
                      activeIcon: Icons.headset_mic_rounded,
                      label: 'Support',
                      isDark: isDark,
                    ),
                    _buildNavItem(
                      index: 4,
                      icon: Icons.person_outline_rounded,
                      activeIcon: Icons.person_rounded,
                      label: 'Profile',
                      isDark: isDark,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isDark,
  }) {
    final isSelected = _currentIndex == index;
    final activeColor = isDark ? AppColors.primaryAccent : AppColors.accentBright;
    final inactiveColor = isDark ? AppColors.textTertiary : AppColors.lightTextSecondary.withValues(alpha: 0.7);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        behavior: HitTestBehavior.opaque,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  color: isSelected ? activeColor : inactiveColor,
                  size: 20,
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected ? activeColor : inactiveColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
