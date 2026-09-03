import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/course_card.dart';
import '../../core/widgets/course_horizontal_card.dart';
import '../../core/widgets/exam_card.dart';
import '../../core/widgets/test_card.dart';
import '../../core/repositories/auth_repository.dart';
import '../../core/repositories/course_repository.dart';
import '../../core/repositories/test_repository.dart';
import '../../core/repositories/mock_data.dart';
import '../../core/models/course_model.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  Widget build(BuildContext context) {
    final userAsync   = ref.watch(authNotifierProvider);
    final user        = userAsync.value;
    final examName    = user?.targetExam ?? 'SSC CGL';
    final firstName   = user?.fullName.split(' ').first ?? 'Aspirant';
    final streak      = user?.streakDays ?? 12;

    final enrolledAsync   = ref.watch(enrolledCoursesProvider);
    final categoriesAsync = ref.watch(examCategoriesProvider);
    final coursesAsync    = ref.watch(allCoursesProvider);
    final freeAsync       = ref.watch(freeCoursesProvider);
    final testsAsync      = ref.watch(testSeriesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            ref.invalidate(allCoursesProvider);
            ref.invalidate(enrolledCoursesProvider);
            ref.invalidate(freeCoursesProvider);
            ref.invalidate(examCategoriesProvider);
            ref.invalidate(testSeriesProvider);
          },
          child: SingleChildScrollView(
            child: Padding(
              // 85px bottom padding ensures content never goes behind fixed bottom navbar
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 85),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [

                  // ════════════════════════════
                  // BRANDING HEADER ROW
                  // [LOGO] App Name        🔔  [AVATAR]
                  // ════════════════════════════
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Application Logo + Name
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.school_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'ParikshaPrep',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),

                      // Notification Bell + Top-Right User Avatar
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.notifications_none_rounded,
                              color: AppColors.textPrimary,
                              size: 24,
                            ),
                            onPressed: () => context.push('/notifications'),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () => context.push('/profile'),
                            child: CircleAvatar(
                              radius: 19,
                              backgroundColor: AppColors.primary,
                              child: Text(
                                firstName.isNotEmpty
                                    ? firstName[0].toUpperCase()
                                    : 'V',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ════════════════════════════
                  // GREETING & STREAK SECTION
                  // ════════════════════════════
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${_greeting()}, $firstName 👋',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Ready to achieve your goal today?',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.streakLight,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.streakOrange
                                .withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🔥',
                                style: TextStyle(fontSize: 13)),
                            const SizedBox(width: 4),
                            Text(
                              '$streak Days',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.streakOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ════════════════════════════
                  // EXAM COUNTDOWN BANNER
                  // ✅ No width:double.infinity on Container.
                  //    DecoratedBox + Row used directly.
                  // ════════════════════════════
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.darkPrimary, AppColors.primary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    examName,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  '87 Days Remaining',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Consistent practice leads to selection!',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () =>
                                context.push('/exam-onboarding'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.darkPrimary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10)),
                            ),
                            child: const Text('Change',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ════════════════════════════
                  // SEARCH BAR
                  // ════════════════════════════
                  GestureDetector(
                    onTap: () => context.push('/search'),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        child: Row(
                          children: [
                            Icon(Icons.search_rounded,
                                color: AppColors.textMuted),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Search courses, subjects, mock tests...',
                                style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ════════════════════════════
                  // CONTINUE LEARNING
                  // ════════════════════════════
                  enrolledAsync.when(
                    loading: () => _skeletonBox(130),
                    error: (_, _) => const SizedBox.shrink(),
                    data: (list) => list.isEmpty
                        ? _exploreBanner(context)
                        : _continueLearningCard(list.first, context),
                  ),

                  // ════════════════════════════
                  // QUICK ACCESS TILES
                  // ════════════════════════════
                  Row(
                    children: [
                      Expanded(
                        child: _QuickTile(
                          bg: AppColors.lightPrimary,
                          iconBg: AppColors.primary,
                          icon: Icons.quiz_rounded,
                          label: 'Daily Quiz',
                          sub: '10 Qs • 5 Mins',
                          onTap: () => context.push('/daily-quiz'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickTile(
                          bg: AppColors.successLight,
                          iconBg: AppColors.success,
                          icon: Icons.newspaper_rounded,
                          label: 'Current Affairs',
                          sub: "Today's News",
                          onTap: () =>
                              context.push('/current-affairs'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ════════════════════════════
                  // EXAM CATEGORIES (horizontal)
                  // ════════════════════════════
                  SectionHeader(
                    title: 'Target Examinations 🎓',
                    subtitle: 'Explore subjects and test series',
                    actionText: 'View All',
                    onActionPressed: () =>
                        context.push('/courses-catalog'),
                  ),
                  SizedBox(
                    height: 135,
                    child: categoriesAsync.when(
                      loading: () => _hSkeletonList(140),
                      error: (_, _) =>
                          _examList(MockData.examCategories, context),
                      data: (cats) => _examList(
                          cats.isNotEmpty
                              ? cats
                              : MockData.examCategories,
                          context),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ════════════════════════════
                  // POPULAR COURSES (horizontal)
                  // ════════════════════════════
                  SectionHeader(
                    title: 'Popular Courses 🌟',
                    subtitle: 'Top rated batches by exam toppers',
                    actionText: 'Explore',
                    onActionPressed: () =>
                        context.push('/courses-catalog'),
                  ),
                  SizedBox(
                    height: 295,
                    child: coursesAsync.when(
                      loading: () => _hSkeletonList(260),
                      error: (_, _) =>
                          _courseHList(MockData.courses, context),
                      data: (list) => _courseHList(
                          list.isNotEmpty ? list : MockData.courses,
                          context),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ════════════════════════════
                  // FREE COURSES (vertical)
                  // ════════════════════════════
                  SectionHeader(
                    title: 'Free Courses & Demo Classes 🎁',
                    subtitle: 'Start learning for free',
                    actionText: 'View Free',
                    onActionPressed: () =>
                        context.push('/free-courses'),
                  ),
                  freeAsync.when(
                    loading: () => _skeletonBox(110),
                    error: (_, _) => _freeCourseColumn(
                        MockData.courses
                            .where((c) =>
                                c.courseType == CourseType.free ||
                                c.price == 0.0)
                            .toList(),
                        context),
                    data: (list) {
                      final free = list.isNotEmpty
                          ? list
                          : MockData.courses
                              .where((c) =>
                                  c.courseType == CourseType.free ||
                                  c.price == 0.0)
                              .toList();
                      return free.isEmpty
                          ? _emptyFree(context)
                          : _freeCourseColumn(free, context);
                    },
                  ),
                  const SizedBox(height: 24),

                  // ════════════════════════════
                  // TEST SERIES (vertical)
                  // ════════════════════════════
                  SectionHeader(
                    title: 'All India Test Series 📝',
                    subtitle: 'Simulate real exam & rank yourself',
                    actionText: 'All Tests',
                    onActionPressed: () =>
                        context.push('/test-series'),
                  ),
                  testsAsync.when(
                    loading: () => _skeletonBox(160),
                    error: (_, _) =>
                        _testColumn(MockData.testSeries, context),
                    data: (list) => _testColumn(
                        list.isNotEmpty ? list : MockData.testSeries,
                        context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Greeting ──
  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  // ── Skeleton: box placeholder ──
  Widget _skeletonBox(double h) => Container(
        height: h,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: AppColors.border.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(14),
        ),
      );

  // ── Skeleton: horizontal ──
  Widget _hSkeletonList(double w) => ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (_, _) => Container(
          width: w,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: AppColors.border.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );

  // ── Continue Learning card ──
  Widget _continueLearningCard(CourseModel c, BuildContext ctx) {
    final pct = (c.progressPercentage * 100).toInt();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SectionHeader(title: 'Continue Learning 📖'),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border:
                Border.all(color: AppColors.primary, width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        c.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$pct%',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                if (c.lastLessonTitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    c.lastLessonTitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
                const SizedBox(height: 10),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: c.progressPercentage.clamp(0.0, 1.0),
                    minHeight: 7,
                    backgroundColor: AppColors.border,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary),
                  ),
                ),
                const SizedBox(height: 12),
                // ✅ Row+Expanded = safe full-width button (no ∞ constraint)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => ctx.push('/course/${c.id}'),
                        icon: const Icon(Icons.play_circle_fill_rounded,
                            size: 18),
                        label: const Text('Continue Lesson',
                            style: TextStyle(fontSize: 13)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // ── Explore banner (no enrolled courses) ──
  Widget _exploreBanner(BuildContext ctx) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SectionHeader(title: 'Start Your Preparation 🎓'),
          GestureDetector(
            onTap: () => ctx.push('/courses-catalog'),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.lightPrimary,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.school_rounded,
                          color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Explore Top Courses',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary)),
                          SizedBox(height: 2),
                          Text(
                            'Enroll in top educator batches.',
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded,
                        size: 14, color: AppColors.primary),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      );

  Widget _examList(List<dynamic> cats, BuildContext ctx) =>
      ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cats.length,
        itemBuilder: (_, i) => ExamCategoryCard(
          exam: cats[i],
          onTap: () => ctx.push('/exam-detail/${cats[i].id}'),
        ),
      );

  Widget _courseHList(List<CourseModel> list, BuildContext ctx) =>
      ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (_, i) => CourseCard(
          course: list[i],
          onTap: () => ctx.push('/course/${list[i].id}'),
        ),
      );

  Widget _freeCourseColumn(List<CourseModel> list, BuildContext ctx) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: list
            .map((c) => CourseHorizontalCard(
                  course: c,
                  onTap: () => ctx.push('/course/${c.id}'),
                ))
            .toList(),
      );

  Widget _testColumn(List<dynamic> list, BuildContext ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: list
            .map((t) => TestSeriesCard(
                  testSeries: t,
                  onTap: () => ctx.push('/mock-test-engine/${t.id}'),
                ))
            .toList(),
      );

  Widget _emptyFree(BuildContext ctx) => DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.school_outlined,
                  size: 36, color: AppColors.textMuted),
              const SizedBox(height: 8),
              const Text('Free courses coming soon!',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ctx.push('/courses-catalog'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Browse All Courses',
                    style: TextStyle(fontSize: 13)),
              ),
            ],
          ),
        ),
      );
}

// ─────────────────────────────────────────────
// Quick Access Tile
// ─────────────────────────────────────────────
class _QuickTile extends StatelessWidget {
  final Color bg;
  final Color iconBg;
  final IconData icon;
  final String label;
  final String sub;
  final VoidCallback onTap;

  const _QuickTile({
    required this.bg,
    required this.iconBg,
    required this.icon,
    required this.label,
    required this.sub,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border:
              Border.all(color: iconBg.withValues(alpha: 0.25)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(label,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary)),
                    Text(sub,
                        style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
