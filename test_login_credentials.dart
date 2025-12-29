import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  final email = 'katsuvajkm2@gmail.com';
  final password = 'Kinshasa243@';
  
  print('=== TEST CREDENTIALS ===');
  print('Email: $email');
  print('Password: $password');
  print('');
  
  // Test regex validation
  final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  final validEmail = emailRegex.hasMatch(email.trim());
  final validPassword = password.isNotEmpty && password.length >= 1;
  
  print('=== LOCAL VALIDATION ===');
  print('Email valid: $validEmail');
  print('Password valid: $validPassword');
  print('');
  
  // Test API login
  print('=== API LOGIN TEST ===');
  try {
    final loginPayload = {'email': email, 'password': password};
    print('Payload: ${json.encode(loginPayload)}');
    print('');
    
    final response = await http.post(
      Uri.parse('https://alert-app-nc1y.onrender.com/api/users/login/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(loginPayload),
    ).timeout(Duration(seconds: 15));
    
    print('Status: ${response.statusCode}');
    print('Response body:');
    print(response.body);
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('\n✓ Login successful!');
      print('Access token: ${data['token']?['access']?.substring(0, 20)}...');
      print('User: ${data['user']}');
    } else {
      print('\n✗ Login failed');
    }
  } catch (e) {
    print('Error: $e');
  }
}
