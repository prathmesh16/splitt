import 'package:flutter/material.dart';
import 'package:splitt/features/home_screen.dart';
import 'package:splitt/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splitwise',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
