import 'package:flutter/material.dart';
import 'apps/supervisor/supervisor_home.dart';
import 'apps/supervisor/pages/login_page.dart';
import 'apps/supervisor/pages/signup_page.dart';
import 'apps/supervisor/pages/alerts_review.dart';
import 'widgets/auth_guard.dart';
import 'design_system/theme.dart';

void main() => runApp(SupervisorApp());

class SupervisorApp extends StatelessWidget {
  const SupervisorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alerte RDC - Supervisor',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      // The RoleGuard handles token verification and role checks.
      home: const RoleGuard(
        allowedRole: 'Supervisor',
        loginPage: SupervisorLoginPage(),
        homePage: SupervisorHomePage(),
      ),
      routes: {
        '/login': (context) => const SupervisorLoginPage(),
        '/signup': (context) => const SupervisorSignupPage(),
        '/alerts': (context) => const AlertsReviewPage(),
      },
    );
  }
}
