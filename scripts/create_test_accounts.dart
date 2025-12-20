import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:http/http.dart' as http;

const String baseUrl = 'https://alert-app-nc1y.onrender.com/api';
const String registerEndpoint = '/users/signup/';
const String loginEndpoint = '/users/login/';
const String meEndpoint = '/users/me/';

// Test accounts - User, Admin et Operator
final testAccounts = [
  {
    'email': 'user_test_${DateTime.now().millisecondsSinceEpoch}@example.com',
    'password': 'TestUser!@#123',
    'firstname': 'John',
    'lastname': 'User',
    'role': 'User',
    'description': 'User Standard',
  },
  {
    'email': 'admin_test_${DateTime.now().millisecondsSinceEpoch}@example.com',
    'password': 'TestAdmin!@#123',
    'firstname': 'Alice',
    'lastname': 'Admin',
    'role': 'Admin',
    'description': 'Administrateur',
  },
  {
    'email': 'operator_test_${DateTime.now().millisecondsSinceEpoch}@example.com',
    'password': 'TestOperator!@#123',
    'firstname': 'Bob',
    'lastname': 'Operator',
    'role': 'Operator',
    'description': 'Opérateur (Superviseur)',
  },
];

// Résultats des tests
final List<Map<String, String>> testResults = [];

void main() async {
  print('╔════════════════════════════════════════════════════════════════╗');
  print('║   CRÉATION DES COMPTES DE TEST - USER, ADMIN ET OPERATOR      ║');
  print('╚════════════════════════════════════════════════════════════════╝');
  print('');

  for (var account in testAccounts) {
    print('🔄 Création du compte ${account['description']}...');
    print('─' * 70);

    try {
      // ======== ÉTAPE 1: INSCRIPTION ========
      print('📝 Étape 1: Inscription...');
      final signupResponse = await signUp(
        email: account['email']!,
        password: account['password']!,
        firstname: account['firstname']!,
        lastname: account['lastname']!,
        role: account['role']!,
      );

      if (!signupResponse['success']) {
        print('❌ Erreur d\'inscription: ${signupResponse['message']}');
        print('');
        continue;
      }

      print('✅ Inscription réussie');
      print('');

      // ======== ÉTAPE 2: CONNEXION ========
      print('📝 Étape 2: Connexion...');
      final loginResponse = await login(
        email: account['email']!,
        password: account['password']!,
      );

      if (!loginResponse['success']) {
        print('❌ Erreur de connexion: ${loginResponse['message']}');
        print('');
        continue;
      }

      dynamic token = loginResponse['token'];
      if (token == null || token.toString().isEmpty) {
        print('❌ Erreur: Token non reçu');
        print('');
        continue;
      }

      token = token.toString();

      print('✅ Connexion réussie');
      print('');

      // ======== ÉTAPE 3: RÉCUPÉRATION DES INFOS ========
      print('📝 Étape 3: Récupération des informations utilisateur...');
      final userInfo = await getUserInfo(token: token);

      if (!userInfo['success']) {
        print('❌ Erreur: ${userInfo['message']}');
        print('');
        continue;
      }

      final userData = userInfo['user'];
      var userRole = userData['role'] ?? userData['groups']?[0] ?? 'User';
      if (userRole is List && (userRole).isNotEmpty) {
        userRole = userRole[0];
      }

      print('✅ Informations récupérées');
      print('');

      // ======== ENREGISTREMENT ========
      testResults.add({
        'role': account['role']!,
        'description': account['description']!,
        'email': account['email']!,
        'password': account['password']!,
        'firstname': userData['first_name']?.toString() ?? account['firstname']!,
        'lastname': userData['last_name']?.toString() ?? account['lastname']!,
        'status': 'Actif',
        'token': token.substring(0, math.min(40, token.length)) + '...',
      });

      print('✅ ✅ ✅ COMPTE CRÉÉ AVEC SUCCÈS ✅ ✅ ✅');
      print('');
      print('═' * 70);
      print('');
    } catch (e) {
      print('❌ Erreur: $e');
      print('');
    }
  }

  // ======== AFFICHAGE DES IDENTIFIANTS ========
  await displayTestAccounts();
  await saveTestAccountsToFile();
}

/// Affiche les identifiants de test formatés
Future<void> displayTestAccounts() async {
  if (testResults.isEmpty) {
    print('❌ Aucun compte n\'a pu être créé.');
    return;
  }

  print('');
  print('╔════════════════════════════════════════════════════════════════╗');
  print('║              IDENTIFIANTS DE TEST - PRÊTS À UTILISER           ║');
  print('╚════════════════════════════════════════════════════════════════╝');
  print('');

  for (var result in testResults) {
    print('┌─ ${result['role']!.toUpperCase()} (${result['description']}) ─────────────────────┐');
    print('│                                                                │');
    print('│  📧 Email:     ${result['email']}');
    print('│  🔑 Mot de passe: ${result['password']}');
    print('│                                                                │');
    print('│  👤 Prénom:    ${result['firstname']}');
    print('│  👥 Nom:       ${result['lastname']}');
    print('│  ✅ Statut:     ${result['status']}');
    print('│                                                                │');
    print('│  🔐 Token (preview): ${result['token']}');
    print('│                                                                │');
    print('└────────────────────────────────────────────────────────────────┘');
    print('');
  }

  print('📝 INSTRUCTIONS D\'UTILISATION:');
  print('   1. Utilisez les emails et mots de passe ci-dessus pour tester');
  print('   2. Chaque compte a un rôle spécifique: User, Admin ou Operator');
  print('   3. Testez les permissions et fonctionnalités pour chaque rôle');
  print('');
}

/// Sauvegarde les comptes de test dans un fichier
Future<void> saveTestAccountsToFile() async {
  final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').split('.')[0];
  final filename = 'test_accounts_$timestamp.txt';
  final file = File(filename);

  final content = '''
╔════════════════════════════════════════════════════════════════════════════════╗
║                 COMPTES DE TEST GÉNÉRÉS - COPIE DE SAUVEGARDE                  ║
╚════════════════════════════════════════════════════════════════════════════════╝

Date/Heure: ${DateTime.now()}
API Base URL: $baseUrl

═════════════════════════════════════════════════════════════════════════════════
COMPTES CRÉÉS
═════════════════════════════════════════════════════════════════════════════════

${testResults.map((r) => '''
┌─ ${r['role']!} (${r['description']})
│  Email:        ${r['email']}
│  Mot de passe: ${r['password']}
│  Prénom:       ${r['firstname']}
│  Nom:          ${r['lastname']}
│  Statut:       ${r['status']}
└─

''').join('')}

═════════════════════════════════════════════════════════════════════════════════
COMMANDES DE TEST CURL
═════════════════════════════════════════════════════════════════════════════════

1️⃣  LOGIN (TOUS LES RÔLES)
   curl -X POST $baseUrl$loginEndpoint \\
     -H "Content-Type: application/json" \\
     -d '{"email":"user_email@example.com","password":"password"}'

2️⃣  RÉCUPÉRER L'UTILISATEUR CONNECTÉ
   curl -X GET $baseUrl$meEndpoint \\
     -H "Authorization: Bearer {access_token}"

3️⃣  LISTER TOUS LES UTILISATEURS (Admin uniquement)
   curl -X GET $baseUrl/users/all/ \\
     -H "Authorization: Bearer {admin_token}"

4️⃣  METTRE À JOUR LE PROFIL
   curl -X POST $baseUrl/users/edit-profile/ \\
     -H "Authorization: Bearer {token}" \\
     -H "Content-Type: multipart/form-data" \\
     -F "email=newemail@example.com" \\
     -F "firstname=NewFirstName"

═════════════════════════════════════════════════════════════════════════════════
NOTES IMPORTANTES
═════════════════════════════════════════════════════════════════════════════════

✅ Les comptes sont créés et actifs
✅ Vous pouvez vous connecter immédiatement
⚠️  Les comptes seront créés avec le rôle spécifié
⚠️  Vérifiez que le rôle est correctement enregistré dans la base de données
⚠️  Conservez ce fichier en lieu sûr

═════════════════════════════════════════════════════════════════════════════════
''';

  await file.writeAsString(content);
  print('📄 Comptes sauvegardés dans: $filename');
  print('');
}

/// Fonction d'inscription
Future<Map<String, dynamic>> signUp({
  required String email,
  required String password,
  required String firstname,
  required String lastname,
  required String role,
}) async {
  try {
    final url = Uri.parse('$baseUrl$registerEndpoint');

    final body = {
      'email': email,
      'password1': password,
      'password2': password,
      'firstname': firstname,
      'lastname': lastname,
      'middlename': '',
      'telephone': '',
      'role': role,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 60));

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return {
        'success': true,
        'message': responseData['message'] ?? 'Inscription réussie',
      };
    } else {
      final errorData = jsonDecode(response.body);
      return {
        'success': false,
        'message': errorData['message'] ?? 'Erreur d\'inscription',
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'Erreur: ${e.toString()}',
    };
  }
}

/// Fonction de connexion
Future<Map<String, dynamic>> login({
  required String email,
  required String password,
}) async {
  try {
    final url = Uri.parse('$baseUrl$loginEndpoint');

    final body = {
      'email': email,
      'password': password,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 60));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      dynamic token;
      if (responseData['access'] != null) {
        token = responseData['access'];
      } else if (responseData['token'] != null) {
        final tokenData = responseData['token'];
        if (tokenData is String) {
          token = tokenData;
        } else if (tokenData is Map && tokenData['access'] != null) {
          token = tokenData['access'];
        } else if (tokenData is Map && tokenData['token'] != null) {
          token = tokenData['token'];
        }
      }

      token ??= '';

      if (token is! String) {
        token = token.toString();
      }

      return {
        'success': true,
        'token': token,
      };
    } else {
      final errorData = jsonDecode(response.body);
      return {
        'success': false,
        'message': errorData['message'] ?? 'Erreur de connexion',
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'Erreur: ${e.toString()}',
    };
  }
}

/// Fonction pour récupérer les informations utilisateur
Future<Map<String, dynamic>> getUserInfo({required String token}) async {
  try {
    final url = Uri.parse('$baseUrl$meEndpoint');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(const Duration(seconds: 60));

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      return {
        'success': true,
        'user': userData,
      };
    } else {
      return {
        'success': false,
        'message': 'Erreur de récupération',
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'Erreur: ${e.toString()}',
    };
  }
}

