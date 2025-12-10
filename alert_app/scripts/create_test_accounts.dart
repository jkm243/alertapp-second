import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// Script pour créer des comptes de test pour les trois rôles
/// Usage: dart scripts/create_test_accounts.dart

const String baseUrl = 'https://alert-app-nc1y.onrender.com/api';
const String signupEndpoint = '/users/signup/';

class TestAccount {
  final String email;
  final String password;
  final String firstname;
  final String lastname;
  final String role;

  TestAccount({
    required this.email,
    required this.password,
    required this.firstname,
    required this.lastname,
    required this.role,
  });
}

final List<TestAccount> testAccounts = [
  TestAccount(
    email: 'dev.user@test.com',
    password: 'devuser123',
    firstname: 'Dev',
    lastname: 'User',
    role: 'User',
  ),
  TestAccount(
    email: 'dev.admin@test.com',
    password: 'devadmin123',
    firstname: 'Dev',
    lastname: 'Admin',
    role: 'Admin',
  ),
  TestAccount(
    email: 'dev.supervisor@test.com',
    password: 'devsuper123',
    firstname: 'Dev',
    lastname: 'Supervisor',
    role: 'Operator', // Supervisor utilise le rôle Operator
  ),
];

Future<void> createAccount(TestAccount account) async {
  try {
    final requestBody = {
      'email': account.email,
      'password1': account.password,
      'password2': account.password,
      'firstname': account.firstname,
      'lastname': account.lastname,
      'role': account.role,
    };

    print('Création du compte: ${account.email} (${account.role})...');

    final response = await http.post(
      Uri.parse('$baseUrl$signupEndpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(requestBody),
    ).timeout(const Duration(seconds: 60));

    if (response.statusCode == 201) {
      print('✅ Compte créé avec succès: ${account.email}');
      print('   Email: ${account.email}');
      print('   Mot de passe: ${account.password}');
      print('   Rôle: ${account.role}');
      print('');
    } else if (response.statusCode == 400 || response.statusCode == 409) {
      final errorData = json.decode(response.body);
      String errorMessage = 'Erreur inconnue';
      
      if (errorData is Map<String, dynamic>) {
        if (errorData.containsKey('message')) {
          errorMessage = errorData['message'] as String;
        } else if (errorData.containsKey('email')) {
          final emailErrors = errorData['email'];
          if (emailErrors is List && emailErrors.isNotEmpty) {
            errorMessage = emailErrors.first.toString();
          }
        } else {
          errorMessage = errorData.toString();
        }
      }
      
      if (errorMessage.contains('existe') || errorMessage.contains('already') || response.statusCode == 409) {
        print('⚠️  Le compte existe déjà: ${account.email}');
        print('   Email: ${account.email}');
        print('   Mot de passe: ${account.password}');
        print('   Rôle: ${account.role}');
        print('');
      } else {
        print('❌ Erreur lors de la création: $errorMessage');
        print('   Réponse: ${response.body}');
        print('');
      }
    } else {
      print('❌ Erreur HTTP ${response.statusCode}: ${response.body}');
      print('');
    }
  } catch (e) {
    print('❌ Exception lors de la création du compte ${account.email}: $e');
    print('');
  }
}

Future<void> main() async {
  print('═══════════════════════════════════════════════════════════');
  print('   Création des comptes de test');
  print('═══════════════════════════════════════════════════════════');
  print('');

  for (final account in testAccounts) {
    await createAccount(account);
    // Petite pause entre les requêtes
    await Future.delayed(const Duration(milliseconds: 500));
  }

  print('═══════════════════════════════════════════════════════════');
  print('   Résumé des identifiants de test');
  print('═══════════════════════════════════════════════════════════');
  print('');
  print('📱 APP USER:');
  print('   Email: dev.user@test.com');
  print('   Mot de passe: devuser123');
  print('');
  print('👨‍💼 APP ADMIN:');
  print('   Email: dev.admin@test.com');
  print('   Mot de passe: devadmin123');
  print('');
  print('👮 APP SUPERVISOR:');
  print('   Email: dev.supervisor@test.com');
  print('   Mot de passe: devsuper123');
  print('');
  print('═══════════════════════════════════════════════════════════');
}

