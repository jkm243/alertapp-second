import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/api_models.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class AlertService {
  /// Créer une nouvelle alerte avec upload de médias
  static Future<Alert> createAlert({
    required String typeId,
    required String description,
    required double? latitude,
    required double? longitude,
    required String token,
    List<File>? mediaFiles,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.createAlertEndpoint}');
      
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      // Ajouter les champs
      request.fields['type'] = typeId;
      request.fields['description'] = description;
      if (latitude != null) request.fields['latitude'] = latitude.toString();
      if (longitude != null) request.fields['longitude'] = longitude.toString();

      // Ajouter les fichiers médias
      if (mediaFiles != null && mediaFiles.isNotEmpty) {
        for (var file in mediaFiles) {
          if (await file.exists()) {
            final fileExtension = file.path.split('.').last.toLowerCase();
            String contentType = 'image/jpeg';
            if (fileExtension == 'png') {
              contentType = 'image/png';
            } else if (['mp4', 'mov', 'avi'].contains(fileExtension)) {
              contentType = 'video/$fileExtension';
            }
            
            request.files.add(
              await http.MultipartFile.fromPath(
                'medias',
                file.path,
                filename: file.path.split('/').last,
                contentType: MediaType.parse(contentType),
              ),
            );
          }
        }
      }

      final streamedResponse = await request.send().timeout(ApiConfig.requestTimeout);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return Alert.fromJson(responseData);
      } else {
        throw ApiService.handleHttpError(response);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw ApiService.handleNetworkError(e);
    }
  }

  /// Récupérer toutes les alertes
  static Future<List<Alert>> getAllAlerts(String token) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.alertsAllEndpoint}'),
            headers: {
              ...ApiConfig.defaultHeaders,
              'Authorization': 'Bearer $token',
            },
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
        throw ApiService.handleHttpError(response);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw ApiService.handleNetworkError(e);
    }
  }

  /// Récupérer les alertes de l'utilisateur connecté
  static Future<List<Alert>> getMyAlerts(String token) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.alertsMyAlertsEndpoint}'),
            headers: {
              ...ApiConfig.defaultHeaders,
              'Authorization': 'Bearer $token',
            },
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
        throw ApiService.handleHttpError(response);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw ApiService.handleNetworkError(e);
    }
  }

  /// Récupérer une alerte par son ID
  static Future<Alert> getAlertById(String alertId, String token) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.alertsEndpoint}$alertId/'),
            headers: {
              ...ApiConfig.defaultHeaders,
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return Alert.fromJson(responseData);
      } else {
        throw ApiService.handleHttpError(response);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw ApiService.handleNetworkError(e);
    }
  }

  /// Valider une alerte (Supervisor uniquement)
  static Future<Map<String, dynamic>> validateAlert(String alertId, String token) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.alertValidateEndpoint.replaceAll('{id}', alertId)}'),
            headers: {
              ...ApiConfig.defaultHeaders,
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw ApiService.handleHttpError(response);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw ApiService.handleNetworkError(e);
    }
  }

  /// Modifier une alerte
  static Future<Alert> updateAlert({
    required String alertId,
    required String token,
    String? description,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (description != null) updateData['description'] = description;
      if (latitude != null) updateData['latitude'] = latitude;
      if (longitude != null) updateData['longitude'] = longitude;

      final response = await http
          .put(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.alertUpdateEndpoint.replaceAll('{id}', alertId)}'),
            headers: {
              ...ApiConfig.defaultHeaders,
              'Authorization': 'Bearer $token',
            },
            body: json.encode(updateData),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return Alert.fromJson(responseData);
      } else {
        throw ApiService.handleHttpError(response);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw ApiService.handleNetworkError(e);
    }
  }

  /// Supprimer une alerte
  static Future<void> deleteAlert(String alertId, String token) async {
    try {
      final response = await http
          .delete(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.alertDeleteEndpoint.replaceAll('{id}', alertId)}'),
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

