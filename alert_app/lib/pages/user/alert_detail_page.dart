import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/alert_service.dart';
import '../../services/authentication_service.dart';
import '../../models/api_models.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AlertDetailPage extends StatefulWidget {
  final String alertId;

  const AlertDetailPage({super.key, required this.alertId});

  @override
  State<AlertDetailPage> createState() => _AlertDetailPageState();
}

class _AlertDetailPageState extends State<AlertDetailPage> {
  Alert? _alert;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAlert();
  }

  Future<void> _loadAlert() async {
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

      // Note: L'API n'a pas d'endpoint direct pour récupérer une alerte par ID
      // On récupère toutes les alertes et on filtre
      final alerts = await AlertService.getMyAlerts(token);
      final alert = alerts.firstWhere(
        (a) => a.id == widget.alertId,
        orElse: () => alerts.first, // Fallback si non trouvé
      );

      setState(() {
        _alert = alert;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur: ${e.toString()}';
        _isLoading = false;
      });
    }
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
      appBar: AppBar(
        title: const Text('Détails de l\'alerte'),
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
                      Text(_errorMessage!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadAlert,
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : _alert == null
                  ? const Center(child: Text('Alerte non trouvée'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Statut
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _getStatusColor(_alert!.status).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline, color: _getStatusColor(_alert!.status)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Statut',
                                        style: TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                      Text(
                                        _getStatusText(_alert!.status),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: _getStatusColor(_alert!.status),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Type d'alerte
                          _buildInfoRow(
                            icon: Icons.category,
                            label: 'Type',
                            value: _alert!.type.name ?? 'Non spécifié',
                          ),
                          const SizedBox(height: 16),

                          // Description
                          if (_alert!.description != null && _alert!.description!.isNotEmpty) ...[
                            const Text(
                              'Description',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _alert!.description!,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Localisation
                          if (_alert!.latitude != null && _alert!.longitude != null) ...[
                            _buildInfoRow(
                              icon: Icons.location_on,
                              label: 'Localisation',
                              value: '${_alert!.latitude!.toStringAsFixed(6)}, ${_alert!.longitude!.toStringAsFixed(6)}',
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Date de création
                          _buildInfoRow(
                            icon: Icons.access_time,
                            label: 'Créée le',
                            value: DateFormat('dd/MM/yyyy à HH:mm').format(_alert!.createdAt),
                          ),
                          const SizedBox(height: 24),

                          // Médias
                          if (_alert!.medias.isNotEmpty) ...[
                            const Text(
                              'Médias',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _alert!.medias.length,
                                itemBuilder: (context, index) {
                                  final media = _alert!.medias[index];
                                  return Container(
                                    width: 200,
                                    margin: const EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.grey[300]!),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: CachedNetworkImage(
                                        imageUrl: media.file,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Informations utilisateur
                          if (_alert!.user.fullName.isNotEmpty) ...[
                            _buildInfoRow(
                              icon: Icons.person,
                              label: 'Créée par',
                              value: _alert!.user.fullName,
                            ),
                          ],
                        ],
                      ),
                    ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}




