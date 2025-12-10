import 'package:flutter/material.dart';
import '../../design_system/colors.dart';
import '../../services/authentication_service.dart';
import 'pages/login_page.dart';

class SupervisorHomePage extends StatefulWidget {
  const SupervisorHomePage({super.key});

  @override
  State<SupervisorHomePage> createState() => _SupervisorHomePageState();
}

class _SupervisorHomePageState extends State<SupervisorHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardTab(),
    const AlertsTab(),
    const VerificationTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supervision', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Tableau de bord',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'Alertes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.verified),
            label: 'Vérification',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        onTap: _onItemTapped,
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      final authService = AuthenticationService();
      await authService.logout();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SupervisorLoginPage()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de déconnexion: $e')),
        );
      }
    }
  }
}

// Dashboard Tab
class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tableau de bord superviseur',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Statistics Cards
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Alertes reçues',
                  value: '89',
                  icon: Icons.warning,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _StatCard(
                  title: 'Alertes vérifiées',
                  value: '67',
                  icon: Icons.check_circle,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'En cours',
                  value: '12',
                  icon: Icons.pending,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _StatCard(
                  title: 'Taux de résolution',
                  value: '75%',
                  icon: Icons.trending_up,
                  color: Colors.purple,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),
          const Text(
            'Actions rapides',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Quick Actions
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _QuickActionCard(
                title: 'Voir alertes',
                icon: Icons.warning,
                onTap: () {},
              ),
              _QuickActionCard(
                title: 'Vérifications',
                icon: Icons.verified,
                onTap: () {},
              ),
              _QuickActionCard(
                title: 'Rapports',
                icon: Icons.analytics,
                onTap: () {},
              ),
              _QuickActionCard(
                title: 'Historique',
                icon: Icons.history,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Alerts Tab
class AlertsTab extends StatelessWidget {
  const AlertsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gestion des alertes',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Filter buttons
          Row(
            children: [
              FilterChip(
                label: const Text('Toutes'),
                selected: true,
                onSelected: (selected) {},
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('En attente'),
                selected: false,
                onSelected: (selected) {},
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Vérifiées'),
                selected: false,
                onSelected: (selected) {},
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Alerts List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 15, // Mock data
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ExpansionTile(
                  title: Text('Alerte ${index + 1}'),
                  subtitle: Text('Utilisateur: John Doe  ${index % 3 == 0 ? 'Vérifiée' : index % 3 == 1 ? 'En cours' : 'En attente'}'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Description:'),
                          const SizedBox(height: 8),
                          const Text('Description détaillée de l\'alerte signalée par l\'utilisateur...'),
                          const SizedBox(height: 16),
                          const Text('Localisation: Paris, France'),
                          const SizedBox(height: 8),
                          Text('Date: ${DateTime.now().toString().split('.')[0]}'),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                child: const Text('Vérification manuelle'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {},
                                child: const Text('Vérification automatique'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: const Text('Ajouter informations'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Verification Tab
class VerificationTab extends StatelessWidget {
  const VerificationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Centre de vérification',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Verification Options
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Options de vérification',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _VerificationOption(
                    title: 'Vérification automatique',
                    description: 'Lancer une vérification automatique basée sur les données disponibles',
                    icon: Icons.autorenew,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 12),
                  _VerificationOption(
                    title: 'Vérification manuelle',
                    description: 'Effectuer une vérification manuelle avec intervention humaine',
                    icon: Icons.person,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 12),
                  _VerificationOption(
                    title: 'Vérification par IA',
                    description: 'Utiliser l\'intelligence artificielle pour analyser l\'alerte',
                    icon: Icons.smart_toy,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),
          const Text(
            'Historique des vérifications',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Verification History
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(
                    index % 3 == 0 ? Icons.check_circle : index % 3 == 1 ? Icons.pending : Icons.error,
                    color: index % 3 == 0 ? Colors.green : index % 3 == 1 ? Colors.orange : Colors.red,
                  ),
                  title: Text('Vérification alerte ${index + 1}'),
                  subtitle: Text('Type: ${index % 3 == 0 ? 'Automatique' : index % 3 == 1 ? 'Manuelle' : 'IA'}  ${DateTime.now().subtract(Duration(hours: index)).toString().split('.')[0]}'),
                  trailing: Text(
                    index % 3 == 0 ? 'Réussie' : index % 3 == 1 ? 'En cours' : 'Échouée',
                    style: TextStyle(
                      color: index % 3 == 0 ? Colors.green : index % 3 == 1 ? Colors.orange : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Helper Widgets
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: AppColors.primary),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VerificationOption extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onPressed;

  const _VerificationOption({
    required this.title,
    required this.description,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, size: 24, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
