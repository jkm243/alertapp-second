import 'package:flutter/material.dart';
import '../design_system/colors.dart' as design_colors;
import '../models/api_models.dart';
import '../services/authentication_service.dart';
import '../services/api_service.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late Future<User> _userFuture;
  late Future<List<Alert>> _alertsFuture;
  final _authService = AuthenticationService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadAlerts();
  }

  void _loadUserData() {
    _userFuture = _fetchUserData();
  }

  void _loadAlerts() {
    _alertsFuture = _fetchAlerts();
  }

  Future<User> _fetchUserData() async {
    final token = _authService.accessToken;
    if (token == null) throw Exception('Token non disponible');
    return ApiService.getCurrentUser(token);
  }

  Future<List<Alert>> _fetchAlerts() async {
    final token = _authService.accessToken;
    if (token == null) throw Exception('Token non disponible');
    return ApiService.getUserAlerts(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: design_colors.AppColors.background,
      appBar: AppBar(
        backgroundColor: design_colors.AppColors.background,
        elevation: 0,
        title: const Text(
          'Profil',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF230F0F),
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<User>(
        future: _userFuture,
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userSnapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
                  const SizedBox(height: 16),
                  const Text('Erreur de chargement'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _loadUserData();
                      });
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          final user = userSnapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar et info utilisateur
                  _buildUserHeader(user),
                  const SizedBox(height: 24),

                  // Actions utilisateur
                  _buildUserActions(user),
                  const SizedBox(height: 32),

                  // Historique des alertes
                  _buildAlertHistory(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserHeader(User user) {
    return Column(
      children: [
        // Avatar
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: user.getAvatar.isNotEmpty
              ? Image.network(
                  user.getAvatar,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: design_colors.AppColors.primary.withValues(alpha: 0.2),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 48,
                        color: design_colors.AppColors.primary,
                      ),
                    );
                  },
                )
              : Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: design_colors.AppColors.primary.withValues(alpha: 0.2),
                  ),
                  child: Icon(
                    Icons.person,
                    size: 48,
                    color: design_colors.AppColors.primary,
                  ),
                ),
        ),
        const SizedBox(height: 16),

        // Nom utilisateur
        Text(
          '${user.firstname ?? ''} ${user.lastname ?? ''}',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF230F0F),
          ),
        ),
        const SizedBox(height: 4),

        // Email
        Text(
          user.email,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),

        // Rôle
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: design_colors.AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            user.role.toString().split('.').last,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: design_colors.AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserActions(User user) {
    return Column(
      children: [
        // Bouton Éditer le profil
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () => _showEditProfileDialog(user),
            style: ElevatedButton.styleFrom(
              backgroundColor: design_colors.AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.edit, color: Colors.white),
            label: const Text(
              'Éditer le profil',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Bouton Changer le mot de passe
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () => _showChangePasswordDialog(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[500],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.lock, color: Colors.white),
            label: const Text(
              'Changer le mot de passe',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAlertHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Historique des Signalements',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        FutureBuilder<List<Alert>>(
          future: _alertsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      const Text('Chargement des alertes...'),
                    ],
                  ),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red[400],
                      ),
                      const SizedBox(height: 16),
                      const Text('Erreur de chargement'),
                    ],
                  ),
                ),
              );
            }

            final alerts = snapshot.data ?? [];
            if (alerts.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      const Text('Aucune alerte pour le moment'),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: List.generate(
                alerts.length,
                (index) {
                  final alert = alerts[index];
                  return _buildAlertHistoryCard(alert);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAlertHistoryCard(Alert alert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre et date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  alert.type.name ?? 'Alerte',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF230F0F),
                  ),
                ),
              ),
              Text(
                _getTimeAgo(alert.createdAt),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Description courte
          Text(
            alert.description ?? 'Sans description',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(User user) {
    final firstnameController = TextEditingController(text: user.firstname ?? '');
    final lastnameController = TextEditingController(text: user.lastname ?? '');
    final emailController = TextEditingController(text: user.email);
    final telephoneController = TextEditingController(text: user.telephone ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Éditer le profil'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstnameController,
                decoration: InputDecoration(
                  labelText: 'Prénom',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: lastnameController,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: telephoneController,
                decoration: InputDecoration(
                  labelText: 'Téléphone',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _updateUserProfile(
                firstname: firstnameController.text,
                lastname: lastnameController.text,
                email: emailController.text,
                telephone: telephoneController.text,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: design_colors.AppColors.primary,
            ),
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool obscureOld = true;
    bool obscureNew = true;
    bool obscureConfirm = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Changer le mot de passe'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: oldPasswordController,
                  obscureText: obscureOld,
                  decoration: InputDecoration(
                    labelText: 'Ancien mot de passe',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(obscureOld ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          obscureOld = !obscureOld;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: newPasswordController,
                  obscureText: obscureNew,
                  decoration: InputDecoration(
                    labelText: 'Nouveau mot de passe',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(obscureNew ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          obscureNew = !obscureNew;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: obscureConfirm,
                  decoration: InputDecoration(
                    labelText: 'Confirmer le mot de passe',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(obscureConfirm ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          obscureConfirm = !obscureConfirm;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _changePassword(
                  oldPassword: oldPasswordController.text,
                  newPassword: newPasswordController.text,
                  confirmPassword: confirmPasswordController.text,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: design_colors.AppColors.primary,
              ),
              child: const Text('Changer'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateUserProfile({
    required String firstname,
    required String lastname,
    required String email,
    required String telephone,
  }) async {
    try {
      final token = _authService.accessToken;
      if (token == null) throw Exception('Token non disponible');

      await ApiService.editUserProfile(
        token: token,
        firstname: firstname,
        lastname: lastname,
        email: email,
        telephone: telephone,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil mis à jour avec succès'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _loadUserData();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    // Validation
    if (oldPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer l\'ancien mot de passe')),
      );
      return;
    }

    if (newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer le nouveau mot de passe')),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Les mots de passe ne correspondent pas')),
      );
      return;
    }

    if (newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le mot de passe doit contenir au moins 6 caractères')),
      );
      return;
    }

    try {
      final token = _authService.accessToken;
      if (token == null) throw Exception('Token non disponible');

      await ApiService.changePassword(
        token: token,
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mot de passe changé avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getTimeAgo(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'À l\'instant';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}j';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w';

    return 'Il y a longtemps';
  }
}
