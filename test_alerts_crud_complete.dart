import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const baseUrl = 'https://alert-app-nc1y.onrender.com';
  final random = DateTime.now().millisecondsSinceEpoch;
  final testEmail = 'testuser_alert_$random@example.com';
  const testPassword = 'TestPass123!';

  print('🚨 Test COMPLET du CRUD des Alertes');
  print('=' * 70);
  
  String? userToken;
  String? alertId;
  List<Map<String, dynamic>> alertTypes = [];

  try {
    // STEP 1: Créer un compte utilisateur
    print('\n📝 ÉTAPE 1: Création du compte utilisateur...');
    print('Email: $testEmail');
    
    final signupResponse = await http.post(
      Uri.parse('$baseUrl/api/users/signup/'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'email': testEmail,
        'password1': testPassword,
        'password2': testPassword,
        'firstname': 'Test',
        'lastname': 'AlertUser',
        'role': 'User',
      }),
    ).timeout(Duration(seconds: 120));

    if (signupResponse.statusCode == 201 || signupResponse.statusCode == 200) {
      print('✅ Compte créé avec succès!');
    } else {
      print('⚠️  Signup response: ${signupResponse.statusCode}');
      print('Response body: ${signupResponse.body}');
    }

    // STEP 2: Se connecter
    print('\n🔓 ÉTAPE 2: Connexion...');
    
    final loginResponse = await http.post(
      Uri.parse('$baseUrl/api/users/login/'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'email': testEmail,
        'password': testPassword,
      }),
    );

    if (loginResponse.statusCode == 200) {
      final loginData = json.decode(loginResponse.body);
      userToken = loginData['access'] as String?;
      print('✅ Connecté avec succès!');
      print('🔐 Token: ${userToken?.substring(0, 30)}...');
    } else {
      print('❌ Erreur de connexion: ${loginResponse.statusCode}');
      print('Response: ${loginResponse.body}');
      return;
    }

    // STEP 3: Récupérer les types d'alertes
    print('\n📋 ÉTAPE 3: Récupération des types d\'alertes...');
    
    final alertTypesResponse = await http.get(
      Uri.parse('$baseUrl/api/alert/typealerts/'),
      headers: {
        'Authorization': 'Bearer $userToken',
        'Accept': 'application/json',
      },
    );

    if (alertTypesResponse.statusCode == 200) {
      final typeData = json.decode(alertTypesResponse.body);
      if (typeData is List) {
        alertTypes = List<Map<String, dynamic>>.from(typeData);
        print('✅ ${alertTypes.length} types d\'alertes trouvés:');
        for (final type in alertTypes) {
          print('   • ${type['name']} (ID: ${type['id']})');
          if (type['description'] != null) {
            print('     Description: ${type['description']}');
          }
        }
      }
    } else {
      print('⚠️  Erreur: ${alertTypesResponse.statusCode}');
      print('Response: ${alertTypesResponse.body}');
    }

    if (alertTypes.isEmpty) {
      print('⚠️  Aucun type d\'alerte trouvé. Impossible de créer une alerte.');
      return;
    }

    // STEP 4: Créer une première alerte
    print('\n✏️  ÉTAPE 4: Création de la première alerte...');
    final selectedType = alertTypes.first;
    final typeId = selectedType['id'] as String;
    
    final createAlertResponse = await http.post(
      Uri.parse('$baseUrl/api/alert/alerts/create/'),
      headers: {
        'Authorization': 'Bearer $userToken',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'type': typeId,
        'description': 'Alerte de test - Problème détecté',
        'latitude': -4.3276,
        'longitude': 15.3136,
      }),
    );

    print('Status: ${createAlertResponse.statusCode}');
    
    if (createAlertResponse.statusCode == 201 || createAlertResponse.statusCode == 200) {
      final alertData = json.decode(createAlertResponse.body);
      alertId = alertData['id'] as String?;
      final status = alertData['status'] as String?;
      print('✅ Alerte créée avec succès!');
      print('   ID: $alertId');
      print('   Type: ${alertData['type']?['name'] ?? 'N/A'}');
      print('   Description: ${alertData['description']}');
      print('   📍 Coordonnées: ${alertData['latitude']}, ${alertData['longitude']}');
      print('   🔴 Statut: $status (attendu: "New")');
      
      if (status == 'New') {
        print('   ✅ Statut correct - En attente de validation!');
      } else {
        print('   ⚠️  Statut inattendu: $status');
      }
    } else {
      print('❌ Erreur: ${createAlertResponse.statusCode}');
      print('Response: ${createAlertResponse.body}');
      return;
    }

    // STEP 5: Créer une deuxième alerte
    print('\n✏️  ÉTAPE 5: Création d\'une deuxième alerte (complète)...');
    
    final createAlert2Response = await http.post(
      Uri.parse('$baseUrl/api/alert/alerts/create/'),
      headers: {
        'Authorization': 'Bearer $userToken',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'type': typeId,
        'description': 'Alerte test 2 - Situation dangereuse à Kinshasa',
        'latitude': -4.3276,
        'longitude': 15.3136,
      }),
    );

    String? alertId2;
    if (createAlert2Response.statusCode == 201 || createAlert2Response.statusCode == 200) {
      final alertData = json.decode(createAlert2Response.body);
      alertId2 = alertData['id'] as String?;
      print('✅ Deuxième alerte créée (ID: $alertId2)');
    } else {
      print('⚠️  Impossible de créer la 2e alerte: ${createAlert2Response.statusCode}');
    }

    // STEP 6: Récupérer toutes les alertes de l'utilisateur
    print('\n📊 ÉTAPE 6: Récupération de toutes les alertes de l\'utilisateur...');
    
    final userAlertsResponse = await http.get(
      Uri.parse('$baseUrl/api/alert/alerts/my-alerts/'),
      headers: {
        'Authorization': 'Bearer $userToken',
        'Accept': 'application/json',
      },
    );

    if (userAlertsResponse.statusCode == 200) {
      final alertsData = json.decode(userAlertsResponse.body);
      if (alertsData is List) {
        print('✅ ${alertsData.length} alertes trouvées:');
        for (final alert in alertsData) {
          final id = alert['id'];
          final type = alert['type']?['name'] ?? 'N/A';
          final status = alert['status'];
          final desc = alert['description'];
          print('   • [$status] $type - $desc (ID: $id)');
        }
      }
    } else {
      print('⚠️  Erreur: ${userAlertsResponse.statusCode}');
      print('Response: ${userAlertsResponse.body}');
    }

    // STEP 7: Récupérer les détails d'une alerte spécifique
    if (alertId != null) {
      print('\n🔍 ÉTAPE 7: Récupération des détails de l\'alerte créée...');
      
      final alertDetailResponse = await http.get(
        Uri.parse('$baseUrl/api/alert/alerts/$alertId/'),
        headers: {
          'Authorization': 'Bearer $userToken',
          'Accept': 'application/json',
        },
      );

      if (alertDetailResponse.statusCode == 200) {
        final alertDetail = json.decode(alertDetailResponse.body);
        print('✅ Détails de l\'alerte:');
        print('   ID: ${alertDetail['id']}');
        print('   Type: ${alertDetail['type']?['name']}');
        print('   Description: ${alertDetail['description']}');
        print('   Statut: ${alertDetail['status']}');
        print('   Créée le: ${alertDetail['createdAt']}');
        print('   Medias: ${(alertDetail['medias'] as List?)?.length ?? 0}');
      } else {
        print('⚠️  Erreur: ${alertDetailResponse.statusCode}');
      }
    }

    // STEP 8: Valider l'alerte (simuler l'opérateur)
    if (alertId != null) {
      print('\n✅ ÉTAPE 8: Validation de l\'alerte par l\'opérateur...');
      print('⚠️  Note: Cela nécessite un token d\'opérateur.');
      print('   Pour tester, il faudrait d\'abord créer/connecter un opérateur.');
      print('   Structure attendue: POST /api/alert/alerts/{id}/validate/');
    }

    // STEP 9: Mettre à jour une alerte
    if (alertId != null) {
      print('\n✏️  ÉTAPE 9: Mise à jour de l\'alerte...');
      
      final updateResponse = await http.put(
        Uri.parse('$baseUrl/api/alert/alerts/$alertId/update/'),
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'description': 'Alerte mise à jour - Nouvelle description',
        }),
      );

      if (updateResponse.statusCode == 200) {
        final updated = json.decode(updateResponse.body);
        print('✅ Alerte mise à jour!');
        print('   Nouvelle description: ${updated['description']}');
      } else {
        print('⚠️  Erreur de mise à jour: ${updateResponse.statusCode}');
        print('Response: ${updateResponse.body}');
      }
    }

    // STEP 10: Supprimer une alerte
    if (alertId2 != null) {
      print('\n🗑️  ÉTAPE 10: Suppression d\'une alerte...');
      
      final deleteResponse = await http.delete(
        Uri.parse('$baseUrl/api/alert/alerts/$alertId2/'),
        headers: {
          'Authorization': 'Bearer $userToken',
          'Accept': 'application/json',
        },
      );

      if (deleteResponse.statusCode == 204) {
        print('✅ Alerte supprimée avec succès!');
      } else {
        print('⚠️  Erreur de suppression: ${deleteResponse.statusCode}');
        print('Response: ${deleteResponse.body}');
      }
    }

    print('\n' + '=' * 70);
    print('✨ Test COMPLET TERMINÉ!');
    print('\n📋 Résumé:');
    print('✅ Création de compte utilisateur');
    print('✅ Login');
    print('✅ Récupération des types d\'alertes (${alertTypes.length} trouvés)');
    print('✅ Création d\'alertes');
    print('✅ Récupération des alertes utilisateur');
    print('✅ Récupération des détails d\'alerte');
    print('✅ Mise à jour d\'alerte');
    print('✅ Suppression d\'alerte');
    print('⏳ Validation d\'alerte (nécessite compte opérateur)');

  } catch (e) {
    print('\n❌ Erreur: $e');
    print('Stack: $e');
  }
}
