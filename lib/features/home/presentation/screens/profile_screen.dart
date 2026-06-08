import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../providers/theme_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _generatedApiKey;
  bool _isCopied = false;

  void _generateKey() {
    final rand = Random();
    final parts = List.generate(4, (_) => rand.nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0'));
    setState(() {
      _generatedApiKey = 'nzxt_live_${parts.join("_")}';
      _isCopied = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final primaryAccent = isDark ? AppColors.accentCyan : AppColors.accentPurple;

    final name = authProvider.isAuthenticated ? (authProvider.username ?? 'Alex Carter') : 'Demo Guest';
    final email = authProvider.isAuthenticated ? (authProvider.email ?? 'guest@nzxtgen.com') : 'guest@nzxtgen.com';

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Ambient purple light
          Positioned(
            bottom: 50,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accentPurple.withValues(alpha: 0.04),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentPurple.withValues(alpha: 0.04),
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
                  // Header
                  Text(
                    'WORKSPACE SETTINGS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      color: primaryAccent,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Profile Portal',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 28),

                  // Avatar card
                  _buildAvatarCard(context, name, email, isDark, primaryAccent),
                  const SizedBox(height: 28),

                  // Arc style Theme Switcher
                  Text(
                    'Appearance Mode',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildThemeSwitcher(context, themeProvider, isDark, primaryAccent),
                  const SizedBox(height: 28),

                  // API Token Generator
                  Text(
                    'Developer Access Keys',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildApiGenerator(context, isDark, primaryAccent),
                  const SizedBox(height: 28),

                  // Stripe-style Billing History
                  Text(
                    'Billing History',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildBillingHistory(context, isDark),
                  const SizedBox(height: 32),

                  // Account controls
                  _buildAccountControls(context, authProvider, isDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarCard(
    BuildContext context,
    String name,
    String email,
    bool isDark,
    Color accentColor,
  ) {
    return GlassCard(
      borderRadius: 24,
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: accentColor.withValues(alpha: 0.15),
            child: Text(
              name.substring(0, min(name.length, 2)).toUpperCase(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: accentColor.withValues(alpha: 0.1),
                  ),
                  child: Text(
                    'ENTERPRISE MEMBER',
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      color: accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSwitcher(
    BuildContext context,
    ThemeProvider provider,
    bool isDark,
    Color accentColor,
  ) {
    return GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: _buildThemeOption(
              label: 'Dark Mode first',
              isActive: provider.isDarkMode,
              onTap: () {
                if (!provider.isDarkMode) {
                  provider.toggleTheme();
                }
              },
              isDark: isDark,
              accentColor: accentColor,
            ),
          ),
          Expanded(
            child: _buildThemeOption(
              label: 'Light Mode',
              isActive: !provider.isDarkMode,
              onTap: () {
                if (provider.isDarkMode) {
                  provider.toggleTheme();
                }
              },
              isDark: isDark,
              accentColor: accentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    required bool isDark,
    required Color accentColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: isActive ? (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)) : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isActive) ...[
              Icon(Icons.check_circle_outline, size: 16, color: accentColor),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                fontSize: 13,
                color: isActive
                    ? (isDark ? Colors.white : Colors.black)
                    : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApiGenerator(BuildContext context, bool isDark, Color accentColor) {
    return GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Generate a temporary Workspace API Key for integrating external pipelines (e.g. CLI commands).',
            style: TextStyle(fontSize: 12.5, height: 1.5),
          ),
          const SizedBox(height: 16),
          if (_generatedApiKey != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isDark ? Colors.black26 : Colors.white24,
                border: Border.all(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.1)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _generatedApiKey!,
                      style: const TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: _generatedApiKey!));
                      setState(() {
                        _isCopied = true;
                      });
                      Future.delayed(const Duration(seconds: 2), () {
                        if (mounted) {
                          setState(() {
                            _isCopied = false;
                          });
                        }
                      });
                    },
                    child: Icon(
                      _isCopied ? Icons.check : Icons.copy,
                      size: 16,
                      color: _isCopied ? Colors.green : accentColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          PrimaryButton(
            text: _generatedApiKey != null ? 'Re-generate Token' : 'Create Live API Token',
            outline: true,
            height: 48,
            onPressed: _generateKey,
          ),
        ],
      ),
    );
  }

  Widget _buildBillingHistory(BuildContext context, bool isDark) {
    final invoices = [
      {'date': 'June 1, 2026', 'amount': '\$5,499.00', 'status': 'PAID'},
      {'date': 'May 15, 2026', 'amount': '\$6,999.00', 'status': 'PAID'},
    ];

    return Column(
      children: List.generate(
        invoices.length,
        (index) {
          final item = invoices[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: GlassCard(
              borderRadius: 16,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['date']!,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Sprint Invoicing',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        item['amount']!,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.green.withValues(alpha: 0.1),
                        ),
                        child: const Text(
                          'PAID',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
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

  Widget _buildAccountControls(BuildContext context, AuthProvider auth, bool isDark) {
    if (auth.isAuthenticated) {
      return PrimaryButton(
        text: 'Logout Workspace Session',
        outline: true,
        textColor: Colors.redAccent,
        gradient: const LinearGradient(colors: [Colors.redAccent, Colors.red]),
        onPressed: () {
          auth.logout();
          context.go(AppRoutes.home);
        },
      );
    } else {
      return PrimaryButton(
        text: 'Log In Workspace',
        onPressed: () {
          context.go(AppRoutes.login);
        },
      );
    }
  }
}
