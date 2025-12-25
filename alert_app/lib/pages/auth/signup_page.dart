import 'package:flutter/material.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/text_link.dart';
import '../../services/authentication_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

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
        const SnackBar(
          content: Text("Vous devez accepter les conditions d'utilisation"),
          backgroundColor: Colors.red,
        ),
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
        role: "User",
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
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey[50],
      labelText: label,
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[500]),
      labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      prefixIcon: Icon(icon, color: Theme.of(context).iconTheme.color),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFfa3333), width: 2),
      ),
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
                  "Creer un compte",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFfa3333),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Inscrivez-vous pour recevoir vos alertes personnalisees",
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
                  decoration: _inputDecoration(
                    label: "Prenom *",
                    hint: "Votre prenom",
                    icon: Icons.person_outlined,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Veuillez entrer votre prenom";
                    if (value.trim().length < 2) return "Le prenom doit contenir au moins 2 caracteres";
                    if (value.trim().length > 50) return "Le prenom ne peut pas depasser 50 caracteres";
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
                  decoration: _inputDecoration(
                    label: "Nom *",
                    hint: "Votre nom de famille",
                    icon: Icons.person_outlined,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Veuillez entrer votre nom";
                    if (value.trim().length < 2) return "Le nom doit contenir au moins 2 caracteres";
                    if (value.trim().length > 50) return "Le nom ne peut pas depasser 50 caracteres";
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
                  decoration: _inputDecoration(
                    label: "Nom du milieu (optionnel)",
                    hint: "Votre nom du milieu",
                    icon: Icons.person_outlined,
                  ),
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      if (value.trim().length < 2) return "Le nom du milieu doit contenir au moins 2 caracteres";
                      if (value.trim().length > 50) return "Le nom du milieu ne peut pas depasser 50 caracteres";
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
                  decoration: _inputDecoration(
                    label: "Telephone (optionnel)",
                    hint: "+243970000400",
                    icon: Icons.phone_outlined,
                  ),
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      if (value.trim().length < 8) return "Le numero de telephone doit contenir au moins 8 caracteres";
                      if (value.trim().length > 20) return "Le numero de telephone ne peut pas depasser 20 caracteres";
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
                  decoration: _inputDecoration(
                    label: "Email *",
                    hint: "votre@email.com",
                    icon: Icons.email_outlined,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Veuillez entrer votre email";
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) return "Veuillez entrer un email valide";
                    if (value.trim().length < 5) return "L'email doit contenir au moins 5 caracteres";
                    if (value.trim().length > 254) return "L'email ne peut pas depasser 254 caracteres";
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
                  decoration: _inputDecoration(
                    label: "Mot de passe *",
                    hint: "Votre mot de passe",
                    icon: Icons.lock_outlined,
                  ).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Veuillez entrer votre mot de passe";
                    if (value.length < 6) return "Le mot de passe doit contenir au moins 6 caracteres";
                    if (value.length > 128) return "Le mot de passe ne peut pas depasser 128 caracteres";
                    if (value.contains("<") || value.contains(">") || value.contains("\"")) {
                      return "Le mot de passe contient des caracteres non autorises";
                    }
                    if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(value)) {
                      return "Le mot de passe doit contenir au moins une lettre et un chiffre";
                    }
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
                  decoration: _inputDecoration(
                    label: "Confirmer le mot de passe *",
                    hint: "Confirmez votre mot de passe",
                    icon: Icons.lock_outlined,
                  ).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Veuillez confirmer votre mot de passe";
                    if (value != _passwordController.text) return "Les mots de passe ne correspondent pas";
                    if (value.length < 6) return "Le mot de passe doit contenir au moins 6 caracteres";
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Terms acceptance
                Row(
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      onChanged: (value) => setState(() => _acceptTerms = value ?? false),
                      activeColor: const Color(0xFFfa3333),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _acceptTerms = !_acceptTerms),
                        child: const Text(
                          "J'accepte les conditions d'utilisation et la politique de confidentialite",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                PrimaryButton(
                  text: "S'inscrire",
                  onPressed: _isLoading ? null : _signup,
                  isLoading: _isLoading,
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Deja un compte ? ", style: TextStyle(color: Colors.grey)),
                    TextLink(
                      text: "Se connecter",
                      onTap: () => Navigator.of(context).pop(),
                    ),
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
