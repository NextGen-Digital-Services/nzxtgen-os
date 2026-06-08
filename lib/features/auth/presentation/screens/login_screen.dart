import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_text_field.dart';
import '../../../../core/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() {
      _errorMessage = null;
    });

    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (success) {
      if (mounted) {
        context.go(AppRoutes.home);
      }
    } else {
      setState(() {
        _errorMessage = 'Invalid email or password. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLoading = Provider.of<AuthProvider>(context).isLoading;
    final primaryAccent = isDark ? AppColors.accentCyan : AppColors.accentPurple;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Ambient light
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentPurple.withValues(alpha: isDark ? 0.12 : 0.04),
                    blurRadius: 100,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),

          // Back to Store chevron
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                size: 18,
              ),
              onPressed: () => context.go(AppRoutes.home),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Brand Identity Icon
                    Icon(
                      Icons.auto_awesome,
                      color: primaryAccent,
                      size: 40,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Welcome to NZXTGEN',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Access your custom development pipelines',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                    ),
                    const SizedBox(height: 32),

                    GlassCard(
                      padding: const EdgeInsets.all(24.0),
                      borderRadius: 24.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (_errorMessage != null) ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.redAccent.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.redAccent.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          GlassTextField(
                            controller: _emailController,
                            label: 'Email',
                            hint: 'you@domain.com',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          GlassTextField(
                            controller: _passwordController,
                            label: 'Password',
                            hint: '••••••••',
                            prefixIcon: Icons.lock_outline,
                            isPassword: true,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _handleLogin(),
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          PrimaryButton(
                            text: 'Login Workspace',
                            onPressed: _handleLogin,
                            isLoading: isLoading,
                          ),

                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(child: Divider(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1))),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  'OR CONTINUE WITH',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                                ),
                              ),
                              Expanded(child: Divider(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1))),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Linear social OAuth row
                          Row(
                            children: [
                              Expanded(
                                child: PrimaryButton(
                                  text: 'Google',
                                  outline: true,
                                  height: 48,
                                  onPressed: () => _handleLogin(),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: PrimaryButton(
                                  text: 'Apple ID',
                                  outline: true,
                                  height: 48,
                                  onPressed: () => _handleLogin(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have a workspace? ",
                          style: TextStyle(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.go(AppRoutes.signup),
                          child: Text(
                            'Create Account',
                            style: TextStyle(
                              color: primaryAccent,
                              fontWeight: FontWeight.bold,
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
        ],
      ),
    );
  }
}
