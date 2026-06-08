import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/routes/app_routes.dart';
import '../../data/services_data.dart';
import '../../data/models/service_model.dart';

class ServiceDetailScreen extends StatelessWidget {
  final String serviceId;

  const ServiceDetailScreen({
    super.key,
    required this.serviceId,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Find matching service
    final service = ServicesData.services.firstWhere(
      (s) => s.id == serviceId,
      orElse: () => const ServiceModel(
        id: '',
        title: 'Unknown Service',
        description: '',
        overview: '',
        category: '',
        icon: Icons.error,
        imageUrl: '',
        benefits: [],
        features: [],
        timeline: [],
        pricing: [],
        faqs: [],
        portfolio: [],
      ),
    );

    if (service.id.isEmpty) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.broken_image_outlined, size: 64, color: Colors.redAccent),
              const SizedBox(height: 16),
              const Text('Service Not Found', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('Back to Store'),
              ),
            ],
          ),
        ),
      );
    }

    final primaryAccent = isDark ? AppColors.accentCyan : AppColors.accentPurple;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background ambient spot
          Positioned(
            top: 50,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryAccent.withValues(alpha: 0.04),
                boxShadow: [
                  BoxShadow(
                    color: primaryAccent.withValues(alpha: 0.04),
                    blurRadius: 100,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Minimal Back/Header bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                        onPressed: () => context.go(AppRoutes.home),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.share_outlined, size: 18),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                // Scrollable Sheet Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // App Store Style Header Row
                        _buildAppStoreHeader(context, service, primaryAccent, isDark),
                        const SizedBox(height: 28),

                        // Scrollable Media / Screenshot Cards
                        _buildHorizontalGallery(service, isDark),
                        const SizedBox(height: 28),

                        // Linear Specifications Details Grid
                        _buildLinearSpecsTable(context, service, isDark, primaryAccent),
                        const SizedBox(height: 28),

                        // Overview Description
                        Text(
                          'Description',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          service.overview,
                          style: TextStyle(
                            fontSize: 14.5,
                            height: 1.6,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Delivery Milestones
                        _buildMilestonesTimeline(context, service, isDark, primaryAccent),
                        const SizedBox(height: 28),

                        // Pricing Plans
                        _buildPricingSection(context, service, isDark, primaryAccent),
                        const SizedBox(height: 28),

                        // Frequently Asked Questions
                        _buildAccordionFaqs(context, service, isDark, primaryAccent),
                      ],
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

  Widget _buildAppStoreHeader(
    BuildContext context,
    ServiceModel service,
    Color accentColor,
    bool isDark,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rounded App shape icon
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: accentColor.withValues(alpha: 0.1),
            border: Border.all(color: accentColor.withValues(alpha: 0.2)),
          ),
          child: Icon(service.icon, size: 48, color: accentColor),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                service.title,
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22, height: 1.2),
              ),
              const SizedBox(height: 4),
              Text(
                service.category.toUpperCase(),
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: accentColor),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 14),
                  const SizedBox(width: 4),
                  const Text('4.9  (120 Ratings)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                text: 'GET',
                height: 36,
                width: 110,
                onPressed: () => context.go(AppRoutes.signup),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalGallery(ServiceModel service, bool isDark) {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: service.portfolio.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final item = service.portfolio[index];
          return Container(
            width: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.1)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl: item.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.broken_image_outlined),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLinearSpecsTable(
    BuildContext context,
    ServiceModel service,
    bool isDark,
    Color accentColor,
  ) {
    final specItems = [
      {'label': 'DEVELOPER', 'value': 'NZXTGEN Inc.'},
      {'label': 'SLA TIME', 'value': '24/7 Priority'},
      {'label': 'TIMELINE', 'value': service.timeline.first.duration},
      {'label': 'DEPLOYED TO', 'value': 'Stores & Web'},
    ];

    return GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(20),
      child: Responsive(
        mobile: Column(
          children: List.generate(
            specItems.length,
            (index) {
              final spec = specItems[index];
              return Padding(
                padding: EdgeInsets.only(bottom: index == specItems.length - 1 ? 0 : 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      spec['label']!,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    Text(
                      spec['value']!,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        desktop: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            specItems.length,
            (index) {
              final spec = specItems[index];
              return Column(
                children: [
                  Text(
                    spec['label']!,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    spec['value']!,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMilestonesTimeline(
    BuildContext context,
    ServiceModel service,
    bool isDark,
    Color accentColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Workflow Timeline',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 16),
        Column(
          children: List.generate(
            service.timeline.length,
            (index) {
              final step = service.timeline[index];
              final isLast = index == service.timeline.length - 1;

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: accentColor, width: 2),
                          ),
                          child: Center(
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: accentColor),
                            ),
                          ),
                        ),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 2,
                              color: accentColor.withValues(alpha: 0.3),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: GlassCard(
                          padding: const EdgeInsets.all(16),
                          borderRadius: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    step.title,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  Text(
                                    step.duration,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: accentColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                step.description,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPricingSection(
    BuildContext context,
    ServiceModel service,
    bool isDark,
    Color accentColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subscriptions Available',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 16),
        Responsive(
          mobile: Column(
            children: List.generate(
              service.pricing.length,
              (idx) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildPricingCard(context, service.pricing[idx], isDark, accentColor),
              ),
            ),
          ),
          desktop: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              service.pricing.length,
              (idx) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: idx == service.pricing.length - 1 ? 0 : 16.0),
                  child: _buildPricingCard(context, service.pricing[idx], isDark, accentColor),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPricingCard(
    BuildContext context,
    PricingPlan plan,
    bool isDark,
    Color accentColor,
  ) {
    return GlassCard(
      borderRadius: 24,
      padding: const EdgeInsets.all(24),
      borderWidth: plan.isPopular ? 1.5 : 1.0,
      borderGradient: plan.isPopular
          ? LinearGradient(colors: [AppColors.accentCyan, AppColors.accentPurple])
          : null,
      showGlow: plan.isPopular,
      glowColor: accentColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                plan.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              if (plan.isPopular)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: accentColor.withValues(alpha: 0.15),
                  ),
                  child: Text(
                    'POPULAR',
                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: accentColor),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                plan.price,
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
              ),
              const SizedBox(width: 4),
              Text(
                '/ ${plan.period}',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white10),
          const SizedBox(height: 12),
          ...List.generate(
            plan.features.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Icon(Icons.check, color: accentColor, size: 14),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      plan.features[index],
                      style: const TextStyle(fontSize: 12.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            text: 'Launch Plan',
            height: 44,
            outline: !plan.isPopular,
            onPressed: () => context.go(AppRoutes.signup),
          ),
        ],
      ),
    );
  }

  Widget _buildAccordionFaqs(
    BuildContext context,
    ServiceModel service,
    bool isDark,
    Color accentColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FAQ',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 16),
        ...List.generate(
          service.faqs.length,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _FaqTile(faq: service.faqs[index], isDark: isDark, accentColor: accentColor),
          ),
        ),
      ],
    );
  }
}

class _FaqTile extends StatefulWidget {
  final FaqItem faq;
  final bool isDark;
  final Color accentColor;

  const _FaqTile({
    required this.faq,
    required this.isDark,
    required this.accentColor,
  });

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      borderRadius: 16,
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
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
                  widget.faq.question,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                ),
              ),
              AnimatedRotation(
                turns: _isExpanded ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.expand_more,
                  color: widget.accentColor,
                ),
              ),
            ],
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: Text(
                widget.faq.answer,
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.5,
                  color: widget.isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}
