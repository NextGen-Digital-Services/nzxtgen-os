import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/ambient_glow.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSendLink() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
    });

    // Simulate sending link
    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _isSubmitted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.baseCanvas : AppColors.lightBaseCanvas,
      appBar: AppBar(
        title: Text(
          'Reset Password',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned(
            top: 100,
            right: -100,
            child: AmbientGlow(color: AppColors.primaryAccent, size: 500),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: AnimatedCrossFade(
                firstChild: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        'Forgot Password?',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Enter your workspace email and we will send a direct magic link to authenticate and reset.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                              height: 1.5,
                            ),
                      ),
                      const SizedBox(height: 32),
                      GlassCard(
                        tier: GlassTier.tier2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            GlassTextField(
                              controller: _emailController,
                              label: 'Email Address',
                              hint: 'you@domain.com',
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Please enter your email address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            PrimaryButton(
                              text: 'Send Reset Link',
                              isLoading: _isLoading,
                              onPressed: _handleSendLink,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                secondChild: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.secondary.withValues(alpha: 0.15),
                      ),
                      child: const Icon(
                        Icons.mark_email_read_outlined,
                        size: 64,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Check your inbox',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'We have sent a secure recovery link to ${_emailController.text}. Please check your email to update your access credentials.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                            height: 1.5,
                          ),
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      text: 'Back to Sign In',
                      variant: ButtonVariant.ghost,
                      onPressed: () => context.pop(),
                    ),
                  ],
                ),
                crossFadeState: _isSubmitted ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
