import 'package:flutter/material.dart';
import '../../widgets/primary_button.dart';
import '../../services/supervisor_service.dart';

class AddAlertPage extends StatefulWidget {
  const AddAlertPage({super.key});

  @override
  State<AddAlertPage> createState() => _AddAlertPageState();
}

class _AddAlertPageState extends State<AddAlertPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final success = await SupervisorService.createAlert(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      location: _locationController.text.trim(),
    );
    setState(() => _isLoading = false);
    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Alerte envoyée avec succès'), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop();
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de l\'envoi de l\'alerte'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final iconColor = Theme.of(context).iconTheme.color;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle alerte'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  style: TextStyle(color: onSurface),
                  decoration: InputDecoration(
                    labelText: 'Titre',
                    prefixIcon: Icon(Icons.report_problem_outlined, color: iconColor),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Veuillez entrer un titre' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  style: TextStyle(color: onSurface),
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.description_outlined, color: iconColor),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Veuillez entrer une description' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _locationController,
                  style: TextStyle(color: onSurface),
                  decoration: InputDecoration(
                    labelText: 'Lieu',
                    prefixIcon: Icon(Icons.location_on_outlined, color: iconColor),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Veuillez entrer un lieu' : null,
                ),
                const SizedBox(height: 20),
                PrimaryButton(text: 'Envoyer l\'alerte', onPressed: _isLoading ? null : _submit, isLoading: _isLoading),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
