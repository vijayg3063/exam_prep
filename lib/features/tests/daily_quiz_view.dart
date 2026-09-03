import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';

class DailyQuizView extends StatefulWidget {
  const DailyQuizView({super.key});

  @override
  State<DailyQuizView> createState() => _DailyQuizViewState();
}

class _DailyQuizViewState extends State<DailyQuizView> {
  int _currentIndex = 0;
  int? _selectedIndex;
  bool _submitted = false;
  int _score = 0;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Who has been appointed as the new Chairman of ISRO?',
      'options': ['S. Somanath', 'K. Sivan', 'Dr. V. Narayanan', 'G. Satheesh Reddy'],
      'correct': 0,
      'explanation': 'S. Somanath is the current Chairman of ISRO (Indian Space Research Organisation).'
    },
    {
      'question': 'What is the unit of measure for electrical resistance?',
      'options': ['Volt', 'Ampere', 'Ohm', 'Watt'],
      'correct': 2,
      'explanation': 'The SI unit of electrical resistance is the Ohm (Ω).'
    },
  ];

  void _checkAnswer(int index) {
    if (_submitted) return;
    setState(() {
      _selectedIndex = index;
      _submitted = true;
      if (index == _questions[_currentIndex]['correct']) {
        _score++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Daily Quiz Challenge ⚡'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${_currentIndex + 1} of ${_questions.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
                Text('Score: $_score', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success)),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              q['question'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 24),
            Column(
              children: List.generate(q['options'].length, (idx) {
                final text = q['options'][idx];
                Color border = AppColors.border;
                Color bg = AppColors.surface;

                if (_submitted) {
                  if (idx == q['correct']) {
                    border = AppColors.success;
                    bg = AppColors.successLight;
                  } else if (idx == _selectedIndex) {
                    border = AppColors.error;
                    bg = AppColors.errorLight;
                  }
                }

                return GestureDetector(
                  onTap: () => _checkAnswer(idx),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: border, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: border,
                          child: Text(
                            String.fromCharCode(65 + idx),
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),

            if (_submitted) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.lightPrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Explanation:', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                    const SizedBox(height: 4),
                    Text(q['explanation'], style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                  ],
                ),
              ),
            ],

            const Spacer(),
            if (_submitted)
              AppButton(
                text: _currentIndex < _questions.length - 1 ? 'Next Question' : 'Finish Quiz',
                onPressed: () {
                  if (_currentIndex < _questions.length - 1) {
                    setState(() {
                      _currentIndex++;
                      _selectedIndex = null;
                      _submitted = false;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('🎉 Daily Quiz completed! Final Score: $_score/${_questions.length}')),
                    );
                    context.pop();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
