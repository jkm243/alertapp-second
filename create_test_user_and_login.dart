import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

void main() async {
  // Generate random test account
  final random = Random();
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final randomNum = random.nextInt(10000);
  final email = 'testuser_${timestamp}_${randomNum}@example.com';
  final password = 'TestPassword123!';
  final firstName = 'Test';
  final lastName = 'User';
  
  print('=== NEW TEST ACCOUNT CREATION ===');
  print('Email: $email');
  print('Password: $password');
  print('First name: $firstName');
  print('Last name: $lastName');
  print('');
  
  // Step 1: Signup
  print('=== STEP 1: SIGNUP ===');
  try {
    final signupPayload = {
      'email': email,
      'password1': password,
      'password2': password,
      'first_name': firstName,
      'last_name': lastName,
      'role': 'User',
    };
    
    print('Signup payload: ${json.encode(signupPayload)}');
    
    final signupResponse = await http.post(
      Uri.parse('https://alert-app-nc1y.onrender.com/api/users/signup/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(signupPayload),
    ).timeout(Duration(seconds: 15));
    
    print('Signup status: ${signupResponse.statusCode}');
    print('Signup response: ${signupResponse.body}');
    
    if (signupResponse.statusCode != 201) {
      print('✗ Signup failed!');
      return;
    }
    print('✓ Signup successful!');
    print('');
    
  } catch (e) {
    print('Signup error: $e');
    return;
  }
  
  // Step 2: Login with newly created account
  print('=== STEP 2: LOGIN ===');
  try {
    final loginPayload = {
      'email': email,
      'password': password,
    };
    
    print('Login payload: ${json.encode(loginPayload)}');
    
    final loginResponse = await http.post(
      Uri.parse('https://alert-app-nc1y.onrender.com/api/users/login/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(loginPayload),
    ).timeout(Duration(seconds: 15));
    
    print('Login status: ${loginResponse.statusCode}');
    print('Login response: ${loginResponse.body}');
    
    if (loginResponse.statusCode == 200) {
      print('✓ Login successful!');
      final data = json.decode(loginResponse.body);
      print('');
      print('=== USER CREDENTIALS ===');
      print('Access token: ${data['token']?['access']?.substring(0, 30)}...');
      print('Refresh token: ${data['token']?['refresh']?.substring(0, 30)}...');
      print('User ID: ${data['user']?['id']}');
      print('User email: ${data['user']?['email']}');
      print('User role: ${data['user']?['role']}');
      print('');
      print('=== USE THESE CREDENTIALS IN THE APP ===');
      print('Email: $email');
      print('Password: $password');
    } else {
      print('✗ Login failed!');
    }
  } catch (e) {
    print('Login error: $e');
  }
}
