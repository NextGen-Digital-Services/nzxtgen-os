import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/ambient_glow.dart';

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
    final primaryAccent = isDark ? AppColors.primaryAccent : AppColors.accentBright;

    return Scaffold(
      backgroundColor: isDark ? AppColors.baseCanvas : AppColors.lightBaseCanvas,
      appBar: AppBar(
        title: const Text('Sign In', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned(
            top: -50,
            right: -50,
            child: AmbientGlow(color: AppColors.primaryAccent, size: 400),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Brand Identity Icon
                    Icon(Icons.auto_awesome, color: primaryAccent, size: 40),
                    const SizedBox(height: 16),
                    Text(
                      'Welcome Back',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to access your projects and services',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                          ),
                    ),
                    const SizedBox(height: 32),

                    GlassCard(
                      tier: GlassTier.tier2,
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (_errorMessage != null) ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.error.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                              ),
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(
                                  color: AppColors.error,
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
                          const SizedBox(height: 12),
                          // Forgot Password link
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                context.push(AppRoutes.forgotPassword);
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: primaryAccent,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          PrimaryButton(
                            text: 'Sign In',
                            isLoading: isLoading,
                            onPressed: _handleLogin,
                          ),

                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(child: Divider(color: isDark ? Colors.white12 : Colors.black12)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  'OR CONTINUE WITH',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                                  ),
                                ),
                              ),
                              Expanded(child: Divider(color: isDark ? Colors.white12 : Colors.black12)),
                            ],
                          ),
                          const SizedBox(height: 20),

                          Row(
                            children: [
                              Expanded(
                                child: PrimaryButton(
                                  text: 'Google',
                                  variant: ButtonVariant.ghost,
                                  height: 48,
                                  onPressed: () => _handleLogin(),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: PrimaryButton(
                                  text: 'Apple ID',
                                  variant: ButtonVariant.ghost,
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
                          "Don't have an account? ",
                          style: TextStyle(
                            color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.push(AppRoutes.signup),
                          child: Text(
                            'Create One',
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
