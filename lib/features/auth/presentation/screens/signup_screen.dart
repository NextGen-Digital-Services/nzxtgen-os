import 'dart:async';
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

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  int _currentStep = 1; // 1: Account, 2: Verify, 3: Profile

  // Step 1 Controllers
  final _formKey1 = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreeToTerms = false;

  // Step 2 Controllers & State
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());
  int _resendSeconds = 45;
  Timer? _resendTimer;
  bool _isVerifying = false;

  // Step 3 Controllers
  final _companyController = TextEditingController();
  String _selectedIndustry = 'SaaS / Tech';
  final List<String> _industries = ['SaaS / Tech', 'E-Commerce', 'Professional Services', 'Finance / Real Estate', 'AI / Automation', 'Other'];
  String _source = 'Search Engine';
  final List<String> _sources = ['Search Engine', 'Social Media', 'Word of Mouth', 'YouTube', 'Other'];
  bool _isCompleting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _companyController.dispose();
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _otpFocusNodes) {
      f.dispose();
    }
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _resendSeconds = 45;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        setState(() {
          _resendSeconds--;
        });
      } else {
        _resendTimer?.cancel();
      }
    });
  }

  void _handleStep1Next() {
    if (!_formKey1.currentState!.validate()) return;
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the Terms and Privacy Policy'), backgroundColor: AppColors.error),
      );
      return;
    }
    setState(() {
      _currentStep = 2;
    });
    _startTimer();
  }

  void _handleVerifyOTP() async {
    // Check if OTP is fully entered
    String code = _otpControllers.map((c) => c.text).join();
    if (code.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the 6-digit verification code'), backgroundColor: AppColors.error),
      );
      return;
    }

    setState(() {
      _isVerifying = true;
    });

    // Simulate OTP server call
    await Future.delayed(const Duration(milliseconds: 1200));

    if (mounted) {
      setState(() {
        _isVerifying = false;
        _currentStep = 3;
      });
    }
  }

  void _handleProfileSetup() async {
    setState(() {
      _isCompleting = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signup(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (success) {
      if (mounted) {
        context.go(AppRoutes.home);
      }
    } else {
      if (mounted) {
        setState(() {
          _isCompleting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to complete setup. Please try again.'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? AppColors.primaryAccent : AppColors.accentBright;

    return Scaffold(
      backgroundColor: isDark ? AppColors.baseCanvas : AppColors.lightBaseCanvas,
      appBar: AppBar(
        title: const Text('Create Account', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () {
            if (_currentStep > 1) {
              setState(() {
                _currentStep--;
              });
            } else {
              context.pop();
            }
          },
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned(
            bottom: -50,
            left: -50,
            child: AmbientGlow(color: AppColors.secondary, size: 400),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                children: [
                  // Step Indicator
                  _buildStepIndicator(isDark, primaryAccent),
                  const SizedBox(height: 32),

                  // Dynamic Forms Switcher
                  AnimatedCrossFade(
                    firstChild: _buildStep1Form(isDark, primaryAccent),
                    secondChild: _currentStep == 2
                        ? _buildStep2Form(isDark, primaryAccent)
                        : _buildStep3Form(isDark, primaryAccent),
                    crossFadeState: _currentStep == 1 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 300),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(bool isDark, Color accentColor) {
    final activeIndicatorColor = accentColor;
    final inactiveIndicatorColor = isDark ? Colors.white12 : Colors.black12;

    return Row(
      children: [
        _buildIndicatorCircle(1, 'Account', _currentStep >= 1, activeIndicatorColor),
        _buildIndicatorLine(_currentStep >= 2, activeIndicatorColor, inactiveIndicatorColor),
        _buildIndicatorCircle(2, 'Verify', _currentStep >= 2, activeIndicatorColor),
        _buildIndicatorLine(_currentStep >= 3, activeIndicatorColor, inactiveIndicatorColor),
        _buildIndicatorCircle(3, 'Profile', _currentStep >= 3, activeIndicatorColor),
      ],
    );
  }

  Widget _buildIndicatorCircle(int step, String label, bool isActive, Color color) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? color : Colors.transparent,
            border: Border.all(color: isActive ? color : AppColors.textTertiary, width: 2),
          ),
          child: Center(
            child: Text(
              '$step',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.black : AppColors.textTertiary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.bold,
            color: isActive ? AppColors.textPrimary : AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildIndicatorLine(bool isActive, Color activeColor, Color inactiveColor) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14.0),
        child: Container(
          height: 2,
          color: isActive ? activeColor : inactiveColor,
        ),
      ),
    );
  }

  // STEP 1 - ACCOUNT CREATION
  Widget _buildStep1Form(bool isDark, Color accentColor) {
    return Form(
      key: _formKey1,
      child: GlassCard(
        tier: GlassTier.tier2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GlassTextField(
              controller: _nameController,
              label: 'Full Name',
              hint: 'John Doe',
              prefixIcon: Icons.person_outline,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter your name';
                return null;
              },
            ),
            const SizedBox(height: 16),
            GlassTextField(
              controller: _emailController,
              label: 'Email',
              hint: 'you@domain.com',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter email';
                if (!val.contains('@')) return 'Please enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 16),
            GlassTextField(
              controller: _phoneController,
              label: 'Phone Number',
              hint: '+91 98765 43210',
              prefixIcon: Icons.phone_android_outlined,
              keyboardType: TextInputType.phone,
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Please enter your phone number';
                return null;
              },
            ),
            const SizedBox(height: 16),
            GlassTextField(
              controller: _passwordController,
              label: 'Password',
              hint: '••••••••',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              validator: (val) {
                if (val == null || val.isEmpty) return 'Please enter a password';
                if (val.length < 8) return 'Password must be at least 8 characters';
                return null;
              },
            ),
            const SizedBox(height: 16),
            GlassTextField(
              controller: _confirmPasswordController,
              label: 'Confirm Password',
              hint: '••••••••',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              validator: (val) {
                if (val != _passwordController.text) return 'Passwords do not match';
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox.adaptive(
                  value: _agreeToTerms,
                  activeColor: accentColor,
                  onChanged: (val) {
                    setState(() {
                      _agreeToTerms = val ?? false;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    'I agree to the Terms of Service & Privacy Policy',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Create Account',
              onPressed: _handleStep1Next,
            ),
          ],
        ),
      ),
    );
  }

  // STEP 2 - EMAIL VERIFICATION
  Widget _buildStep2Form(bool isDark, Color accentColor) {
    return Column(
      children: [
        Text(
          'Verify Your Email',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          'We sent a 6-digit confirmation code to ${_emailController.text}. Please enter the digits below.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.5,
            color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            6,
            (idx) => SizedBox(
              width: 46,
              height: 54,
              child: GlassCard(
                tier: GlassTier.tier2,
                padding: EdgeInsets.zero,
                child: Center(
                  child: TextField(
                    controller: _otpControllers[idx],
                    focusNode: _otpFocusNodes[idx],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    maxLength: 1,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (val) {
                      if (val.isNotEmpty && idx < 5) {
                        _otpFocusNodes[idx + 1].requestFocus();
                      } else if (val.isEmpty && idx > 0) {
                        _otpFocusNodes[idx - 1].requestFocus();
                      }
                      if (_otpControllers.map((c) => c.text).join().length == 6) {
                        _handleVerifyOTP();
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Didn\'t receive code? ', style: TextStyle(fontSize: 12.5, color: AppColors.textTertiary)),
            _resendSeconds > 0
                ? Text('Resend in 0:${_resendSeconds.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.textTertiary))
                : GestureDetector(
                    onTap: _startTimer,
                    child: Text('Resend Now', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: accentColor)),
                  ),
          ],
        ),
        const SizedBox(height: 32),
        PrimaryButton(
          text: 'Verify Code',
          isLoading: _isVerifying,
          onPressed: _handleVerifyOTP,
        ),
      ],
    );
  }

  // STEP 3 - PROFILE SETUP
  Widget _buildStep3Form(bool isDark, Color accentColor) {
    return GlassCard(
      tier: GlassTier.tier2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Avatar upload mock
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: accentColor.withValues(alpha: 0.12),
                  child: Icon(Icons.person, size: 48, color: accentColor),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: accentColor,
                    child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          GlassTextField(
            controller: _companyController,
            label: 'Company / Business Name (Optional)',
            hint: 'E.g. NZXTGEN Labs',
            prefixIcon: Icons.business,
          ),
          const SizedBox(height: 20),

          // Industry Select Dropdown
          Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 6.0),
            child: Text(
              'Industry',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ),
          Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: isDark ? AppColors.surfaceLevel2 : AppColors.lightSurfaceLevel2,
              border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedIndustry,
                dropdownColor: isDark ? AppColors.surfaceLevel2 : Colors.white,
                items: _industries.map((ind) {
                  return DropdownMenuItem<String>(
                    value: ind,
                    child: Text(ind, style: const TextStyle(fontSize: 13.5)),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedIndustry = val ?? 'SaaS / Tech';
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Source Select Dropdown
          Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 6.0),
            child: Text(
              'How did you hear about us? (Optional)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ),
          Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: isDark ? AppColors.surfaceLevel2 : AppColors.lightSurfaceLevel2,
              border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _source,
                dropdownColor: isDark ? AppColors.surfaceLevel2 : Colors.white,
                items: _sources.map((src) {
                  return DropdownMenuItem<String>(
                    value: src,
                    child: Text(src, style: const TextStyle(fontSize: 13.5)),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _source = val ?? 'Search Engine';
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            text: 'Complete Setup & Enter Workspace',
            isLoading: _isCompleting,
            onPressed: _handleProfileSetup,
          ),
        ],
      ),
    );
  }
}
