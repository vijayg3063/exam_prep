import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

class NotesViewerView extends StatefulWidget {
  final String title;

  const NotesViewerView({
    super.key,
    required this.title,
  });

  @override
  State<NotesViewerView> createState() => _NotesViewerViewState();
}

class _NotesViewerViewState extends State<NotesViewerView> {
  bool _isBookmarked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(
              _isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: _isBookmarked ? AppColors.primary : AppColors.textPrimary,
            ),
            onPressed: () {
              setState(() {
                _isBookmarked = !_isBookmarked;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isBookmarked ? 'Added to My Bookmarks!' : 'Removed from Bookmarks'),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading PDF to device storage...')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.description_rounded, size: 48, color: AppColors.primary),
                    const SizedBox(height: 10),
                    Text(
                      widget.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Prepared by Faculty Team • Pariksha Prep',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const Divider(height: 32, color: AppColors.border),
              const Text(
                'CHAPTER SUMMARY & KEY FORMULAS',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 1.0),
              ),
              const SizedBox(height: 14),
              const Text(
                '1. Percentage Basics:\nPercentage means "per hundred". Fraction to Percentage conversion: Multiply by 100.\nExample: 1/4 = 25%, 1/5 = 20%, 1/8 = 12.5%, 1/6 = 16.67%.\n\n2. Successive Percentage Increase/Decrease Formula:\nOverall Change = a + b + (a * b / 100)%\nWhere a and b are percentage changes (+ for increase, - for decrease).\n\n3. Price & Consumption Relation:\nIf Price increases by R%, Consumption must decrease by [R / (100 + R)] * 100% to keep expenditure constant.\n\n4. Examination & Pass Marks Tricks:\nIf candidate gets x% marks and fails by a marks, while candidate 2 gets y% and gets b marks more than pass marks:\nMax Marks = [100 * (a + b)] / (y - x).',
                style: TextStyle(fontSize: 14, height: 1.6, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warningLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lightbulb_outline_rounded, color: AppColors.warning),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Exam Tip: Memorize fractions up to 1/20 to solve Quant questions in SSC CGL Tier 1 in under 15 seconds.',
                        style: TextStyle(fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                      ),
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
}
