import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_scroll_behavior.dart';
import 'core/routing/app_router.dart';
import 'core/constants/app_constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: ParikshaPrepApp(),
    ),
  );
}

class ParikshaPrepApp extends ConsumerWidget {
  const ParikshaPrepApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      scrollBehavior: const AppScrollBehavior(),
      routerConfig: router,
    );
  }
}
