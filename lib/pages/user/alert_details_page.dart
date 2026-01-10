import 'package:flutter/material.dart';
import '../../models/api_models.dart';
import '../../services/api_service.dart';
import '../../services/authentication_service.dart';

class AlertDetailsPage extends StatefulWidget {
  final Alert alert;

  const AlertDetailsPage({
    super.key,
    required this.alert,
  });

  @override
  State<AlertDetailsPage> createState() => _AlertDetailsPageState();
}

class _AlertDetailsPageState extends State<AlertDetailsPage> {
  late TextEditingController _descriptionController;
  bool _isLoading = false;
  bool _isEditing = false;
  late Alert _alert;
  late AuthenticationService _authService;

  @override
  void initState() {
    super.initState();
    _authService = authService; // Use global auth service
    _alert = widget.alert;
    _descriptionController = TextEditingController(text: _alert.description ?? '');
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La description ne peut pas être vide')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final token = _authService.accessToken;
      if (token == null) throw Exception('Token non disponible');

      _alert = await ApiService.updateAlert(
        token: token,
        alertId: _alert.id,
        description: _descriptionController.text.trim(),
      );

      setState(() {
        _isEditing = false;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Alerte mise à jour avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
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

  Future<void> _deleteAlert() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer l\'alerte'),
        content: Text('Êtes-vous sûr de vouloir supprimer cette alerte?'),
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

    setState(() => _isLoading = true);

    try {
      final token = _authService.accessToken;
      if (token == null) throw Exception('Token non disponible');

      await ApiService.deleteAlert(token: token, alertId: _alert.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Alerte supprimée avec succès'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _isLoading = false);
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
        title: const Text('Détails de l\'alerte'),
        backgroundColor: const Color(0xFFfa3333),
        elevation: 0,
        actions: [
          if (!_isEditing)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  setState(() => _isEditing = true);
                } else if (value == 'delete') {
                  _deleteAlert();
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 12),
                      Text('Modifier'),
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
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type d'alerte
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: _getStatusColor(_alert.status),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          _getStatusIcon(_alert.status),
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Type d\'alerte',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _alert.type.name ?? 'Inconnu',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                      Chip(
                        label: Text(
                          _getStatusLabel(_alert.status),
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: _getStatusColor(_alert.status),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Créateur
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Créé par',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_alert.user.firstname ?? ''} ${_alert.user.lastname ?? ''}'.trim(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      ...[
                      const SizedBox(height: 4),
                      Text(
                        _alert.user.email,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Date de création
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Créée le',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDateTime(_alert.createdAt),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              if (_isEditing)
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Entrez la description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                )
              else
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      _alert.description ?? 'Aucune description',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Localisation
              if (_alert.latitude != null && _alert.longitude != null) ...[
                Text(
                  'Localisation',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.red, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Latitude: ${_alert.latitude!.toStringAsFixed(6)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.red, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Longitude: ${_alert.longitude!.toStringAsFixed(6)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Fichiers médias
              if (_alert.medias.isNotEmpty) ...[
                Text(
                  'Fichiers joints',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _alert.medias.length,
                  itemBuilder: (context, index) {
                    final media = _alert.medias[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.attachment, color: Colors.blue),
                        title: Text('Fichier ${index + 1}'),
                        subtitle: Text(
                          media.file.split('/').last,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          // Ouvrir/télécharger le fichier
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Ouverture: ${media.file}')),
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],

              // Boutons d'action
              if (_isEditing) ...[
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : () => setState(() => _isEditing = false),
                        child: const Text('Annuler'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFfa3333),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Enregistrer'),
                      ),
                    ),
                  ],
                ),
              ] else
                ElevatedButton.icon(
                  onPressed: () => setState(() => _isEditing = true),
                  icon: const Icon(Icons.edit),
                  label: const Text('Modifier'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFfa3333),
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} à ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
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

  String _getStatusLabel(StatusEnum status) {
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
}
