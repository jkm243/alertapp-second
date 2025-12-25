import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_models.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class TypeAlertService {
  /// Récupérer tous les types d'alertes
  static Future<List<TypeAlert>> getAllTypes(String token) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.alertTypesEndpoint}'),
            headers: {
              ...ApiConfig.defaultHeaders,
              'Authorization': 'Bearer $token',
            },
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
        throw ApiService.handleHttpError(response);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw ApiService.handleNetworkError(e);
    }
  }

  /// Récupérer un type d'alerte par son ID
  static Future<TypeAlert> getTypeById(String typeId, String token) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.alertTypeDetailEndpoint.replaceAll('{id}', typeId)}'),
            headers: {
              ...ApiConfig.defaultHeaders,
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return TypeAlert.fromJson(responseData);
      } else {
        throw ApiService.handleHttpError(response);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw ApiService.handleNetworkError(e);
    }
  }

  /// Créer un nouveau type d'alerte
  static Future<TypeAlert> createType({
    required String name,
    required String? description,
    required String? slug,
    required String token,
  }) async {
    try {
      final requestData = {
        'name': name,
        if (description != null) 'description': description,
        if (slug != null) 'slug': slug,
      };

      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.alertTypeCreateEndpoint}'),
            headers: {
              ...ApiConfig.defaultHeaders,
              'Authorization': 'Bearer $token',
            },
            body: json.encode(requestData),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return TypeAlert.fromJson(responseData);
      } else {
        throw ApiService.handleHttpError(response);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw ApiService.handleNetworkError(e);
    }
  }

  /// Modifier un type d'alerte
  static Future<TypeAlert> updateType({
    required String typeId,
    required String token,
    String? name,
    String? description,
    String? slug,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (name != null) updateData['name'] = name;
      if (description != null) updateData['description'] = description;
      if (slug != null) updateData['slug'] = slug;

      final response = await http
          .put(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.alertTypeUpdateEndpoint.replaceAll('{id}', typeId)}'),
            headers: {
              ...ApiConfig.defaultHeaders,
              'Authorization': 'Bearer $token',
            },
            body: json.encode(updateData),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return TypeAlert.fromJson(responseData);
      } else {
        throw ApiService.handleHttpError(response);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw ApiService.handleNetworkError(e);
    }
  }

  /// Supprimer un type d'alerte
  static Future<void> deleteType(String typeId, String token) async {
    try {
      final response = await http
          .delete(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.alertTypeDeleteEndpoint.replaceAll('{id}', typeId)}'),
            headers: {
              ...ApiConfig.defaultHeaders,
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode != 204) {
        throw ApiService.handleHttpError(response);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw ApiService.handleNetworkError(e);
    }
  }
}

