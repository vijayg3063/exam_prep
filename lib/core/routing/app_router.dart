import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/splash_view.dart';
import '../../features/auth/login_view.dart';
import '../../features/auth/register_view.dart';
import '../../features/auth/exam_onboarding_view.dart';
import '../../features/navigation/main_app_shell.dart';

import '../../features/home/home_view.dart';
import '../../features/home/global_search_view.dart';

import '../../features/courses/course_discovery_view.dart';
import '../../features/courses/exam_detail_view.dart';
import '../../features/courses/course_detail_view.dart';
import '../../features/courses/free_courses_view.dart';

import '../../features/learning/my_learning_view.dart';
import '../../features/learning/video_player_view.dart';
import '../../features/learning/notes_viewer_view.dart';
import '../../features/learning/downloads_view.dart';

import '../../features/live/live_view.dart';

import '../../features/tests/test_series_view.dart';
import '../../features/tests/mock_test_engine_view.dart';
import '../../features/tests/test_result_view.dart';
import '../../features/tests/daily_quiz_view.dart';

import '../../features/current_affairs/current_affairs_view.dart';

import '../../features/profile/profile_view.dart';
import '../../features/profile/certificates_view.dart';
import '../../features/profile/bookmarks_view.dart';
import '../../features/profile/settings_view.dart';
import '../../features/profile/notifications_view.dart';

import '../models/course_model.dart';
import '../models/test_model.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      // Auth Routes
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterView(),
      ),
      GoRoute(
        path: '/exam-onboarding',
        builder: (context, state) => const ExamOnboardingView(),
      ),

      // Stateful 4-Tab Navigation Shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainAppShell(navigationShell: navigationShell);
        },
        branches: [
          // Tab 0: Home 🏠
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeView(),
              ),
            ],
          ),

          // Tab 1: My Learning 📚
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/my-learning',
                builder: (context, state) => const MyLearningView(),
              ),
            ],
          ),

          // Tab 2: Live 🔴
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/live',
                builder: (context, state) => const LiveView(),
              ),
            ],
          ),

          // Tab 3: Profile 👤
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileView(),
              ),
            ],
          ),
        ],
      ),

      // Secondary Application Flow Routes
      GoRoute(
        path: '/search',
        builder: (context, state) => const GlobalSearchView(),
      ),
      GoRoute(
        path: '/courses-catalog',
        builder: (context, state) => const CourseDiscoveryView(),
      ),
      GoRoute(
        path: '/free-courses',
        builder: (context, state) => const FreeCoursesView(),
      ),
      GoRoute(
        path: '/exam-detail/:id',
        builder: (context, state) {
          final examId = state.pathParameters['id'] ?? '';
          return ExamDetailView(examId: examId);
        },
      ),
      GoRoute(
        path: '/course/:id',
        builder: (context, state) {
          final courseId = state.pathParameters['id'] ?? '';
          return CourseDetailView(courseId: courseId);
        },
      ),
      GoRoute(
        path: '/video-player',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return VideoPlayerView(
            course: extra['course'] as CourseModel,
            lesson: extra['lesson'] as LessonModel,
          );
        },
      ),
      GoRoute(
        path: '/notes-viewer',
        builder: (context, state) {
          final title = state.extra as String? ?? 'Study Material Notes';
          return NotesViewerView(title: title);
        },
      ),
      GoRoute(
        path: '/downloads',
        builder: (context, state) => const DownloadsView(),
      ),
      GoRoute(
        path: '/test-series',
        builder: (context, state) => const TestSeriesView(),
      ),
      GoRoute(
        path: '/mock-test-engine/:id',
        builder: (context, state) {
          final testId = state.pathParameters['id'] ?? '';
          return MockTestEngineView(testId: testId);
        },
      ),
      GoRoute(
        path: '/test-result',
        builder: (context, state) {
          final attempt = state.extra as TestAttemptModel?;
          return TestResultView(attempt: attempt);
        },
      ),
      GoRoute(
        path: '/daily-quiz',
        builder: (context, state) => const DailyQuizView(),
      ),
      GoRoute(
        path: '/current-affairs',
        builder: (context, state) => const CurrentAffairsView(),
      ),
      GoRoute(
        path: '/certificates',
        builder: (context, state) => const CertificatesView(),
      ),
      GoRoute(
        path: '/bookmarks',
        builder: (context, state) => const BookmarksView(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsView(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsView(),
      ),
    ],
  );
});
