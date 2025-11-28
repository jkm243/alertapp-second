import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:alert_app/services/api_service.dart';

void main() {
  group('API Integration tests', () {
    // Read credentials from environment variables to make tests configurable in CI
    final email = Platform.environment['API_TEST_EMAIL'];
    final password = Platform.environment['API_TEST_PASSWORD'];
    final skipTests = email == null || password == null;

    test('Login returns tokens and user', () async {
      if (skipTests) {
        print('Skipping login test: set API_TEST_EMAIL and API_TEST_PASSWORD environment variables');
        return;
      }

      try {
        final response = await ApiService.login(email: email, password: password);
        expect(response.token.access.isNotEmpty, true, reason: 'Access token should be present');
        expect(response.token.refresh.isNotEmpty, true, reason: 'Refresh token should be present');
        expect(response.user.email, email, reason: 'Returned user email should match');
      } catch (e) {
        fail('Login failed with error: $e');
      }
    }, timeout: Timeout(Duration(seconds: 60)));

    test('Verify token returns user', () async {
      if (skipTests) {
        print('Skipping verify-token test: set API_TEST_EMAIL and API_TEST_PASSWORD environment variables');
        return;
      }

      try {
        final loginRes = await ApiService.login(email: email, password: password);
        final access = loginRes.token.access;
        final user = await ApiService.verifyToken(access);
        expect(user.email, email, reason: 'Verified user email should match');
      } catch (e) {
        fail('Verify token failed: $e');
      }
    }, timeout: Timeout(Duration(seconds: 60)));
  });
}
