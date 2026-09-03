import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/models/test_model.dart';
import '../../core/repositories/test_repository.dart';
import '../../core/widgets/app_button.dart';

class TestResultView extends ConsumerWidget {
  final TestAttemptModel? attempt;

  const TestResultView({
    super.key,
    this.attempt,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentAsync = ref.watch(recentTestResultProvider);
    final result = attempt ?? recentAsync.value;

    if (result == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Test Result')),
        body: const Center(child: Text('No recent test attempt found.')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/home'),
        ),
        title: const Text('Performance Result Scorecard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Score Summary Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.darkPrimary, AppColors.primary],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    result.testTitle,
                    style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('YOUR SCORE', style: TextStyle(color: Colors.white70, fontSize: 11)),
                          const SizedBox(height: 4),
                          Text(
                            '${result.score.toStringAsFixed(1)} / ${result.maxScore.toInt()}',
                            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                      Container(height: 40, width: 1, color: Colors.white30),
                      Column(
                        children: [
                          const Text('ACCURACY', style: TextStyle(color: Colors.white70, fontSize: 11)),
                          const SizedBox(height: 4),
                          Text(
                            '${result.accuracy.toStringAsFixed(1)}%',
                            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                      Container(height: 40, width: 1, color: Colors.white30),
                      Column(
                        children: [
                          const Text('ALL INDIA RANK', style: TextStyle(color: Colors.white70, fontSize: 11)),
                          const SizedBox(height: 4),
                          Text(
                            '#${result.rank}',
                            style: const TextStyle(color: AppColors.warning, fontSize: 24, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Statistics Grid (Correct, Incorrect, Unattempted, Time)
            Row(
              children: [
                _buildStatCard('Correct', '${result.correctCount}', Icons.check_circle_rounded, AppColors.success),
                const SizedBox(width: 10),
                _buildStatCard('Incorrect', '${result.incorrectCount}', Icons.cancel_rounded, AppColors.error),
                const SizedBox(width: 10),
                _buildStatCard('Unattempted', '${result.unattemptedCount}', Icons.remove_circle_outline_rounded, AppColors.textMuted),
                const SizedBox(width: 10),
                _buildStatCard('Time', '${(result.timeSpentSeconds / 60).floor()}m', Icons.timer_outlined, AppColors.primary),
              ],
            ),
            const SizedBox(height: 24),

            // Subject Performance Breakdown
            const Text(
              'Subject-wise Score Breakdown 📊',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),
            Column(
              children: result.subjectPerformance.entries.map((entry) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        Text(
                          '${entry.value.toInt()} Marks',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Weak Topics vs Strong Topics
            const Text(
              'Weak & Strong Topics Analysis 💡',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.errorLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('⚠️ Weak Areas', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.error, fontSize: 13)),
                        const SizedBox(height: 6),
                        ...result.weakTopics.map((topic) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text('• $topic', style: const TextStyle(fontSize: 11, color: AppColors.textPrimary)),
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.successLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('💪 Strong Areas', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.success, fontSize: 13)),
                        const SizedBox(height: 6),
                        ...result.strongTopics.map((topic) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text('• $topic', style: const TextStyle(fontSize: 11, color: AppColors.textPrimary)),
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Action Buttons
            AppButton(
              text: 'Review Solutions & Explanations 📖',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening detailed question solutions...')),
                );
              },
            ),
            const SizedBox(height: 12),
            AppButton(
              text: 'Practice Weak Areas',
              type: AppButtonType.secondary,
              onPressed: () => context.push('/courses-catalog'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
