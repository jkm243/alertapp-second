import 'package:flutter/material.dart';
import '../../../services/authentication_service.dart';

class SupervisorSignupPage extends StatefulWidget {
  const SupervisorSignupPage({super.key});

  @override
  State<SupervisorSignupPage> createState() => _SupervisorSignupPageState();
}

class _SupervisorSignupPageState extends State<SupervisorSignupPage> {
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
        role: 'Operator',
      );

      if (mounted) {
        if (result.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Erreur lors de l\'inscription';
        if (e.toString().contains('TimeoutException')) {
          errorMessage = 'Délai d\'attente dépassé. Le serveur met trop de temps à répondre.';
        } else if (e.toString().contains('SocketException')) {
          errorMessage = 'Erreur de connexion réseau. Vérifiez votre connexion internet.';
        } else {
          errorMessage = 'Erreur: ${e.toString()}';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Superviseur - Inscription'), backgroundColor: const Color(0xFFfa3333)),
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
