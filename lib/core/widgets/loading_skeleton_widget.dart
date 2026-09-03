import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';

class LoadingSkeletonWidget extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;

  const LoadingSkeletonWidget({
    super.key,
    this.height = 20,
    this.width = double.infinity,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.border.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ).animate(onPlay: (controller) => controller.repeat())
     .shimmer(duration: const Duration(milliseconds: 1200), color: Colors.white.withValues(alpha: 0.8));
  }
}
