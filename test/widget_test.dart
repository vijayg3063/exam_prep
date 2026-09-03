import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exam_prep/main.dart';

void main() {
  testWidgets('App launch smoke test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const ProviderScope(
        child: ParikshaPrepApp(),
      ),
    );

    await tester.pump();
    expect(find.byType(ParikshaPrepApp), findsOneWidget);

    // Fast-forward any lingering animation timers in test environment
    await tester.pump(const Duration(seconds: 100));
  });
}
