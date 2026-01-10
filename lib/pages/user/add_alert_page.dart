import 'package:flutter/material.dart';
import '../../design_system/colors.dart';
import '../../models/api_models.dart';
import '../../services/api_service.dart';
import '../../services/authentication_service.dart';
import '../../services/location_service.dart';

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
  late AuthenticationService _authService;
  int _currentStep = 1; // 1 = type, 2 = description, 3 = location

  @override
  void initState() {
    super.initState();
    _authService = authService; // Use global auth service instance
    _loadAlertTypes();
    _getLocation(); // Récupérer la localisation
    
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
    print('🔍 _loadAlertTypes called');
    print('   Token: ${token != null ? "Available" : "NULL"}');
    
    if (token != null) {
      _alertTypesFuture = ApiService.getAlertTypes(token).then((types) {
        print('   ✅ Types loaded: ${types.length}');
        for (var t in types) {
          print('      - ${t.name} (${t.id})');
        }
        return types;
      }).catchError((e, stackTrace) {
        print('   ❌ Error loading types: $e');
        print('   Stack: $stackTrace');
        throw e;
      });
    } else {
      print('   ❌ No token available');
      _alertTypesFuture = Future.error('Token non disponible');
    }
  }

  Future<void> _getLocation() async {
    print('📍 Getting user location...');
    try {
      final position = await locationService.getCurrentLocation();
      
      if (position != null && mounted) {
        setState(() {
          _latitudeController.text = position.latitude.toStringAsFixed(6);
          _longitudeController.text = position.longitude.toStringAsFixed(6);
          _locationController.text = 
            '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
        });
        print('✅ Location auto-filled in form');
      } else if (mounted) {
        print('⚠️ Could not get location');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Impossible de récupérer votre localisation. Veuillez vérifier les permissions.',
            ),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      print('❌ Error getting location: $e');
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

    // Valider les coordonnées GPS
    double? latitude = double.tryParse(_latitudeController.text.trim());
    double? longitude = double.tryParse(_longitudeController.text.trim());

    if (!LocationService.isValidCoordinates(latitude, longitude)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Coordonnées GPS invalides ou manquantes. Veuillez les autoriser.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final token = _authService.accessToken;
      print('📤 Submitting alert:');
      print('   Token: ${token != null ? "Available" : "NULL"}');
      print('   Type: ${_selectedType?.name} (${_selectedType?.id})');
      print('   Description: ${_descriptionController.text.trim()}');
      
      if (token == null) throw Exception('Token non disponible');

      print('   Latitude: $latitude, Longitude: $longitude');

      if (widget.alertToEdit != null) {
        // Édition d'une alerte existante
        print('   Mode: Update alert ${widget.alertToEdit!.id}');
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
        print('   Mode: Create new alert');
        await ApiService.createAlert(
          token: token,
          type: _selectedType!.id,
          description: _descriptionController.text.trim(),
          latitude: latitude,
          longitude: longitude,
        );
      }

      print('✅ Alert submitted successfully');
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
      print('❌ Error submitting alert');
      print('   Exception type: ${e.runtimeType}');
      print('   Exception: $e');
      
      String errorMessage = 'Une erreur est survenue';
      
      // Essayer de récupérer le message d'erreur
      if (e is ApiError) {
        print('   ✓ Is ApiError');
        print('   Message: ${e.message}');
        print('   Status: ${e.statusCode}');
        errorMessage = e.message;
      } else if (e is Exception) {
        print('   Is Exception: ${e.toString()}');
        errorMessage = e.toString().replaceFirst('Exception: ', '');
      } else {
        print('   Unknown error type: $e');
      }
      
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
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
            print('🔍 FutureBuilder snapshot:');
            print('   connectionState: ${snapshot.connectionState}');
            print('   hasData: ${snapshot.hasData}');
            print('   hasError: ${snapshot.hasError}');
            if (snapshot.hasError) print('   error: ${snapshot.error}');
            if (snapshot.hasData) print('   data length: ${snapshot.data?.length}');
            
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            
            if (snapshot.hasError) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '❌ Erreur: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        setState(() => _loadAlertTypes());
                      },
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              );
            }
            
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '⚠️ Aucun type d\'alerte disponible',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        setState(() => _loadAlertTypes());
                      },
                      child: const Text('Recharger'),
                    ),
                  ],
                ),
              );
            }

            final types = snapshot.data!;
            print('✅ Rendering ${types.length} types');
            
            return Column(
              children: List.generate(types.length, (index) {
                final type = types[index];
                final isSelected = _selectedType?.id == type.id;
                print('   Type $index: ${type.name} (selected: $isSelected)');
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: GestureDetector(
                    onTap: () {
                      print('🎯 Selected type: ${type.name}');
                      setState(() => _selectedType = type);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.grey[300]!,
                          width: isSelected ? 3 : 1,
                        ),
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.15)
                            : Colors.white,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  type.name ?? 'Inconnu',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF230F0F),
                                  ),
                                ),
                                if (type.description != null && type.description!.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    type.description!,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? AppColors.primary : Colors.grey[400]!,
                                width: 2,
                              ),
                              color: isSelected ? AppColors.primary : Colors.white,
                            ),
                            child: isSelected
                                ? const Icon(Icons.check, size: 16, color: Colors.white)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
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
        // Avertissement
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.info, color: Colors.blue[700], size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Les coordonnées GPS sont obligatoires',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
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
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Latitude *',
                  hintText: '0.000',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _longitudeController,
                keyboardType: TextInputType.number,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Longitude *',
                  hintText: '0.000',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _getLocation,
            icon: const Icon(Icons.my_location),
            label: const Text('Actualiser la localisation'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
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
    print('📍 _handleNextStep called - currentStep: $_currentStep');
    
    if (_currentStep == 1) {
      print('   Checking type selection: $_selectedType');
      if (_selectedType == null) {
        print('   ❌ No type selected! Showing error.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez sélectionner un type'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
      print('   ✅ Type selected: ${_selectedType!.name}');
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
