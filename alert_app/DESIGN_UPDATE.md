# Mise à jour du design - Couleur et Police

## Changements apportés

### Couleur principale
- **Ancienne couleur** : #2196F3 (bleu)
- **Nouvelle couleur** : #fa3333 (rouge)
- **Application** : Tous les éléments d'interface utilisateur

### Police
- **Nouvelle police** : Inter
- **Application** : Thème global de l'application

## Fichiers modifiés

### 1. Configuration globale
- `lib/main.dart` - Thème global avec couleur #fa3333 et police Inter
- `pubspec.yaml` - Configuration des polices Inter
- `assets/fonts/README.md` - Instructions pour ajouter les polices

### 2. Widgets
- `lib/widgets/primary_button.dart` - Couleur de fond du bouton principal
- `lib/widgets/text_link.dart` - Couleur des liens

### 3. Pages d'authentification
- `lib/pages/auth/login_page.dart` - Couleur de l'icône et du titre
- `lib/pages/auth/signup_page.dart` - Couleur du titre

### 4. Page d'accueil
- `lib/pages/home_page.dart` - Couleur de l'AppBar et navigation

### 5. Pages de permissions
- `lib/pages/permissions/location_permission_page.dart` - Couleur des icônes
- `lib/pages/permissions/notification_permission_page.dart` - Couleur des icônes

### 6. Pages d'onboarding
- `lib/pages/onboarding/onboarding_page.dart` - Couleur de fond du premier slide

## Éléments mis à jour

### Couleurs
- ✅ AppBar et navigation
- ✅ Boutons principaux
- ✅ Liens texte
- ✅ Icônes d'interface
- ✅ Couleurs d'accent
- ✅ Couleurs de fond des slides

### Police
- ✅ Thème global configuré
- ✅ Tous les textes utilisent Inter
- ✅ Configuration dans pubspec.yaml

## Prochaines étapes

1. **Ajouter les fichiers de police Inter** :
   - Télécharger depuis Google Fonts
   - Placer dans `assets/fonts/`
   - Exécuter `flutter pub get`

2. **Tester l'application** :
   - Vérifier que tous les éléments utilisent la nouvelle couleur
   - Vérifier que la police Inter s'applique correctement

3. **Ajustements finaux** :
   - Ajuster les contrastes si nécessaire
   - Vérifier l'accessibilité des couleurs

## Notes techniques

- La couleur #fa3333 est définie comme `Color(0xFFfa3333)` dans le code
- La police Inter est configurée dans le thème global
- Tous les widgets héritent automatiquement de la nouvelle couleur et police
- Les polices Inter doivent être ajoutées manuellement dans le dossier `assets/fonts/`
