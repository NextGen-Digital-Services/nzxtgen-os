import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/status_badge.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Pending', 'Paid', 'Overdue'];

  final List<Map<String, dynamic>> _invoices = [
    {
      'id': 'INV-2026-004',
      'project': 'Mobile App Development MVP',
      'amount': 50000,
      'date': 'Jun 12, 2026',
      'due': 'Jun 25, 2026',
      'status': 'Pending',
      'icon': Icons.phone_android,
      'items': [
        {'desc': 'UX Design & Figma Sprints (30%)', 'price': 30000},
        {'desc': 'Database Schema Setup (20%)', 'price': 20000},
      ]
    },
    {
      'id': 'INV-2026-003',
      'project': 'AI Automations Pipeline',
      'amount': 30000,
      'date': 'May 20, 2026',
      'due': 'May 30, 2026',
      'status': 'Paid',
      'icon': Icons.auto_awesome,
      'items': [
        {'desc': 'Make/Zapier Automations (100%)', 'price': 30000},
      ]
    },
    {
      'id': 'INV-2026-002',
      'project': 'Website Design Conversion',
      'amount': 25000,
      'date': 'May 02, 2026',
      'due': 'May 12, 2026',
      'status': 'Paid',
      'icon': Icons.web,
      'items': [
        {'desc': 'Landing Page Figma Code (100%)', 'price': 25000},
      ]
    },
    {
      'id': 'INV-2026-001',
      'project': 'Consulting Audits Retainer',
      'amount': 15000,
      'date': 'Apr 10, 2026',
      'due': 'Apr 20, 2026',
      'status': 'Overdue',
      'icon': Icons.analytics,
      'items': [
        {'desc': 'Architecture Sprints Audits (100%)', 'price': 15000},
      ]
    },
  ];

  void _showInvoiceDetails(Map<String, dynamic> inv) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? AppColors.primaryAccent : AppColors.accentBright;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GlassCard(
          tier: GlassTier.tier4,
          borderRadius: 24,
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    inv['id'],
                    style: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  _buildBadge(inv['status']),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                inv['project'],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 24),
              const Text(
                'LINE ITEMS',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textTertiary),
              ),
              const SizedBox(height: 8),
              ...List.generate(
                (inv['items'] as List).length,
                (index) {
                  final item = inv['items'][index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item['desc'], style: const TextStyle(fontSize: 12.5)),
                        Text('₹${item['price']}', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                },
              ),
              const Divider(color: Colors.white10, height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(
                    '₹${inv['amount']}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryAccent),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              if (inv['status'] != 'Paid')
                PrimaryButton(
                  text: 'Pay Invoice Now',
                  onPressed: () {
                    context.pop();
                    _triggerCheckout(inv);
                  },
                ),
              const SizedBox(height: 12),
              PrimaryButton(
                text: 'Download PDF Receipt',
                variant: ButtonVariant.ghost,
                onPressed: () {
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Downloading invoice PDF...'), backgroundColor: AppColors.secondary),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _triggerCheckout(Map<String, dynamic> inv) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? AppColors.primaryAccent : AppColors.accentBright;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _CheckoutModal(inv: inv, primaryAccent: primaryAccent);
      },
    ).then((success) {
      if (success == true) {
        setState(() {
          inv['status'] = 'Paid';
        });
      }
    });
  }

  Widget _buildBadge(String status) {
    switch (status) {
      case 'Paid':
        return const StatusBadge(label: 'Paid', type: StatusType.completed);
      case 'Overdue':
        return const StatusBadge(label: 'Overdue', type: StatusType.cancelled);
      default:
        return const StatusBadge(label: 'Pending', type: StatusType.pending);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? AppColors.primaryAccent : AppColors.accentBright;

    final filtered = _invoices.where((inv) {
      if (_selectedFilter == 'All') return true;
      return inv['status'] == _selectedFilter;
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.baseCanvas : AppColors.lightBaseCanvas,
      appBar: AppBar(
        title: const Text('Payments & Invoices', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BALANCE OVERVIEW CARD
              GlassCard(
                tier: GlassTier.tier3,
                showGlow: true,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('TOTAL INVESTED', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textTertiary)),
                    const SizedBox(height: 8),
                    Text(
                      '₹70,000',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: primaryAccent,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.white10),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('PENDING AMOUNT', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textTertiary)),
                              SizedBox(height: 4),
                              Text('₹50,000', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.warning)),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          color: Colors.white10,
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('CREDIT BALANCE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textTertiary)),
                                SizedBox(height: 4),
                                Text('₹0.00', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.secondary)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Filter chips
              SizedBox(
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
              const SizedBox(height: 24),

              // INVOICE LIST
              Text(
                'INVOICES',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
              ),
              const SizedBox(height: 12),
              ...List.generate(
                filtered.length,
                (index) {
                  final inv = filtered[index];
                  final isPending = inv['status'] == 'Pending';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: GlassCard(
                      tier: GlassTier.tier2,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      borderWidth: isPending ? 1.5 : 1.0,
                      onTap: () => _showInvoiceDetails(inv),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: primaryAccent.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(inv['icon'], color: primaryAccent, size: 20),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  inv['id'],
                                  style: GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textTertiary),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  inv['project'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                const SizedBox(height: 2),
                                Text('Due: ${inv['due']}', style: const TextStyle(fontSize: 10.5, color: AppColors.textTertiary)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '₹${inv['amount']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.5,
                                  color: isPending ? AppColors.warning : (isDark ? Colors.white : Colors.black),
                                ),
                              ),
                              const SizedBox(height: 4),
                              _buildBadge(inv['status']),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // SAVED METHODS
              Text(
                'PAYMENT METHODS',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
              ),
              const SizedBox(height: 12),
              GlassCard(
                tier: GlassTier.tier2,
                child: Column(
                  children: [
                    _buildPaymentMethodRow('HDFC Bank Debit Card', '•••• 4209', '09/29', Icons.credit_card),
                    const Divider(color: Colors.white10, height: 20),
                    _buildPaymentMethodRow('Google Pay UPI ID', 'riaz@okhdfc', '', Icons.account_balance_wallet_outlined),
                    const Divider(color: Colors.white10, height: 20),
                    ListTile(
                      leading: const Icon(Icons.add, color: AppColors.primaryAccent),
                      title: const Text('Add Payment Method', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      contentPadding: EdgeInsets.zero,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodRow(String name, String detail, String expiry, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 20),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              if (detail.isNotEmpty)
                Text('$detail • Expiry $expiry', style: const TextStyle(fontSize: 10.5, color: AppColors.textTertiary)),
            ],
          ),
        ),
        const Icon(Icons.check_circle_outline, color: AppColors.secondary, size: 16),
      ],
    );
  }
}

class _CheckoutModal extends StatefulWidget {
  final Map<String, dynamic> inv;
  final Color primaryAccent;

  const _CheckoutModal({
    required this.inv,
    required this.primaryAccent,
  });

  @override
  State<_CheckoutModal> createState() => _CheckoutModalState();
}

class _CheckoutModalState extends State<_CheckoutModal> {
  bool _isProcessing = false;
  bool _isSuccess = false;

  void _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isProcessing = false;
        _isSuccess = true;
      });
    }

    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: GlassCard(
        tier: GlassTier.tier3,
        width: MediaQuery.of(context).size.width * 0.85,
        child: AnimatedCrossFade(
          firstChild: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Complete Payment',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Amount to Pay',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: AppColors.textTertiary),
              ),
              const SizedBox(height: 4),
              Text(
                '₹${widget.inv['amount']}',
                textAlign: TextAlign.center,
                style: GoogleFonts.spaceGrotesk(fontSize: 32, fontWeight: FontWeight.bold, color: widget.primaryAccent),
              ),
              const SizedBox(height: 24),
              const Text(
                'PAY WITH SAVED CARD',
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textTertiary),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.credit_card, color: Colors.blueAccent),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text('HDFC Bank Card (•••• 4209)', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Pay Secured Now',
                isLoading: _isProcessing,
                onPressed: _processPayment,
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                text: 'Cancel',
                variant: ButtonVariant.ghost,
                onPressed: () => Navigator.of(context).pop(false),
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline, size: 10, color: AppColors.textTertiary),
                  SizedBox(width: 4),
                  Text('Secured by 256-bit SSL Gateway', style: TextStyle(fontSize: 9, color: AppColors.textTertiary)),
                ],
              ),
            ],
          ),
          secondChild: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_outline, color: AppColors.secondary, size: 64),
              SizedBox(height: 16),
              Text(
                'Payment Success!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Invoice settled in real-time.',
                style: TextStyle(fontSize: 11, color: AppColors.textTertiary),
              ),
              SizedBox(height: 16),
            ],
          ),
          crossFadeState: _isSuccess ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }
}
