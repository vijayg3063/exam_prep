import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/badge_widget.dart';
import '../../core/repositories/course_repository.dart';
import '../../core/models/course_model.dart';

class CourseDetailView extends ConsumerWidget {
  final String courseId;

  const CourseDetailView({
    super.key,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseRepo = ref.watch(courseRepositoryProvider);

    return FutureBuilder<CourseModel?>(
      future: courseRepo.getCourseById(courseId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final course = snapshot.data;
        if (course == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Course Details')),
            body: const Center(child: Text('Course not found.')),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              // Header Sliver AppBar with Image Preview
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                leading: CircleAvatar(
                  backgroundColor: Colors.black.withValues(alpha: 0.5),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    onPressed: () => context.pop(),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.network(
                        course.thumbnailUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(color: AppColors.darkPrimary),
                      ),
                      Container(color: Colors.black.withValues(alpha: 0.4)),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (course.chapters.isNotEmpty && course.chapters.first.lessons.isNotEmpty) {
                            final lesson = course.chapters.first.lessons.first;
                            context.push('/video-player', extra: {
                              'course': course,
                              'lesson': lesson,
                            });
                          }
                        },
                        icon: const Icon(Icons.play_arrow_rounded, size: 28),
                        label: const Text('Watch Preview Trailer'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.darkPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content Body
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.lightPrimary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              course.examCategory,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                          ),
                          _buildTypeBadge(course.courseType),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        course.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 18, color: AppColors.warning),
                          const SizedBox(width: 4),
                          Text(
                            '${course.rating}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Text(
                            ' (${course.ratingCount} reviews)',
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.people_alt_rounded, size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            '${course.studentCount} Students',
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Instructor Card
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: AppColors.border),
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: AppColors.primary,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(
                            course.instructorName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          subtitle: Text(course.instructorRole, style: const TextStyle(fontSize: 12)),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // What you'll learn
                      const Text(
                        'What You Will Learn',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: course.whatYouWillLearn.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // Syllabus Curriculum Breakdown
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Course Content',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          Text(
                            '${course.totalLessons} Lessons • ${course.durationText}',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      Column(
                        children: course.chapters.map((chapter) {
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ExpansionTile(
                              title: Text(
                                chapter.title,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              children: chapter.lessons.map((lesson) {
                                return ListTile(
                                  dense: true,
                                  leading: Icon(
                                    lesson.isCompleted
                                        ? Icons.check_circle_rounded
                                        : Icons.play_circle_outline_rounded,
                                    color: lesson.isCompleted ? AppColors.success : AppColors.primary,
                                  ),
                                  title: Text(
                                    lesson.title,
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Text(lesson.durationText, style: const TextStyle(fontSize: 11)),
                                  trailing: lesson.isFreeDemo
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.successLight,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Text('Free Demo', style: TextStyle(fontSize: 10, color: AppColors.success, fontWeight: FontWeight.bold)),
                                        )
                                      : const Icon(Icons.lock_rounded, size: 14, color: AppColors.textMuted),
                                  onTap: () {
                                    if (lesson.isFreeDemo || course.isEnrolled) {
                                      context.push('/video-player', extra: {
                                        'course': course,
                                        'lesson': lesson,
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Please enroll in the course to unlock this lesson.')),
                                      );
                                    }
                                  },
                                );
                              }).toList(),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 100), // Space for bottom CTA
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom Fixed Enrollment CTA Bar
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Course Fee', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      if (course.price == 0.0)
                        const Text(
                          'FREE',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.success),
                        )
                      else
                        Row(
                          children: [
                            Text(
                              '₹${course.price.toInt()}',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '₹${course.originalPrice.toInt()}',
                              style: const TextStyle(fontSize: 12, decoration: TextDecoration.lineThrough, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: AppButton(
                      text: course.isEnrolled
                          ? 'Go to Course'
                          : (course.price == 0.0 ? 'Start Free Learning' : 'Enroll Now'),
                      onPressed: () async {
                        if (!course.isEnrolled) {
                          await ref.read(courseRepositoryProvider).enrollCourse(course.id);
                          ref.invalidate(enrolledCoursesProvider);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Enrolled successfully! Course added to My Learning.')),
                            );
                          }
                        }
                        if (context.mounted) {
                          context.push('/my-learning');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTypeBadge(CourseType type) {
    switch (type) {
      case CourseType.free:
        return CourseBadge.free();
      case CourseType.demo:
        return CourseBadge.demo();
      case CourseType.live:
        return CourseBadge.live();
      default:
        return const CourseBadge(label: 'PREMIUM BATCH');
    }
  }
}
