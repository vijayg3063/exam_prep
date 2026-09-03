import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/test_model.dart';
import 'mock_data.dart';

abstract class TestRepository {
  Future<List<TestSeriesModel>> getTestSeries();
  Future<List<TestQuestionModel>> getQuestionsForTest(String testId);
  Future<TestAttemptModel> submitTest(String testId, String testTitle, List<TestQuestionModel> questions, int timeSpentSeconds);
  Future<TestAttemptModel?> getRecentTestResult();
}

class MockTestRepository implements TestRepository {
  TestAttemptModel? _latestResult = MockData.recentTestResult;

  @override
  Future<List<TestSeriesModel>> getTestSeries() async {
    return MockData.testSeries;
  }

  @override
  Future<List<TestQuestionModel>> getQuestionsForTest(String testId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(MockData.sampleMockQuestions);
  }

  @override
  Future<TestAttemptModel> submitTest(
    String testId,
    String testTitle,
    List<TestQuestionModel> questions,
    int timeSpentSeconds,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));

    int correct = 0;
    int incorrect = 0;
    int unattempted = 0;

    for (final q in questions) {
      if (q.selectedOptionIndex == null) {
        unattempted++;
      } else if (q.selectedOptionIndex == q.correctOptionIndex) {
        correct++;
      } else {
        incorrect++;
      }
    }

    double rawScore = (correct * 2.0) - (incorrect * 0.5);
    double maxScore = questions.length * 2.0;
    double percentage = maxScore > 0 ? ((rawScore / maxScore) * 100).clamp(0, 100) : 0;
    int attempted = correct + incorrect;
    double accuracy = attempted > 0 ? ((correct / attempted) * 100) : 0;

    _latestResult = TestAttemptModel(
      id: 'attempt_${DateTime.now().millisecondsSinceEpoch}',
      testId: testId,
      testTitle: testTitle,
      score: rawScore < 0 ? 0 : rawScore,
      maxScore: maxScore,
      percentage: percentage,
      accuracy: accuracy,
      correctCount: correct,
      incorrectCount: incorrect,
      unattemptedCount: unattempted,
      timeSpentSeconds: timeSpentSeconds,
      rank: 215,
      subjectPerformance: {
        'Quantitative Aptitude': 85.0,
        'Reasoning': 90.0,
        'English Language': 75.0,
        'General Awareness': 68.0,
      },
      weakTopics: ['General Awareness (Government Schemes)', 'English (Vocabulary)'],
      strongTopics: ['Reasoning (Analogy)', 'Quantitative Aptitude (Percentage)'],
      completedAt: DateTime.now(),
    );

    return _latestResult!;
  }

  @override
  Future<TestAttemptModel?> getRecentTestResult() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _latestResult;
  }
}

final testRepositoryProvider = Provider<TestRepository>((ref) {
  return MockTestRepository();
});

final testSeriesProvider = FutureProvider<List<TestSeriesModel>>((ref) {
  return ref.watch(testRepositoryProvider).getTestSeries();
});

final recentTestResultProvider = FutureProvider<TestAttemptModel?>((ref) {
  return ref.watch(testRepositoryProvider).getRecentTestResult();
});
