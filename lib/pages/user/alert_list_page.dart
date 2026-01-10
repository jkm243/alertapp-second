import 'package:flutter/material.dart';
import '../../models/api_models.dart';
import '../../services/api_service.dart';
import '../../services/authentication_service.dart';
import 'alert_details_page.dart';

class AlertListPage extends StatefulWidget {
  const AlertListPage({super.key});

  @override
  State<AlertListPage> createState() => _AlertListPageState();
}

class _AlertListPageState extends State<AlertListPage> {
  late Future<List<Alert>> _alertsFuture;
  late AuthenticationService _authService;

  @override
  void initState() {
    super.initState();
    _authService = authService; // Use global auth service
    _loadAlerts();
  }

  void _loadAlerts() {
    _alertsFuture = _fetchAlerts();
  }

  Future<List<Alert>> _fetchAlerts() async {
    final token = _authService.accessToken;
    if (token == null) throw Exception('Token non disponible');
    return ApiService.getUserAlerts(token);
  }

  Future<void> _refreshAlerts() async {
    setState(() {
      _loadAlerts();
    });
  }

  Future<void> _deleteAlert(Alert alert) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer l\'alerte'),
        content: Text('Êtes-vous sûr de vouloir supprimer l\'alerte "${alert.description}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final token = _authService.accessToken;
      if (token == null) throw Exception('Token non disponible');
      
      await ApiService.deleteAlert(token: token, alertId: alert.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Alerte supprimée avec succès'),
            backgroundColor: Colors.green,
          ),
        );
        _refreshAlerts();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes alertes'),
        backgroundColor: const Color(0xFFfa3333),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAlerts,
        child: FutureBuilder<List<Alert>>(
          future: _alertsFuture,
          builder: (context, snapshot) {
            // Chargement
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Erreur
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Erreur de chargement',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(snapshot.error.toString()),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshAlerts,
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              );
            }

            // Pas de données
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_none, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Aucune alerte',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Créez votre première alerte',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              );
            }

            // Liste d'alertes
            final alerts = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                final alert = alerts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(
                      decoration: BoxDecoration(
                        color: _getStatusColor(alert.status),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        _getStatusIcon(alert.status),
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      alert.type.name ?? 'Alerte',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          alert.description ?? 'Sans description',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Créée le ${_formatDate(alert.createdAt)}',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'view') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AlertDetailsPage(alert: alert),
                            ),
                          ).then((_) => _refreshAlerts());
                        } else if (value == 'delete') {
                          _deleteAlert(alert);
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem(
                          value: 'view',
                          child: Row(
                            children: [
                              Icon(Icons.visibility, size: 20),
                              SizedBox(width: 12),
                              Text('Détails'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 20, color: Colors.red),
                              SizedBox(width: 12),
                              Text('Supprimer', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AlertDetailsPage(alert: alert),
                        ),
                      ).then((_) => _refreshAlerts());
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getStatusColor(StatusEnum status) {
    switch (status) {
      case StatusEnum.new_:
        return Colors.orange;
      case StatusEnum.validated:
        return Colors.green;
      case StatusEnum.rejected:
        return Colors.red;
      case StatusEnum.inProgress:
        return Colors.blue;
      case StatusEnum.resolved:
        return Colors.green;
      case StatusEnum.closed:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(StatusEnum status) {
    switch (status) {
      case StatusEnum.new_:
        return Icons.schedule;
      case StatusEnum.validated:
        return Icons.check_circle;
      case StatusEnum.rejected:
        return Icons.cancel;
      case StatusEnum.inProgress:
        return Icons.notifications_active;
      case StatusEnum.resolved:
        return Icons.check_circle;
      case StatusEnum.closed:
        return Icons.archive;
    }
  }
}
