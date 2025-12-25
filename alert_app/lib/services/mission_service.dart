import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_models.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class MissionService {
  /// Récupérer toutes les missions
  static Future<List<Mission>> getAllMissions(String token) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.missionsEndpoint}'),
            headers: {
              ...ApiConfig.defaultHeaders,
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List) {
          return responseData.map((missionJson) => Mission.fromJson(missionJson)).toList();
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

  /// Récupérer une mission par son ID
  static Future<Mission> getMissionById(String missionId, String token) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.missionDetailEndpoint.replaceAll('{id}', missionId)}'),
            headers: {
              ...ApiConfig.defaultHeaders,
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return Mission.fromJson(responseData);
      } else {
        throw ApiService.handleHttpError(response);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw ApiService.handleNetworkError(e);
    }
  }

  /// Terminer une mission
  static Future<void> finishMission(String missionId, String token) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.missionsEndpoint}$missionId/finish/'),
            headers: {
              ...ApiConfig.defaultHeaders,
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode != 200) {
        throw ApiService.handleHttpError(response);
      }
    } catch (e) {
      if (e is ApiError) rethrow;
      throw ApiService.handleNetworkError(e);
    }
  }

  /// Récupérer les logs d'une mission
  static Future<List<MissionLog>> getMissionLogs(String missionId, String token) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.missionLogsEndpoint.replaceAll('{id}', missionId)}'),
            headers: {
              ...ApiConfig.defaultHeaders,
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List) {
          return responseData.map((logJson) => MissionLog.fromJson(logJson)).toList();
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
}

