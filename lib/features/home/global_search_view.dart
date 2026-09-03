import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/repositories/course_repository.dart';
import '../../core/widgets/course_horizontal_card.dart';
import '../../core/widgets/empty_state_widget.dart';

class GlobalSearchView extends ConsumerStatefulWidget {
  const GlobalSearchView({super.key});

  @override
  ConsumerState<GlobalSearchView> createState() => _GlobalSearchViewState();
}

class _GlobalSearchViewState extends ConsumerState<GlobalSearchView> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final allCoursesAsync = ref.watch(allCoursesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            onChanged: (val) {
              setState(() {
                _query = val.trim().toLowerCase();
              });
            },
            decoration: InputDecoration(
              hintText: 'Search courses, subjects, topics, tests...',
              filled: true,
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _query = '';
                        });
                      },
                    )
                  : null,
            ),
          ),
        ),
      ),
      body: _query.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Popular Search Topics 🔥',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'Percentage Short Tricks',
                      'SSC CGL Tier 1 Mock',
                      'Rajasthan Forts & History',
                      'Polity Laxmikanth',
                      'Daily Current Affairs',
                      'Syllogism Reasoning',
                    ].map((topic) {
                      return ActionChip(
                        label: Text(topic),
                        backgroundColor: AppColors.surface,
                        side: const BorderSide(color: AppColors.border),
                        onPressed: () {
                          _searchController.text = topic;
                          setState(() {
                            _query = topic.toLowerCase();
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            )
          : allCoursesAsync.when(
              data: (courses) {
                final filtered = courses.where((c) {
                  return c.title.toLowerCase().contains(_query) ||
                      c.examCategory.toLowerCase().contains(_query) ||
                      c.instructorName.toLowerCase().contains(_query);
                }).toList();

                if (filtered.isEmpty) {
                  return EmptyStateWidget(
                    title: 'No Results Found',
                    description: 'We couldn\'t find anything matching "$_query". Try searching for subjects like Quant, Polity or SSC.',
                    icon: Icons.search_off_rounded,
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final course = filtered[index];
                    return CourseHorizontalCard(
                      course: course,
                      onTap: () => context.push('/course/${course.id}'),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const Center(child: Text('Error searching content.')),
            ),
    );
  }
}
