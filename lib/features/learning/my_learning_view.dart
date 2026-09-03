import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/repositories/course_repository.dart';
import '../../core/services/download_service.dart';
import '../../core/widgets/course_horizontal_card.dart';
import '../../core/widgets/empty_state_widget.dart';

class MyLearningView extends ConsumerWidget {
  const MyLearningView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enrolledCoursesAsync = ref.watch(enrolledCoursesProvider);
    final downloads = ref.watch(downloadNotifierProvider);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('My Learning Hub 📚'),
          actions: [
            IconButton(
              icon: const Icon(Icons.download_for_offline_rounded),
              onPressed: () => context.push('/downloads'),
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            tabs: [
              Tab(text: 'Ongoing Courses'),
              Tab(text: 'Recorded Classes'),
              Tab(text: 'Completed'),
              Tab(text: 'Downloaded'),
            ],
          ),
        ),
        body: enrolledCoursesAsync.when(
          data: (courses) {
            final ongoing = courses.where((c) => c.progressPercentage < 1.0).toList();
            final completed = courses.where((c) => c.progressPercentage >= 1.0).toList();

            return TabBarView(
              children: [
                // Tab 1: Ongoing Courses
                ongoing.isEmpty
                    ? EmptyStateWidget(
                        title: 'No Ongoing Courses',
                        description: 'You haven\'t started learning any course yet. Discover top courses for your target exam.',
                        buttonText: 'Explore Courses',
                        onButtonPressed: () => context.push('/courses-catalog'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 85),
                        itemCount: ongoing.length,
                        itemBuilder: (context, index) {
                          final course = ongoing[index];
                          return CourseHorizontalCard(
                            course: course,
                            onTap: () => context.push('/course/${course.id}'),
                          );
                        },
                      ),

                // Tab 2: Recorded Classes (Tree view: Subject -> Chapter -> Lesson)
                ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 85),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: const BorderSide(color: AppColors.border),
                      ),
                      child: ExpansionTile(
                        leading: const Icon(Icons.video_library_rounded, color: AppColors.primary),
                        title: Text(
                          course.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        subtitle: Text('${course.chapters.length} Chapters • Recorded Classes'),
                        children: course.chapters.map((ch) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: ExpansionTile(
                              title: Text(ch.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                              children: ch.lessons.map((lesson) {
                                return ListTile(
                                  dense: true,
                                  leading: Icon(
                                    lesson.isCompleted ? Icons.check_circle_rounded : Icons.play_circle_fill_rounded,
                                    color: lesson.isCompleted ? AppColors.success : AppColors.primary,
                                    size: 20,
                                  ),
                                  title: Text(lesson.title, style: const TextStyle(fontSize: 12)),
                                  subtitle: Text(lesson.durationText, style: const TextStyle(fontSize: 10)),
                                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12),
                                  onTap: () {
                                    context.push('/video-player', extra: {
                                      'course': course,
                                      'lesson': lesson,
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),

                // Tab 3: Completed Courses
                completed.isEmpty
                    ? const EmptyStateWidget(
                        title: 'No Completed Courses Yet',
                        description: 'Keep studying lessons and complete mock tests to earn your course certificates!',
                        icon: Icons.emoji_events_outlined,
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 85),
                        itemCount: completed.length,
                        itemBuilder: (context, index) {
                          final course = completed[index];
                          return CourseHorizontalCard(
                            course: course,
                            onTap: () => context.push('/course/${course.id}'),
                          );
                        },
                      ),

                // Tab 4: Downloaded Offline Items
                downloads.isEmpty
                    ? const EmptyStateWidget(
                        title: 'No Downloads',
                        description: 'Download lessons & notes while online to study uninterrupted offline.',
                        icon: Icons.download_done_rounded,
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 85),
                        itemCount: downloads.length,
                        itemBuilder: (context, index) {
                          final item = downloads[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              leading: Icon(
                                item.fileType == 'video' ? Icons.video_file_rounded : Icons.picture_as_pdf_rounded,
                                color: item.fileType == 'video' ? AppColors.primary : AppColors.error,
                              ),
                              title: Text(item.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                              subtitle: Text('${item.courseTitle} • ${item.fileSizeText}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                                onPressed: () {
                                  ref.read(downloadNotifierProvider.notifier).deleteDownload(item.id);
                                },
                              ),
                              onTap: () {
                                if (item.fileType == 'pdf') {
                                  context.push('/notes-viewer', extra: item.title);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Playing offline video: ${item.title}')),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => const Center(child: Text('Error loading learning items.')),
        ),
      ),
    );
  }
}
