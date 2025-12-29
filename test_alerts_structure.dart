import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const baseUrl = 'https://alert-app-nc1y.onrender.com';
  // Créons un compte test avec un email unique
  final random = DateTime.now().millisecondsSinceEpoch;
  final testEmail = 'alert_test_$random@test.local';
  const testPassword = 'TestPass123!';

  print('🚨 Test des Alertes (SANS attendre l\'email)');
  print('=' * 70);
  
  String? userToken;
  String? operatorToken;
  String? alertId;
  List<Map<String, dynamic>> alertTypes = [];

  try {
    // Essayons juste de tester avec le login d'abord pour voir si des comptes existent
    // Testing endpoint existence
    print('\n✅ ÉTAPE 1: Vérification que les endpoints existent...');
    
    final healthCheck = await http.get(
      Uri.parse('$baseUrl/api/alert/typealerts/'),
    );
    
    if (healthCheck.statusCode == 401) {
      print('✅ Endpoint /api/alert/typealerts/ accessible (nécessite auth)');
    } else if (healthCheck.statusCode == 200) {
      print('✅ Endpoint /api/alert/typealerts/ accessible publiquement');
      final typeData = json.decode(healthCheck.body);
      if (typeData is List) {
        alertTypes = List<Map<String, dynamic>>.from(typeData);
        print('   ✅ ${alertTypes.length} types d\'alertes trouvés:');
        for (final type in alertTypes) {
          print('     • ${type['name']} (ID: ${type['id']})');
        }
      }
    } else {
      print('⚠️  Status: ${healthCheck.statusCode}');
    }

    // Test les endpoints des alertes
    print('\n✅ ÉTAPE 2: Test des endpoints SANS authentification...');
    
    final endpoints = [
      '/api/alert/typealerts/',
      '/api/alert/alerts/create/',
      '/api/alert/alerts/my-alerts/',
    ];

    for (final endpoint in endpoints) {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
      );
      
      // 401 = endpoint existe mais besoin auth
      // 404 = endpoint n\'existe pas
      // 200 = endpoint accessible
      if (response.statusCode == 401) {
        print('✅ $endpoint - Existe (auth requise)');
      } else if (response.statusCode == 200) {
        print('✅ $endpoint - Accessible sans auth');
      } else if (response.statusCode == 404) {
        print('❌ $endpoint - NOT FOUND');
      } else {
        print('⚠️  $endpoint - Status: ${response.statusCode}');
      }
    }

    // Simulations de test avec données mock
    print('\n' + '=' * 70);
    print('📋 STRUCTURE DES ALERTES ATTENDUE:');
    print('=' * 70);

    print('\n📝 Modèle Alert:');
    print('''
    {
      "id": "uuid",
      "type": {
        "id": "uuid",
        "name": "Incendie",
        "description": "Alerte incendie",
        "slug": "incendie"
      },
      "user": {
        "id": "uuid",
        "email": "user@example.com",
        "firstname": "John",
        "lastname": "Doe"
      },
      "description": "Feu détecté à Kinshasa",
      "latitude": -4.3276,
      "longitude": 15.3136,
      "status": "New",  // Statuts: New, Validated, Rejected, In Progress, Resolved, Closed
      "createdAt": "2025-12-30T...",
      "medias": []
    }
    ''');

    print('\n🔄 WORKFLOWS ATTENDUS:');
    print('''
    1️⃣  USER WORKFLOW:
       • Crée une alerte avec status = "New"
       • Voir la liste de ses alertes
       • Voir le statut "New" (en attente de validation)
       • Peut éditer/supprimer l'alerte si status = "New"
       • Voit la mise à jour du statut quand l'opérateur valide
    
    2️⃣  OPERATOR WORKFLOW:
       • Récupère les alertes avec status = "New"
       • Valide l'alerte via POST /api/alert/alerts/{id}/validate/
       • Le statut passe à "Validated"
       • Peut assigner une mission drone
       • Peut attacher une vidéo
    
    3️⃣  STATUT PROGRESSION:
       New → Validated → In Progress → Resolved → Closed
    ''');

    print('\n' + '=' * 70);
    print('📊 ENDPOINTS DU CRUD:');
    print('=' * 70);

    print('\n🔴 USER ENDPOINTS:');
    print('  • GET    /api/alert/typealerts/          - Récupérer types d\'alertes');
    print('  • POST   /api/alert/alerts/create/       - Créer une alerte');
    print('  • GET    /api/alert/alerts/my-alerts/    - Lister ses alertes');
    print('  • GET    /api/alert/alerts/{id}/         - Détails d\'une alerte');
    print('  • PUT    /api/alert/alerts/{id}/update/  - Mettre à jour');
    print('  • DELETE /api/alert/alerts/{id}/         - Supprimer');

    print('\n🟠 OPERATOR ENDPOINTS:');
    print('  • GET    /api/alert/alerts/all/          - Toutes les alertes');
    print('  • POST   /api/alert/alerts/{id}/validate/- Valider une alerte');
    print('  • POST   /api/missions/                   - Créer une mission drone');
    print('  • POST   /api/alert/alerts/{id}/attach-video/ - Attacher vidéo');

    print('\n' + '=' * 70);
    print('✅ POINTS DE VÉRIFICATION RECOMMANDÉS:');
    print('=' * 70);
    print('''
    Dans l'APP:
    ✓ Les types d'alertes s'affichent dans le formulaire
    ✓ L'utilisateur peut remplir tous les champs
    ✓ Après création, l'alerte a status = "New"
    ✓ L'alerte apparaît dans la liste des alertes
    ✓ L'opérateur voit l'alerte dans son interface
    ✓ Après validation par l'opérateur, le statut change
    ✓ L'utilisateur voit le statut "Validated" mis à jour
    
    PROBLÈMES À VÉRIFIER:
    ⚠️  Envoi d'email de confirmation (peut timeout)
    ⚠️  Permissions sur les endpoints
    ⚠️  Synchronisation du statut en temps réel
    ''');

  } catch (e) {
    print('\n❌ Erreur: $e');
  }
}
