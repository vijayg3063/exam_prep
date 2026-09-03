import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/models/live_class_model.dart';
import '../../core/repositories/live_repository.dart';
import '../../core/widgets/live_class_card.dart';
import '../../core/widgets/section_header.dart';

class LiveView extends ConsumerStatefulWidget {
  const LiveView({super.key});

  @override
  ConsumerState<LiveView> createState() => _LiveViewState();
}

class _LiveViewState extends ConsumerState<LiveView> {
  final _chatController = TextEditingController();
  final List<Map<String, dynamic>> _chatMessages = [
    {'sender': 'Rohan Sharma', 'message': 'Good morning sir! Ready for current affairs.', 'isInstructor': false},
    {'sender': 'Deepak Yadav Sir', 'message': 'Welcome students! Today we analyze 5 major international summits.', 'isInstructor': true},
    {'sender': 'Pooja Verma', 'message': 'Sir please explain the AgriStack farmer ID concept again.', 'isInstructor': false},
  ];

  void _sendMessage() {
    if (_chatController.text.trim().isNotEmpty) {
      setState(() {
        _chatMessages.add({
          'sender': 'Vijay Gurjar',
          'message': _chatController.text.trim(),
          'isInstructor': false,
        });
        _chatController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final liveClassesAsync = ref.watch(liveClassesProvider);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Live Learning Center 🔴'),
          bottom: const TabBar(
            isScrollable: true,
            labelColor: AppColors.error,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.error,
            indicatorWeight: 3,
            tabs: [
              Tab(text: '🔴 Live Now'),
              Tab(text: '📅 Upcoming Classes'),
              Tab(text: '❓ Doubt Sessions'),
              Tab(text: '📝 Live Tests'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Live Now Player + Live Chat
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 85),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Active Live Video Container
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.play_circle_fill_rounded, size: 54, color: AppColors.error),
                              SizedBox(height: 6),
                              Text(
                                '🔴 LIVE STREAM BROADCASTING',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('LIVE • 3,420 Viewers', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '🔴 LIVE: Daily Current Affairs & Editorial Analysis - Aug 19',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  const Text('Faculty: Deepak Yadav Sir • UPSC CSE Masterclass', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(height: 20),

                  // Live Chat & Q&A Container
                  const SectionHeader(title: 'Live Student Chat & Polls 💬'),
                  Container(
                    height: 260,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: _chatMessages.length,
                            itemBuilder: (context, index) {
                              final msg = _chatMessages[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                                    children: [
                                      TextSpan(
                                        text: '${msg['sender']}: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: msg['isInstructor'] ? AppColors.error : AppColors.primary,
                                        ),
                                      ),
                                      TextSpan(text: msg['message']),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _chatController,
                                decoration: const InputDecoration(
                                  hintText: 'Ask a doubt to sir...',
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.send_rounded, color: AppColors.primary),
                              onPressed: _sendMessage,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Tab 2: Upcoming Classes
            liveClassesAsync.when(
              data: (classes) {
                final upcoming = classes.where((l) => l.isUpcoming && l.type == LiveType.liveClass).toList();
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 85),
                  itemCount: upcoming.length,
                  itemBuilder: (context, index) {
                    final l = upcoming[index];
                    return LiveClassCard(
                      liveClass: l,
                      onTap: () {},
                      onReminderToggle: () async {
                        await ref.read(liveRepositoryProvider).toggleReminder(l.id);
                        ref.invalidate(liveClassesProvider);
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const SizedBox.shrink(),
            ),

            // Tab 3: Upcoming Doubt Sessions
            liveClassesAsync.when(
              data: (classes) {
                final doubts = classes.where((l) => l.type == LiveType.doubtSession).toList();
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 85),
                  itemCount: doubts.length,
                  itemBuilder: (context, index) {
                    final d = doubts[index];
                    return LiveClassCard(
                      liveClass: d,
                      onTap: () {},
                      onReminderToggle: () async {
                        await ref.read(liveRepositoryProvider).toggleReminder(d.id);
                        ref.invalidate(liveClassesProvider);
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const SizedBox.shrink(),
            ),

            // Tab 4: Live Tests
            liveClassesAsync.when(
              data: (classes) {
                final tests = classes.where((l) => l.type == LiveType.liveTest).toList();
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 85),
                  itemCount: tests.length,
                  itemBuilder: (context, index) {
                    final t = tests[index];
                    return LiveClassCard(
                      liveClass: t,
                      onTap: () {},
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
