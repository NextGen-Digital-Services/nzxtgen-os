import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';

class LiveChatScreen extends StatefulWidget {
  const LiveChatScreen({super.key});

  @override
  State<LiveChatScreen> createState() => _LiveChatScreenState();
}

class _LiveChatScreenState extends State<LiveChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'system',
      'text': 'Support chat started. Active SLA: Under 2 hours.',
      'time': '',
    },
    {
      'sender': 'agent',
      'text': 'Hello! Marcus here from the NZXTGEN Solutions Team. How can I assist you with your sprints today?',
      'time': '02:08 PM',
      'read': true,
    },
    {
      'sender': 'client',
      'text': 'Hi Marcus, I wanted to check if the database model changes will impact client key tokens?',
      'time': '02:10 PM',
      'read': true,
    },
    {
      'sender': 'agent',
      'text': 'No, they won\'t. We designed the schema upgrades to be fully backward-compatible. Your active API key tokens will remain valid.',
      'time': '02:11 PM',
      'read': true,
    },
  ];

  void _sendMessage() {
    if (_msgController.text.trim().isEmpty) return;
    setState(() {
      _messages.add({
        'sender': 'client',
        'text': _msgController.text.trim(),
        'time': 'Just Now',
        'read': false,
      });
      _msgController.clear();
    });

    // Auto scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    // Simulate agent reply
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          // Mark client messages as read (double blue seen)
          for (var msg in _messages) {
            if (msg['sender'] == 'client') {
              msg['read'] = true;
            }
          }
          _messages.add({
            'sender': 'agent',
            'text': 'Let me know if you want us to audit the connection logs for verification.',
            'time': 'Just Now',
            'read': true,
          });
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? AppColors.primaryAccent : AppColors.accentBright;

    return Scaffold(
      backgroundColor: isDark ? AppColors.baseCanvas : AppColors.lightBaseCanvas,
      appBar: AppBar(
        leadingWidth: 40,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            onPressed: () => context.pop(),
          ),
        ),
        titleSpacing: 8.0,
        title: Row(
          children: [
            // Avatar with online ring
            Container(
              padding: const EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.secondary, width: 1.5),
              ),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: primaryAccent.withValues(alpha: 0.15),
                child: const Text('M', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryAccent)),
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Marcus Aurelius',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Icon(Icons.circle, color: AppColors.secondary, size: 6),
                    SizedBox(width: 4),
                    Text(
                      'Solutions Agent • Online',
                      style: TextStyle(fontSize: 9.5, color: AppColors.textTertiary),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_outlined, size: 20),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.escalator_warning_outlined, size: 20),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Divider
            Divider(color: isDark ? Colors.white10 : Colors.black12, height: 1),

            // Messages area
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(20.0),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final sender = msg['sender'];

                  if (sender == 'system') {
                    return Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 16.0),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
                        ),
                        child: Text(
                          msg['text'],
                          style: const TextStyle(fontSize: 10.5, fontStyle: FontStyle.italic, color: AppColors.textTertiary),
                        ),
                      ),
                    );
                  }

                  final isClient = sender == 'client';
                  return Align(
                    alignment: isClient ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(18),
                          topRight: const Radius.circular(18),
                          bottomLeft: isClient ? const Radius.circular(18) : Radius.zero,
                          bottomRight: isClient ? Radius.zero : const Radius.circular(18),
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
                            msg['text'],
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? Colors.white : Colors.black,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                msg['time'],
                                style: const TextStyle(fontSize: 9, color: AppColors.textTertiary),
                              ),
                              if (isClient) ...[
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.done_all,
                                  size: 11,
                                  color: msg['read'] == true ? Colors.blue : AppColors.textTertiary,
                                ),
                              ]
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Branded input bar (Glass Tier 1)
            GlassCard(
              tier: GlassTier.tier1,
              borderRadius: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: AppColors.textTertiary),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: isDark ? AppColors.surfaceLevel2 : AppColors.lightSurfaceLevel2,
                        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
                      ),
                      child: TextField(
                        controller: _msgController,
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(
                          hintText: 'Message Support Desk...',
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
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: primaryAccent,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_upward, size: 16, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
