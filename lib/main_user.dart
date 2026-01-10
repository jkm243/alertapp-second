import 'package:flutter/material.dart';
import 'apps/user/user_home.dart';
import 'pages/onboarding/onboarding_page.dart';
import 'pages/auth/login_page.dart';
import 'design_system/theme.dart';
import 'services/authentication_service.dart';
import 'services/location_service.dart';

void main() async {
  print('🚀 Starting User App...');
  
  // Initialize authentication service
  final authService = AuthenticationService();
  initializeAuthService(authService);
  await authService.initialize();
  
  // Request location permissions
  print('📍 Requesting location permissions...');
  await locationService.requestLocationPermission();
  
  print('✅ App initialized');
  runApp(const UserApp());
}

class UserApp extends StatelessWidget {
  const UserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alerte RDC - User',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: OnboardingPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => const UserHomeWrapper(),
      },
    );
  }
}
