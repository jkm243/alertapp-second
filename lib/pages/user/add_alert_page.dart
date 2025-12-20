import 'package:flutter/material.dart';
import '../../design_system/colors.dart';
import '../../models/api_models.dart';
import '../../services/api_service.dart';
import '../../services/authentication_service.dart';

class AddAlertPage extends StatefulWidget {
  final Alert? alertToEdit;

  const AddAlertPage({
    super.key,
    this.alertToEdit,
  });

  @override
  State<AddAlertPage> createState() => _AddAlertPageState();
}

class _AddAlertPageState extends State<AddAlertPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _locationController = TextEditingController();
  
  bool _isLoading = false;
  late Future<List<TypeAlert>> _alertTypesFuture;
  TypeAlert? _selectedType;
  final _authService = AuthenticationService();
  int _currentStep = 1; // 1 = type, 2 = description, 3 = location

  @override
  void initState() {
    super.initState();
    _loadAlertTypes();
    
    // Si on édite une alerte
    if (widget.alertToEdit != null) {
      _selectedType = widget.alertToEdit!.type;
      _descriptionController.text = widget.alertToEdit!.description ?? '';
      // Pour l'adresse, on la reconstruit à partir des coordonnées
      if (widget.alertToEdit!.latitude != null &&
          widget.alertToEdit!.longitude != null) {
        _latitudeController.text = widget.alertToEdit!.latitude!.toString();
        _longitudeController.text = widget.alertToEdit!.longitude!.toString();
        _locationController.text =
            '${widget.alertToEdit!.latitude}, ${widget.alertToEdit!.longitude}';
      }
    }
  }

  void _loadAlertTypes() {
    final token = _authService.accessToken;
    if (token != null) {
      _alertTypesFuture = ApiService.getAlertTypes(token);
    } else {
      _alertTypesFuture = Future.error('Token non disponible');
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner un type d\'alerte')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final token = _authService.accessToken;
      if (token == null) throw Exception('Token non disponible');

      double? latitude;
      double? longitude;
      
      if (_latitudeController.text.trim().isNotEmpty) {
        latitude = double.tryParse(_latitudeController.text.trim());
      }
      if (_longitudeController.text.trim().isNotEmpty) {
        longitude = double.tryParse(_longitudeController.text.trim());
      }

      if (widget.alertToEdit != null) {
        // Édition d'une alerte existante
        await ApiService.updateAlert(
          token: token,
          alertId: widget.alertToEdit!.id,
          type: _selectedType!.id,
          description: _descriptionController.text.trim(),
          latitude: latitude,
          longitude: longitude,
        );
      } else {
        // Création d'une nouvelle alerte
        await ApiService.createAlert(
          token: token,
          type: _selectedType!.id,
          description: _descriptionController.text.trim(),
          latitude: latitude,
          longitude: longitude,
        );
      }

      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.alertToEdit != null
                  ? 'Alerte mise à jour avec succès'
                  : 'Alerte créée avec succès',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF230F0F)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Signaler une alerte',
          style: TextStyle(
            color: Color(0xFF230F0F),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: List.generate(
                  5,
                  (index) => Expanded(
                    child: Container(
                      height: 4,
                      margin: EdgeInsets.only(right: index < 4 ? 8.0 : 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: _currentStep > index
                            ? AppColors.primary
                            : AppColors.primary.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: _buildStepContent(),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppColors.border,
              width: 1,
            ),
          ),
          color: AppColors.background,
        ),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            if (_currentStep > 1)
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => _currentStep--);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: const Color(0xFF230F0F),
                  ),
                  child: const Text('Retour'),
                ),
              ),
            if (_currentStep > 1) const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleNextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  _currentStep >= 5
                      ? 'Créer l\'alerte'
                      : 'Suivant',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1:
        return _buildTypeStep();
      case 2:
        return _buildDescriptionStep();
      case 3:
        return _buildLocationStep();
      case 4:
        return _buildPhotoStep();
      case 5:
        return _buildReviewStep();
      default:
        return _buildTypeStep();
    }
  }

  Widget _buildTypeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const Text(
          'Quel type d\'incident signalez-vous ?',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF230F0F),
          ),
        ),
        const SizedBox(height: 24),
        FutureBuilder<List<TypeAlert>>(
          future: _alertTypesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text('Erreur: ${snapshot.error}');
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('Aucun type d\'alerte disponible');
            }

            return Column(
              children: snapshot.data!.map((type) {
                final isSelected = _selectedType?.id == type.id;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedType = type),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.grey[300]!,
                          width: 2,
                        ),
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : Colors.white,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            type.name ?? 'Inconnu',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF230F0F),
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? AppColors.primary : Colors.grey[400]!,
                                width: 2,
                              ),
                              color: isSelected ? AppColors.primary : Colors.white,
                            ),
                            child: isSelected
                                ? const Icon(Icons.check, size: 14, color: Colors.white)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const Text(
          'Décrivez les détails de l\'incident',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF230F0F),
          ),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _descriptionController,
          maxLines: 8,
          decoration: InputDecoration(
            hintText: 'Décrivez en détail ce que vous avez observé...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(12),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Veuillez entrer une description';
            }
            if (value.trim().length < 10) {
              return 'La description doit contenir au moins 10 caractères';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildLocationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const Text(
          'Où a eu lieu l\'incident ?',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF230F0F),
          ),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _locationController,
          decoration: InputDecoration(
            labelText: 'Adresse ou lieu',
            hintText: 'Ex: Avenue Kasa-Vubu, Kinshasa',
            prefixIcon: const Icon(Icons.location_on),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _latitudeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Latitude',
                  hintText: '0.000',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    if (double.tryParse(value) == null) {
                      return 'Format invalide';
                    }
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _longitudeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Longitude',
                  hintText: '0.000',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    if (double.tryParse(value) == null) {
                      return 'Format invalide';
                    }
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPhotoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const Text(
          'Ajouter une photo (optionnel)',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF230F0F),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
            color: Colors.grey[50],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Appuyez pour ajouter une photo',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Les photos aident les autorités à mieux répondre',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const Text(
          'Vérifier votre signalement',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF230F0F),
          ),
        ),
        const SizedBox(height: 24),
        _buildReviewItem('Type', _selectedType?.name ?? ''),
        _buildReviewItem('Description', _descriptionController.text),
        _buildReviewItem('Lieu', _locationController.text),
        if (_latitudeController.text.isNotEmpty &&
            _longitudeController.text.isNotEmpty)
          _buildReviewItem(
            'Coordonnées',
            '${_latitudeController.text}, ${_longitudeController.text}',
          ),
      ],
    );
  }

  Widget _buildReviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF9E4747),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF230F0F),
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _handleNextStep() {
    if (_currentStep == 1) {
      if (_selectedType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez sélectionner un type')),
        );
        return;
      }
      setState(() => _currentStep = 2);
    } else if (_currentStep == 2) {
      if (!_formKey.currentState!.validate()) return;
      setState(() => _currentStep = 3);
    } else if (_currentStep == 3) {
      setState(() => _currentStep = 4);
    } else if (_currentStep == 4) {
      setState(() => _currentStep = 5);
    } else if (_currentStep == 5) {
      _submit();
    }
  }
}
