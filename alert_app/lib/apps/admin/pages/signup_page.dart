import 'package:flutter/material.dart';
import '../../../services/authentication_service.dart';

class AdminSignupPage extends StatefulWidget {
  const AdminSignupPage({super.key});

  @override
  State<AdminSignupPage> createState() => _AdminSignupPageState();
}

class _AdminSignupPageState extends State<AdminSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = AuthenticationService();
      final result = await authService.signup(
        email: _emailController.text.trim(),
        password1: _passwordController.text,
        password2: _passwordConfirmController.text,
        firstname: _firstNameController.text.trim(),
        lastname: _lastNameController.text.trim(),
        role: 'Admin',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message), backgroundColor: result.isSuccess ? Colors.green : Colors.red),
        );

        if (result.isSuccess) Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin - Inscription'), backgroundColor: const Color(0xFFfa3333)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
              const SizedBox(height: 8),
              TextFormField(controller: _firstNameController, decoration: const InputDecoration(labelText: 'Prénom')),
              const SizedBox(height: 8),
              TextFormField(controller: _lastNameController, decoration: const InputDecoration(labelText: 'Nom')),
              const SizedBox(height: 8),
              TextFormField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Mot de passe')),
              const SizedBox(height: 8),
              TextFormField(controller: _passwordConfirmController, obscureText: true, decoration: const InputDecoration(labelText: 'Confirmer le mot de passe')),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _isLoading ? null : _signup, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFfa3333)), child: _isLoading ? const CircularProgressIndicator() : const Text('S\'inscrire')),
            ],
          ),
        ),
      ),
    );
  }
}
