import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const baseUrl = 'https://alert-app-nc1y.onrender.com';
  final random = DateTime.now().millisecondsSinceEpoch;
  final email = 'testuser_$random@example.com';
  const password = 'TestPassword123!';
  const firstName = 'Test';
  const lastName = 'User';

  print('🧪 Test Signup et Login (SANS TIMEOUT)');
  print('=' * 60);
  
  try {
    // Test 1: Création de compte
    print('\n📝 Test 1: Création de compte...');
    print('Email: $email');
    
    final signupResponse = await http.post(
      Uri.parse('$baseUrl/api/users/signup/'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password1': password,
        'password2': password,
        'firstname': firstName,
        'lastname': lastName,
        'role': 'User',
      }),
    );

    print('Status: ${signupResponse.statusCode}');
    print('Response: ${signupResponse.body}');

    if (signupResponse.statusCode == 201 || signupResponse.statusCode == 200) {
      print('✅ Inscription réussie!');
    } else {
      print('❌ Erreur lors de l\'inscription');
      return;
    }

    // Test 2: Connexion
    print('\n🔓 Test 2: Connexion avec le nouveau compte...');
    
    final loginResponse = await http.post(
      Uri.parse('$baseUrl/api/users/login/'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    print('Status: ${loginResponse.statusCode}');
    print('Response: ${loginResponse.body}');

    if (loginResponse.statusCode == 200) {
      final loginData = json.decode(loginResponse.body);
      if (loginData['access'] != null) {
        print('✅ Connexion réussie!');
        print('🔐 Token: ${loginData['access'].toString().substring(0, 20)}...');
      } else {
        print('❌ Pas de token reçu');
      }
    } else {
      print('❌ Erreur lors de la connexion');
    }

    print('\n' + '=' * 60);
    print('✨ Test complété avec succès!');
  } catch (e) {
    print('\n❌ Erreur: $e');
    print('Vérifiez que le serveur API est en cours d\'exécution sur $baseUrl');
  }
}
