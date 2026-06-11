import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../data/services_data.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final List<String> _categories = ['All', 'Development', 'Marketing', 'Design', 'AI & Automation'];

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

  List<String> _getTags(String id) {
    switch (id) {
      case 'website-development':
        return ['React', 'Next.js', 'WordPress'];
      case 'app-development':
        return ['Flutter', 'React Native'];
      case 'crm-development':
        return ['Custom', 'Integration'];
      case 'ai-automation':
        return ['GPT-4', 'Zapier', 'Custom AI'];
      case 'seo':
        return ['On-Page', 'Technical', 'Link Building'];
      case 'meta-ads':
        return ['Facebook', 'Instagram', 'Reels'];
      case 'google-ads':
        return ['Search', 'Display', 'Shopping'];
      case 'branding':
        return ['Logo', 'Guidelines', 'Identity'];
      case 'graphic-design':
        return ['Social Media', 'Print', 'Digital'];
      default:
        return ['SaaS', 'Digital'];
    }
  }

  Gradient _getGradient(String id) {
    switch (id) {
      case 'website-development':
        return const LinearGradient(colors: [Colors.indigo, Colors.purple]);
      case 'app-development':
        return const LinearGradient(colors: [Colors.cyan, Colors.teal]);
      case 'ai-automation':
        return const LinearGradient(colors: [Colors.indigo, Colors.blueAccent]);
      case 'crm-development':
        return const LinearGradient(colors: [Colors.teal, Colors.green]);
      case 'seo':
        return const LinearGradient(colors: [Colors.amber, Colors.orange]);
      case 'meta-ads':
        return const LinearGradient(colors: [Colors.pink, Colors.red]);
      case 'google-ads':
        return const LinearGradient(colors: [Colors.blue, Colors.cyan]);
      case 'branding':
        return const LinearGradient(colors: [Colors.purple, Colors.pink]);
      case 'graphic-design':
        return const LinearGradient(colors: [Colors.pinkAccent, Colors.orange]);
      default:
        return AppColors.heroGradient;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? AppColors.primaryAccent : AppColors.accentBright;

    // Filter logic
    final filteredServices = ServicesData.services.where((service) {
      // Handle the 'AI' mapping
      String catToCheck = service.category;
      if (catToCheck == 'AI') {
        catToCheck = 'AI & Automation';
      }

      final matchesCategory = _selectedCategory == 'All' || catToCheck == _selectedCategory;
      final matchesSearch = service.title.toLowerCase().contains(_searchQuery) ||
          service.description.toLowerCase().contains(_searchQuery);
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.baseCanvas : AppColors.lightBaseCanvas,
      appBar: AppBar(
        title: const Text('Services Catalog', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Category filter chips (Sticky)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = _selectedCategory == cat;

                    return ChoiceChip(
                      label: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : AppColors.textTertiary,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (val) {
                        setState(() {
                          _selectedCategory = cat;
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
            ),

            // Main Services List
            Expanded(
              child: filteredServices.isEmpty
                  ? Center(
                      child: Text(
                        'No services found.',
                        style: TextStyle(color: AppColors.textTertiary, fontSize: 13),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0, bottom: 120.0),
                      itemCount: filteredServices.length,
                      itemBuilder: (context, index) {
                        final s = filteredServices[index];
                        final grad = _getGradient(s.id);
                        final tags = _getTags(s.id);
                        final price = s.pricing.isNotEmpty ? s.pricing.first.price : 'Custom';

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          child: GlassCard(
                            tier: GlassTier.tier2,
                            padding: const EdgeInsets.all(14.0),
                            onTap: () {
                              context.push('/services/${s.id}');
                            },
                            child: Row(
                              children: [
                                // Icon with gradient container
                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    gradient: grad,
                                  ),
                                  child: Icon(s.icon, color: Colors.white, size: 24),
                                ),
                                const SizedBox(width: 16),

                                // Service info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        s.title,
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                              fontSize: 14.5,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        s.description,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
                                      ),
                                      const SizedBox(height: 6),
                                      // Micro tags chips
                                      Row(
                                        children: List.generate(
                                          tags.length,
                                          (tIdx) => Container(
                                            margin: const EdgeInsets.only(right: 6),
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(4),
                                              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
                                            ),
                                            child: Text(
                                              tags[tIdx],
                                              style: const TextStyle(fontSize: 9, color: AppColors.textTertiary),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // GET Button / Price
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(99),
                                        color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.06),
                                      ),
                                      child: Text(
                                        'GET',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: primaryAccent,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'From $price',
                                      style: const TextStyle(fontSize: 9, color: AppColors.textTertiary),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
