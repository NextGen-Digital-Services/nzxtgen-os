import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_text_field.dart';
import '../../data/services_data.dart';
import '../../data/models/service_model.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final List<String> _categories = ['All', 'Development', 'Marketing', 'Design', 'AI'];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? AppColors.accentCyan : AppColors.accentPurple;

    // Filter services based on category and search query
    final filteredServices = ServicesData.services.where((service) {
      final matchesCategory = _selectedCategory == 'All' || service.category == _selectedCategory;
      final matchesSearch = service.title.toLowerCase().contains(_searchQuery) ||
          service.description.toLowerCase().contains(_searchQuery) ||
          service.category.toLowerCase().contains(_searchQuery);
      return matchesCategory && matchesSearch;
    }).toList();

    // Spotlight service (e.g. AI Automation)
    final spotlightService = ServicesData.services.firstWhere(
      (s) => s.id == 'ai-automation',
      orElse: () => ServicesData.services.first,
    );

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Ambient neon spot
          Positioned(
            top: 100,
            left: -150,
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0, bottom: 120.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Store Style header title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NZXTGEN SOLUTIONS',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                              color: primaryAccent,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Service Store',
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                        ],
                      ),
                      // Small App Store profile thumbnail mapping
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: primaryAccent.withValues(alpha: 0.15),
                        child: Icon(Icons.person_outline, color: primaryAccent, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Search Bar
                  GlassTextField(
                    controller: _searchController,
                    label: 'Search Store',
                    hint: 'Type a capability (e.g. app dev, seo)...',
                    prefixIcon: Icons.search,
                  ),
                  const SizedBox(height: 20),

                  // Filter Categories Bar
                  _buildCategoriesList(isDark),
                  const SizedBox(height: 28),

                  // App Store Today Spotlight Banner (Only show when not filtering search)
                  if (_searchQuery.isEmpty && _selectedCategory == 'All') ...[
                    _buildTodaySpotlight(context, spotlightService, isDark, primaryAccent),
                    const SizedBox(height: 32),
                  ],

                  // Feed list header
                  Text(
                    _selectedCategory == 'All' ? 'Popular Services' : '$_selectedCategory Services',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // Services Feed Items list (App Store Layout)
                  if (filteredServices.isEmpty)
                    _buildEmptyState(isDark)
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredServices.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) => _buildAppStoreListItem(context, filteredServices[index], isDark, primaryAccent),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesList(bool isDark) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = _selectedCategory == cat;
          final activeColor = isDark ? AppColors.accentCyan : AppColors.accentPurple;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = cat;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: isSelected
                    ? activeColor
                    : (isDark ? AppColors.darkCardBg : AppColors.lightCardBg),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
              ),
              child: Center(
                child: Text(
                  cat,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected ? Colors.white : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTodaySpotlight(
    BuildContext context,
    ServiceModel service,
    bool isDark,
    Color accentColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TODAY\'S FEATURED',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GlassCard(
            borderRadius: 28,
            padding: const EdgeInsets.all(24),
            showGlow: true,
            glowColor: accentColor,
            onTap: () => context.go('/services/${service.id}'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: accentColor.withValues(alpha: 0.15),
                      ),
                      child: Icon(service.icon, color: accentColor, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.category.toUpperCase(),
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: accentColor),
                          ),
                          Text(
                            service.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: isDark ? Colors.white10 : Colors.black12,
                      ),
                      child: Text(
                        'GET',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: accentColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Accelerate your operations with automated support loops, automated invoice scripts, and neural agent models.',
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.5,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppStoreListItem(
    BuildContext context,
    ServiceModel service,
    bool isDark,
    Color accentColor,
  ) {
    // Find the starting price (lowest pricing plan or fallback)
    final startingPrice = service.pricing.isNotEmpty ? service.pricing.first.price : 'Custom';
    
    // Calculate estimated total timeline duration
    String timelineText = 'Flexible';
    if (service.timeline.isNotEmpty) {
      if (service.timeline.length == 1) {
        timelineText = service.timeline.first.duration;
      } else {
        timelineText = '${service.timeline.first.duration.split(" ").last} - ${service.timeline.last.duration}';
      }
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GlassCard(
        borderRadius: 22,
        padding: const EdgeInsets.all(18),
        onTap: () => context.go('/services/${service.id}'),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App icon visual style
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: accentColor.withValues(alpha: 0.1),
                border: Border.all(color: accentColor.withValues(alpha: 0.2)),
              ),
              child: Center(
                child: Icon(
                  service.icon,
                  size: 26,
                  color: accentColor,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Metadata
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15.5),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          startingPrice,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: accentColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.access_time_rounded,
                        size: 11,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        timelineText,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    service.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.4,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // App Store Purchase GET button
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.06),
                  ),
                  child: Text(
                    'GET',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w900,
                      color: isDark ? AppColors.accentCyan : AppColors.accentPurple,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 48),
          Icon(
            Icons.search_off,
            size: 48,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Services Found',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'We couldn\'t find any matches. Try again.',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
