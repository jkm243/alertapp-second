import 'package:flutter/material.dart';
import 'apps/user/user_home.dart';
import 'pages/onboarding/onboarding_page.dart';
import 'pages/auth/login_page.dart';
import 'design_system/theme.dart';

void main() => runApp(UserApp());

class UserApp extends StatelessWidget {
  const UserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alerte RDC - User',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: OnboardingPage(), // onboarding is shared; the app's home is the user wrapper (Home page uses services)
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => const UserHomeWrapper(),
      },
    );
  }
}
