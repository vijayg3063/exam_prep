import 'package:flutter/material.dart';
import '../models/exam_model.dart';
import '../theme/app_colors.dart';

class ExamCategoryCard extends StatelessWidget {
  final ExamCategoryModel exam;
  final bool isSelected;
  final VoidCallback onTap;

  const ExamCategoryCard({
    super.key,
    required this.exam,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lightPrimary : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getIcon(exam.iconName),
                    color: isSelected ? Colors.white : AppColors.primary,
                    size: 20,
                  ),
                ),
                if (exam.daysRemaining > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.streakLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${exam.daysRemaining}d left',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.streakOrange,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exam.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${exam.subjects.length} Subjects',
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String name) {
    switch (name) {
      case 'assignment':
        return Icons.assignment_rounded;
      case 'account_balance':
        return Icons.account_balance_rounded;
      case 'security':
        return Icons.security_rounded;
      case 'account_balance_wallet':
        return Icons.account_balance_wallet_rounded;
      case 'train':
        return Icons.train_rounded;
      case 'agriculture':
        return Icons.agriculture_rounded;
      case 'calculate':
        return Icons.calculate_rounded;
      default:
        return Icons.school_rounded;
    }
  }
}
