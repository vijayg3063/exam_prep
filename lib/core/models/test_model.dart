class TestQuestionModel {
  final String id;
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;
  final String subject;
  final String topic;
  final int? selectedOptionIndex;
  final bool isMarkedForReview;
  final bool isBookmarked;

  const TestQuestionModel({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
    required this.subject,
    required this.topic,
    this.selectedOptionIndex,
    this.isMarkedForReview = false,
    this.isBookmarked = false,
  });

  TestQuestionModel copyWith({
    int? selectedOptionIndex,
    bool? isMarkedForReview,
    bool? isBookmarked,
  }) {
    return TestQuestionModel(
      id: id,
      questionText: questionText,
      options: options,
      correctOptionIndex: correctOptionIndex,
      explanation: explanation,
      subject: subject,
      topic: topic,
      selectedOptionIndex: selectedOptionIndex ?? this.selectedOptionIndex,
      isMarkedForReview: isMarkedForReview ?? this.isMarkedForReview,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}

enum TestCategory { fullMock, subjectTest, chapterTest, pyq, weeklyTest, dailyQuiz }

class TestSeriesModel {
  final String id;
  final String title;
  final String examCategory;
  final TestCategory category;
  final int totalQuestions;
  final int durationMinutes;
  final double totalMarks;
  final double negativeMarks;
  final int attemptsCount;
  final bool isFree;

  const TestSeriesModel({
    required this.id,
    required this.title,
    required this.examCategory,
    required this.category,
    required this.totalQuestions,
    required this.durationMinutes,
    required this.totalMarks,
    this.negativeMarks = 0.5,
    required this.attemptsCount,
    this.isFree = false,
  });
}

class TestAttemptModel {
  final String id;
  final String testId;
  final String testTitle;
  final double score;
  final double maxScore;
  final double percentage;
  final double accuracy;
  final int correctCount;
  final int incorrectCount;
  final int unattemptedCount;
  final int timeSpentSeconds;
  final int rank;
  final Map<String, double> subjectPerformance;
  final List<String> weakTopics;
  final List<String> strongTopics;
  final DateTime completedAt;

  const TestAttemptModel({
    required this.id,
    required this.testId,
    required this.testTitle,
    required this.score,
    required this.maxScore,
    required this.percentage,
    required this.accuracy,
    required this.correctCount,
    required this.incorrectCount,
    required this.unattemptedCount,
    required this.timeSpentSeconds,
    required this.rank,
    required this.subjectPerformance,
    required this.weakTopics,
    required this.strongTopics,
    required this.completedAt,
  });
}
