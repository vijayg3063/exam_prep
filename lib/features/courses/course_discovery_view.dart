import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/repositories/course_repository.dart';
import '../../core/widgets/course_card.dart';
import '../../core/models/course_model.dart';

class CourseDiscoveryView extends ConsumerStatefulWidget {
  const CourseDiscoveryView({super.key});

  @override
  ConsumerState<CourseDiscoveryView> createState() => _CourseDiscoveryViewState();
}

class _CourseDiscoveryViewState extends ConsumerState<CourseDiscoveryView> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final coursesAsync = ref.watch(allCoursesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Explore Courses Catalog'),
      ),
      body: Column(
        children: [
          // Filter Bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: ['All', 'Free', 'Demo', 'Live', 'Paid'].map((filter) {
                final isSel = filter == _selectedFilter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter),
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
                          _selectedFilter = filter;
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1, color: AppColors.border),

          Expanded(
            child: coursesAsync.when(
              data: (courses) {
                List<CourseModel> list = courses;
                if (_selectedFilter == 'Free') {
                  list = courses.where((c) => c.courseType == CourseType.free || c.price == 0.0).toList();
                } else if (_selectedFilter == 'Demo') {
                  list = courses.where((c) => c.courseType == CourseType.demo).toList();
                } else if (_selectedFilter == 'Live') {
                  list = courses.where((c) => c.courseType == CourseType.live).toList();
                } else if (_selectedFilter == 'Paid') {
                  list = courses.where((c) => c.price > 0.0).toList();
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final course = list[index];
                    return CourseCard(
                      course: course,
                      width: double.infinity,
                      onTap: () => context.push('/course/${course.id}'),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const Center(child: Text('Error loading courses.')),
            ),
          ),
        ],
      ),
    );
  }
}
