import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/repositories/mock_data.dart';

class BookmarksView extends StatelessWidget {
  const BookmarksView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
          ),
          title: const Text('My Bookmarks 📌'),
          bottom: const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: 'Bookmarked Questions'),
              Tab(text: 'Saved Notes'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Bookmarked Questions
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: MockData.sampleMockQuestions.length,
              itemBuilder: (context, index) {
                final q = MockData.sampleMockQuestions[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.lightPrimary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                q.subject,
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                            ),
                            const Icon(Icons.bookmark_rounded, color: AppColors.primary, size: 20),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          q.questionText,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Correct Answer: ${q.options[q.correctOptionIndex]}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.success),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Tab 2: Saved Notes
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.error),
                  title: const Text('Percentage Short Tricks PDF Notes'),
                  subtitle: const Text('SSC CGL Complete Quantitative Aptitude'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  onTap: () => context.push('/notes-viewer', extra: 'Percentage Short Tricks PDF Notes'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
