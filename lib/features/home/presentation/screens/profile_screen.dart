import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/ambient_glow.dart';
import '../../../../providers/theme_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../about/presentation/screens/about_screen.dart';
import 'main_navigation_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _generatedApiKey;
  bool _isCopied = false;
  bool _pushNotifications = true;

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
    final primaryAccent = isDark ? AppColors.primaryAccent : AppColors.accentBright;

    final name = authProvider.isAuthenticated ? (authProvider.username ?? 'Alex Carter') : 'Demo Guest';
    final email = authProvider.isAuthenticated ? (authProvider.email ?? 'guest@nzxtgen.com') : 'guest@nzxtgen.com';

    return Scaffold(
      backgroundColor: isDark ? AppColors.baseCanvas : AppColors.lightBaseCanvas,
      appBar: AppBar(
        title: const Text('Profile Settings', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background glow
          const Positioned(
            bottom: 50,
            right: -100,
            child: AmbientGlow(color: AppColors.primaryAccent, size: 400),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 120.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Personal Information Card
                  _buildPersonalInfoCard(context, name, email, isDark, primaryAccent),
                  const SizedBox(height: 24),

                  // 2. Navigation Actions Grid
                  Text(
                    'PORTAL SECTIONS',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: AppColors.textTertiary),
                  ),
                  const SizedBox(height: 12),
                  _buildNavigationOptions(context, authProvider.isAuthenticated),
                  const SizedBox(height: 24),

                  // 3. Security & Developer Access Keys
                  Text(
                    'SECURITY & ACCESS KEYS',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: AppColors.textTertiary),
                  ),
                  const SizedBox(height: 12),
                  _buildSecuritySection(context, isDark, primaryAccent),
                  const SizedBox(height: 24),

                  // 4. App Settings
                  Text(
                    'SYSTEM CONFIGURATIONS',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: AppColors.textTertiary),
                  ),
                  const SizedBox(height: 12),
                  _buildAppSettings(context, themeProvider, isDark, primaryAccent),
                  const SizedBox(height: 32),

                  // 5. Logout Button
                  _buildAccountControls(context, authProvider, isDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard(
    BuildContext context,
    String name,
    String email,
    bool isDark,
    Color accentColor,
  ) {
    return GlassCard(
      tier: GlassTier.tier2,
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: accentColor.withValues(alpha: 0.15),
            child: Text(
              name.substring(0, min(name.length, 2)).toUpperCase(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.5),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: AppColors.secondary.withValues(alpha: 0.15),
            ),
            child: const Text(
              'ACTIVE',
              style: TextStyle(
                fontSize: 8.5,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationOptions(BuildContext context, bool isAuthenticated) {
    return GlassCard(
      tier: GlassTier.tier2,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.payment_outlined, color: AppColors.primaryAccent),
            title: const Text('Payments & Invoices', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12),
            onTap: () {
              if (isAuthenticated) {
                context.push(AppRoutes.payments);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please sign in to view invoices.'), backgroundColor: AppColors.error),
                );
              }
            },
          ),
          const Divider(color: Colors.white10, height: 1),
          ListTile(
            leading: const Icon(Icons.notifications_none_rounded, color: AppColors.primaryAccent),
            title: const Text('System Notifications', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12),
            onTap: () {
              context.push(AppRoutes.notifications);
            },
          ),
          const Divider(color: Colors.white10, height: 1),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded, color: AppColors.primaryAccent),
            title: const Text('About NZXTGEN Agency', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
          const Divider(color: Colors.white10, height: 1),
          ListTile(
            leading: const Icon(Icons.help_outline_rounded, color: AppColors.primaryAccent),
            title: const Text('Help & Support Desk', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12),
            onTap: () {
              final navState = context.findAncestorStateOfType<MainNavigationScreenState>();
              navState?.setIndex(3); // Go to Support Tab
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySection(BuildContext context, bool isDark, Color accentColor) {
    return GlassCard(
      tier: GlassTier.tier2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Developer Access Keys',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
          ),
          const SizedBox(height: 6),
          const Text(
            'Generate a secure API key to authenticate external automation pipelines or CLI utilities.',
            style: TextStyle(fontSize: 11.5, height: 1.4, color: AppColors.textTertiary),
          ),
          const SizedBox(height: 16),
          if (_generatedApiKey != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isDark ? Colors.black26 : Colors.white24,
                border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _generatedApiKey!,
                      style: const TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 11.5,
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
            text: _generatedApiKey != null ? 'Re-generate Key' : 'Create API Token',
            variant: ButtonVariant.ghost,
            height: 44,
            onPressed: _generateKey,
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettings(
    BuildContext context,
    ThemeProvider themeProvider,
    bool isDark,
    Color accentColor,
  ) {
    return Column(
      children: [
        // Theme switcher option
        GlassCard(
          tier: GlassTier.tier2,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.dark_mode_outlined, size: 20, color: AppColors.primaryAccent),
                  SizedBox(width: 12),
                  Text('Dark Mode Appearance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              Switch.adaptive(
                value: themeProvider.isDarkMode,
                activeTrackColor: accentColor,
                onChanged: (_) {
                  themeProvider.toggleTheme();
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Push notifications switch
        GlassCard(
          tier: GlassTier.tier2,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.notifications_active_outlined, size: 20, color: AppColors.primaryAccent),
                  SizedBox(width: 12),
                  Text('Push Notifications', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              Switch.adaptive(
                value: _pushNotifications,
                activeTrackColor: accentColor,
                onChanged: (val) {
                  setState(() {
                    _pushNotifications = val;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccountControls(BuildContext context, AuthProvider auth, bool isDark) {
    if (auth.isAuthenticated) {
      return PrimaryButton(
        text: 'Logout Session',
        variant: ButtonVariant.destructive,
        onPressed: () {
          auth.logout();
          final navState = context.findAncestorStateOfType<MainNavigationScreenState>();
          navState?.setIndex(0); // Go back home
        },
      );
    } else {
      return PrimaryButton(
        text: 'Log In Workspace',
        variant: ButtonVariant.primary,
        onPressed: () {
          context.push(AppRoutes.login);
        },
      );
    }
  }
}
