import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/repositories/course_repository.dart';
import '../../core/widgets/course_card.dart';

class FreeCoursesView extends ConsumerWidget {
  const FreeCoursesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final freeCoursesAsync = ref.watch(freeCoursesProvider);
    final demoCoursesAsync = ref.watch(demoCoursesProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
          ),
          title: const Text('Free Learning Hub'),
          bottom: const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            tabs: [
              Tab(text: 'Free Full Courses 🎁'),
              Tab(text: 'Demo Classes 🎬'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Free Full Courses
            freeCoursesAsync.when(
              data: (courses) => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return CourseCard(
                    course: course,
                    width: double.infinity,
                    onTap: () => context.push('/course/${course.id}'),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const Center(child: Text('Error loading courses.')),
            ),

            // Tab 2: Demo Classes
            demoCoursesAsync.when(
              data: (demos) => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: demos.length,
                itemBuilder: (context, index) {
                  final demo = demos[index];
                  return CourseCard(
                    course: demo,
                    width: double.infinity,
                    onTap: () => context.push('/course/${demo.id}'),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const Center(child: Text('Error loading demo classes.')),
            ),
          ],
        ),
      ),
    );
  }
}
