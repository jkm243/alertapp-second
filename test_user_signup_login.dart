import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

void main() async {
  // Generate unique email
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final random = Random().nextInt(10000);
  final email = 'user_${timestamp}_$random@example.com';

  final signupPayload = {
    "email": email,
    "password1": "TestPass123!",
    "password2": "TestPass123!",
    "lastname": "Fictif",
    "firstname": "Compte",
    "middlename": "Test",
    "telephone": "+243970000000",
    "role": "User"
  };

  print('=== SIGNUP TEST ===');
  print('Email: $email');
  print('Payload: ${json.encode(signupPayload)}');
  print('');

  try {
    final signupResponse = await http.post(
      Uri.parse('https://alert-app-nc1y.onrender.com/api/users/signup/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(signupPayload),
    ).timeout(Duration(seconds: 15));

    print('Status: ${signupResponse.statusCode}');
    print('Response: ${signupResponse.body}');
    print('');

    if (signupResponse.statusCode != 201) {
      print('✗ Signup failed!');
      return;
    }

    print('✓ Signup successful!');
    print('');

    // Now test login
    print('=== LOGIN TEST ===');
    final loginPayload = {
      'email': signupPayload['email'],
      'password': signupPayload['password1'],
    };

    print('Payload: ${json.encode(loginPayload)}');

    final loginResponse = await http.post(
      Uri.parse('https://alert-app-nc1y.onrender.com/api/users/login/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(loginPayload),
    ).timeout(Duration(seconds: 15));

    print('Status: ${loginResponse.statusCode}');
    print('Response: ${loginResponse.body}');
    print('');

    if (loginResponse.statusCode == 200) {
      print('✓ Login successful!');
      final data = json.decode(loginResponse.body);
      print('Access token: ${data['token']?['access']?.substring(0, 30)}...');
      print('User: ${data['user']?['email']} (${data['user']?['role']})');
    } else if (loginResponse.statusCode == 401) {
      print('✗ Login failed (401) - check if account is activated');
      print('  Hint: You may need to activate the account via email link');
    } else {
      print('✗ Login failed');
    }
  } catch (e) {
    print('Error: $e');
  }
}
