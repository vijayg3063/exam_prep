import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exam_prep/features/auth/exam_onboarding_view.dart';
import 'package:exam_prep/core/theme/app_theme.dart';

void main() {
  testWidgets('ExamOnboardingView renders target exams without Material shape assertion error', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ExamOnboardingView(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Personalize Your Learning 🎯'), findsOneWidget);
    expect(find.byType(ListTile), findsWidgets);
  });
}
