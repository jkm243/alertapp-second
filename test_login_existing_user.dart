import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const baseUrl = 'https://alert-app-nc1y.onrender.com';
  const email = 'dev.user@test.com';
  const password = 'devuser123';

  print('🧪 Test Login (SANS TIMEOUT CLIENT)');
  print('=' * 60);
  
  try {
    // Test: Login avec un compte existant
    print('\n🔓 Test: Connexion avec un compte existant...');
    print('Email: $email');
    
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
        print('\n✅ SUCCÈS! Connexion réussie!');
        print('🔐 Token (premiers 40 caractères): ${loginData['access'].toString().substring(0, 40)}...');
        print('👤 Utilisateur: ${loginData['user']?['fullName'] ?? 'Inconnu'}');
      } else {
        print('\n❌ Pas de token reçu');
      }
    } else if (loginResponse.statusCode == 401) {
      print('\n⚠️ Identifiants incorrects ou compte inexistant');
    } else {
      print('\n❌ Erreur lors de la connexion');
    }

    print('\n' + '=' * 60);
    print('✨ Test complété!');
  } catch (e) {
    print('\n❌ Erreur: $e');
    print('Vérifiez que le serveur API est en cours d\'exécution sur $baseUrl');
  }
}
