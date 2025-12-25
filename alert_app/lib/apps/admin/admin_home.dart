import 'package:flutter/material.dart';
import '../../design_system/colors.dart';
import '../../services/authentication_service.dart';
import '../../services/alert_service.dart';
import '../../models/api_models.dart';
import 'pages/login_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardTab(),
    const UsersTab(),
    const AlertsTab(),
    const SettingsTab(),
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
        title: const Text('Administration', style: TextStyle(color: Colors.white)),
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
            icon: Icon(Icons.people),
            label: 'Utilisateurs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'Alertes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramètres',
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
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AdminLoginPage()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de déconnexion: $e')),
      );
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
            'Tableau de bord administrateur',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Statistics Cards
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Utilisateurs actifs',
                  value: '1,234',
                  icon: Icons.people,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _StatCard(
                  title: 'Alertes totales',
                  value: '567',
                  icon: Icons.warning,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'Alertes vérifiées',
                  value: '423',
                  icon: Icons.check_circle,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _StatCard(
                  title: 'Alertes en attente',
                  value: '144',
                  icon: Icons.pending,
                  color: Colors.red,
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
                title: 'Gérer utilisateurs',
                icon: Icons.people,
                onTap: () {},
              ),
              _QuickActionCard(
                title: 'Voir alertes',
                icon: Icons.warning,
                onTap: () {},
              ),
              _QuickActionCard(
                title: 'Configuration',
                icon: Icons.settings,
                onTap: () {},
              ),
              _QuickActionCard(
                title: 'Rapports',
                icon: Icons.analytics,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Users Tab
class UsersTab extends StatelessWidget {
  const UsersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Gestion des utilisateurs',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Ajouter utilisateur'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // User List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10, // Mock data
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
                  ),
                  title: Text('Utilisateur ${index + 1}'),
                  subtitle: Text('Rôle: ${index % 3 == 0 ? 'Admin' : index % 3 == 1 ? 'Operator' : 'User'}'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      // Handle menu actions
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: 'edit',
                        child: Text('Modifier'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Text('Supprimer'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'reset_password',
                        child: Text('Réinitialiser mot de passe'),
                      ),
                    ],
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

// Alerts Tab
class AlertsTab extends StatefulWidget {
  const AlertsTab({super.key});

  @override
  State<AlertsTab> createState() => _AlertsTabState();
}

class _AlertsTabState extends State<AlertsTab> {
  List<Alert> _alerts = [];
  bool _isLoading = true;
  String _filterStatus = 'all';

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  Future<void> _loadAlerts() async {
    setState(() => _isLoading = true);
    try {
      final authService = AuthenticationService();
      await authService.initialize();
      final token = authService.accessToken;
      
      if (token != null) {
        final alerts = await AlertService.getAllAlerts(token);
        setState(() {
          _alerts = alerts;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${e.toString()}')),
        );
      }
    }
  }

  List<Alert> get _filteredAlerts {
    if (_filterStatus == 'all') return _alerts;
    return _alerts.where((alert) {
      switch (_filterStatus) {
        case 'new':
          return alert.status == StatusEnum.new_;
        case 'validated':
          return alert.status == StatusEnum.validated;
        default:
          return true;
      }
    }).toList();
  }

  String _getStatusText(StatusEnum status) {
    switch (status) {
      case StatusEnum.new_:
        return 'Nouveau';
      case StatusEnum.validated:
        return 'Validé';
      case StatusEnum.rejected:
        return 'Rejeté';
      case StatusEnum.inProgress:
        return 'En cours';
      case StatusEnum.resolved:
        return 'Résolu';
      case StatusEnum.closed:
        return 'Fermé';
    }
  }

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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Toutes', 'all'),
                const SizedBox(width: 8),
                _buildFilterChip('En attente', 'new'),
                const SizedBox(width: 8),
                _buildFilterChip('Validées', 'validated'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Alerts List
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredAlerts.isEmpty
                  ? const Center(child: Text('Aucune alerte'))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _filteredAlerts.length,
                      itemBuilder: (context, index) {
                        final alert = _filteredAlerts[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ExpansionTile(
                            title: Text(alert.type.name ?? 'Type inconnu'),
                            subtitle: Text('Statut: ${_getStatusText(alert.status)}'),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (alert.description != null)
                                      Text('Description: ${alert.description}'),
                                    if (alert.latitude != null && alert.longitude != null)
                                      Text('Position: ${alert.latitude}, ${alert.longitude}'),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () => _loadAlerts(),
                                          child: const Text('Actualiser'),
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

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filterStatus == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _filterStatus = value);
      },
    );
  }
}

// Settings Tab
class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Configuration système',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Settings sections
          _SettingsSection(
            title: 'Paramètres généraux',
            children: [
              _SettingItem(
                title: 'Notifications push',
                subtitle: 'Activer les notifications push',
                value: true,
                onChanged: (value) {},
              ),
              _SettingItem(
                title: 'Mode maintenance',
                subtitle: 'Activer le mode maintenance',
                value: false,
                onChanged: (value) {},
              ),
            ],
          ),

          const SizedBox(height: 20),

          _SettingsSection(
            title: 'Configuration des alertes',
            children: [
              _SettingItem(
                title: 'Vérification automatique',
                subtitle: 'Activer la vérification automatique des alertes',
                value: true,
                onChanged: (value) {},
              ),
              _SettingItem(
                title: 'Alertes prioritaires',
                subtitle: 'Traiter en priorité les alertes urgentes',
                value: true,
                onChanged: (value) {},
              ),
            ],
          ),

          const SizedBox(height: 20),

          _SettingsSection(
            title: 'Gestion des utilisateurs',
            children: [
              _SettingItem(
                title: 'Inscription ouverte',
                subtitle: 'Permettre l\'inscription libre',
                value: false,
                onChanged: (value) {},
              ),
              _SettingItem(
                title: 'Validation email',
                subtitle: 'Exiger la validation des emails',
                value: true,
                onChanged: (value) {},
              ),
            ],
          ),

          const SizedBox(height: 32),

          Center(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text('Sauvegarder les paramètres'),
            ),
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

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingItem({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.primary,
      ),
    );
  }
}
