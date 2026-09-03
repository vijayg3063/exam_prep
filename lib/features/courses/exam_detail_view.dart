import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/repositories/course_repository.dart';
import '../../core/repositories/mock_data.dart';
import '../../core/widgets/course_card.dart';
import '../../core/widgets/section_header.dart';

class ExamDetailView extends ConsumerWidget {
  final String examId;

  const ExamDetailView({
    super.key,
    required this.examId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exam = MockData.examCategories.firstWhere(
      (e) => e.id == examId,
      orElse: () => MockData.examCategories.first,
    );

    final coursesAsync = ref.watch(allCoursesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(exam.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.darkPrimary, AppColors.primary],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        exam.code,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),
                      if (exam.daysRemaining > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '⏳ ${exam.daysRemaining} Days Left',
                            style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    exam.title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    exam.description,
                    style: const TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Subjects Breakdown
            const SectionHeader(title: 'Syllabus Subjects Breakdown 📚'),
            Column(
              children: exam.subjects.map((subject) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.lightPrimary,
                      child: const Icon(Icons.book_rounded, color: AppColors.primary, size: 20),
                    ),
                    title: Text(
                      subject,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: const Text('Complete Theory + PYQs Practice'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
                    onTap: () => context.push('/courses-catalog'),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Courses for this exam
            const SectionHeader(title: 'Recommended Batches & Courses'),
            coursesAsync.when(
              data: (courses) => Column(
                children: courses.map((c) => CourseCard(
                  course: c,
                  width: double.infinity,
                  onTap: () => context.push('/course/${c.id}'),
                )).toList(),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
