import 'package:flutter/material.dart';
import '../design_system/colors.dart' as design_colors;
import '../models/api_models.dart';
import '../services/authentication_service.dart';
import '../services/api_service.dart';
import 'permissions/location_permission_page.dart';
import 'user/add_alert_page.dart';
import 'user/alert_details_page.dart';
import 'user_profile_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1; // Start on Alerts tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: design_colors.AppColors.background,
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          _MapTab(),
          _AlertsTab(),
          _ProfileTab(),
          _SettingsTab(),
        ],
      ),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddAlertPage(),
                  ),
                ).then((result) {
                  if (result == true) {
                    setState(() {});
                  }
                });
              },
              backgroundColor: design_colors.AppColors.primary,
              icon: const Icon(Icons.add),
              label: const Text('Signaler une alerte'),
            )
          : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey[300]!,
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: design_colors.AppColors.background,
          selectedItemColor: design_colors.AppColors.primary,
          unselectedItemColor: Colors.grey[500],
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Carte',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Alertes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Paramètres',
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertsTab extends StatefulWidget {
  const _AlertsTab();

  @override
  State<_AlertsTab> createState() => __AlertsTabState();
}

class __AlertsTabState extends State<_AlertsTab> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Alert>> _alertsFuture;
  final _authService = AuthenticationService();

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadAlerts() {
    setState(() {
      _alertsFuture = _fetchAlerts();
    });
  }

  Future<List<Alert>> _fetchAlerts() async {
    final token = _authService.accessToken;
    if (token == null) throw Exception('Token non disponible');
    return ApiService.getUserAlerts(token);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Sticky header
        SliverAppBar(
          pinned: true,
          backgroundColor: design_colors.AppColors.background,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Alertes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF230F0F),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.menu, color: Colors.grey[700]),
              onPressed: () => _showMenuDialog(context),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Rechercher...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Map placeholder
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey[300],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.map,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Recent alerts heading
                Text(
                  'Alertes récentes',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ),
        // Alerts list
        FutureBuilder<List<Alert>>(
          future: _alertsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 32),
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        const Text('Chargement...'),
                      ],
                    ),
                  ),
                ),
              );
            }

            if (snapshot.hasError) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
                        const SizedBox(height: 16),
                        const Text('Erreur de chargement'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _loadAlerts(),
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            final alerts = snapshot.data ?? [];
            if (alerts.isEmpty) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_none, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        const Text('Aucune alerte'),
                      ],
                    ),
                  ),
                ),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final alert = alerts[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AlertDetailsPage(alert: alert),
                          ),
                        ).then((_) => _loadAlerts());
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: _buildAlertCard(alert),
                      ),
                    );
                  },
                  childCount: alerts.length,
                ),
              ),
            );
          },
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
      ],
    );
  }

  Widget _buildAlertCard(Alert alert) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!, width: 0.5),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: design_colors.AppColors.primary.withValues(alpha: 0.1),
            ),
            child: Icon(
              Icons.location_on,
              color: design_colors.AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.type.name ?? 'Alerte',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${alert.description ?? "Sans description"} • ${_getTimeAgo(alert.createdAt)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'À l\'instant';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}j';

    return 'Il y a longtemps';
  }

  void _showMenuDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Menu'),
        content: const Text('Sélectionnez une option'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LocationPermissionPage(),
                ),
              );
            },
            child: const Text('Permissions'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _logout(context);
            },
            child: const Text('Déconnexion'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              if (!mounted) return;
              Navigator.of(context).pop();
              final authService = AuthenticationService();
              await authService.logout();
              if (mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );
  }
}

class _MapTab extends StatelessWidget {
  const _MapTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.map,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Carte - À venir',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const UserProfilePage(),
        );
      },
    );
  }
}

class _SettingsTab extends StatelessWidget {
  const _SettingsTab();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const SettingsPage(),
        );
      },
    );
  }
}
