import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CourseBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;

  const CourseBadge({
    super.key,
    required this.label,
    this.backgroundColor = AppColors.lightPrimary,
    this.textColor = AppColors.primary,
    this.icon,
  });

  factory CourseBadge.free() {
    return const CourseBadge(
      label: 'FREE',
      backgroundColor: AppColors.successLight,
      textColor: AppColors.success,
    );
  }

  factory CourseBadge.demo() {
    return const CourseBadge(
      label: 'FREE DEMO',
      backgroundColor: AppColors.warningLight,
      textColor: AppColors.warning,
      icon: Icons.play_circle_fill_rounded,
    );
  }

  factory CourseBadge.live() {
    return const CourseBadge(
      label: '🔴 LIVE',
      backgroundColor: AppColors.errorLight,
      textColor: AppColors.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: textColor,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
