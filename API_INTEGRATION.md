# Intégration API - Alert App

## Vue d'ensemble

L'application Alert App a été intégrée avec l'API RESTful disponible à l'adresse `https://alert-app-nc1y.onrender.com/api/`. Cette intégration permet la gestion complète de l'authentification des utilisateurs.

## Architecture mise en place

### 1. Modèles de données (`lib/models/`)

- **`api_models.dart`** : Modèles de données pour l'API
  - `LoginRequest` : Requête de connexion
  - `LoginResponse` : Réponse de connexion avec token
  - `User` : Modèle utilisateur
  - `ApiError` : Gestion des erreurs API
  - `RegisterRequest` : Requête d'inscription
  - `RegisterResponse` : Réponse d'inscription

### 2. Services API (`lib/services/`)

- **`api_service.dart`** : Service principal pour les appels API
  - Méthodes pour l'authentification (login, register, logout)
  - Gestion des erreurs HTTP et réseau
  - Headers d'authentification automatiques
  - Timeout et gestion des exceptions

- **`authentication_service.dart`** : Service d'authentification local
  - Stockage sécurisé des tokens avec SharedPreferences
  - Gestion de l'état d'authentification
  - Validation des données utilisateur
  - Persistance de session

- **`api_test.dart`** : Tests de connexion API
  - Test de connectivité
  - Test des endpoints d'authentification

## Fonctionnalités implémentées

### ✅ Authentification complète

1. **Connexion utilisateur**
   - Validation des champs email/mot de passe
   - Appel API avec gestion d'erreurs
   - Stockage sécurisé du token
   - Redirection vers la page d'accueil

2. **Inscription utilisateur**
   - Validation des données d'inscription
   - Création de compte via API
   - Retour à la page de connexion

3. **Gestion des sessions**
   - Persistance du token d'authentification
   - Vérification automatique du token
   - Déconnexion sécurisée
   - Nettoyage des données locales

### ✅ Sécurité

- **Stockage sécurisé** : Utilisation de SharedPreferences pour les tokens
- **Validation des données** : Vérification email/mot de passe côté client
- **Gestion des erreurs** : Messages d'erreur appropriés pour l'utilisateur
- **Timeout** : Protection contre les requêtes longues

### ✅ Interface utilisateur

- **Pages mises à jour** :
  - `login_page.dart` : Intégration avec l'API
  - `signup_page.dart` : Inscription via API
  - `home_page.dart` : Déconnexion sécurisée

## Configuration requise

### Dépendances ajoutées

```yaml
dependencies:
  http: ^1.1.0                    # Requêtes HTTP
  shared_preferences: ^2.2.2      # Stockage local
  json_annotation: ^4.8.1        # Sérialisation JSON

dev_dependencies:
  json_serializable: ^6.7.1      # Génération de code
  build_runner: ^2.4.7           # Outil de build
```

### Installation

```bash
flutter pub get
```

## Utilisation

### 1. Connexion utilisateur

```dart
final authService = AuthenticationService();
final result = await authService.login(email, password);

if (result.isSuccess) {
  // Connexion réussie
  print(result.message);
} else {
  // Erreur de connexion
  print(result.message);
}
```

### 2. Inscription utilisateur

```dart
final authService = AuthenticationService();
final result = await authService.register(
  email: email,
  password: password,
  firstName: firstName,
  lastName: lastName,
);
```

### 3. Vérification de l'état d'authentification

```dart
final authService = AuthenticationService();
await authService.initialize();

if (authService.isAuthenticated) {
  // Utilisateur connecté
  print('Utilisateur: ${authService.userName}');
}
```

## Endpoints API utilisés

### Authentification

- `POST /api/auth/login` - Connexion utilisateur
- `POST /api/auth/register` - Inscription utilisateur
- `GET /api/auth/me` - Vérification du token
- `POST /api/auth/logout` - Déconnexion
- `POST /api/auth/refresh` - Rafraîchissement du token

### Utilisateurs

- `GET /api/users/profile` - Profil utilisateur
- `PUT /api/users/profile` - Mise à jour du profil

## Gestion des erreurs

### Types d'erreurs gérées

1. **Erreurs réseau** : Connexion internet, timeout
2. **Erreurs HTTP** : Codes de statut 400, 401, 500
3. **Erreurs de validation** : Données invalides
4. **Erreurs d'authentification** : Token expiré, invalide

### Messages d'erreur utilisateur

- Messages clairs et en français
- Indication des actions à effectuer
- Gestion des cas d'erreur courants

## Tests

### Test de connectivité

```dart
import 'services/api_test.dart';

// Test de connexion
final isConnected = await ApiTest.testConnection();
print('API accessible: $isConnected');

// Test complet
await ApiTest.runFullTest();
```

## Sécurité

### Bonnes pratiques implémentées

1. **Stockage sécurisé** : Tokens stockés localement avec SharedPreferences
2. **Validation côté client** : Vérification des données avant envoi
3. **Gestion des sessions** : Nettoyage automatique à la déconnexion
4. **Gestion des erreurs** : Pas d'exposition d'informations sensibles

### Recommandations

1. **HTTPS** : L'API utilise HTTPS pour la sécurité
2. **Tokens** : Gestion automatique des tokens d'authentification
3. **Validation** : Validation des données côté client et serveur

## Prochaines étapes

1. **Tests unitaires** : Ajouter des tests pour les services
2. **Gestion offline** : Cache des données pour utilisation hors ligne
3. **Refresh token** : Implémentation du rafraîchissement automatique
4. **Biométrie** : Authentification biométrique pour la sécurité
5. **2FA** : Authentification à deux facteurs

## Dépannage

### Problèmes courants

1. **Erreur de connexion** : Vérifier la connectivité internet
2. **Token expiré** : L'utilisateur sera redirigé vers la connexion
3. **Données invalides** : Messages d'erreur clairs affichés

### Logs de débogage

Les erreurs sont loggées avec `debugPrint()` pour faciliter le débogage en développement.
