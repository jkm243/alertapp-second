import 'package:flutter/material.dart';
import '../../../services/alert_service.dart';
import '../../../services/authentication_service.dart';
import '../../../models/api_models.dart';

class AlertsReviewPage extends StatefulWidget {
  const AlertsReviewPage({super.key});

  @override
  State<AlertsReviewPage> createState() => _AlertsReviewPageState();
}

class _AlertsReviewPageState extends State<AlertsReviewPage> {
  List<Alert> _alerts = [];
  bool _isLoading = true;
  String? _errorMessage;

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
          _errorMessage = 'Non authentifié';
          _isLoading = false;
        });
        return;
      }

      // Récupérer toutes les alertes et filtrer celles en attente (New)
      final allAlerts = await AlertService.getAllAlerts(token);
      final pendingAlerts = allAlerts.where((alert) => alert.status == StatusEnum.new_).toList();
      
      setState(() {
        _alerts = pendingAlerts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    await _loadAlerts();
  }

  Future<void> _validateAlert(String alertId) async {
    try {
      final authService = AuthenticationService();
      await authService.initialize();
      final token = authService.accessToken;
      
      if (token == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Non authentifié')),
          );
        }
        return;
      }

      final result = await AlertService.validateAlert(alertId, token);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Alerte validée et mission créée'),
            backgroundColor: Colors.green,
          ),
        );
        _refresh();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vérifier les alertes'),
        backgroundColor: const Color(0xFFfa3333),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text(_errorMessage!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _refresh,
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : _alerts.isEmpty
                  ? const Center(child: Text('Aucune alerte en attente'))
                  : RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _alerts.length,
                        itemBuilder: (context, index) {
                          final alert = _alerts[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ExpansionTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.orange,
                                child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
                              ),
                              title: Text(alert.type.name ?? 'Type inconnu'),
                              subtitle: Text(
                                alert.description ?? 'Pas de description',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
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
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton.icon(
                                            onPressed: () => _validateAlert(alert.id),
                                            icon: const Icon(Icons.check),
                                            label: const Text('Valider'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              foregroundColor: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          OutlinedButton.icon(
                                            onPressed: () {
                                              // TODO: Implémenter le rejet
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Fonctionnalité à venir')),
                                              );
                                            },
                                            icon: const Icon(Icons.close),
                                            label: const Text('Rejeter'),
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: Colors.red,
                                            ),
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
                    ),
    );
  }
}
