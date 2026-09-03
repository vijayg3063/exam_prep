import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum AppButtonType { primary, secondary, outline, text }

// ──────────────────────────────────────────────────────────────
// AppButton — full-width button component.
//
// IMPORTANT: Never wrap ElevatedButton in SizedBox(width: double.infinity).
// That creates ConstrainedBox(minWidth: ∞) which Flutter cannot resolve
// in certain layout passes (inside Column/SingleChildScrollView), causing
// the "BoxConstraints forces an infinite width" crash and a blank screen.
//
// Safe pattern: wrap in Row([Expanded(child: button)]).
// The Expanded widget gives the button a bounded tight width equal to
// the Row's remaining horizontal space — always finite.
// ──────────────────────────────────────────────────────────────
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    // If a specific width was given, honour it with SizedBox.
    // Otherwise use Row+Expanded for full-width (safe — no ∞ constraint).
    if (width != null) {
      return SizedBox(width: width, height: height, child: _button());
    }
    return SizedBox(height: height, child: Row(children: [Expanded(child: _button())]));
  }

  Widget _button() {
    if (isLoading) {
      return ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary.withValues(alpha: 0.7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        ),
      );
    }

    switch (type) {
      case AppButtonType.primary:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _buildChild(),
        );
      case AppButtonType.secondary:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.lightPrimary,
            foregroundColor: AppColors.primary,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _buildChild(),
        );
      case AppButtonType.outline:
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _buildChild(),
        );
      case AppButtonType.text:
        return TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(foregroundColor: AppColors.primary),
          child: _buildChild(),
        );
    }
  }

  Widget _buildChild() {
    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      );
    }
    return Text(text, style: const TextStyle(fontWeight: FontWeight.w600));
  }
}
