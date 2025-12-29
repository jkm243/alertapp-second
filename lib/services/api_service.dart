import 'dart:convert';
import 'dart:io';
import 'dart:async';
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
      
      // Essayer de parser comme ApiError standard
      if (errorData is Map<String, dynamic>) {
        // Vérifier si c'est un format d'erreur Django REST Framework
        if (errorData.containsKey('message')) {
          return ApiError(
            message: errorData['message'] as String,
            detail: errorData['detail'] as String?,
            statusCode: response.statusCode,
          );
        }
        
        // Vérifier si c'est un format d'erreur avec 'error' ou 'errors'
        if (errorData.containsKey('error')) {
          final error = errorData['error'];
          if (error is String) {
            return ApiError(
              message: error,
              statusCode: response.statusCode,
            );
          }
        }
        
        if (errorData.containsKey('errors')) {
          final errors = errorData['errors'];
          if (errors is Map) {
            // Extraire le premier message d'erreur
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              return ApiError(
                message: firstError.first.toString(),
                statusCode: response.statusCode,
              );
            }
          }
        }
        
        // Vérifier les erreurs de validation Django (format avec champs)
        final errorMessages = <String>[];
        errorData.forEach((key, value) {
          if (value is List && value.isNotEmpty) {
            errorMessages.add('$key: ${value.first}');
          } else if (value is String) {
            errorMessages.add('$key: $value');
          }
        });
        
        if (errorMessages.isNotEmpty) {
          return ApiError(
            message: errorMessages.join(', '),
            statusCode: response.statusCode,
          );
        }
        
        // Essayer ApiError.fromJson en dernier recours
        return ApiError.fromJson(errorData);
      }
      
      return ApiError(
        message: 'Erreur de communication avec le serveur',
        statusCode: response.statusCode,
      );
    } catch (e) {
      // Si le body n'est pas du JSON valide, retourner un message générique
      String message = 'Erreur de communication avec le serveur';
      if (response.statusCode == 400) {
        message = 'Requête invalide. Vérifiez vos données.';
      } else if (response.statusCode == 401) {
        message = 'Identifiants incorrects';
      } else if (response.statusCode == 403) {
        message = 'Accès refusé';
      } else if (response.statusCode == 404) {
        message = 'Ressource non trouvée';
      } else if (response.statusCode == 409) {
        message = 'Cet utilisateur existe déjà';
      } else if (response.statusCode >= 500) {
        message = 'Erreur serveur. Veuillez réessayer plus tard.';
      }
      
      return ApiError(
        message: message,
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
    } else if (error is TimeoutException) {
      return ApiError(
        message: ApiConfig.timeoutErrorMessage,
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

  /// Raw signup returning decoded JSON (useful to extract server messages)
  static Future<dynamic> signupRaw({
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
          );

      final responseData = json.decode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return responseData;
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

  /// Récupération de tous les utilisateurs (Admin uniquement)
  static Future<List<User>> getAllUsers(String token) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.usersAllEndpoint}'),
            headers: _getAuthHeaders(token),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List) {
          return responseData.map((userJson) => User.fromJson(userJson)).toList();
        } else {
          throw ApiError(message: 'Format de réponse invalide');
        }
      } else {
        throw _handleHttpError(response);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw _handleNetworkError(e);
    }
  }

  /// Récupération des utilisateurs avec pagination (Admin uniquement)
  static Future<UserPagination> getUsersPaginated({
    required String token,
    int? page,
    int? pageSize,
    String? search,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (page != null) queryParams['page'] = page.toString();
      if (pageSize != null) queryParams['page_size'] = pageSize.toString();
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.usersPaginationEndpoint}')
          .replace(queryParameters: queryParams.isEmpty ? null : queryParams);

      final response = await http
          .get(
            uri,
            headers: _getAuthHeaders(token),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return UserPagination.fromJson(responseData);
      } else {
        throw _handleHttpError(response);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw _handleNetworkError(e);
    }
  }

  /// Récupération des types d'alerte disponibles
  static Future<List<TypeAlert>> getAlertTypes(String token) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.alertTypeListEndpoint}'),
            headers: _getAuthHeaders(token),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List) {
          return responseData.map((typeJson) => TypeAlert.fromJson(typeJson)).toList();
        } else {
          throw ApiError(message: 'Format de réponse invalide');
        }
      } else {
        throw _handleHttpError(response);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw _handleNetworkError(e);
    }
  }

  /// Récupération de toutes les alertes de l'utilisateur
  static Future<List<Alert>> getUserAlerts(String token) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.alertsMyAlertsEndpoint}'),
            headers: _getAuthHeaders(token),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List) {
          return responseData.map((alertJson) => Alert.fromJson(alertJson)).toList();
        } else {
          throw ApiError(message: 'Format de réponse invalide');
        }
      } else {
        throw _handleHttpError(response);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw _handleNetworkError(e);
    }
  }

  /// Créer une nouvelle alerte
  static Future<Alert> createAlert({
    required String token,
    required String type,
    required String description,
    double? latitude,
    double? longitude,
    List<String>? mediaPaths,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.alertCreateEndpoint}');
      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll(_getAuthHeaders(token));
      request.fields['type'] = type;
      request.fields['description'] = description;
      if (latitude != null) request.fields['latitude'] = latitude.toString();
      if (longitude != null) request.fields['longitude'] = longitude.toString();

      // Ajouter les fichiers média
      if (mediaPaths != null && mediaPaths.isNotEmpty) {
        for (final path in mediaPaths) {
          final file = File(path);
          if (await file.exists()) {
            request.files.add(
              await http.MultipartFile.fromPath('medias', path),
            );
          }
        }
      }

      final response = await request.send().timeout(ApiConfig.requestTimeout);
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        final responseData = json.decode(responseBody);
        return Alert.fromJson(responseData);
      } else {
        throw _handleHttpError(http.Response(responseBody, response.statusCode));
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw _handleNetworkError(e);
    }
  }

  /// Mettre à jour une alerte
  static Future<Alert> updateAlert({
    required String token,
    required String alertId,
    String? type,
    String? description,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (type != null) updateData['type'] = type;
      if (description != null) updateData['description'] = description;
      if (latitude != null) updateData['latitude'] = latitude;
      if (longitude != null) updateData['longitude'] = longitude;

      final response = await http
          .put(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.alertUpdateEndpoint.replaceFirst('{id}', alertId)}'),
            headers: _getAuthHeaders(token),
            body: json.encode(updateData),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return Alert.fromJson(responseData);
      } else {
        throw _handleHttpError(response);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw _handleNetworkError(e);
    }
  }

  /// Supprimer une alerte
  static Future<void> deleteAlert({
    required String token,
    required String alertId,
  }) async {
    try {
      final response = await http
          .delete(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.alertDeleteEndpoint.replaceFirst('{id}', alertId)}'),
            headers: _getAuthHeaders(token),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode != 204) {
        throw _handleHttpError(response);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw _handleNetworkError(e);
    }
  }

  /// Récupérer une alerte spécifique
  static Future<Alert> getAlert({
    required String token,
    required String alertId,
  }) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.alertDetailEndpoint.replaceFirst('{id}', alertId)}'),
            headers: _getAuthHeaders(token),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return Alert.fromJson(responseData);
      } else {
        throw _handleHttpError(response);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw _handleNetworkError(e);
    }
  }

  /// Récupérer les informations de l'utilisateur connecté
  static Future<User> getCurrentUser(String token) async {
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

  /// Modifier le profil utilisateur
  static Future<User> editUserProfile({
    required String token,
    String? email,
    String? firstname,
    String? lastname,
    String? middlename,
    String? telephone,
  }) async {
    try {
      final requestBody = <String, dynamic>{};
      if (email != null) requestBody['email'] = email;
      if (firstname != null) requestBody['firstname'] = firstname;
      if (lastname != null) requestBody['lastname'] = lastname;
      if (middlename != null) requestBody['middlename'] = middlename;
      if (telephone != null) requestBody['telephone'] = telephone;

      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.profileEndpoint}'),
            headers: _getAuthHeaders(token),
            body: json.encode(requestBody),
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

  /// Changer le mot de passe utilisateur
  static Future<void> changePassword({
    required String token,
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/api/users/change-password/'),
            headers: _getAuthHeaders(token),
            body: json.encode({
              'old_password': oldPassword,
              'new_password': newPassword,
              'confirm_password': confirmPassword,
            }),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode != 200) {
        throw _handleHttpError(response);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw _handleNetworkError(e);
    }
  }
}
