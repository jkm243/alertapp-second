import 'package:flutter/material.dart';
import '../../services/alert_service.dart';
import '../../services/authentication_service.dart';
import '../../models/api_models.dart';
import 'alert_detail_page.dart';
import 'create_alert_page.dart';

class AlertsListPage extends StatefulWidget {
  const AlertsListPage({super.key});

  @override
  State<AlertsListPage> createState() => _AlertsListPageState();
}

class _AlertsListPageState extends State<AlertsListPage> {
  List<Alert> _alerts = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _filterStatus = 'all'; // all, new, validated, rejected, inProgress, resolved, closed

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  Future<void> _loadAlerts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = AuthenticationService();
      await authService.initialize();
      final token = authService.accessToken;
      
      if (token == null) {
        setState(() {
          _errorMessage = 'Non authentifié. Veuillez vous reconnecter.';
          _isLoading = false;
        });
        return;
      }

      final alerts = await AlertService.getMyAlerts(token);
      setState(() {
        _alerts = alerts;
        _isLoading = false;
      });
    } on ApiError catch (e) {
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors du chargement: ${e.toString()}';
        _isLoading = false;
      });
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
        case 'rejected':
          return alert.status == StatusEnum.rejected;
        case 'inProgress':
          return alert.status == StatusEnum.inProgress;
        case 'resolved':
          return alert.status == StatusEnum.resolved;
        case 'closed':
          return alert.status == StatusEnum.closed;
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
        return Colors.teal;
      case StatusEnum.closed:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red[700]),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _loadAlerts,
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Filtres
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip('Toutes', 'all'),
                            const SizedBox(width: 8),
                            _buildFilterChip('Nouveau', 'new'),
                            const SizedBox(width: 8),
                            _buildFilterChip('Validé', 'validated'),
                            const SizedBox(width: 8),
                            _buildFilterChip('En cours', 'inProgress'),
                            const SizedBox(width: 8),
                            _buildFilterChip('Résolu', 'resolved'),
                            const SizedBox(width: 8),
                            _buildFilterChip('Fermé', 'closed'),
                          ],
                        ),
                      ),
                    ),
                    // Liste des alertes
                    Expanded(
                      child: _filteredAlerts.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.warning_amber, size: 64, color: Colors.grey[400]),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Aucune alerte',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 18),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Créez votre première alerte',
                                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                                  ),
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _loadAlerts,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: _filteredAlerts.length,
                                itemBuilder: (context, index) {
                                  final alert = _filteredAlerts[index];
                                  return _buildAlertCard(alert);
                                },
                              ),
                            ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const CreateAlertPage()),
          );
          if (result != null) {
            _loadAlerts();
          }
        },
        backgroundColor: const Color(0xFFfa3333),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Nouvelle alerte', style: TextStyle(color: Colors.white)),
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
      selectedColor: const Color(0xFFfa3333).withOpacity(0.2),
      checkmarkColor: const Color(0xFFfa3333),
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFFfa3333) : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildAlertCard(Alert alert) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AlertDetailPage(alertId: alert.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alert.type.name ?? 'Type inconnu',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (alert.description != null && alert.description!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              alert.description!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey[700], fontSize: 14),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(alert.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getStatusText(alert.status),
                      style: TextStyle(
                        color: _getStatusColor(alert.status),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (alert.latitude != null && alert.longitude != null)
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${alert.latitude!.toStringAsFixed(4)}, ${alert.longitude!.toStringAsFixed(4)}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                  const Spacer(),
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(alert.createdAt),
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
              if (alert.medias.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.photo_library, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${alert.medias.length} média${alert.medias.length > 1 ? 'x' : ''}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return 'Il y a ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'Il y a ${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'Il y a ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'À l\'instant';
    }
  }
}




