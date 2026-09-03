import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course_model.dart';
import '../models/exam_model.dart';
import 'mock_data.dart';

abstract class CourseRepository {
  Future<List<CourseModel>> getCourses({String? examCategory, CourseType? type, String? searchQuery});
  Future<List<CourseModel>> getEnrolledCourses();
  Future<List<CourseModel>> getFreeCourses();
  Future<List<CourseModel>> getDemoCourses();
  Future<CourseModel?> getCourseById(String id);
  Future<void> enrollCourse(String courseId);
  Future<void> markLessonCompleted(String courseId, String lessonId);
  Future<List<ExamCategoryModel>> getExamCategories();
}

class MockCourseRepository implements CourseRepository {
  final List<CourseModel> _courses = List.from(MockData.courses);

  @override
  Future<List<CourseModel>> getCourses({String? examCategory, CourseType? type, String? searchQuery}) async {
    return _courses.where((c) {
      if (examCategory != null && examCategory.isNotEmpty && c.examCategory != examCategory) {
        return false;
      }
      if (type != null && c.courseType != type) {
        return false;
      }
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        final matchTitle = c.title.toLowerCase().contains(query);
        final matchInstructor = c.instructorName.toLowerCase().contains(query);
        final matchCategory = c.examCategory.toLowerCase().contains(query);
        if (!matchTitle && !matchInstructor && !matchCategory) return false;
      }
      return true;
    }).toList();
  }

  @override
  Future<List<CourseModel>> getEnrolledCourses() async {
    return _courses.where((c) => c.isEnrolled).toList();
  }

  @override
  Future<List<CourseModel>> getFreeCourses() async {
    return _courses.where((c) => c.courseType == CourseType.free || c.price == 0.0).toList();
  }

  @override
  Future<List<CourseModel>> getDemoCourses() async {
    return _courses.where((c) => c.courseType == CourseType.demo).toList();
  }

  @override
  Future<CourseModel?> getCourseById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _courses.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> enrollCourse(String courseId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _courses.indexWhere((c) => c.id == courseId);
    if (index != -1) {
      _courses[index] = _courses[index].copyWith(isEnrolled: true);
    }
  }

  @override
  Future<void> markLessonCompleted(String courseId, String lessonId) async {
    final index = _courses.indexWhere((c) => c.id == courseId);
    if (index != -1) {
      final course = _courses[index];
      final updatedChapters = course.chapters.map((ch) {
        final updatedLessons = ch.lessons.map((l) {
          if (l.id == lessonId) {
            return l.copyWith(isCompleted: true);
          }
          return l;
        }).toList();
        return ChapterModel(id: ch.id, title: ch.title, lessons: updatedLessons);
      }).toList();

      int completedCount = 0;
      for (final ch in updatedChapters) {
        for (final l in ch.lessons) {
          if (l.isCompleted) completedCount++;
        }
      }

      double progress = course.totalLessons > 0 ? (completedCount / course.totalLessons) : 0.0;

      _courses[index] = course.copyWith(
        chapters: updatedChapters,
        completedLessonsCount: completedCount,
        progressPercentage: progress,
      );
    }
  }

  @override
  Future<List<ExamCategoryModel>> getExamCategories() async {
    return MockData.examCategories;
  }
}

// Providers
final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  return MockCourseRepository();
});

final allCoursesProvider = FutureProvider<List<CourseModel>>((ref) {
  return ref.watch(courseRepositoryProvider).getCourses();
});

final enrolledCoursesProvider = FutureProvider<List<CourseModel>>((ref) {
  return ref.watch(courseRepositoryProvider).getEnrolledCourses();
});

final freeCoursesProvider = FutureProvider<List<CourseModel>>((ref) {
  return ref.watch(courseRepositoryProvider).getFreeCourses();
});

final demoCoursesProvider = FutureProvider<List<CourseModel>>((ref) {
  return ref.watch(courseRepositoryProvider).getDemoCourses();
});

final examCategoriesProvider = FutureProvider<List<ExamCategoryModel>>((ref) {
  return ref.watch(courseRepositoryProvider).getExamCategories();
});
