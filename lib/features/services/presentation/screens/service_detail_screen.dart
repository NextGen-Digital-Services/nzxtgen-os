import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../data/services_data.dart';
import 'quote_order_flow.dart';

class ServiceDetailScreen extends StatelessWidget {
  final String serviceId;

  const ServiceDetailScreen({
    super.key,
    required this.serviceId,
  });

  Gradient _getGradient(String id) {
    switch (id) {
      case 'website-development':
        return const LinearGradient(colors: [Colors.indigo, Colors.purple]);
      case 'app-development':
        return const LinearGradient(colors: [Colors.cyan, Colors.teal]);
      case 'ai-automation':
        return const LinearGradient(colors: [Colors.indigo, Colors.blueAccent]);
      default:
        return AppColors.heroGradient;
    }
  }

  void _openQuoteSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const QuoteOrderFlow(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final service = ServicesData.services.firstWhere(
      (s) => s.id == serviceId,
      orElse: () => ServicesData.services.first,
    );

    final primaryAccent = isDark ? AppColors.primaryAccent : AppColors.accentBright;
    final startingPrice = service.pricing.isNotEmpty ? service.pricing.first.price : 'Custom';

    return Scaffold(
      backgroundColor: isDark ? AppColors.baseCanvas : AppColors.lightBaseCanvas,
      body: Stack(
        children: [
          // Scrollable content
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Hero Parallax App Bar
              SliverAppBar(
                expandedHeight: 220.0,
                pinned: true,
                backgroundColor: isDark ? AppColors.baseCanvas : AppColors.lightBaseCanvas,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                  onPressed: () => context.pop(),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share_outlined, size: 20),
                    onPressed: () {},
                  )
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: _getGradient(service.id),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          right: -50,
                          top: -50,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40),
                            Icon(service.icon, size: 64, color: Colors.white),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.white24,
                              ),
                              child: Text(
                                service.category.toUpperCase(),
                                style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Content Details list
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SERVICE OVERVIEW
                      Text(
                        service.title,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        service.overview,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // WHAT'S INCLUDED DELIVERABLES LIST
                      _buildSectionLabel('WHAT\'S INCLUDED'),
                      const SizedBox(height: 12),
                      ...List.generate(
                        service.benefits.length,
                        (index) => Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: GlassCard(
                            tier: GlassTier.tier2,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_outline, color: AppColors.secondary, size: 18),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    service.benefits[index],
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // CHOOSE A PACKAGE
                      _buildSectionLabel('CHOOSE A PACKAGE'),
                      const SizedBox(height: 12),
                      ...List.generate(
                        service.pricing.length,
                        (idx) {
                          final plan = service.pricing[idx];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            child: GlassCard(
                              tier: GlassTier.tier2,
                              borderWidth: plan.isPopular ? 1.5 : 1.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(plan.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15.5)),
                                      if (plan.isPopular)
                                        const StatusBadge(label: 'POPULAR', type: StatusType.premium),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(plan.price, style: GoogleFonts.spaceGrotesk(fontSize: 24, fontWeight: FontWeight.bold, color: primaryAccent)),
                                      const SizedBox(width: 4),
                                      Text('/ ${plan.period}', style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  ...List.generate(
                                    plan.features.length,
                                    (fIdx) => Padding(
                                      padding: const EdgeInsets.only(bottom: 6.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.check, color: primaryAccent, size: 12),
                                          const SizedBox(width: 8),
                                          Expanded(child: Text(plan.features[fIdx], style: const TextStyle(fontSize: 12))),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 28),

                      // FAQ SECTION
                      _buildSectionLabel('FREQUENTLY ASKED'),
                      const SizedBox(height: 12),
                      ...List.generate(
                        service.faqs.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: _FaqTile(q: service.faqs[index].question, a: service.faqs[index].answer, accentColor: primaryAccent),
                        ),
                      ),

                      // Spacing for Bottom action bar clearance
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // STICKY BOTTOM ACTION BAR (Glass Tier 4)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GlassCard(
              tier: GlassTier.tier4,
              borderRadius: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Starting at', style: TextStyle(fontSize: 9.5, color: AppColors.textTertiary)),
                        const SizedBox(height: 2),
                        Text(
                          startingPrice,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryAccent,
                          ),
                        ),
                      ],
                    ),
                    PrimaryButton(
                      text: 'Get Quote',
                      width: 140,
                      height: 44,
                      onPressed: () => _openQuoteSheet(context),
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

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
        color: AppColors.textTertiary,
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  final String q;
  final String a;
  final Color accentColor;

  const _FaqTile({
    required this.q,
    required this.a,
    required this.accentColor,
  });

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassCard(
      tier: GlassTier.tier2,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      onTap: () {
        setState(() {
          _expanded = !_expanded;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.q,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              AnimatedRotation(
                turns: _expanded ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Icon(Icons.keyboard_arrow_down, color: widget.accentColor),
              )
            ],
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                widget.a,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                  height: 1.5,
                ),
              ),
            ),
            crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          )
        ],
      ),
    );
  }
}
