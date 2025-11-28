import 'package:flutter/material.dart';
import '../../widgets/primary_button.dart';
import '../../../services/authentication_service.dart';
import 'pages/alerts_review.dart';
import 'pages/login_page.dart';

class SupervisorHomePage extends StatelessWidget {
  const SupervisorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supervisor - Tableau de bord'),
        backgroundColor: const Color(0xFFfa3333),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final authService = AuthenticationService();
              await authService.logout();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SupervisorLoginPage()));
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
              'Bienvenue, Superviseur',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Ce tableau de bord est réservé aux superviseurs.'),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Vérifier les alertes',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AlertsReviewPage()),
                );
              },
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              text: 'Rapports',
              onPressed: () {
                // TODO: Route to reports
              },
            ),
          ],
        ),
      ),
    );
  }
}
