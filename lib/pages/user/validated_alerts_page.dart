import 'package:flutter/material.dart';
import '../../models/api_models.dart';
import '../../services/api_service.dart';
import '../../services/authentication_service.dart';
import 'alert_details_page.dart';

class ValidatedAlertsPage extends StatefulWidget {
  const ValidatedAlertsPage({super.key});

  @override
  State<ValidatedAlertsPage> createState() => _ValidatedAlertsPageState();
}

class _ValidatedAlertsPageState extends State<ValidatedAlertsPage> {
  late Future<List<Alert>> _alertsFuture;
  late AuthenticationService _authService;

  @override
  void initState() {
    super.initState();
    _authService = authService;
    _loadAlerts();
  }

  void _loadAlerts() {
    _alertsFuture = _fetchAlerts();
  }

  Future<List<Alert>> _fetchAlerts() async {
    final token = _authService.accessToken;
    if (token == null) throw Exception('Token non disponible');
    return ApiService.getValidatedAlerts(token);
  }

  Future<void> _refreshAlerts() async {
    setState(() {
      _loadAlerts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alertes validées'),
        backgroundColor: const Color(0xFFfa3333),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAlerts,
        child: FutureBuilder<List<Alert>>(
          future: _alertsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Erreur: ${snapshot.error}'),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _refreshAlerts,
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Aucune alerte validée',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _refreshAlerts,
                      child: const Text('Actualiser'),
                    ),
                  ],
                ),
              );
            }

            final alerts = snapshot.data!;
            return ListView.builder(
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                final alert = alerts[index];
                return _buildAlertCard(alert);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildAlertCard(Alert alert) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AlertDetailsPage(alert: alert),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header avec type et statut
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alert.type.name ?? 'Type inconnu',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF230F0F),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          alert.user.fullName,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(alert.status),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      alert.status.toString().split('.').last,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Description
              if (alert.description != null && alert.description!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              // Localisation
              Row(
                children: [
                  Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${alert.latitude?.toStringAsFixed(4)}, ${alert.longitude?.toStringAsFixed(4)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Date
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(alert.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              // Nombre de médias
              if (alert.medias.isNotEmpty)
                Column(
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.image, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${alert.medias.length} fichier(s)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(StatusEnum status) {
    switch (status) {
      case StatusEnum.new_:
        return Colors.blue;
      case StatusEnum.validated:
        return Colors.green;
      case StatusEnum.rejected:
        return Colors.red;
      case StatusEnum.inProgress:
        return Colors.orange;
      case StatusEnum.resolved:
        return Colors.purple;
      case StatusEnum.closed:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays}j';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
