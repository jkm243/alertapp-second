# Structure de l'application Alert App

Cette application Flutter suit une architecture modulaire avec une séparation claire des responsabilités.

## Structure des dossiers

```
lib/
├── main.dart                          # Point d'entrée de l'application
├── pages/                             # Pages de l'application
│   ├── onboarding/                   # Pages d'introduction
│   │   ├── onboarding_page.dart      # Page principale d'onboarding
│   │   └── onboarding_slide.dart     # Composant de slide individuel
│   ├── auth/                         # Pages d'authentification
│   │   ├── login_page.dart           # Page de connexion
│   │   └── signup_page.dart          # Page d'inscription
│   ├── permissions/                  # Pages de gestion des permissions
│   │   ├── location_permission_page.dart      # Permission de localisation
│   │   └── notification_permission_page.dart  # Permission de notifications
│   └── home_page.dart               # Page d'accueil principale
├── widgets/                          # Widgets personnalisés réutilisables
│   ├── primary_button.dart          # Bouton principal stylisé
│   └── text_link.dart               # Lien texte stylisé
└── services/                         # Services métier
    └── authentication_service.dart  # Service d'authentification
```

## Description des composants

### Pages

#### Onboarding
- **onboarding_page.dart** : Page principale avec navigation entre les slides
- **onboarding_slide.dart** : Composant réutilisable pour chaque slide d'introduction

#### Authentification
- **login_page.dart** : Interface de connexion avec validation des champs
- **signup_page.dart** : Interface d'inscription avec validation complète

#### Permissions
- **location_permission_page.dart** : Gestion de la permission de localisation
- **notification_permission_page.dart** : Gestion de la permission de notifications

#### Accueil
- **home_page.dart** : Page principale avec navigation par onglets (Alertes, Carte, Paramètres)

### Widgets

#### PrimaryButton
Bouton principal stylisé avec support pour :
- État de chargement
- Couleurs personnalisables
- Tailles personnalisables

#### TextLink
Lien texte stylisé avec support pour :
- Couleurs personnalisables
- Styles de texte personnalisables
- États de survol

### Services

#### AuthenticationService
Service d'authentification avec méthodes pour :
- Connexion utilisateur
- Inscription utilisateur
- Déconnexion
- Réinitialisation de mot de passe
- Changement de mot de passe
- Mise à jour de profil
- Validation des données

## Fonctionnalités implémentées

### Navigation
- Navigation fluide entre les pages
- Gestion des états de chargement
- Retour en arrière approprié

### Interface utilisateur
- Design moderne et cohérent
- Couleurs et thème unifiés
- Responsive design
- Animations fluides

### Gestion des permissions
- Interface pour demander les permissions
- Gestion des états de permission
- Redirection vers les paramètres si nécessaire

### Authentification
- Validation des formulaires
- Gestion des erreurs
- États de chargement
- Simulation d'API

## Prochaines étapes

1. **Intégration d'API réelles** : Remplacer les simulations par de vraies API
2. **Gestion des permissions natives** : Intégrer `permission_handler`
3. **Persistance des données** : Ajouter le stockage local
4. **Tests** : Ajouter des tests unitaires et d'intégration
5. **Notifications push** : Implémenter les notifications en temps réel
6. **Géolocalisation** : Intégrer les services de localisation
7. **Carte interactive** : Ajouter une carte avec les alertes

## Dépendances nécessaires

Pour une utilisation complète, ajouter ces dépendances au `pubspec.yaml` :

```yaml
dependencies:
  permission_handler: ^11.0.1
  geolocator: ^10.1.0
  firebase_messaging: ^14.7.10
  shared_preferences: ^2.2.2
```

## Utilisation

1. Lancer l'application avec `flutter run`
2. Suivre le flux d'onboarding
3. Se connecter ou s'inscrire
4. Autoriser les permissions nécessaires
5. Utiliser l'interface principale
