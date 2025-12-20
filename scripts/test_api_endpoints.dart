import 'dart:convert';
import 'package:http/http.dart' as http;

/// Script pour tester tous les endpoints de l'API
/// Usage: dart scripts/test_api_endpoints.dart

const String baseUrl = 'https://alert-app-nc1y.onrender.com/api';

class TestResult {
  final String endpoint;
  final String method;
  final bool success;
  final int? statusCode;
  final String? error;
  final Map<String, dynamic>? response;

  TestResult({
    required this.endpoint,
    required this.method,
    required this.success,
    this.statusCode,
    this.error,
    this.response,
  });

  @override
  String toString() {
    if (success) {
      return '✅ $method $endpoint - Status: $statusCode';
    } else {
      return '❌ $method $endpoint - Status: $statusCode - Error: $error';
    }
  }
}

Future<TestResult> testEndpoint({
  required String endpoint,
  required String method,
  Map<String, dynamic>? body,
  Map<String, String>? headers,
  bool requiresAuth = false,
  String? authToken,
}) async {
  try {
    final uri = Uri.parse('$baseUrl$endpoint');
    final defaultHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth && authToken != null) {
      defaultHeaders['Authorization'] = 'Bearer $authToken';
    }

    if (headers != null) {
      defaultHeaders.addAll(headers);
    }

    http.Response response;
    switch (method.toUpperCase()) {
      case 'GET':
        response = await http.get(uri, headers: defaultHeaders).timeout(
              const Duration(seconds: 30),
            );
        break;
      case 'POST':
        response = await http
            .post(
              uri,
              headers: defaultHeaders,
              body: body != null ? json.encode(body) : null,
            )
            .timeout(const Duration(seconds: 30));
        break;
      case 'PUT':
        response = await http
            .put(
              uri,
              headers: defaultHeaders,
              body: body != null ? json.encode(body) : null,
            )
            .timeout(const Duration(seconds: 30));
        break;
      case 'DELETE':
        response = await http.delete(uri, headers: defaultHeaders).timeout(
              const Duration(seconds: 30),
            );
        break;
      default:
        return TestResult(
          endpoint: endpoint,
          method: method,
          success: false,
          error: 'Méthode HTTP non supportée: $method',
        );
    }

    Map<String, dynamic>? responseData;
    try {
      if (response.body.isNotEmpty) {
        responseData = json.decode(response.body) as Map<String, dynamic>?;
      }
    } catch (e) {
      // Response might not be JSON
    }

    final isSuccess = response.statusCode >= 200 && response.statusCode < 300;

    return TestResult(
      endpoint: endpoint,
      method: method,
      success: isSuccess,
      statusCode: response.statusCode,
      error: isSuccess ? null : response.body,
      response: responseData,
    );
  } catch (e) {
    return TestResult(
      endpoint: endpoint,
      method: method,
      success: false,
      error: e.toString(),
    );
  }
}

Future<void> main() async {
  print('═══════════════════════════════════════════════════════════');
  print('   Test des endpoints de l\'API');
  print('═══════════════════════════════════════════════════════════');
  print('');

  // Test 1: Endpoint de connexion (sans credentials valides - devrait retourner 401)
  print('📋 Test 1: Endpoint de connexion (sans credentials)');
  var result = await testEndpoint(
    endpoint: '/users/login/',
    method: 'POST',
    body: {
      'email': 'test@test.com',
      'password': 'wrongpassword',
    },
  );
  print(result);
  if (result.statusCode == 401) {
    print('   ✅ Comportement attendu: 401 Unauthorized');
  } else {
    print('   ⚠️  Status inattendu: ${result.statusCode}');
  }
  print('');

  // Test 2: Endpoint d'inscription (avec données valides)
  print('📋 Test 2: Endpoint d\'inscription');
  final testEmail = 'test_${DateTime.now().millisecondsSinceEpoch}@test.com';
  result = await testEndpoint(
    endpoint: '/users/signup/',
    method: 'POST',
    body: {
      'email': testEmail,
      'password1': 'testpass123',
      'password2': 'testpass123',
      'firstname': 'Test',
      'lastname': 'User',
      'role': 'User',
    },
  );
  print(result);
  if (result.success) {
    print('   ✅ Compte créé avec succès');
    print('   Email: $testEmail');
    print('   Password: testpass123');
  } else {
    print('   ❌ Erreur: ${result.error}');
  }
  print('');

  // Test 3: Endpoint de connexion (avec le compte créé)
  String? authToken;
  if (result.success) {
    print('📋 Test 3: Endpoint de connexion (avec credentials valides)');
    result = await testEndpoint(
      endpoint: '/users/login/',
      method: 'POST',
      body: {
        'email': testEmail,
        'password': 'testpass123',
      },
    );
    print(result);
    if (result.success && result.response != null) {
      final tokenData = result.response!['token'];
      if (tokenData is Map && tokenData.containsKey('access')) {
        authToken = tokenData['access'] as String;
        print('   ✅ Token obtenu avec succès');
        print('   Token (premiers 20 caractères): ${authToken.substring(0, authToken.length > 20 ? 20 : authToken.length)}...');
      }
    } else {
      print('   ❌ Impossible d\'obtenir le token');
    }
    print('');
  }

  // Test 4: Endpoint /users/me/ (avec token)
  if (authToken != null) {
    print('📋 Test 4: Endpoint /auth/me (récupération du profil)');
    result = await testEndpoint(
      endpoint: '/auth/me',
      method: 'GET',
      requiresAuth: true,
      authToken: authToken,
    );
    print(result);
    if (result.success) {
      print('   ✅ Profil récupéré avec succès');
    }
    print('');
  }

  // Test 5: Endpoint /users/all/ (nécessite Admin)
  print('📋 Test 5: Endpoint /users/all/ (nécessite Admin)');
  result = await testEndpoint(
    endpoint: '/users/all/',
    method: 'GET',
    requiresAuth: true,
    authToken: authToken,
  );
  print(result);
  if (result.statusCode == 403) {
    print('   ✅ Comportement attendu: 403 Forbidden (utilisateur non-admin)');
  } else if (result.success) {
    print('   ✅ Liste des utilisateurs récupérée');
  } else {
    print('   ⚠️  Status: ${result.statusCode}');
  }
  print('');

  // Test 6: Endpoint /users/pagination/
  print('📋 Test 6: Endpoint /users/pagination/');
  result = await testEndpoint(
    endpoint: '/users/pagination/',
    method: 'GET',
    requiresAuth: true,
    authToken: authToken,
  );
  print(result);
  if (result.statusCode == 403) {
    print('   ✅ Comportement attendu: 403 Forbidden (utilisateur non-admin)');
  } else if (result.success) {
    print('   ✅ Pagination des utilisateurs récupérée');
  }
  print('');

  // Test 7: Endpoint /alerts/
  print('📋 Test 7: Endpoint /alerts/');
  result = await testEndpoint(
    endpoint: '/alerts/',
    method: 'GET',
    requiresAuth: true,
    authToken: authToken,
  );
  print(result);
  if (result.success) {
    print('   ✅ Liste des alertes récupérée');
  }
  print('');

  // Test 8: Endpoint /alerts/types/
  print('📋 Test 8: Endpoint /alerts/types/');
  result = await testEndpoint(
    endpoint: '/alerts/types/',
    method: 'GET',
    requiresAuth: true,
    authToken: authToken,
  );
  print(result);
  if (result.success) {
    print('   ✅ Types d\'alertes récupérés');
  }
  print('');

  // Test 9: Endpoint /missions/
  print('📋 Test 9: Endpoint /missions/');
  result = await testEndpoint(
    endpoint: '/missions/',
    method: 'GET',
    requiresAuth: true,
    authToken: authToken,
  );
  print(result);
  if (result.success) {
    print('   ✅ Liste des missions récupérée');
  }
  print('');

  // Test 10: Endpoint /notifications/
  print('📋 Test 10: Endpoint /notifications/');
  result = await testEndpoint(
    endpoint: '/notifications/',
    method: 'GET',
    requiresAuth: true,
    authToken: authToken,
  );
  print(result);
  if (result.success) {
    print('   ✅ Liste des notifications récupérée');
  }
  print('');

  // Test de connectivité de base
  print('📋 Test de connectivité de base');
  try {
    final response = await http
        .get(Uri.parse(baseUrl))
        .timeout(const Duration(seconds: 10));
    print('   Status: ${response.statusCode}');
    if (response.statusCode < 500) {
      print('   ✅ Serveur accessible');
    } else {
      print('   ❌ Serveur retourne une erreur');
    }
  } catch (e) {
    print('   ❌ Impossible de se connecter au serveur: $e');
  }
  print('');

  print('═══════════════════════════════════════════════════════════');
  print('   Résumé');
  print('═══════════════════════════════════════════════════════════');
  print('');
  print('Si tous les tests passent, l\'API fonctionne correctement.');
  print('Si certains tests échouent, vérifiez:');
  print('  1. La connexion internet');
  print('  2. L\'URL de l\'API: $baseUrl');
  print('  3. Le statut du serveur (peut être en veille)');
  print('');
}

