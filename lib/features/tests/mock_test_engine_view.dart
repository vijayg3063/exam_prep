import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/models/test_model.dart';
import '../../core/repositories/test_repository.dart';

class MockTestEngineView extends ConsumerStatefulWidget {
  final String testId;

  const MockTestEngineView({
    super.key,
    required this.testId,
  });

  @override
  ConsumerState<MockTestEngineView> createState() => _MockTestEngineViewState();
}

class _MockTestEngineViewState extends ConsumerState<MockTestEngineView> {
  List<TestQuestionModel> _questions = [];
  int _currentIndex = 0;
  int _secondsRemaining = 3600; // 60 mins default
  int _timeSpentSeconds = 0;
  Timer? _timer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() async {
    final list = await ref.read(testRepositoryProvider).getQuestionsForTest(widget.testId);
    setState(() {
      _questions = list;
      _isLoading = false;
    });
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
          _timeSpentSeconds++;
        });
      } else {
        _timer?.cancel();
        _submitTest();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _selectOption(int optionIndex) {
    setState(() {
      _questions[_currentIndex] = _questions[_currentIndex].copyWith(
        selectedOptionIndex: optionIndex,
      );
    });
  }

  void _toggleMarkForReview() {
    setState(() {
      _questions[_currentIndex] = _questions[_currentIndex].copyWith(
        isMarkedForReview: !_questions[_currentIndex].isMarkedForReview,
      );
    });
  }

  void _clearAnswer() {
    setState(() {
      _questions[_currentIndex] = _questions[_currentIndex].copyWith(
        selectedOptionIndex: null,
      );
    });
  }

  void _submitTest() async {
    _timer?.cancel();
    final attempt = await ref.read(testRepositoryProvider).submitTest(
          widget.testId,
          'SSC CGL Tier 1 All India Full Mock Test 05',
          _questions,
          _timeSpentSeconds,
        );
    ref.invalidate(recentTestResultProvider);
    if (mounted) {
      context.go('/test-result', extra: attempt);
    }
  }

  void _showSubmitConfirmation() {
    int answered = _questions.where((q) => q.selectedOptionIndex != null).length;
    int marked = _questions.where((q) => q.isMarkedForReview).length;
    int unattempted = _questions.length - answered;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Examination?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Questions: ${_questions.length}'),
            const SizedBox(height: 4),
            Text('Answered: $answered', style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Marked for Review: $marked', style: const TextStyle(color: AppColors.warning, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Unattempted: $unattempted', style: const TextStyle(color: AppColors.textMuted)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Resume Test'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _submitTest();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Submit Test Now'),
          ),
        ],
      ),
    );
  }

  void _openQuestionPalette() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Question Palette Grid 🎯',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _questions.length,
                  itemBuilder: (context, idx) {
                    final q = _questions[idx];
                    Color bg = AppColors.border;
                    if (q.selectedOptionIndex != null) bg = AppColors.success;
                    if (q.isMarkedForReview) bg = AppColors.warning;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentIndex = idx;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(8),
                          border: _currentIndex == idx ? Border.all(color: AppColors.primary, width: 2.5) : null,
                        ),
                        child: Center(
                          child: Text(
                            '${idx + 1}',
                            style: TextStyle(
                              color: (q.selectedOptionIndex != null || q.isMarkedForReview) ? Colors.white : AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final currentQuestion = _questions[_currentIndex];
    final minutes = (_secondsRemaining / 60).floor();
    final seconds = _secondsRemaining % 60;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.grid_view_rounded),
          onPressed: _openQuestionPalette,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Q${_currentIndex + 1} of ${_questions.length}', style: const TextStyle(fontSize: 14, color: Colors.white)),
            Text(currentQuestion.subject, style: const TextStyle(fontSize: 11, color: Colors.white70)),
          ],
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer_outlined, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _showSubmitConfirmation,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              minimumSize: const Size(70, 34),
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            child: const Text('Submit', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Question Content Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.lightPrimary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          currentQuestion.topic,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          currentQuestion.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                          color: AppColors.primary,
                        ),
                        onPressed: () {
                          setState(() {
                            _questions[_currentIndex] = currentQuestion.copyWith(
                              isBookmarked: !currentQuestion.isBookmarked,
                            );
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    currentQuestion.questionText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Options List
                  Column(
                    children: List.generate(currentQuestion.options.length, (optIndex) {
                      final optionText = currentQuestion.options[optIndex];
                      final isSelected = currentQuestion.selectedOptionIndex == optIndex;

                      return GestureDetector(
                        onTap: () => _selectOption(optIndex),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.lightPrimary : AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.border,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: isSelected ? AppColors.primary : AppColors.border,
                                child: Text(
                                  String.fromCharCode(65 + optIndex),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? Colors.white : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  optionText,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),

          // Exam Navigation Footer Toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  OutlinedButton(
                    onPressed: _toggleMarkForReview,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: currentQuestion.isMarkedForReview ? AppColors.warning : AppColors.textSecondary,
                      side: BorderSide(color: currentQuestion.isMarkedForReview ? AppColors.warning : AppColors.border),
                    ),
                    child: Text(currentQuestion.isMarkedForReview ? 'Marked' : 'Mark Review'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: _clearAnswer,
                    child: const Text('Clear', style: TextStyle(color: AppColors.textMuted)),
                  ),
                  const Spacer(),
                  if (_currentIndex > 0)
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _currentIndex--;
                        });
                      },
                      child: const Text('Prev'),
                    ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentIndex < _questions.length - 1) {
                        setState(() {
                          _currentIndex++;
                        });
                      } else {
                        _showSubmitConfirmation();
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    child: Text(_currentIndex < _questions.length - 1 ? 'Save & Next' : 'Submit'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
