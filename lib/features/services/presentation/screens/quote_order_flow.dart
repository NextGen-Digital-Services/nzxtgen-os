import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../home/presentation/screens/main_navigation_screen.dart';

class QuoteOrderFlow extends StatefulWidget {
  const QuoteOrderFlow({super.key});

  @override
  State<QuoteOrderFlow> createState() => _QuoteOrderFlowState();
}

class _QuoteOrderFlowState extends State<QuoteOrderFlow> {
  int _step = 1; // 1: Brief, 2: Details, 3: Review, 4: Success

  // Step 1 states
  final _briefController = TextEditingController();
  String _selectedTimeline = 'ASAP';
  final List<String> _timelines = ['ASAP', '1 Month', 'Flexible'];
  String _selectedBudget = '₹25,000 - ₹50,000';
  final List<String> _budgets = ['< ₹25,000', '₹25,000 - ₹50,000', '₹50,000 - ₹1,000,000', '₹1,000,000+'];
  final List<String> _goals = ['New Web Design', 'Mobile Launch', 'AI Automations', 'Brand Refresh'];
  final List<String> _selectedGoals = [];

  // Step 2 states
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _companyController = TextEditingController();
  String _contactMethod = 'WhatsApp';
  final List<String> _contactMethods = ['WhatsApp', 'Email', 'Call'];
  bool _termsAccepted = false;

  @override
  void initState() {
    super.initState();
    // Prefill if authenticated
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.isAuthenticated) {
      _nameController.text = auth.username ?? '';
      _emailController.text = auth.email ?? '';
    }
  }

  @override
  void dispose() {
    _briefController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_step == 1) {
      if (_briefController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please describe your project brief'), backgroundColor: AppColors.error),
        );
        return;
      }
      setState(() => _step = 2);
    } else if (_step == 2) {
      if (_nameController.text.trim().isEmpty || _emailController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please complete your name and email'), backgroundColor: AppColors.error),
        );
        return;
      }
      setState(() => _step = 3);
    }
  }

  void _submitRequest() async {
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept terms to submit request'), backgroundColor: AppColors.error),
      );
      return;
    }

    setState(() => _step = 4); // Goto success state
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? AppColors.primaryAccent : AppColors.accentBright;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: GlassCard(
        tier: GlassTier.tier4,
        borderRadius: 24,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.white12,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Step Indicator (Only for steps 1-3)
            if (_step <= 3) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Step $_step of 3',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: primaryAccent),
                  ),
                  Row(
                    children: List.generate(
                      3,
                      (index) => Container(
                        width: 16,
                        height: 4,
                        margin: const EdgeInsets.only(left: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: _step >= index + 1 ? primaryAccent : Colors.white12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],

            // Dynamic forms
            AnimatedCrossFade(
              firstChild: _buildStep1Brief(isDark, primaryAccent),
              secondChild: _step == 2
                  ? _buildStep2Details(isDark, primaryAccent)
                  : (_step == 3 ? _buildStep3Review(isDark, primaryAccent) : _buildStep4Success(isDark, primaryAccent)),
              crossFadeState: _step == 1 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 250),
            ),
          ],
        ),
      ),
    );
  }

  // STEP 1 - PROJECT BRIEF
  Widget _buildStep1Brief(bool isDark, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Describe your project', style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GlassTextField(
          controller: _briefController,
          label: 'Project Scope details',
          hint: 'We need to build a custom Flutter CRM with offline-first local SQL storage sync...',
          maxLines: 4,
          maxLength: 300,
        ),
        const SizedBox(height: 20),
        const Text('What\'s your goal?', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textTertiary)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _goals.map((g) {
            final isSel = _selectedGoals.contains(g);
            return ChoiceChip(
              label: Text(g, style: TextStyle(fontSize: 11, color: isSel ? Colors.white : AppColors.textTertiary)),
              selected: isSel,
              selectedColor: accentColor,
              onSelected: (val) {
                setState(() {
                  if (val) {
                    _selectedGoals.add(g);
                  } else {
                    _selectedGoals.remove(g);
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Timeline', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textTertiary)),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: _selectedTimeline,
                    dropdownColor: isDark ? AppColors.surfaceLevel3 : Colors.white,
                    items: _timelines.map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 13)))).toList(),
                    onChanged: (val) => setState(() => _selectedTimeline = val ?? 'ASAP'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Budget', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textTertiary)),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: _selectedBudget,
                    dropdownColor: isDark ? AppColors.surfaceLevel3 : Colors.white,
                    items: _budgets.map((b) => DropdownMenuItem(value: b, child: Text(b, style: const TextStyle(fontSize: 13)))).toList(),
                    onChanged: (val) => setState(() => _selectedBudget = val ?? '< ₹25,000'),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        PrimaryButton(
          text: 'Next Details →',
          onPressed: _nextStep,
        ),
      ],
    );
  }

  // STEP 2 - YOUR DETAILS
  Widget _buildStep2Details(bool isDark, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your Details', style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GlassTextField(
          controller: _nameController,
          label: 'Contact Name',
          hint: 'Alex Carter',
          prefixIcon: Icons.person_outline,
        ),
        const SizedBox(height: 14),
        GlassTextField(
          controller: _emailController,
          label: 'Work Email',
          hint: 'alex@company.com',
          prefixIcon: Icons.email_outlined,
        ),
        const SizedBox(height: 14),
        GlassTextField(
          controller: _companyController,
          label: 'Company Name (Optional)',
          hint: 'Company Inc.',
          prefixIcon: Icons.business,
        ),
        const SizedBox(height: 14),
        const Text('Preferred contact method', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textTertiary)),
        const SizedBox(height: 8),
        Row(
          children: _contactMethods.map((m) {
            final isSel = _contactMethod == m;
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Text(m, style: TextStyle(fontSize: 11, color: isSel ? Colors.white : AppColors.textTertiary)),
                selected: isSel,
                selectedColor: accentColor,
                onSelected: (val) {
                  if (val) {
                    setState(() => _contactMethod = m);
                  }
                },
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            Expanded(
              child: PrimaryButton(
                text: 'Back',
                variant: ButtonVariant.ghost,
                onPressed: () => setState(() => _step = 1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PrimaryButton(
                text: 'Review',
                onPressed: _nextStep,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // STEP 3 - REVIEW & SUBMIT
  Widget _buildStep3Review(bool isDark, Color accentColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Review Brief', style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        GlassCard(
          tier: GlassTier.tier2,
          child: Column(
            children: [
              _buildReviewRow('Scope Brief', _briefController.text),
              const Divider(color: Colors.white10, height: 20),
              _buildReviewRow('Target Budget', _selectedBudget),
              const Divider(color: Colors.white10, height: 20),
              _buildReviewRow('Timeline', _selectedTimeline),
              const Divider(color: Colors.white10, height: 20),
              _buildReviewRow('Preferred Contact', _contactMethod),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Checkbox.adaptive(
              value: _termsAccepted,
              activeColor: accentColor,
              onChanged: (val) => setState(() => _termsAccepted = val ?? false),
            ),
            const Expanded(
              child: Text(
                'I confirm these requirements are accurate to trigger solutions proposals.',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            Expanded(
              child: PrimaryButton(
                text: 'Back',
                variant: ButtonVariant.ghost,
                onPressed: () => setState(() => _step = 2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PrimaryButton(
                text: 'Submit Request',
                onPressed: _submitRequest,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewRow(String label, String val) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textTertiary)),
        Expanded(
          child: Text(val, style: const TextStyle(fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  // STEP 4 - SUCCESS
  Widget _buildStep4Success(bool isDark, Color accentColor) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.secondary.withValues(alpha: 0.15),
          ),
          child: const Icon(Icons.check_circle_outline, size: 56, color: AppColors.secondary),
        ),
        const SizedBox(height: 24),
        Text('Request Submitted!', style: GoogleFonts.spaceGrotesk(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text(
          'Our team has captured your brief. We will reach out within 24 hours to schedule design wireframes walkthrough.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary, height: 1.5),
        ),
        const SizedBox(height: 32),
        PrimaryButton(
          text: 'View Dashboard Portal',
          onPressed: () {
            context.pop();
            // Switch navigation to tab index 2
            final navState = context.findAncestorStateOfType<MainNavigationScreenState>();
            navState?.setIndex(2);
          },
        ),
        const SizedBox(height: 12),
        PrimaryButton(
          text: 'Back to Home',
          variant: ButtonVariant.ghost,
          onPressed: () => context.pop(),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
