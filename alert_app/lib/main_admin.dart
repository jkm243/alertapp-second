import 'package:flutter/material.dart';
import 'apps/admin/admin_home.dart';
import 'apps/admin/pages/login_page.dart';
import 'apps/admin/pages/signup_page.dart';
import 'apps/admin/pages/user_management.dart';
import 'widgets/auth_guard.dart';
import 'design_system/theme.dart';

void main() => runApp(AdminApp());

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alerte RDC - Admin',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      // RoleGuard will show login page by default if not authenticated or wrong role
      home: const RoleGuard(
        allowedRole: 'Admin',
        loginPage: AdminLoginPage(),
        homePage: AdminHomePage(),
      ),
      routes: {
        '/login': (context) => const AdminLoginPage(),
        '/signup': (context) => const AdminSignupPage(),
        '/dashboard': (context) => const AdminHomePage(),
        '/users': (context) => const UserManagementPage(),
      },
    );
  }
}
