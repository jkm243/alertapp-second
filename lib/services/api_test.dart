import 'dart:convert';
import 'api_service.dart';
import '../models/api_models.dart';

class ApiTestService {
  static Future<void> testSignup() async {
    try {
      print('🧪 Test de l\'inscription...');
      
      final signupRequest = SignupRequest(
        email: "test@example.com",
        password1: "TestPassword123!",
        password2: "TestPassword123!",
        firstname: "Test",
        lastname: "User",
        middlename: "Middle",
        telephone: "+243970000400",
        role: "User",
      );

      print('📤 Données envoyées:');
      print(json.encode(signupRequest.toJson()));

      final response = await ApiService.signup(
        email: signupRequest.email,
        password1: signupRequest.password1,
        password2: signupRequest.password2,
        firstname: signupRequest.firstname,
        lastname: signupRequest.lastname,
        middlename: signupRequest.middlename,
        telephone: signupRequest.telephone,
        role: signupRequest.role,
      );

      print('✅ Inscription réussie!');
      print('📥 Réponse reçue:');
      print('ID: ${response.id}');
      print('Email: ${response.email}');
      print('Nom: ${response.firstname} ${response.lastname}');
      print('Rôle: ${response.role}');
      print('Actif: ${response.isActive}');
      
    } catch (e) {
      print('❌ Erreur lors de l\'inscription: $e');
    }
  }

  static Future<void> testLogin() async {
    try {
      print('🧪 Test de la connexion...');
      
      final loginRequest = LoginRequest(
        email: "test@example.com",
        password: "TestPassword123!",
      );

      print('📤 Données envoyées:');
      print(json.encode(loginRequest.toJson()));

      final response = await ApiService.login(
        email: loginRequest.email,
        password: loginRequest.password,
      );

      print('✅ Connexion réussie!');
      print('📥 Réponse reçue:');
      print('Token d\'accès: ${response.token.access.substring(0, 20)}...');
      print('Token de rafraîchissement: ${response.token.refresh.substring(0, 20)}...');
      print('Utilisateur: ${response.user.firstname} ${response.user.lastname}');
      print('Email: ${response.user.email}');
      print('Rôle: ${response.user.role}');
      
    } catch (e) {
      print('❌ Erreur lors de la connexion: $e');
    }
  }

  static Future<void> runAllTests() async {
    print('🚀 Début des tests API...\n');
    
    await testSignup();
    print('\n${'='*50}\n');
    await testLogin();
    
    print('\n🏁 Tests terminés!');
  }
}