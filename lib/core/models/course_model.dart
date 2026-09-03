enum CourseType { free, paid, demo, live, recorded, hybrid }

class LessonModel {
  final String id;
  final String title;
  final String chapterId;
  final String durationText;
  final int durationSeconds;
  final String videoUrl;
  final String? pdfUrl;
  final bool isFreeDemo;
  final bool isCompleted;
  final bool isDownloaded;
  final int watchPositionSeconds;

  const LessonModel({
    required this.id,
    required this.title,
    required this.chapterId,
    required this.durationText,
    required this.durationSeconds,
    required this.videoUrl,
    this.pdfUrl,
    this.isFreeDemo = false,
    this.isCompleted = false,
    this.isDownloaded = false,
    this.watchPositionSeconds = 0,
  });

  LessonModel copyWith({
    bool? isCompleted,
    bool? isDownloaded,
    int? watchPositionSeconds,
  }) {
    return LessonModel(
      id: id,
      title: title,
      chapterId: chapterId,
      durationText: durationText,
      durationSeconds: durationSeconds,
      videoUrl: videoUrl,
      pdfUrl: pdfUrl,
      isFreeDemo: isFreeDemo,
      isCompleted: isCompleted ?? this.isCompleted,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      watchPositionSeconds: watchPositionSeconds ?? this.watchPositionSeconds,
    );
  }
}

class ChapterModel {
  final String id;
  final String title;
  final List<LessonModel> lessons;

  const ChapterModel({
    required this.id,
    required this.title,
    required this.lessons,
  });
}

class CourseModel {
  final String id;
  final String title;
  final String examCategory;
  final String instructorName;
  final String instructorRole;
  final double rating;
  final int ratingCount;
  final int studentCount;
  final String durationText;
  final double price;
  final double originalPrice;
  final CourseType courseType;
  final String thumbnailUrl;
  final String description;
  final List<String> whatYouWillLearn;
  final List<ChapterModel> chapters;
  final bool isEnrolled;
  final double progressPercentage;
  final String? lastLessonTitle;
  final int totalLessons;
  final int completedLessonsCount;

  const CourseModel({
    required this.id,
    required this.title,
    required this.examCategory,
    required this.instructorName,
    required this.instructorRole,
    required this.rating,
    required this.ratingCount,
    required this.studentCount,
    required this.durationText,
    required this.price,
    required this.originalPrice,
    required this.courseType,
    required this.thumbnailUrl,
    required this.description,
    required this.whatYouWillLearn,
    required this.chapters,
    this.isEnrolled = false,
    this.progressPercentage = 0.0,
    this.lastLessonTitle,
    required this.totalLessons,
    this.completedLessonsCount = 0,
  });

  CourseModel copyWith({
    bool? isEnrolled,
    double? progressPercentage,
    String? lastLessonTitle,
    int? completedLessonsCount,
    List<ChapterModel>? chapters,
  }) {
    return CourseModel(
      id: id,
      title: title,
      examCategory: examCategory,
      instructorName: instructorName,
      instructorRole: instructorRole,
      rating: rating,
      ratingCount: ratingCount,
      studentCount: studentCount,
      durationText: durationText,
      price: price,
      originalPrice: originalPrice,
      courseType: courseType,
      thumbnailUrl: thumbnailUrl,
      description: description,
      whatYouWillLearn: whatYouWillLearn,
      chapters: chapters ?? this.chapters,
      isEnrolled: isEnrolled ?? this.isEnrolled,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      lastLessonTitle: lastLessonTitle ?? this.lastLessonTitle,
      totalLessons: totalLessons,
      completedLessonsCount: completedLessonsCount ?? this.completedLessonsCount,
    );
  }
}
