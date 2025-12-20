import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiTestService {
  static const String baseUrl = 'http://localhost:8000/api'; // Adjust if different

  static Future<void> testAdminSignup() async {
    try {
      print('🧪 Test de l\'inscription Admin...');

      final signupData = {
        'email': 'admin@example.com',
        'password1': 'AdminPassword123!',
        'password2': 'AdminPassword123!',
        'firstname': 'Admin',
        'lastname': 'User',
        'middlename': null,
        'telephone': '+243970000401',
        'role': 'Admin',
      };

      print('📤 Données envoyées:');
      print(json.encode(signupData));

      final response = await http.post(
        Uri.parse('$baseUrl/auth/register/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(signupData),
      );

      print('📥 Statut de la réponse: ${response.statusCode}');
      print('📥 Corps de la réponse:');
      print(response.body);

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        print('✅ Inscription Admin réussie!');
        print('ID: ${responseData['id']}');
        print('Email: ${responseData['email']}');
        print('Nom: ${responseData['firstname']} ${responseData['lastname']}');
        print('Rôle: ${responseData['role']}');
        print('Actif: ${responseData['is_active']}');
      } else {
        print('❌ Erreur lors de l\'inscription Admin: ${response.statusCode}');
      }

    } catch (e) {
      print('❌ Erreur lors de l\'inscription Admin: $e');
    }
  }

  static Future<void> testSupervisorSignup() async {
    try {
      print('🧪 Test de l\'inscription Superviseur...');

      final signupData = {
        'email': 'supervisor@example.com',
        'password1': 'SupervisorPassword123!',
        'password2': 'SupervisorPassword123!',
        'firstname': 'Supervisor',
        'lastname': 'User',
        'middlename': null,
        'telephone': '+243970000402',
        'role': 'Supervisor',
      };

      print('📤 Données envoyées:');
      print(json.encode(signupData));

      final response = await http.post(
        Uri.parse('$baseUrl/auth/register/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(signupData),
      );

      print('📥 Statut de la réponse: ${response.statusCode}');
      print('📥 Corps de la réponse:');
      print(response.body);

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        print('✅ Inscription Superviseur réussie!');
        print('ID: ${responseData['id']}');
        print('Email: ${responseData['email']}');
        print('Nom: ${responseData['firstname']} ${responseData['lastname']}');
        print('Rôle: ${responseData['role']}');
        print('Actif: ${responseData['is_active']}');
      } else {
        print('❌ Erreur lors de l\'inscription Superviseur: ${response.statusCode}');
      }

    } catch (e) {
      print('❌ Erreur lors de l\'inscription Superviseur: $e');
    }
  }

  static Future<void> runAllTests() async {
    print('🚀 Début des tests API Admin/Superviseur...\n');

    await testAdminSignup();
    print('\n${'='*50}\n');
    await testSupervisorSignup();

    print('\n🏁 Tests terminés!');
  }
}

void main() async {
  await ApiTestService.runAllTests();
}
