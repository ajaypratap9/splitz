import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/router/app_router.dart';

class SplitzApp extends ConsumerWidget {
  const SplitzApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Splitz',
      debugShowCheckedModeBanner: false,
      theme: SplitzTheme.lightTheme(),
      darkTheme: SplitzTheme.darkTheme(),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
