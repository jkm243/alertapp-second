import 'package:flutter/material.dart';
import '../../../services/authentication_service.dart';
import '../../../services/api_service.dart';
import '../../../models/api_models.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final AuthenticationService _authService = AuthenticationService();
  List<User> _users = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.initialize();
      final token = _authService.accessToken;
      
      if (token == null) {
        setState(() {
          _errorMessage = 'Non authentifié. Veuillez vous reconnecter.';
          _isLoading = false;
        });
        return;
      }

      final users = await ApiService.getAllUsers(token);
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } on ApiError catch (e) {
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors du chargement des utilisateurs: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  String _getRoleName(RoleEnum role) {
    switch (role) {
      case RoleEnum.admin:
        return 'Admin';
      case RoleEnum.operator:
        return 'Opérateur';
      case RoleEnum.user:
        return 'Utilisateur';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des utilisateurs'),
        backgroundColor: const Color(0xFFfa3333),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUsers,
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red[700]),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _loadUsers,
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : _users.isEmpty
                  ? const Center(
                      child: Text('Aucun utilisateur trouvé'),
                    )
                  : ListView.builder(
                      itemCount: _users.length,
                      itemBuilder: (context, index) {
                        final user = _users[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: user.isActive ? Colors.green : Colors.grey,
                              child: Text(
                                user.email[0].toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(user.email),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${user.fullName.isNotEmpty ? user.fullName : "Nom non renseigné"}'),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Chip(
                                      label: Text(_getRoleName(user.role)),
                                      backgroundColor: user.role == RoleEnum.admin
                                          ? Colors.red[100]
                                          : user.role == RoleEnum.operator
                                              ? Colors.blue[100]
                                              : Colors.grey[200],
                                      labelStyle: const TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(width: 8),
                                    Chip(
                                      label: Text(user.isActive ? 'Actif' : 'Inactif'),
                                      backgroundColor: user.isActive ? Colors.green[100] : Colors.red[100],
                                      labelStyle: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                if (user.telephone != null && user.telephone!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text('📞 ${user.telephone}'),
                                  ),
                              ],
                            ),
                            isThreeLine: true,
                          ),
                        );
                      },
                    ),
    );
  }
}
