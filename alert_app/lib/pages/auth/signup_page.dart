import 'package:flutter/material.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/text_link.dart';
import '../../services/authentication_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key, this.role = 'User'});

  final String role;

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _middlenameController = TextEditingController();
  final _telephoneController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _middlenameController.dispose();
    _telephoneController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez accepter les conditions d\'utilisation')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = AuthenticationService();
      final result = await authService.signup(
        email: _emailController.text.trim(),
        password1: _passwordController.text,
        password2: _confirmPasswordController.text,
        firstname: _firstnameController.text.trim(),
        lastname: _lastnameController.text.trim(),
        middlename: _middlenameController.text.trim(),
        telephone: _telephoneController.text.trim(),
        role: widget.role,
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
          // Attendre un peu avant de revenir à la page de login
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) {
            Navigator.of(context).pop(); // Go back to login page
          }
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
      if (!mounted) return;
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
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  InputDecoration _inputDecoration({required String label, required String hint, required IconData icon}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: Theme.of(context).iconTheme.color),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Créer un compte',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFfa3333),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Inscrivez-vous pour recevoir vos alertes personnalisées',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // First name
                TextFormField(
                  controller: _firstnameController,
                  textCapitalization: TextCapitalization.words,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  cursorColor: Theme.of(context).colorScheme.onSurface,
                  decoration: _inputDecoration(label: 'Prénom *', hint: 'Votre prénom', icon: Icons.person_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Veuillez entrer votre prénom';
                    if (value.trim().length < 2) return 'Le prénom doit contenir au moins 2 caractères';
                    if (value.trim().length > 50) return 'Le prénom ne peut pas dépasser 50 caractères';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Last name
                TextFormField(
                  controller: _lastnameController,
                  textCapitalization: TextCapitalization.words,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  cursorColor: Theme.of(context).colorScheme.onSurface,
                  decoration: _inputDecoration(label: 'Nom *', hint: 'Votre nom de famille', icon: Icons.person_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Veuillez entrer votre nom';
                    if (value.trim().length < 2) return 'Le nom doit contenir au moins 2 caractères';
                    if (value.trim().length > 50) return 'Le nom ne peut pas dépasser 50 caractères';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Middle name
                TextFormField(
                  controller: _middlenameController,
                  textCapitalization: TextCapitalization.words,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  cursorColor: Theme.of(context).colorScheme.onSurface,
                  decoration: _inputDecoration(label: 'Nom du milieu (optionnel)', hint: 'Votre nom du milieu', icon: Icons.person_outlined),
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      if (value.trim().length < 2) return 'Le nom du milieu doit contenir au moins 2 caractères';
                      if (value.trim().length > 50) return 'Le nom du milieu ne peut pas dépasser 50 caractères';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Telephone
                TextFormField(
                  controller: _telephoneController,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  cursorColor: Theme.of(context).colorScheme.onSurface,
                  decoration: _inputDecoration(label: 'Téléphone (optionnel)', hint: '+243970000400', icon: Icons.phone_outlined),
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      if (value.trim().length < 8) return 'Le numéro de téléphone doit contenir au moins 8 caractères';
                      if (value.trim().length > 20) return 'Le numéro de téléphone ne peut pas dépasser 20 caractères';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  cursorColor: Theme.of(context).colorScheme.onSurface,
                  decoration: _inputDecoration(label: 'Email', hint: 'votre@email.com', icon: Icons.email_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Veuillez entrer votre email';
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) return 'Veuillez entrer un email valide';
                    if (value.trim().length < 5) return 'L\'email doit contenir au moins 5 caractères';
                    if (value.trim().length > 254) return 'L\'email ne peut pas dépasser 254 caractères';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  cursorColor: Theme.of(context).colorScheme.onSurface,
                  decoration: _inputDecoration(label: 'Mot de passe', hint: 'Votre mot de passe', icon: Icons.lock_outlined).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off, color: Theme.of(context).iconTheme.color),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Veuillez entrer votre mot de passe';
                    if (value.length < 6) return 'Le mot de passe doit contenir au moins 6 caractères';
                    if (value.length > 128) return 'Le mot de passe ne peut pas dépasser 128 caractères';
                    if (value.contains('<') || value.contains('>') || value.contains('"') || value.contains("'")) return 'Le mot de passe contient des caractères non autorisés';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Confirm password
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  cursorColor: Theme.of(context).colorScheme.onSurface,
                  decoration: _inputDecoration(label: 'Confirmer le mot de passe', hint: 'Confirmez votre mot de passe', icon: Icons.lock_outlined).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off, color: Theme.of(context).iconTheme.color),
                      onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Veuillez confirmer votre mot de passe';
                    if (value != _passwordController.text) return 'Les mots de passe ne correspondent pas';
                    if (value.length < 6) return 'Le mot de passe doit contenir au moins 6 caractères';
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Terms
                Row(
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      onChanged: (value) => setState(() => _acceptTerms = value ?? false),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _acceptTerms = !_acceptTerms),
                        child: const Text('J\'accepte les conditions d\'utilisation et la politique de confidentialité', style: TextStyle(fontSize: 14)),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                PrimaryButton(
                  text: 'S\'inscrire',
                  onPressed: _isLoading ? null : _signup,
                  isLoading: _isLoading,
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Déjà un compte ? ', style: TextStyle(color: Colors.grey)),
                    TextLink(text: 'Se connecter', onTap: () => Navigator.of(context).pop()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
