import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/repositories/test_repository.dart';
import '../../core/widgets/test_card.dart';

class TestSeriesView extends ConsumerWidget {
  const TestSeriesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testSeriesAsync = ref.watch(testSeriesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('All India Test Series 📝'),
      ),
      body: testSeriesAsync.when(
        data: (tests) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: tests.length,
          itemBuilder: (context, index) {
            final test = tests[index];
            return TestSeriesCard(
              testSeries: test,
              onTap: () => context.push('/mock-test-engine/${test.id}'),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: Text('Error loading test series.')),
      ),
    );
  }
}
