import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splitt/config/app_config.dart';
import 'package:splitt/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:splitt/features/auth/presentation/views/login_screen.dart';
import 'package:splitt/features/home_screen.dart';
import 'package:splitt/theme/theme.dart';

import 'common/utils/keys.dart';

void main() async {
  appConfig = AppConfig();
  WidgetsFlutterBinding.ensureInitialized();
  final authBloc = AuthBloc();
  await authBloc.checkLoginStatus();
  runApp(
    BlocProvider(
      create: (_) => authBloc,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splitwise',
      navigatorKey: navigatorKey,
      theme: AppTheme.lightTheme,
      home: context.read<AuthBloc>().state.isLoggedIn
          ? const HomeScreen()
          : const LoginScreen(),
    );
  }
}
