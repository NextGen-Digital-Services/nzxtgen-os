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
  bool _emailNotifications = false;

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
          // Background glow
          Positioned(
            bottom: 50,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accentPurple.withValues(alpha: isDark ? 0.04 : 0.01),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentPurple.withValues(alpha: isDark ? 0.04 : 0.01),
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
                    'PORTAL CONFIGURATION',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      color: primaryAccent,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Profile Settings',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 28),

                  // 1. Personal Information Card
                  Text(
                    'Personal Information',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildPersonalInfoCard(context, name, email, isDark, primaryAccent),
                  const SizedBox(height: 28),

                  // 2. Purchased Services
                  Text(
                    'Purchased Services',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildPurchasedServicesList(context, isDark, primaryAccent),
                  const SizedBox(height: 28),

                  // 3. Documents
                  Text(
                    'Shared Documents',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildDocumentsList(context, isDark, primaryAccent),
                  const SizedBox(height: 28),

                  // 4. Security & Developer Access Keys
                  Text(
                    'Security & Access Keys',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildSecuritySection(context, isDark, primaryAccent),
                  const SizedBox(height: 28),

                  // 5. Appearance & Notifications
                  Text(
                    'App Settings',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildAppSettings(context, themeProvider, isDark, primaryAccent),
                  const SizedBox(height: 32),

                  // 6. Logout / Session Control
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
      borderRadius: 24,
      padding: const EdgeInsets.all(20),
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
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16.5),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: accentColor.withValues(alpha: 0.1),
            ),
            child: Text(
              'ACTIVE',
              style: TextStyle(
                fontSize: 8.5,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurchasedServicesList(BuildContext context, bool isDark, Color accentColor) {
    final services = [
      {'title': 'App Development MVP', 'date': 'Active from June 1, 2026'},
      {'title': 'Premium SEO Engine', 'date': 'Active from May 15, 2026'},
    ];

    return Column(
      children: services.map((s) {
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
                    Text(s['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                    const SizedBox(height: 4),
                    Text(
                      s['date']!,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 12, color: accentColor.withValues(alpha: 0.5)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDocumentsList(BuildContext context, bool isDark, Color accentColor) {
    final docs = [
      {'name': 'NZXT-Service_Agreement.pdf', 'date': 'Signed June 1, 2026'},
      {'name': 'Figma-Architecture_Specs.pdf', 'date': 'Uploaded May 28, 2026'},
    ];

    return Column(
      children: docs.map((d) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: GlassCard(
            borderRadius: 16,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                const Icon(Icons.insert_drive_file_outlined, color: AppColors.accentBlue, size: 18),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        d['name']!,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        d['date']!,
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.download_rounded, size: 16, color: accentColor),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSecuritySection(BuildContext context, bool isDark, Color accentColor) {
    return GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Developer Access Keys',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          const Text(
            'Generate a secure API key to authenticate external automation pipelines or CLI utilities.',
            style: TextStyle(fontSize: 12, height: 1.4, color: Colors.grey),
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
            outline: true,
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
          borderRadius: 16,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.dark_mode_outlined, size: 20),
                  SizedBox(width: 12),
                  Text('Dark Mode Appearance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                ],
              ),
              Switch.adaptive(
                value: themeProvider.isDarkMode,
                activeThumbColor: accentColor,
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
          borderRadius: 16,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.notifications_active_outlined, size: 20),
                  SizedBox(width: 12),
                  Text('Push Notifications', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                ],
              ),
              Switch.adaptive(
                value: _pushNotifications,
                activeThumbColor: accentColor,
                onChanged: (val) {
                  setState(() {
                    _pushNotifications = val;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Email notifications switch
        GlassCard(
          borderRadius: 16,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.email_outlined, size: 20),
                  SizedBox(width: 12),
                  Text('Email Alerts & Invoices', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                ],
              ),
              Switch.adaptive(
                value: _emailNotifications,
                activeThumbColor: accentColor,
                onChanged: (val) {
                  setState(() {
                    _emailNotifications = val;
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
        outline: true,
        textColor: Colors.redAccent,
        gradient: const LinearGradient(colors: [Colors.redAccent, Colors.red]),
        onPressed: () {
          auth.logout();
          // Reset to home index
          final navState = context.findAncestorStateOfType<MainNavigationScreenState>();
          navState?.setIndex(0);
          context.go(AppRoutes.home);
        },
      );
    } else {
      return PrimaryButton(
        text: 'Log In',
        onPressed: () {
          context.go(AppRoutes.login);
        },
      );
    }
  }
}
