import 'package:flutter/material.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final List<Map<String, dynamic>> _users = [
    {'id': 'u1', 'email': 'user1@example.com', 'role': 'User', 'active': true},
    {'id': 'u2', 'email': 'supervisor@example.com', 'role': 'Supervisor', 'active': true},
    {'id': 'u3', 'email': 'admin@example.com', 'role': 'Admin', 'active': true},
  ];

  void _toggleActive(int index) {
    setState(() {
      _users[index]['active'] = !_users[index]['active'];
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mise à jour effectuée')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestion des utilisateurs'), backgroundColor: const Color(0xFFfa3333)),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return ListTile(
            title: Text(user['email']),
            subtitle: Text('${user['role']} - ${user['active'] ? 'Actif' : 'Désactivé'}'),
            trailing: ElevatedButton(
              onPressed: () => _toggleActive(index),
              child: Text(user['active'] ? 'Désactiver' : 'Activer'),
            ),
          );
        },
      ),
    );
  }
}
