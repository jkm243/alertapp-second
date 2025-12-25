import 'dart:convert';
import 'package:http/http.dart' as http;

/// Modèle pour stocker les résultats des tests
class TestResult {
  final String endpoint;
  final String method;
  final bool passed;
  final String? errorMessage;
  final int? statusCode;
  final String? responseBody;

  TestResult({
    required this.endpoint,
    required this.method,
    required this.passed,
    this.errorMessage,
    this.statusCode,
    this.responseBody,
  });

  @override
  String toString() {
    final _green = '\x1b[32m';
    final _red = '\x1b[31m';
    final _reset = '\x1b[0m';
    final status = passed ? '\${_green}✓ PASS\${_reset}' : '\${_red}✗ FAIL\${_reset}';
    final details = errorMessage != null ? ' | Erreur: $errorMessage' : '';
    final code = statusCode != null ? ' | HTTP $statusCode' : '';
    return '$status | $endpoint [$method]$code$details';
  }
}

/// Classe pour tester tous les endpoints de l'API Alert App
class ApiIntegrationTester {
  final String baseUrl = 'https://alert-app-nc1y.onrender.com/api';
  late String accessToken;
  late String refreshToken;
  late String userId;
  late String testAlertId;
  late String testTypeAlertId;
  late String testUserEmail;
  String testUserPassword = 'TestPassword123!';
  // Operator (supervisor) credentials & token
  late String operatorEmail;
  String operatorPassword = 'OperatorPass123!';
  late String operatorAccessToken;

  // Couleurs pour l'output
  static const String _green = '\x1b[32m';
  static const String _red = '\x1b[31m';
  static const String _yellow = '\x1b[33m';
  static const String _blue = '\x1b[34m';
  static const String _reset = '\x1b[0m';

  final List<TestResult> results = [];

  
  // --- Helpers: signup/login for arbitrary credentials ---
  Future<String> loginAndReturnToken(String email, String password) async {
    const endpoint = '/users/login/';
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token']?['access'] ?? '';
      }
    } catch (_) {}
    return '';
  }

  Future<String> testSignupForRole(String role) async {
    const endpoint = '/users/signup/';
    final email = 'signup_test_${role.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}@example.com';
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password1': testUserPassword,
          'password2': testUserPassword,
          'firstname': role,
          'lastname': 'Test',
          'role': role,
        }),
      ).timeout(Duration(seconds: 30));

      final passed = response.statusCode == 201 || response.statusCode == 200;
      results.add(TestResult(endpoint: endpoint, method: 'POST', passed: passed, statusCode: response.statusCode, responseBody: response.body));
      if (passed) return email;
    } catch (e) {
      results.add(TestResult(endpoint: endpoint, method: 'POST', passed: false, errorMessage: e.toString()));
    }
    return '';
  }

  Future<void> testOperatorValidateAlert() async {
    final endpointTemplate = '/alert/alerts/{id}/validate/';
    if (testAlertId.isEmpty) {
      results.add(TestResult(endpoint: endpointTemplate, method: 'POST', passed: false, errorMessage: 'No alert id'));
      return;
    }
    final endpoint = endpointTemplate.replaceAll('{id}', testAlertId);
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Authorization': 'Bearer $operatorAccessToken', 'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 30));

      final passed = response.statusCode == 200;
      results.add(TestResult(endpoint: endpoint, method: 'POST', passed: passed, statusCode: response.statusCode, responseBody: response.body));
    } catch (e) {
      results.add(TestResult(endpoint: endpoint, method: 'POST', passed: false, errorMessage: e.toString()));
    }
  }

  Future<void> testGetAlertDetail() async {
    final endpointTemplate = '/alert/alerts/{id}/';
    if (testAlertId.isEmpty) return;
    final endpoint = endpointTemplate.replaceAll('{id}', testAlertId);
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $accessToken'},
      ).timeout(Duration(seconds: 30));
      final passed = response.statusCode == 200;
      results.add(TestResult(endpoint: endpoint, method: 'GET', passed: passed, statusCode: response.statusCode, responseBody: response.body));
      if (passed) {
        final data = jsonDecode(response.body);
        print('  Alert detail: ${data}');
      }
    } catch (e) {
      results.add(TestResult(endpoint: endpoint, method: 'GET', passed: false, errorMessage: e.toString()));
    }
  }

  /// === AUTHENTICATION TESTS ===

  Future<void> testLogin() async {
    const endpoint = '/users/login/';
    try {
      print('$_blue→ Testing: $endpoint$_reset');

      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': 'testuser@example.com',
          'password': 'TestPassword123!',
        }),
      ).timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        accessToken = data['token']['access'] ?? '';
        refreshToken = data['token']['refresh'] ?? '';
        userId = data['user']['id'] ?? '';

        results.add(TestResult(
          endpoint: endpoint,
          method: 'POST',
          passed: true,
          statusCode: response.statusCode,
        ));
        print('  Token: ${accessToken.substring(0, 20)}...');
        print('  User ID: $userId\n');
      } else {
        results.add(TestResult(
          endpoint: endpoint,
          method: 'POST',
          passed: false,
          statusCode: response.statusCode,
          errorMessage: 'Expected 200, got ${response.statusCode}',
          responseBody: response.body,
        ));
        print('  ${_red}Status: ${response.statusCode}$_reset');
        print('  Body: ${response.body}\n');
      }
    } catch (e) {
      results.add(TestResult(
        endpoint: endpoint,
        method: 'POST',
        passed: false,
        errorMessage: e.toString(),
      ));
      print('  ${_red}Error: $e$_reset\n');
    }
  }

  Future<void> testSignup() async {
    const endpoint = '/users/signup/';
    try {
      print('$_blue→ Testing: $endpoint$_reset');

      final email = 'signup_test_${DateTime.now().millisecondsSinceEpoch}@example.com';
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password1': 'TestPassword123!',
          'password2': 'TestPassword123!',
          'firstname': 'Test',
          'lastname': 'User',
          'role': 'User',
        }),
      ).timeout(Duration(seconds: 30));

      final passed = response.statusCode == 201 || response.statusCode == 200;
      results.add(TestResult(
        endpoint: endpoint,
        method: 'POST',
        passed: passed,
        statusCode: response.statusCode,
        errorMessage: passed ? null : 'Expected 201, got ${response.statusCode}',
        responseBody: response.body,
      ));

      print('  Status: ${response.statusCode}');
      print('  Body: ${response.body}\n');
    } catch (e) {
      results.add(TestResult(
        endpoint: endpoint,
        method: 'POST',
        passed: false,
        errorMessage: e.toString(),
      ));
      print('  ${_red}Error: $e$_reset\n');
    }
  }

  Future<void> testGetCurrentUser() async {
    const endpoint = '/users/me/';
    try {
      print('$_blue→ Testing: $endpoint$_reset');

      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(Duration(seconds: 30));

      final passed = response.statusCode == 200;
      results.add(TestResult(
        endpoint: endpoint,
        method: 'GET',
        passed: passed,
        statusCode: response.statusCode,
        errorMessage: passed ? null : 'Expected 200, got ${response.statusCode}',
        responseBody: response.body,
      ));

      if (passed) {
        final data = jsonDecode(response.body);
        print('  User: ${data['email']} (${data['role']})');
      } else {
        print('  ${_red}Status: ${response.statusCode}$_reset');
      }
      print('');
    } catch (e) {
      results.add(TestResult(
        endpoint: endpoint,
        method: 'GET',
        passed: false,
        errorMessage: e.toString(),
      ));
      print('  ${_red}Error: $e$_reset\n');
    }
  }

  /// === USER PROFILE TESTS ===

  Future<void> testEditProfile() async {
    const endpoint = '/users/edit-profile/';
    try {
      print('$_blue→ Testing: $endpoint$_reset');

      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'firstname': 'Updated',
          'lastname': 'User',
          'email': 'updated_${DateTime.now().millisecondsSinceEpoch}@example.com',
          'telephone': '+243970000000',
        }),
      ).timeout(Duration(seconds: 30));

      final passed = response.statusCode == 200;
      results.add(TestResult(
        endpoint: endpoint,
        method: 'POST',
        passed: passed,
        statusCode: response.statusCode,
        errorMessage: passed ? null : 'Expected 200, got ${response.statusCode}',
        responseBody: response.body,
      ));

      print('  Status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('  Updated: ${data['firstname']} ${data['lastname']}');
      }
      print('');
    } catch (e) {
      results.add(TestResult(
        endpoint: endpoint,
        method: 'POST',
        passed: false,
        errorMessage: e.toString(),
      ));
      print('  ${_red}Error: $e$_reset\n');
    }
  }

  Future<void> testChangePassword() async {
    const endpoint = '/users/change-password/';
    try {
      print('$_blue→ Testing: $endpoint$_reset');

      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'old_password': 'TestPassword123!',
          'new_password': 'NewPassword123!',
          'confirm_password': 'NewPassword123!',
        }),
      ).timeout(Duration(seconds: 30));

      final passed = response.statusCode == 200;
      results.add(TestResult(
        endpoint: endpoint,
        method: 'POST',
        passed: passed,
        statusCode: response.statusCode,
        errorMessage: passed ? null : 'Expected 200, got ${response.statusCode}',
        responseBody: response.body,
      ));

      print('  Status: ${response.statusCode}');
      if (!passed) print('  Body: ${response.body}');
      print('');
    } catch (e) {
      results.add(TestResult(
        endpoint: endpoint,
        method: 'POST',
        passed: false,
        errorMessage: e.toString(),
      ));
      print('  ${_red}Error: $e$_reset\n');
    }
  }

  /// === ALERT TYPE TESTS ===

  Future<void> testGetAlertTypes() async {
    const endpoint = '/alert/typealerts/';
    try {
      print('$_blue→ Testing: $endpoint$_reset');

      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(Duration(seconds: 30));

      final passed = response.statusCode == 200;
      results.add(TestResult(
        endpoint: endpoint,
        method: 'GET',
        passed: passed,
        statusCode: response.statusCode,
        errorMessage: passed ? null : 'Expected 200, got ${response.statusCode}',
        responseBody: response.body,
      ));

      if (passed) {
        final data = jsonDecode(response.body);
        if (data is List && data.isNotEmpty) {
          testTypeAlertId = data[0]['id'];
          print('  Found ${data.length} alert types');
          print('  First type: ${data[0]['name']}');
        }
      } else {
        print('  ${_red}Status: ${response.statusCode}$_reset');
      }
      print('');
    } catch (e) {
      results.add(TestResult(
        endpoint: endpoint,
        method: 'GET',
        passed: false,
        errorMessage: e.toString(),
      ));
      print('  ${_red}Error: $e$_reset\n');
    }
  }

  /// === ALERT TESTS ===

  Future<void> testCreateAlert() async {
    const endpoint = '/alert/alerts/create/';
    try {
      print('$_blue→ Testing: $endpoint$_reset');

      if (testTypeAlertId.isEmpty) {
        print('  ${_yellow}Skipping: No alert type found$_reset\n');
        return;
      }

      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        body: {
          'type': testTypeAlertId,
          'description': 'Test alert from integration test',
          'latitude': '-4.3276',
          'longitude': '15.3136',
        },
      ).timeout(Duration(seconds: 30));

      final passed = response.statusCode == 201 || response.statusCode == 200;
      results.add(TestResult(
        endpoint: endpoint,
        method: 'POST',
        passed: passed,
        statusCode: response.statusCode,
        errorMessage: passed ? null : 'Expected 201, got ${response.statusCode}',
        responseBody: response.body,
      ));

      if (passed) {
        final data = jsonDecode(response.body);
        testAlertId = data['id'] ?? '';
        print('  Created alert: $testAlertId');
      } else {
        print('  ${_red}Status: ${response.statusCode}$_reset');
        print('  Body: ${response.body}');
      }
      print('');
    } catch (e) {
      results.add(TestResult(
        endpoint: endpoint,
        method: 'POST',
        passed: false,
        errorMessage: e.toString(),
      ));
      print('  ${_red}Error: $e$_reset\n');
    }
  }

  Future<void> testGetMyAlerts() async {
    const endpoint = '/alert/alerts/my-alerts/';
    try {
      print('$_blue→ Testing: $endpoint$_reset');

      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(Duration(seconds: 30));

      final passed = response.statusCode == 200;
      results.add(TestResult(
        endpoint: endpoint,
        method: 'GET',
        passed: passed,
        statusCode: response.statusCode,
        errorMessage: passed ? null : 'Expected 200, got ${response.statusCode}',
        responseBody: response.body,
      ));

      if (passed) {
        final data = jsonDecode(response.body);
        print('  Found ${(data as List).length} alerts');
      } else {
        print('  ${_red}Status: ${response.statusCode}$_reset');
      }
      print('');
    } catch (e) {
      results.add(TestResult(
        endpoint: endpoint,
        method: 'GET',
        passed: false,
        errorMessage: e.toString(),
      ));
      print('  ${_red}Error: $e$_reset\n');
    }
  }

  Future<void> testGetAllAlerts() async {
    const endpoint = '/alert/alerts/all/';
    try {
      print('$_blue→ Testing: $endpoint$_reset');

      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(Duration(seconds: 30));

      final passed = response.statusCode == 200;
      results.add(TestResult(
        endpoint: endpoint,
        method: 'GET',
        passed: passed,
        statusCode: response.statusCode,
        errorMessage: passed ? null : 'Expected 200, got ${response.statusCode}',
        responseBody: response.body,
      ));

      if (passed) {
        final data = jsonDecode(response.body);
        print('  Found ${(data as List).length} total alerts');
      } else {
        print('  ${_red}Status: ${response.statusCode}$_reset');
      }
      print('');
    } catch (e) {
      results.add(TestResult(
        endpoint: endpoint,
        method: 'GET',
        passed: false,
        errorMessage: e.toString(),
      ));
      print('  ${_red}Error: $e$_reset\n');
    }
  }

  Future<void> testUpdateAlert() async {
    const endpoint = '/alert/alerts/{id}/update/';
    try {
      print('$_blue→ Testing: $endpoint$_reset');

      if (testAlertId.isEmpty) {
        print('  ${_yellow}Skipping: No alert created$_reset\n');
        return;
      }

      final actualEndpoint = endpoint.replaceAll('{id}', testAlertId);
      final response = await http.put(
        Uri.parse('$baseUrl$actualEndpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'description': 'Updated alert description',
        }),
      ).timeout(Duration(seconds: 30));

      final passed = response.statusCode == 200;
      results.add(TestResult(
        endpoint: endpoint,
        method: 'PUT',
        passed: passed,
        statusCode: response.statusCode,
        errorMessage: passed ? null : 'Expected 200, got ${response.statusCode}',
        responseBody: response.body,
      ));

      if (!passed) print('  ${_red}Status: ${response.statusCode}$_reset');
      print('');
    } catch (e) {
      results.add(TestResult(
        endpoint: endpoint,
        method: 'PUT',
        passed: false,
        errorMessage: e.toString(),
      ));
      print('  ${_red}Error: $e$_reset\n');
    }
  }

  Future<void> testDeleteAlert() async {
    const endpoint = '/alert/alerts/{id}/delete/';
    try {
      print('$_blue→ Testing: $endpoint$_reset');

      if (testAlertId.isEmpty) {
        print('  ${_yellow}Skipping: No alert created$_reset\n');
        return;
      }

      final actualEndpoint = endpoint.replaceAll('{id}', testAlertId);
      final response = await http.delete(
        Uri.parse('$baseUrl$actualEndpoint'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(Duration(seconds: 30));

      final passed = response.statusCode == 204;
      results.add(TestResult(
        endpoint: endpoint,
        method: 'DELETE',
        passed: passed,
        statusCode: response.statusCode,
        errorMessage: passed ? null : 'Expected 204, got ${response.statusCode}',
        responseBody: response.body,
      ));

      if (!passed) print('  ${_red}Status: ${response.statusCode}$_reset');
      print('');
    } catch (e) {
      results.add(TestResult(
        endpoint: endpoint,
        method: 'DELETE',
        passed: false,
        errorMessage: e.toString(),
      ));
      print('  ${_red}Error: $e$_reset\n');
    }
  }

  /// === UTILITY TESTS ===

  Future<void> testRefreshToken() async {
    const endpoint = '/users/account/refresh/';
    try {
      print('$_blue→ Testing: $endpoint$_reset');

      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'refresh': refreshToken,
        }),
      ).timeout(Duration(seconds: 30));

      final passed = response.statusCode == 200;
      results.add(TestResult(
        endpoint: endpoint,
        method: 'POST',
        passed: passed,
        statusCode: response.statusCode,
        errorMessage: passed ? null : 'Expected 200, got ${response.statusCode}',
        responseBody: response.body,
      ));

      if (passed) {
        final data = jsonDecode(response.body);
        accessToken = data['access'] ?? '';
        print('  Token refreshed');
      } else {
        print('  ${_red}Status: ${response.statusCode}$_reset');
      }
      print('');
    } catch (e) {
      results.add(TestResult(
        endpoint: endpoint,
        method: 'POST',
        passed: false,
        errorMessage: e.toString(),
      ));
      print('  ${_red}Error: $e$_reset\n');
    }
  }

  /// === SUMMARY & REPORT ===

  void printSummary() {
    print('\n$_blue${"="*60}$_reset');
    print('${_blue}RÉSUMÉ DES TESTS$_reset');
    print('$_blue${"="*60}$_reset\n');

    final totalTests = results.length;
    final passedTests = results.where((r) => r.passed).length;
    final failedTests = results.where((r) => !r.passed).length;

    print('Total tests: $totalTests');
    print('${_green}Réussis: $passedTests$_reset');
    print('$_redÉchoués: $failedTests$_reset');
    print('Taux de réussite: ${((passedTests / totalTests) * 100).toStringAsFixed(1)}%\n');

    if (failedTests > 0) {
      print('${_red}ENDPOINTS AVEC ERREURS:$_reset\n');
      for (final result in results.where((r) => !r.passed)) {
        print('  • ${result.endpoint} [${result.method}]');
        if (result.errorMessage != null) {
          print('    Erreur: ${result.errorMessage}');
        }
        if (result.statusCode != null) {
          print('    HTTP: ${result.statusCode}');
        }
      }
    }

    print('\n${_blue}TOUS LES RÉSULTATS:$_reset\n');
    for (final result in results) {
      print(result.toString());
    }
  }

  Future<void> runAllTests() async {
    print('$_blue${"="*60}$_reset');
    print('${_blue}TESTS D\'INTÉGRATION API - ALERT APP$_reset');
    print('$_blue${"="*60}$_reset\n');
    // E2E flow requested by user:
    // 1) signup user -> login user
    // 2) create alert as user
    // 3) signup operator -> login operator
    // 4) operator validates alert
    // 5) verify alert detail as user shows validation

    // Signup user
    testUserEmail = await testSignupForRole('User');
    if (testUserEmail.isEmpty) {
      print('Failed to create test user, aborting');
      printSummary();
      return;
    }

    // Login as user
    accessToken = await loginAndReturnToken(testUserEmail, testUserPassword);
    if (accessToken.isEmpty) {
      results.add(TestResult(endpoint: '/users/login/', method: 'POST', passed: false, errorMessage: 'Login failed for user'));
      printSummary();
      return;
    }

    // Basic user checks
    await testGetCurrentUser();
    await testEditProfile();

    // Fetch types and create alert
    await testGetAlertTypes();
    await testCreateAlert();
    await testGetMyAlerts();

    // Create operator and login
    operatorEmail = await testSignupForRole('Operator');
    if (operatorEmail.isEmpty) {
      results.add(TestResult(endpoint: '/users/signup/', method: 'POST', passed: false, errorMessage: 'Operator signup failed'));
      printSummary();
      return;
    }
    operatorAccessToken = await loginAndReturnToken(operatorEmail, operatorPassword);
    if (operatorAccessToken.isEmpty) {
      results.add(TestResult(endpoint: '/users/login/', method: 'POST', passed: false, errorMessage: 'Login failed for operator'));
      printSummary();
      return;
    }

    // Operator validates the alert
    await testOperatorValidateAlert();

    // Back to user: verify alert detail shows validation
    await testGetAlertDetail();

    printSummary();
  }
}

void main() async {
  final tester = ApiIntegrationTester();
  await tester.runAllTests();
}
