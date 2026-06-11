import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/status_badge.dart';

class ProjectDetailScreen extends StatefulWidget {
  final String projectId;

  const ProjectDetailScreen({
    super.key,
    required this.projectId,
  });

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _msgController = TextEditingController();
  final List<Map<String, String>> _messages = [
    {'sender': 'agent', 'text': 'Good morning! The UX wireframes for the mobile app are ready.', 'time': '10:14 AM'},
    {'sender': 'client', 'text': 'Awesome, let me review the landing flow screen.', 'time': '10:20 AM'},
    {'sender': 'agent', 'text': 'Sure, you can access the files under the Files tab.', 'time': '10:22 AM'},
  ];

  final List<Map<String, String>> _files = [
    {'name': 'NZXT-Service_Agreement.pdf', 'size': '1.2 MB', 'type': 'pdf', 'date': 'June 01, 2026'},
    {'name': 'Figma-Architecture_Specs.pdf', 'size': '4.8 MB', 'type': 'doc', 'date': 'May 28, 2026'},
    {'name': 'Wireframe-Landing.png', 'size': '850 KB', 'type': 'image', 'date': 'June 10, 2026'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _msgController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_msgController.text.trim().isEmpty) return;
    setState(() {
      _messages.add({
        'sender': 'client',
        'text': _msgController.text.trim(),
        'time': 'Just Now',
      });
      _msgController.clear();
    });
  }

  void _uploadFileMock() {
    setState(() {
      _files.add({
        'name': 'Client-Assets.zip',
        'size': '14.5 MB',
        'type': 'zip',
        'date': 'Just Now',
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('File uploaded successfully!'),
        backgroundColor: AppColors.secondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? AppColors.primaryAccent : AppColors.accentBright;

    // Mock project meta
    final String title = widget.projectId == 'website' ? 'Web Platform Sprint' : 'Mobile App Pipeline';
    final String category = widget.projectId == 'website' ? 'Website Development' : 'Mobile App Development';
    final double progress = widget.projectId == 'website' ? 0.85 : 0.60;

    return Scaffold(
      backgroundColor: isDark ? AppColors.baseCanvas : AppColors.lightBaseCanvas,
      appBar: AppBar(
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. PROJECT HEADER CARD (Glass Tier 3)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: GlassCard(
                tier: GlassTier.tier3,
                showGlow: true,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: primaryAccent.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  category.toUpperCase(),
                                  style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: primaryAccent),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const StatusBadge(label: 'Active', type: StatusType.active),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            title,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Start: Jun 01, 2026  •  Est: Jul 15, 2026',
                            style: TextStyle(fontSize: 11, color: AppColors.textTertiary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Large Circular Progress
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 6,
                            backgroundColor: isDark ? Colors.white10 : Colors.black12,
                            valueColor: AlwaysStoppedAnimation<Color>(primaryAccent),
                          ),
                        ),
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 2. TAB NAVIGATION (Standard slide index)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TabBar(
                controller: _tabController,
                indicatorColor: primaryAccent,
                labelColor: isDark ? Colors.white : Colors.black,
                unselectedLabelColor: AppColors.textTertiary,
                labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Milestones'),
                  Tab(text: 'Files'),
                  Tab(text: 'Messages'),
                ],
              ),
            ),

            // 3. Tab Contents
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(isDark, primaryAccent),
                  _buildMilestonesTab(isDark, primaryAccent),
                  _buildFilesTab(isDark, primaryAccent),
                  _buildMessagesTab(isDark, primaryAccent),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(bool isDark, Color accentColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Description Card
          GlassCard(
            tier: GlassTier.tier2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Project Scope',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Design and engineering sprints to implement next-gen offline data synchronization, premium dark-mode styling variables, and live WebSocket message architectures in Flutter.',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Assigned Team Card
          GlassCard(
            tier: GlassTier.tier2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Assigned Team',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 14),
                _buildTeamRow('Fahad Riaz', 'Lead Engineer', Colors.purple),
                const SizedBox(height: 12),
                _buildTeamRow('Zainab Riaz', 'Product Design', Colors.teal),
                const SizedBox(height: 12),
                _buildTeamRow('Marcus Aurelius', 'Solutions Lead', Colors.blue),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Invoice summary mini-card
          GlassCard(
            tier: GlassTier.tier2,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.receipt_long, color: AppColors.warning),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Stage 2 Invoicing', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                      Text('Due: July 01, 2026 • ₹50,000', style: TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                    ],
                  ),
                ),
                PrimaryButton(
                  text: 'Pay Now',
                  width: 90,
                  height: 36,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamRow(String name, String role, Color initialBg) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: initialBg.withValues(alpha: 0.2),
          child: Text(
            name.substring(0, 1),
            style: TextStyle(fontWeight: FontWeight.bold, color: initialBg),
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Text(role, style: const TextStyle(fontSize: 10.5, color: AppColors.textTertiary)),
          ],
        )
      ],
    );
  }

  Widget _buildMilestonesTab(bool isDark, Color accentColor) {
    final milestones = [
      {'name': 'UX Architecture & Figma Wireframes', 'desc': 'Complete responsive grid maps & branding colors', 'date': 'Completed Jun 08', 'state': 'done'},
      {'name': 'Database Model & API Integration', 'desc': 'Set up client queries and secure tokens storage', 'date': 'Completed Jun 12', 'state': 'done'},
      {'name': 'Local Cache & Messaging UI', 'desc': 'Establish local SQLite synchronization models', 'date': 'Due Jun 25', 'state': 'active'},
      {'name': 'Store Release & Audit Optimization', 'desc': 'TestFlight launch and Google Play releases', 'date': 'Due Jul 15', 'state': 'pending'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20.0),
      itemCount: milestones.length,
      itemBuilder: (context, index) {
        final step = milestones[index];
        final state = step['state'];
        final isLast = index == milestones.length - 1;

        Color dotColor;
        Widget dotChild;

        if (state == 'done') {
          dotColor = AppColors.secondary;
          dotChild = const Icon(Icons.check, size: 10, color: Colors.black);
        } else if (state == 'active') {
          dotColor = accentColor;
          dotChild = Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          );
        } else {
          dotColor = isDark ? Colors.white24 : Colors.black12;
          dotChild = const SizedBox();
        }

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: state == 'done' ? AppColors.secondary : Colors.transparent,
                      border: Border.all(color: dotColor, width: 2),
                    ),
                    child: Center(child: dotChild),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: state == 'done' ? AppColors.secondary.withValues(alpha: 0.4) : (isDark ? Colors.white12 : Colors.black12),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: GlassCard(
                    tier: GlassTier.tier2,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                step['name']!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: state == 'pending' ? AppColors.textTertiary : (isDark ? Colors.white : Colors.black),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              step['date']!,
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: state == 'done' ? AppColors.secondary : (state == 'active' ? accentColor : AppColors.textTertiary),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          step['desc']!,
                          style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
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
    );
  }

  Widget _buildFilesTab(bool isDark, Color accentColor) {
    return Column(
      children: [
        // Upload Card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: GestureDetector(
            onTap: _uploadFileMock,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.4),
                  style: BorderStyle.none, // Can use custom dash path, or simply styled border
                ),
                color: accentColor.withValues(alpha: 0.05),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_upload_outlined, color: accentColor, size: 28),
                    const SizedBox(height: 8),
                    Text(
                      'Tap to Upload Deliverables / Assets',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: accentColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Files Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.3,
            ),
            itemCount: _files.length,
            itemBuilder: (context, index) {
              final file = _files[index];
              final type = file['type'];
              IconData icon;
              Color iconColor;

              if (type == 'pdf') {
                icon = Icons.picture_as_pdf;
                iconColor = Colors.redAccent;
              } else if (type == 'image') {
                icon = Icons.image;
                iconColor = Colors.blueAccent;
              } else if (type == 'doc') {
                icon = Icons.description;
                iconColor = Colors.indigoAccent;
              } else {
                icon = Icons.folder_zip;
                iconColor = Colors.amber;
              }

              return GlassCard(
                tier: GlassTier.tier2,
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(icon, color: iconColor, size: 28),
                        IconButton(
                          icon: const Icon(Icons.download, size: 16),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {},
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          file['name']!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${file['size']}  •  ${file['date']}',
                          style: const TextStyle(fontSize: 9, color: AppColors.textTertiary),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMessagesTab(bool isDark, Color accentColor) {
    return Column(
      children: [
        // Thread
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(20.0),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final msg = _messages[index];
              final isClient = msg['sender'] == 'client';

              return Align(
                alignment: isClient ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: isClient ? const Radius.circular(16) : Radius.zero,
                      bottomRight: isClient ? Radius.zero : const Radius.circular(16),
                    ),
                    color: isClient
                        ? AppColors.primaryAccent.withValues(alpha: 0.15)
                        : (isDark ? AppColors.surfaceLevel3 : AppColors.lightSurfaceLevel2),
                    border: Border.all(
                      color: isClient
                          ? AppColors.primaryAccent.withValues(alpha: 0.3)
                          : (isDark ? Colors.white10 : Colors.black12),
                    ),
                  ),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        msg['text']!,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          msg['time']!,
                          style: const TextStyle(fontSize: 9, color: AppColors.textTertiary),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Text Input Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceLevel1 : AppColors.lightSurfaceLevel1,
            border: Border(top: BorderSide(color: isDark ? Colors.white10 : Colors.black12)),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.attach_file, color: AppColors.textTertiary),
                onPressed: _uploadFileMock,
              ),
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: isDark ? AppColors.surfaceLevel2 : AppColors.lightSurfaceLevel2,
                  ),
                  child: TextField(
                    controller: _msgController,
                    style: const TextStyle(fontSize: 13),
                    decoration: const InputDecoration(
                      hintText: 'Ask your lead engineer...',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.send, color: accentColor),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
