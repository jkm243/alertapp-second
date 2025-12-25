import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/api_models.dart';
import 'api_service.dart';

class NotificationService {
  /// Récupérer toutes les notifications
  static Future<List<Map<String, dynamic>>> getNotifications(String token) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.notificationsEndpoint}'),
            headers: {
              ...ApiConfig.defaultHeaders,
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List) {
          return List<Map<String, dynamic>>.from(responseData);
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

  /// Récupérer le nombre de notifications non lues
  static Future<int> getUnreadCount(String token) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.notificationCountEndpoint}'),
            headers: {
              ...ApiConfig.defaultHeaders,
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        // Le format peut varier selon l'API
        if (responseData is Map && responseData.containsKey('unread_count')) {
          return responseData['unread_count'] as int;
        } else if (responseData is int) {
          return responseData;
        } else {
          return 0;
        }
      } else {
        throw ApiService.handleHttpError(response);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw ApiService.handleNetworkError(e);
    }
  }
}

