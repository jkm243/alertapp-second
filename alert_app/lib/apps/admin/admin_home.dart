import 'package:flutter/material.dart';
import '../../widgets/primary_button.dart';
import '../../../services/authentication_service.dart';
import 'pages/login_page.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin - Tableau de bord'),
        backgroundColor: const Color(0xFFfa3333),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // logout and go to login page
              final authService = AuthenticationService();
              await authService.logout();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AdminLoginPage()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bienvenue, Admin',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Ce tableau de bord est réservé aux administrateurs.'),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Gestion des utilisateurs',
              onPressed: () {
                Navigator.of(context).pushNamed('/users');
              },
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              text: 'Paramètres du système',
              onPressed: () {
                Navigator.of(context).pushNamed('/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
