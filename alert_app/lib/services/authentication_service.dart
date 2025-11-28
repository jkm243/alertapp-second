import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import '../models/api_models.dart';

class AuthenticationService extends ChangeNotifier {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _isAuthenticatedKey = 'is_authenticated';

  bool _isAuthenticated = false;
  String? _accessToken;
  User? _currentUser;

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  String? get accessToken => _accessToken;
  User? get currentUser => _currentUser;
  String? get userEmail => _currentUser?.email;
  String? get userName => _currentUser?.fullName;

  // Initialisation du service
  Future<void> initialize() async {
    await _loadAuthState();
  }

  // Chargement de l'état d'authentification depuis le stockage local
  Future<void> _loadAuthState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isAuthenticated = prefs.getBool(_isAuthenticatedKey) ?? false;
      _accessToken = prefs.getString(_tokenKey);

      if (_isAuthenticated && _accessToken != null) {
        final userJson = prefs.getString(_userKey);
        if (userJson != null) {
          final userData = json.decode(userJson);
          _currentUser = User.fromJson(userData);
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors du chargement de l\'état d\'authentification: $e');
    }
  }

  // Sauvegarde de l'état d'authentification
  Future<void> _saveAuthState({
    required String token,
    required User user,
    required bool isAuthenticated,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isAuthenticatedKey, isAuthenticated);
      await prefs.setString(_tokenKey, token);
      await prefs.setString(_userKey, json.encode(user.toJson()));
    } catch (e) {
      debugPrint('Erreur lors de la sauvegarde de l\'état d\'authentification: $e');
    }
  }

  // Suppression de l'état d'authentification
  Future<void> _clearAuthState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_isAuthenticatedKey);
      await prefs.remove(_tokenKey);
      await prefs.remove(_userKey);
    } catch (e) {
      debugPrint('Erreur lors de la suppression de l\'état d\'authentification: $e');
    }
  }

  // Connexion utilisateur
  Future<AuthResult> login(String email, String password) async {
    try {
      if (!isValidEmail(email)) {
        return AuthResult.error('Adresse email invalide');
      }

      if (!isValidPassword(password)) {
        return AuthResult.error('Le mot de passe doit contenir au moins 6 caractères');
      }

      final loginResponse = await ApiService.login(
        email: email,
        password: password,
      );

      _accessToken = loginResponse.token.access;
      _currentUser = loginResponse.user;
      _isAuthenticated = true;

      await _saveAuthState(
        token: _accessToken!,
        user: _currentUser!,
        isAuthenticated: true,
      );

      notifyListeners();
      return AuthResult.success('Connexion réussie');
    } on ApiError catch (e) {
      return AuthResult.error(e.message);
    } catch (e) {
      debugPrint('Erreur lors de la connexion: $e');
      return AuthResult.error('Erreur de connexion. Veuillez réessayer.');
    }
  }

  // Inscription utilisateur avec le nouveau format
  Future<AuthResult> signup({
    required String email,
    required String password1,
    required String password2,
    required String firstname,
    required String lastname,
    String? middlename,
    String? telephone,
    String role = 'User',
  }) async {
    try {
      if (!isValidEmail(email)) {
        return AuthResult.error('Adresse email invalide');
      }

      if (!isValidPassword(password1)) {
        return AuthResult.error('Le mot de passe doit contenir au moins 6 caractères');
      }

      if (password1 != password2) {
        return AuthResult.error('Les mots de passe ne correspondent pas');
      }

      if (firstname.trim().isEmpty || lastname.trim().isEmpty) {
        return AuthResult.error('Le prénom et le nom sont obligatoires');
      }

      if (!isValidName(firstname)) {
        return AuthResult.error('Le prénom contient des caractères non autorisés ou est trop long');
      }

      if (!isValidName(lastname)) {
        return AuthResult.error('Le nom contient des caractères non autorisés ou est trop long');
      }

      if (middlename != null && middlename.trim().isNotEmpty && !isValidName(middlename)) {
        return AuthResult.error('Le nom du milieu contient des caractères non autorisés ou est trop long');
      }

      await ApiService.signup(
        email: email,
        password1: password1,
        password2: password2,
        firstname: firstname,
        lastname: lastname,
        middlename: middlename,
        telephone: telephone,
        role: role,
      );

      return AuthResult.success('Inscription réussie. Vous pouvez maintenant vous connecter.');
    } on ApiError catch (e) {
      return AuthResult.error(e.message);
    } catch (e) {
      debugPrint('Erreur lors de l\'inscription: $e');
      return AuthResult.error('Erreur d\'inscription. Veuillez réessayer.');
    }
  }

  // Inscription utilisateur (ancienne méthode pour compatibilité)
  Future<AuthResult> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    try {
      if (!isValidEmail(email)) {
        return AuthResult.error('Adresse email invalide');
      }

      if (!isValidPassword(password)) {
        return AuthResult.error('Le mot de passe doit contenir au moins 6 caractères');
      }

      if (firstName.trim().isEmpty || lastName.trim().isEmpty) {
        return AuthResult.error('Le prénom et le nom sont obligatoires');
      }

      if (!isValidName(firstName)) {
        return AuthResult.error('Le prénom contient des caractères non autorisés ou est trop long');
      }

      if (!isValidName(lastName)) {
        return AuthResult.error('Le nom contient des caractères non autorisés ou est trop long');
      }

      await ApiService.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );

      return AuthResult.success('Inscription réussie. Vous pouvez maintenant vous connecter.');
    } on ApiError catch (e) {
      return AuthResult.error(e.message);
    } catch (e) {
      debugPrint('Erreur lors de l\'inscription: $e');
      return AuthResult.error('Erreur d\'inscription. Veuillez réessayer.');
    }
  }

  // Déconnexion
  Future<void> logout() async {
    try {
      if (_accessToken != null) {
        await ApiService.logout(_accessToken!);
      }
    } catch (e) {
      debugPrint('Erreur lors de la déconnexion du serveur: $e');
    } finally {
      _isAuthenticated = false;
      _accessToken = null;
      _currentUser = null;

      await _clearAuthState();
      notifyListeners();
    }
  }

  // Vérification du token
  Future<bool> verifyToken() async {
    if (_accessToken == null) return false;

    try {
      final user = await ApiService.verifyToken(_accessToken!);
      _currentUser = user;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Token invalide: $e');
      await logout();
      return false;
    }
  }

  // Mise à jour du profil
  Future<AuthResult> updateProfile({
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    try {
      if (_accessToken == null) {
        return AuthResult.error('Non authentifié');
      }

      if (firstName.trim().isEmpty || lastName.trim().isEmpty) {
        return AuthResult.error('Le prénom et le nom sont obligatoires');
      }

      final updatedUser = await ApiService.updateUserProfile(
        token: _accessToken!,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );

      _currentUser = updatedUser;
      await _saveAuthState(
        token: _accessToken!,
        user: _currentUser!,
        isAuthenticated: true,
      );

      notifyListeners();
      return AuthResult.success('Profil mis à jour avec succès');
    } on ApiError catch (e) {
      return AuthResult.error(e.message);
    } catch (e) {
      debugPrint('Erreur lors de la mise à jour du profil: $e');
      return AuthResult.error('Erreur lors de la mise à jour du profil');
    }
  }

  // Validation des données
  bool isValidEmail(String email) {
    if (email.isEmpty || email.length < 5 || email.length > 254) {
      return false;
    }
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim());
  }

  bool isValidPassword(String password) {
    if (password.length < 6 || password.length > 128) {
      return false;
    }
    // Vérification de caractères dangereux
    if (password.contains('<') || password.contains('>') || password.contains('"') || password.contains("'")) {
      return false;
    }
    return true;
  }

  bool isValidName(String name) {
    if (name.trim().length < 2 || name.trim().length > 100) {
      return false;
    }
    // Vérification de caractères dangereux
    if (name.contains('<') || name.contains('>') || name.contains('"') || name.contains("'")) {
      return false;
    }
    return true;
  }

  // Informations utilisateur
  Map<String, String?> getUserInfo() {
    return {
      'name': _currentUser?.fullName,
      'email': _currentUser?.email,
      'phone': _currentUser?.telephone,
    };
  }
}

// Classe pour gérer les résultats d'authentification
class AuthResult {
  final bool isSuccess;
  final String message;

  const AuthResult._(this.isSuccess, this.message);

  factory AuthResult.success(String message) => AuthResult._(true, message);
  factory AuthResult.error(String message) => AuthResult._(false, message);
}
