import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/repositories/mock_data.dart';
import '../../core/widgets/app_button.dart';

class CurrentAffairsView extends StatefulWidget {
  const CurrentAffairsView({super.key});

  @override
  State<CurrentAffairsView> createState() => _CurrentAffairsViewState();
}

class _CurrentAffairsViewState extends State<CurrentAffairsView> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Daily Current Affairs 📰'),
      ),
      body: Column(
        children: [
          // Category Selector Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: AppConstants.currentAffairCategories.map((cat) {
                final isSel = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSel,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSel ? Colors.white : AppColors.textPrimary,
                      fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                    ),
                    backgroundColor: AppColors.surface,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1, color: AppColors.border),

          // Articles List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: MockData.currentAffairs.length,
              itemBuilder: (context, index) {
                final item = MockData.currentAffairs[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        item.imageUrl,
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(height: 140, color: AppColors.darkPrimary),
                      ),
                      Padding(
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
                                    item.category,
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                                  ),
                                ),
                                Text(
                                  item.publishedDate.toString().split(' ')[0],
                                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.title,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.summary,
                              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.warningLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.star_rounded, size: 16, color: AppColors.warning),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'Exam Relevance: ${item.examRelevance}',
                                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            AppButton(
                              text: 'Practice Questions on this Topic ✏️',
                              type: AppButtonType.secondary,
                              onPressed: () => context.push('/daily-quiz'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
