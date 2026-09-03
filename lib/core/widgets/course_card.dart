import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../theme/app_colors.dart';
import 'badge_widget.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback onTap;
  final double width;

  const CourseCard({
    super.key,
    required this.course,
    required this.onTap,
    this.width = 260,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 14),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Thumbnail (gradient, no network) ──
              Stack(
                children: [
                  _CourseThumbnail(
                    category: course.examCategory,
                    height: 120,
                    courseType: course.courseType,
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: _buildTypeBadge(),
                  ),
                ],
              ),

              // ── Details ──
              Padding(
                padding: const EdgeInsets.all(12),
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
                    const SizedBox(height: 4),
                    Text(
                      course.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.person_outline_rounded,
                            size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            course.instructorName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 16, color: AppColors.warning),
                        const SizedBox(width: 2),
                        Text(
                          course.rating.toString(),
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ' (${course.studentCount} students)',
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (course.price == 0.0)
                          const Text(
                            'FREE',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.success,
                            ),
                          )
                        else
                          Row(
                            children: [
                              Text(
                                '₹${course.price.toInt()}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '₹${course.originalPrice.toInt()}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  decoration: TextDecoration.lineThrough,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        Text(
                          course.durationText,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeBadge() {
    switch (course.courseType) {
      case CourseType.free:
        return CourseBadge.free();
      case CourseType.demo:
        return CourseBadge.demo();
      case CourseType.live:
        return CourseBadge.live();
      default:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            course.examCategory,
            style: const TextStyle(
                fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        );
    }
  }
}

// ──────────────────────────────────────────────
// Gradient thumbnail — works 100% offline.
// Avoids Image.network white-box on emulator.
// ──────────────────────────────────────────────
class _CourseThumbnail extends StatelessWidget {
  final String category;
  final double height;
  final CourseType courseType;

  const _CourseThumbnail({
    required this.category,
    required this.height,
    required this.courseType,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _gradientColors(courseType);
    final icon = _icon(category);

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            left: -10,
            bottom: -10,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          // Icon
          Center(
            child: Icon(icon, size: 36, color: Colors.white.withValues(alpha: 0.9)),
          ),
        ],
      ),
    );
  }

  List<Color> _gradientColors(CourseType type) {
    switch (type) {
      case CourseType.free:
        return [const Color(0xFF16A34A), const Color(0xFF4ADE80)];
      case CourseType.demo:
        return [const Color(0xFFF59E0B), const Color(0xFFFBBF24)];
      case CourseType.live:
        return [const Color(0xFFDC2626), const Color(0xFFF87171)];
      case CourseType.hybrid:
        return [const Color(0xFF7C3AED), const Color(0xFFA78BFA)];
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
