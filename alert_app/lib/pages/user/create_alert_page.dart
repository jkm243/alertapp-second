import 'dart:io';
import 'package:flutter/material.dart';
import '../../services/alert_service.dart';
import '../../services/type_alert_service.dart';
import '../../services/authentication_service.dart';
import '../../models/api_models.dart';
import '../../widgets/primary_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

class CreateAlertPage extends StatefulWidget {
  const CreateAlertPage({super.key});

  @override
  State<CreateAlertPage> createState() => _CreateAlertPageState();
}

class _CreateAlertPageState extends State<CreateAlertPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  
  TypeAlert? _selectedType;
  List<TypeAlert> _alertTypes = [];
  final List<File> _selectedMedia = [];
  bool _isLoading = false;
  bool _isLoadingTypes = true;
  bool _isAnonymous = false;
  Position? _currentPosition;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _loadAlertTypes();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadAlertTypes() async {
    try {
      final authService = AuthenticationService();
      await authService.initialize();
      final token = authService.accessToken;
      
      if (token == null) {
        if (mounted) {
          setState(() => _isLoadingTypes = false);
        }
        return;
      }

      final types = await TypeAlertService.getAllTypes(token);
      if (mounted) {
        setState(() {
          _alertTypes = types;
          _isLoadingTypes = false;
          if (types.isNotEmpty && _selectedType == null) {
            _selectedType = types.first;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingTypes = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du chargement des types: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Le service de localisation est désactivé')),
          );
        }
        setState(() => _isLoadingLocation = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Permission de localisation refusée')),
            );
          }
          setState(() => _isLoadingLocation = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permission de localisation refusée définitivement')),
          );
        }
        setState(() => _isLoadingLocation = false);
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingLocation = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de localisation: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source, imageQuality: 85);
      
      if (image != null) {
        setState(() {
          _selectedMedia.add(File(image.path));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la sélection: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _pickVideo() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
      
      if (video != null) {
        setState(() {
          _selectedMedia.add(File(video.path));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la sélection: ${e.toString()}')),
        );
      }
    }
  }

  void _removeMedia(int index) {
    setState(() {
      _selectedMedia.removeAt(index);
    });
  }

  Future<void> _submitAlert() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner un type d\'alerte')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = AuthenticationService();
      await authService.initialize();
      final token = authService.accessToken;
      
      if (token == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Non authentifié. Veuillez vous reconnecter.')),
          );
        }
        setState(() => _isLoading = false);
        return;
      }

      final alert = await AlertService.createAlert(
        typeId: _selectedType!.id,
        description: _descriptionController.text.trim(),
        latitude: _currentPosition?.latitude,
        longitude: _currentPosition?.longitude,
        token: token,
        mediaFiles: _selectedMedia.isNotEmpty ? _selectedMedia : null,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Alerte créée avec succès'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(alert);
      }
    } on ApiError catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signaler un incident'),
        backgroundColor: const Color(0xFFfa3333),
        foregroundColor: Colors.white,
      ),
      body: _isLoadingTypes
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Type d'alerte
                    const Text(
                      'Type d\'alerte *',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<TypeAlert>(
                      initialValue: _selectedType,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items: _alertTypes.map((type) {
                        return DropdownMenuItem<TypeAlert>(
                          value: type,
                          child: Text(type.name ?? 'Type sans nom'),
                        );
                      }).toList(),
                      onChanged: (TypeAlert? value) {
                        setState(() => _selectedType = value);
                      },
                      validator: (value) => value == null ? 'Veuillez sélectionner un type' : null,
                    ),
                    const SizedBox(height: 24),

                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Description *',
                        hintText: 'Décrivez l\'incident en détail',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.white,
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
                    const SizedBox(height: 24),

                    // Localisation
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Color(0xFFfa3333)),
                                const SizedBox(width: 8),
                                const Text(
                                  'Localisation',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                if (_isLoadingLocation)
                                  const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                else
                                  IconButton(
                                    icon: const Icon(Icons.refresh),
                                    onPressed: _getCurrentLocation,
                                    tooltip: 'Actualiser la position',
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (_currentPosition != null)
                              Text(
                                'Lat: ${_currentPosition!.latitude.toStringAsFixed(6)}, Lng: ${_currentPosition!.longitude.toStringAsFixed(6)}',
                                style: TextStyle(color: Colors.grey[700], fontSize: 12),
                              )
                            else
                              const Text(
                                'Position non disponible',
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Médias
                    const Text(
                      'Photos / Vidéos',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        // Bouton ajouter photo
                        InkWell(
                          onTap: () => _pickImage(ImageSource.camera),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt, size: 32, color: Colors.grey),
                                SizedBox(height: 4),
                                Text('Caméra', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                        // Bouton galerie
                        InkWell(
                          onTap: () => _pickImage(ImageSource.gallery),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.photo_library, size: 32, color: Colors.grey),
                                SizedBox(height: 4),
                                Text('Galerie', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                        // Bouton vidéo
                        InkWell(
                          onTap: _pickVideo,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.videocam, size: 32, color: Colors.grey),
                                SizedBox(height: 4),
                                Text('Vidéo', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                        // Aperçus des médias sélectionnés
                        ..._selectedMedia.asMap().entries.map((entry) {
                          final index = entry.key;
                          final file = entry.value;
                          return Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: FileImage(file),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: InkWell(
                                  onTap: () => _removeMedia(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close, size: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Option anonyme
                    CheckboxListTile(
                      title: const Text('Rester anonyme'),
                      subtitle: const Text('Votre nom ne sera pas affiché publiquement'),
                      value: _isAnonymous,
                      onChanged: (value) => setState(() => _isAnonymous = value ?? false),
                      activeColor: const Color(0xFFfa3333),
                    ),
                    const SizedBox(height: 24),

                    // Bouton soumettre
                    PrimaryButton(
                      text: 'Envoyer l\'alerte',
                      onPressed: _isLoading ? null : _submitAlert,
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

