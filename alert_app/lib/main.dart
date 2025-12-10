import 'package:flutter/material.dart';
import 'pages/onboarding/onboarding_page.dart';
import 'pages/auth/login_page.dart';
import 'pages/user/add_alert_page.dart';
import 'design_system/theme.dart';
import 'design_system/examples/badge_example.dart';
import 'design_system/examples/design_system_demo.dart';
import 'design_system/examples/usage_example.dart';

// Default entrypoint runs the user app. For alternate roles, use
// `flutter run -t lib/main_admin.dart` or `flutter run -t lib/main_supervisor.dart`.
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alerte RDC',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: OnboardingPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/add-alert': (context) => const AddAlertPage(),
        '/badge-example': (context) => const BadgeExample(),
        '/design-system': (context) => const DesignSystemDemo(),
        '/usage-example': (context) => const UsageExample(),
      },
    );
  }
}