import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/repositories/auth_repository.dart';

class ExamOnboardingView extends ConsumerStatefulWidget {
  const ExamOnboardingView({super.key});

  @override
  ConsumerState<ExamOnboardingView> createState() => _ExamOnboardingViewState();
}

class _ExamOnboardingViewState extends ConsumerState<ExamOnboardingView> {
  String _selectedExam = 'SSC CGL';
  String _selectedLanguage = 'Bilingual (Hinglish)';

  void _saveAndProceed() async {
    final notifier = ref.read(authNotifierProvider.notifier);
    await notifier.updateTargetExam(_selectedExam);
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Personalize Your Learning 🎯',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Select your primary target examination to get customized courses, countdowns & test series.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'What are you preparing for?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 12),

              Expanded(
                child: ListView.builder(
                  itemCount: AppConstants.targetExams.length,
                  itemBuilder: (context, index) {
                    final exam = AppConstants.targetExams[index];
                    final isSelected = exam == _selectedExam;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Material(
                        color: isSelected ? AppColors.lightPrimary : AppColors.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected ? AppColors.primary : AppColors.border,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                        onTap: () {
                          setState(() {
                            _selectedExam = exam;
                          });
                        },
                        leading: CircleAvatar(
                          backgroundColor: isSelected ? AppColors.primary : AppColors.border,
                          radius: 16,
                          child: Icon(
                            isSelected ? Icons.check : Icons.school_outlined,
                            size: 18,
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                          ),
                        ),
                        title: Text(
                          exam,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? AppColors.primary : AppColors.textPrimary,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.radio_button_checked, color: AppColors.primary)
                            : const Icon(Icons.radio_button_unchecked, color: AppColors.textMuted),
                      ),
                    ),
                  );
                },
                ),
              ),

              const SizedBox(height: 16),
              const Text(
                'Preferred Language',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Row(
                children: AppConstants.languages.map((lang) {
                  final isSel = lang == _selectedLanguage;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(
                          lang,
                          style: TextStyle(
                            fontSize: 12,
                            color: isSel ? Colors.white : AppColors.textPrimary,
                            fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        selected: isSel,
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.surface,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedLanguage = lang;
                            });
                          }
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),
              AppButton(
                text: 'Start Preparing Now',
                onPressed: _saveAndProceed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
