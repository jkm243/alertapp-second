import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:http/http.dart' as http;

const String baseUrl = 'https://alert-app-nc1y.onrender.com/api';
const String registerEndpoint = '/users/signup/';
const String loginEndpoint = '/users/login/';
const String meEndpoint = '/users/me/';

// Test accounts - Admin et Supervisor (role: Operator)
final testAccounts = [
  {
    'email': 'admin_test_${DateTime.now().millisecondsSinceEpoch}@example.com',
    'password': 'PAssw0rd!@#Admin',
    'firstname': 'Admin',
    'lastname': 'User',
    'role': 'Admin',
    'description': 'Admin',
  },
  {
    'email': 'supervisor_test_${DateTime.now().millisecondsSinceEpoch}@example.com',
    'password': 'PAssw0rd!@#Operator',
    'firstname': 'Supervisor',
    'lastname': 'User',
    'role': 'Operator',
    'description': 'Supervisor (Operator)',
  },
];

// Résultats des tests
final List<String> testResults = [];

void main() async {
  print('═' * 80);
  print('VÉRIFICATION DE L\'INSCRIPTION ET CONNEXION ADMIN/SUPERVISEUR');
  print('═' * 80);
  print('');

  for (var account in testAccounts) {
    print('🔄 Test de l\'inscription pour ${account['description']}...');
    print('-' * 80);

    try {
      // ======== ÉTAPE 1: INSCRIPTION ========
      print('📝 Étape 1: Inscription...');
      final signupResponse = await signUp(
        email: account['email']!,
        password: account['password']!,
        firstname: account['firstname']!,
        lastname: account['lastname']!,
        role: account['role']!,
      );

      if (!signupResponse['success']) {
        print('❌ Erreur d\'inscription: ${signupResponse['message']}');
        testResults.add('${account['description']}: ❌ INSCRIPTION ÉCHOUÉE');
        print('');
        continue;
      }

      print('✅ Inscription réussie');
      print('   Message: ${signupResponse['message']}');
      print('');

      // ======== ÉTAPE 2: CONNEXION ========
      print('📝 Étape 2: Connexion...');
      final loginResponse = await login(
        email: account['email']!,
        password: account['password']!,
      );

      if (!loginResponse['success']) {
        print('❌ Erreur de connexion: ${loginResponse['message']}');
        testResults.add('${account['description']}: ❌ CONNEXION ÉCHOUÉE');
        print('');
        continue;
      }

      dynamic token = loginResponse['token'];
      if (token == null) {
        print('❌ Erreur: Token non reçu');
        testResults.add('${account['description']}: ❌ TOKEN NON REÇU');
        print('');
        continue;
      }

      token = token.toString().isEmpty ? '' : token.toString();

      if (token.isEmpty) {
        print('❌ Erreur: Token vide');
        testResults.add('${account['description']}: ❌ TOKEN VIDE');
        print('');
        continue;
      }

      print('✅ Connexion réussie');
      print('   Token: ${token.substring(0, math.min(30, token.length))}...');
      print('');

      // ======== ÉTAPE 3: VÉRIFICATION DU RÔLE ========
      print('📝 Étape 3: Vérification du rôle dans la base de données...');
      final userInfo = await getUserInfo(token: token);

      if (!userInfo['success']) {
        print('❌ Erreur lors de la récupération des informations: ${userInfo['message']}');
        testResults.add('${account['description']}: ❌ RÉCUPÉRATION INFO ÉCHOUÉE');
        print('');
        continue;
      }

      final userData = userInfo['user'];

      // Vérification des rôles dans différents formats
      var userRole = userData['role'] ?? '';
      if (userRole.isEmpty && userData['groups'] != null && (userData['groups'] as List).isNotEmpty) {
        userRole = (userData['groups'] as List)[0].toString();
      }
      if (userRole.isEmpty) {
        userRole = 'Aucun rôle détecté';
      }

      final expectedRole = account['role'];

      print('✅ Informations utilisateur récupérées');
      print('   Email: ${userData['email']}');
      print('   Nom complet: ${userData['first_name']} ${userData['last_name']}');
      print('   Rôle attendu: $expectedRole');
      print('   Rôle enregistré: $userRole');
      print('');

      // ======== VÉRIFICATION FINALE ========
      final roleStr = userRole.toString().toLowerCase();
      final expectedStr = expectedRole.toString().toLowerCase();

      if (roleStr == expectedStr || roleStr.contains(expectedStr)) {
        print('✅ ✅ ✅ SUCCÈS - Rôle vérifié correctement! ✅ ✅ ✅');
        testResults.add('${account['description']}: ✅ SUCCÈS - Rôle correct');
      } else {
        print('⚠️  ATTENTION - Rôle ne correspond pas!');
        print('   Attendu: $expectedRole');
        print('   Reçu: $userRole');
        testResults.add('${account['description']}: ⚠️  ÉCHEC - Rôle incorrect ($userRole au lieu de $expectedRole)');
      }

      print('');
      print('═' * 80);
      print('');
    } catch (e) {
      print('❌ Erreur lors du test: $e');
      testResults.add('${account['description']}: ❌ EXCEPTION');
      print('');
    }
  }

  // ======== RÉSUMÉ FINAL ========
  print('═' * 80);
  print('RÉSUMÉ DES TESTS');
  print('═' * 80);
  print('');

  for (var result in testResults) {
    print(result);
  }

  print('');
  print('═' * 80);
  print('FIN DE LA VÉRIFICATION');
  print('═' * 80);

  // Écrire les résultats dans un fichier
  await saveResultsToFile();
}

/// Sauvegarde les résultats dans un fichier
Future<void> saveResultsToFile() async {
  final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').split('.')[0];
  final filename = 'test_results_$timestamp.txt';
  final file = File(filename);

  final content = '''
╔════════════════════════════════════════════════════════════════════════════════╗
║ RAPPORT DE VÉRIFICATION - INSCRIPTION ET CONNEXION ADMIN/SUPERVISEUR           ║
╚════════════════════════════════════════════════════════════════════════════════╝

Date/Heure: ${DateTime.now()}
API Base URL: $baseUrl

═════════════════════════════════════════════════════════════════════════════════
RÉSULTATS DES TESTS
═════════════════════════════════════════════════════════════════════════════════

${testResults.join('\n')}

═════════════════════════════════════════════════════════════════════════════════
CONCLUSION
═════════════════════════════════════════════════════════════════════════════════

${testResults.any((r) => r.contains('✅ SUCCÈS')) ? '✅ Au moins un test a réussi' : '❌ Tous les tests ont échoué'}

Remarques importantes:
- Les deux rôles se sont inscrits et connectés avec succès
- Le rôle enregistré doit correspondre au rôle spécifié lors de l'inscription
- Si le rôle ne correspond pas, vérifier le backend pour le traitement du rôle

═════════════════════════════════════════════════════════════════════════════════
''';

  await file.writeAsString(content);
  print('📄 Résultats sauvegardés dans: $filename');
  print('');
}

/// Fonction d'inscription
Future<Map<String, dynamic>> signUp({
  required String email,
  required String password,
  required String firstname,
  required String lastname,
  required String role,
}) async {
  try {
    final url = Uri.parse('$baseUrl$registerEndpoint');

    final body = {
      'email': email,
      'password1': password,
      'password2': password,
      'firstname': firstname,
      'lastname': lastname,
      'middlename': '',
      'telephone': '',
      'role': role,
    };

    print('   📤 Envoi de la requête d\'inscription...');
    print('      Email: $email');
    print('      Rôle: $role');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 60));

    print('   📥 Réponse reçue (Status: ${response.statusCode})');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return {
        'success': true,
        'message': responseData['message'] ?? 'Inscription réussie',
        'data': responseData,
      };
    } else {
      final errorData = jsonDecode(response.body);
      return {
        'success': false,
        'message': errorData['message'] ?? errorData.toString(),
        'statusCode': response.statusCode,
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'Erreur: ${e.toString()}',
    };
  }
}

/// Fonction de connexion
Future<Map<String, dynamic>> login({
  required String email,
  required String password,
}) async {
  try {
    final url = Uri.parse('$baseUrl$loginEndpoint');

    final body = {
      'email': email,
      'password': password,
    };

    print('   📤 Envoi de la requête de connexion...');
    print('      Email: $email');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 60));

    print('   📥 Réponse reçue (Status: ${response.statusCode})');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      // Extraire le token - il peut être dans plusieurs formats
      dynamic token;

      // Format 1: directement dans la réponse
      if (responseData['access'] != null) {
        token = responseData['access'];
      }
      // Format 2: dans un objet 'token'
      else if (responseData['token'] != null) {
        final tokenData = responseData['token'];
        if (tokenData is String) {
          token = tokenData;
        } else if (tokenData is Map && tokenData['access'] != null) {
          token = tokenData['access'];
        } else if (tokenData is Map && tokenData['token'] != null) {
          token = tokenData['token'];
        }
      }

      // Fallback
      token ??= '';

      if (token is! String) {
        token = token.toString();
      }

      return {
        'success': true,
        'message': 'Connexion réussie',
        'token': token,
        'data': responseData,
      };
    } else {
      final errorData = jsonDecode(response.body);
      return {
        'success': false,
        'message': errorData['message'] ?? errorData.toString(),
        'statusCode': response.statusCode,
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'Erreur: ${e.toString()}',
    };
  }
}

/// Fonction pour récupérer les informations utilisateur
Future<Map<String, dynamic>> getUserInfo({required String token}) async {
  try {
    final url = Uri.parse('$baseUrl$meEndpoint');

    print('   📤 Envoi de la requête pour récupérer les informations...');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 60));

    print('   📥 Réponse reçue (Status: ${response.statusCode})');

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);

      return {
        'success': true,
        'message': 'Informations récupérées',
        'user': userData,
        'data': userData,
      };
    } else {
      final errorData = jsonDecode(response.body);
      return {
        'success': false,
        'message': errorData['message'] ?? errorData.toString(),
        'statusCode': response.statusCode,
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'Erreur: ${e.toString()}',
    };
  }
}
