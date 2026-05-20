import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: InsightActionApp(),
    ),
  );
}

class InsightActionApp extends StatelessWidget {
  const InsightActionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Insight → Action',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}
