import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/api_models.dart';
import '../config/api_config.dart';

class ApiService {

  // Headers par défaut
  static Map<String, String> get _defaultHeaders => ApiConfig.defaultHeaders;

  // Headers avec authentification
  static Map<String, String> _getAuthHeaders(String token) => {
        ..._defaultHeaders,
        'Authorization': 'Bearer $token',
      };

  // Gestion des erreurs HTTP
  static ApiError _handleHttpError(http.Response response) {
    try {
      final errorData = json.decode(response.body);
      return ApiError.fromJson(errorData);
    } catch (e) {
      return ApiError(
        message: 'Erreur de communication avec le serveur',
        statusCode: response.statusCode,
      );
    }
  }

  // Gestion des exceptions réseau
  static ApiError _handleNetworkError(dynamic error) {
    if (error is SocketException) {
      return ApiError(
        message: 'Erreur de connexion réseau. Vérifiez votre connexion internet.',
      );
    } else if (error is HttpException) {
      return ApiError(
        message: 'Erreur HTTP. Veuillez réessayer plus tard.',
      );
    } else {
      return ApiError(
        message: 'Erreur inattendue: ${error.toString()}',
      );
    }
  }

  /// Connexion utilisateur
  static Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final loginRequest = LoginRequest(
        email: email,
        password: password,
      );

      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.loginEndpoint}'),
            headers: _defaultHeaders,
            body: json.encode(loginRequest.toJson()),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return LoginResponse.fromJson(responseData);
      } else {
        throw _handleHttpError(response);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw _handleNetworkError(e);
    }
  }

  /// Inscription utilisateur avec le nouveau format
  static Future<SignupResponse> signup({
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
      final signupRequest = SignupRequest(
        email: email,
        password1: password1,
        password2: password2,
        firstname: firstname,
        lastname: lastname,
        middlename: middlename,
        telephone: telephone,
        role: role,
      );

      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.registerEndpoint}'),
            headers: _defaultHeaders,
            body: json.encode(signupRequest.toJson()),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return SignupResponse.fromJson(responseData);
      } else {
        throw _handleHttpError(response);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw _handleNetworkError(e);
    }
  }

  /// Inscription utilisateur (ancienne méthode pour compatibilité)
  static Future<RegisterResponse> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    try {
      final registerRequest = RegisterRequest(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );

      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.registerEndpoint}'),
            headers: _defaultHeaders,
            body: json.encode(registerRequest.toJson()),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return RegisterResponse.fromJson(responseData);
      } else {
        throw _handleHttpError(response);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw _handleNetworkError(e);
    }
  }

  /// Vérification du token
  static Future<User> verifyToken(String token) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.meEndpoint}'),
            headers: _getAuthHeaders(token),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return User.fromJson(responseData);
      } else {
        throw _handleHttpError(response);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw _handleNetworkError(e);
    }
  }

  /// Rafraîchissement du token
  static Future<LoginResponse> refreshToken(String refreshToken) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.refreshEndpoint}'),
            headers: _defaultHeaders,
            body: json.encode({'refresh_token': refreshToken}),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return LoginResponse.fromJson(responseData);
      } else {
        throw _handleHttpError(response);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw _handleNetworkError(e);
    }
  }

  /// Déconnexion
  static Future<void> logout(String token) async {
    try {
      await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.logoutEndpoint}'),
            headers: _getAuthHeaders(token),
          )
          .timeout(ApiConfig.requestTimeout);
    } catch (e) {
      // Ignorer les erreurs de déconnexion
      // L'utilisateur sera déconnecté localement de toute façon
    }
  }

  /// Récupération du profil utilisateur
  static Future<User> getUserProfile(String token) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.profileEndpoint}'),
            headers: _getAuthHeaders(token),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return User.fromJson(responseData);
      } else {
        throw _handleHttpError(response);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw _handleNetworkError(e);
    }
  }

  /// Mise à jour du profil utilisateur
  static Future<User> updateUserProfile({
    required String token,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    try {
      final updateData = {
        'first_name': firstName,
        'last_name': lastName,
        if (phone != null) 'phone': phone,
      };

      final response = await http
          .put(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.profileEndpoint}'),
            headers: _getAuthHeaders(token),
            body: json.encode(updateData),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return User.fromJson(responseData);
      } else {
        throw _handleHttpError(response);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw _handleNetworkError(e);
    }
  }
}
