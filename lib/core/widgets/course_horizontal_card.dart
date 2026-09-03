import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../theme/app_colors.dart';

class CourseHorizontalCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback onTap;

  const CourseHorizontalCard({
    super.key,
    required this.course,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.border, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Thumbnail (gradient, no network) ──
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _HorizontalThumbnail(
                  category: course.examCategory,
                  courseType: course.courseType,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.examCategory,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      course.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (course.isEnrolled) ...[
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                value: course.progressPercentage.clamp(0.0, 1.0),
                                minHeight: 6,
                                backgroundColor: AppColors.border,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    AppColors.primary),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${(course.progressPercentage * 100).toInt()}%',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      if (course.lastLessonTitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          course.lastLessonTitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              course.instructorName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            course.price == 0.0
                                ? 'FREE'
                                : '₹${course.price.toInt()}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: course.price == 0.0
                                  ? AppColors.success
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Offline-safe gradient thumbnail for horizontal cards
// ──────────────────────────────────────────────
class _HorizontalThumbnail extends StatelessWidget {
  final String category;
  final CourseType courseType;

  const _HorizontalThumbnail({
    required this.category,
    required this.courseType,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _colors(courseType);
    return Container(
      height: 80,
      width: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          _icon(category),
          size: 28,
          color: Colors.white.withValues(alpha: 0.9),
        ),
      ),
    );
  }

  List<Color> _colors(CourseType type) {
    switch (type) {
      case CourseType.free:
        return [const Color(0xFF16A34A), const Color(0xFF4ADE80)];
      case CourseType.demo:
        return [const Color(0xFFF59E0B), const Color(0xFFFBBF24)];
      case CourseType.live:
        return [const Color(0xFFDC2626), const Color(0xFFF87171)];
      default:
        return [AppColors.darkPrimary, AppColors.primary];
    }
  }

  IconData _icon(String category) {
    final lower = category.toLowerCase();
    if (lower.contains('upsc') || lower.contains('ias')) {
      return Icons.account_balance_rounded;
    }
    if (lower.contains('police') || lower.contains('security')) {
      return Icons.local_police_rounded;
    }
    if (lower.contains('bank') || lower.contains('ibps')) {
      return Icons.account_balance_wallet_rounded;
    }
    if (lower.contains('railway') || lower.contains('rrb')) {
      return Icons.train_rounded;
    }
    if (lower.contains('ca') || lower.contains('finance')) {
      return Icons.calculate_rounded;
    }
    if (lower.contains('agri')) {
      return Icons.agriculture_rounded;
    }
    return Icons.school_rounded;
  }
}
