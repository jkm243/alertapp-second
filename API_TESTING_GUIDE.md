# Guide de test API avec popups

## 🧪 Tests API avec interface utilisateur

L'application Alert App inclut maintenant un système de test API complet avec des popups pour afficher les résultats des tests au lieu d'utiliser des `print()`.

## 📱 Interface de test

### Widget de test API

Un widget `ApiTestWidget` a été ajouté à la page des paramètres qui permet de :

1. **Test de connexion** : Vérifier si l'API est accessible
2. **Test complet** : Tester tous les endpoints d'authentification

### Localisation

Le widget de test se trouve dans l'onglet **Paramètres** de la page d'accueil.

## 🔧 Fonctionnalités de test

### 1. Test de connexion simple

```dart
// Test de connexion avec popup
await ApiTest.testConnectionWithPopup(context);
```

**Résultat :**
- ✅ **Succès** : Popup vert "Connexion réussie"
- ❌ **Échec** : Popup rouge "Connexion échouée"

### 2. Test complet des endpoints

```dart
// Test complet avec popup
await ApiTest.runFullTestWithPopup(context);
```

**Résultat :**
- Popup détaillé avec les résultats de chaque endpoint
- Affichage des codes de statut HTTP
- Messages d'erreur du serveur
- Réponses JSON formatées

## 📊 Interface des résultats

### Popup de test de connexion

```
┌─────────────────────────────┐
│     Connexion réussie       │
├─────────────────────────────┤
│ L'API est accessible et     │
│ répond correctement.        │
├─────────────────────────────┤
│        [Fermer]             │
└─────────────────────────────┘
```

### Popup de test complet

```
┌─────────────────────────────┐
│   Résultats des tests API   │
├─────────────────────────────┤
│ ✅ Test de connexion        │
│    Statut: Succès           │
│    Détails:                 │
│    ┌─────────────────────┐  │
│    │ {"status": "ok"}    │  │
│    └─────────────────────┘  │
│                             │
│ ❌ Test d'inscription       │
│    Statut: Échec            │
│    Détails:                 │
│    ┌─────────────────────┐  │
│    │ {"error": "..."}    │  │
│    └─────────────────────┘  │
├─────────────────────────────┤
│        [Fermer]             │
└─────────────────────────────┘
```

## 🎨 Design des popups

### Couleurs utilisées

- **Succès** : Vert (`Colors.green`)
- **Erreur** : Rouge (`Colors.red`)
- **Couleur principale** : `#fa3333`
- **Fond** : Blanc avec ombres

### Éléments visuels

- **Icônes** : ✅ pour succès, ❌ pour erreur
- **Bordures** : Couleurs correspondant au statut
- **Police** : Monospace pour les détails techniques
- **Scroll** : Contenu scrollable pour les longues réponses

## 🔍 Types de tests effectués

### 1. Test de connexion

- **Endpoint** : `GET /api/health`
- **Timeout** : 10 secondes
- **Critère** : Status code 200

### 2. Test de login

- **Endpoint** : `POST /api/auth/login`
- **Données** : `test@example.com` / `testpassword`
- **Résultat** : Code de statut et réponse JSON

### 3. Test d'inscription

- **Endpoint** : `POST /api/auth/register`
- **Données** : Utilisateur test complet
- **Résultat** : Code de statut et réponse JSON

## 🛠️ Utilisation dans le code

### Ajout du widget de test

```dart
import '../widgets/api_test_widget.dart';

// Dans votre widget
const ApiTestWidget()
```

### Tests programmatiques

```dart
import '../services/api_test.dart';

// Test de connexion
await ApiTest.testConnectionWithPopup(context);

// Test complet
await ApiTest.runFullTestWithPopup(context);

// Test des endpoints uniquement
await ApiTest.testAuthEndpointsWithPopup(context);
```

## 📋 Gestion des erreurs

### Types d'erreurs affichées

1. **Erreurs réseau** : Connexion internet, timeout
2. **Erreurs HTTP** : Codes 400, 401, 500, etc.
3. **Erreurs de parsing** : JSON invalide
4. **Erreurs de timeout** : Délai dépassé

### Messages d'erreur

- **Connexion** : "Impossible de se connecter à l'API"
- **Timeout** : "Délai d'attente dépassé"
- **Serveur** : Affichage du message d'erreur du serveur

## 🎯 Avantages des popups

### Pour l'utilisateur

- **Visibilité** : Résultats clairement affichés
- **Détails** : Informations techniques complètes
- **Interactivité** : Interface utilisateur native
- **Accessibilité** : Compatible avec les lecteurs d'écran

### Pour le développeur

- **Debug** : Informations détaillées des réponses
- **Test** : Validation rapide des endpoints
- **Monitoring** : Vérification de l'état de l'API
- **Documentation** : Interface de test intégrée

## 🔧 Personnalisation

### Modification des couleurs

```dart
// Dans _buildTestResult
color: isSuccess ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1)
```

### Modification des timeouts

```dart
// Dans ApiTest
.timeout(const Duration(seconds: 10))
```

### Ajout de nouveaux tests

```dart
// Nouvelle méthode de test
static Future<void> testCustomEndpoint(BuildContext context) async {
  // Votre test personnalisé
  // Affichage du résultat dans un popup
}
```

## 📱 Intégration dans l'application

Le widget de test est automatiquement disponible dans l'onglet **Paramètres** de la page d'accueil. Il s'affiche en haut de la liste des paramètres pour un accès facile.

## 🚀 Utilisation recommandée

1. **Développement** : Utiliser pour tester l'API pendant le développement
2. **Debug** : Vérifier les problèmes de connexion
3. **Validation** : S'assurer que l'API fonctionne correctement
4. **Support** : Aider les utilisateurs à diagnostiquer les problèmes

Les tests API avec popups offrent une expérience utilisateur moderne et professionnelle pour le debugging et la validation de l'API ! 🎉
