import 'package:flutter/material.dart';

import 'package:flutter_sleep_calculator/screens/home_screen.dart';
import 'package:flutter_sleep_calculator/widgets/about_screen.dart';

void main() {
  runApp(const SleepCalculatorApp());
}

class SleepCalculatorApp extends StatefulWidget {
  const SleepCalculatorApp({super.key});

  @override
  State<SleepCalculatorApp> createState() => _SleepCalculatorAppState();
}

class _SleepCalculatorAppState extends State<SleepCalculatorApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleep Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: const Color(0xFF6366F1),
              brightness: Brightness.light,
            ).copyWith(
              primary: const Color(0xFF6366F1),
              secondary: const Color(0xFF8B5CF6),
              tertiary: const Color(0xFF06B6D4),
            ),
        fontFamily: 'SF Pro Display',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: const Color(0xFF6366F1),
              brightness: Brightness.dark,
            ).copyWith(
              primary: const Color(0xFF818CF8),
              secondary: const Color(0xFFA78BFA),
              tertiary: const Color(0xFF22D3EE),
            ),
        fontFamily: 'SF Pro Display',
      ),
      themeMode: _themeMode,
      home: HomeScreen(onThemeToggle: _toggleTheme),
      routes: {'/about': (context) => const AboutScreen()},
    );
  }
}
