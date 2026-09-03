class ExamCategoryModel {
  final String id;
  final String title;
  final String code;
  final String iconName;
  final String description;
  final DateTime? examDate;
  final List<String> subjects;
  final int activeStudentsCount;

  const ExamCategoryModel({
    required this.id,
    required this.title,
    required this.code,
    required this.iconName,
    required this.description,
    this.examDate,
    required this.subjects,
    this.activeStudentsCount = 15000,
  });

  int get daysRemaining {
    if (examDate == null) return 0;
    final diff = examDate!.difference(DateTime.now()).inDays;
    return diff > 0 ? diff : 0;
  }
}

class SubjectModel {
  final String id;
  final String name;
  final String examId;
  final int totalLessons;
  final int completedLessons;
  final String iconName;

  const SubjectModel({
    required this.id,
    required this.name,
    required this.examId,
    required this.totalLessons,
    this.completedLessons = 0,
    required this.iconName,
  });
}
