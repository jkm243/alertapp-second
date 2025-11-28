# Design System Flutter - Alert App

## 🎨 Vue d'ensemble

Ce design system complet pour Flutter inclut tous les éléments nécessaires pour créer une interface utilisateur cohérente et moderne.

## 🚀 Fonctionnalités

### 1. Système de Couleurs Complet
- **Palette HSL** convertie en couleurs Flutter
- **Mode clair et sombre** avec toutes les variables CSS
- **Couleur principale** : Rouge #F43F5E
- **Couleurs d'état** : destructive, muted, accent, etc.

### 2. Typographie Détaillée
- **Hiérarchie complète** : H1, H2, H3, body, caption
- **Tailles et poids** de police précis
- **Hauteurs de ligne** et espacement des lettres
- **Police Inter** intégrée

### 3. Système d'Espacement
- **Espacement Tailwind** converti en Flutter
- **Rayons de bordure** avec les valeurs exactes
- **Ombres** avec les paramètres précis
- **Système basé sur 4px** (xs=4, sm=8, md=16, etc.)

### 4. Composants UI Techniques
- **Boutons** : 5 variantes (primary, secondary, outline, ghost, destructive)
- **Cartes** : styles et hover effects
- **Champs de saisie** : bordures et focus states
- **Badges** : 4 variantes avec couleurs

### 5. Layout Mobile-First
- **Navigation** : TopNav (64px) et BottomNav (64px)
- **Conteneurs** : max-width et padding
- **Grid responsive** : 1/2/3 colonnes selon l'écran

### 6. Animations et Transitions
- **Durées** : fast (150ms), normal (300ms), slow (500ms)
- **Curves** : easeOut, easeInOut
- **Accordion** : animation spécifique

### 7. Thème Flutter Complet
- **ThemeData** light et dark
- **ColorScheme** avec toutes les couleurs
- **TextTheme** avec la hiérarchie
- **Component themes** pour boutons, inputs, cartes

## 📁 Structure du Projet

```
lib/design_system/
├── colors.dart              # Système de couleurs
├── typography.dart          # Typographie
├── spacing.dart             # Espacement et bordures
├── animations.dart          # Animations
├── theme.dart               # Thème Flutter complet
├── components/
│   ├── buttons.dart         # Boutons (5 variantes)
│   ├── cards.dart           # Cartes avec hover effects
│   ├── inputs.dart          # Champs de saisie
│   └── badges.dart          # Badges (4 variantes)
├── layout/
│   ├── navigation.dart      # Navigation (TopNav, BottomNav)
│   └── containers.dart      # Conteneurs et grilles
├── examples/
│   ├── badge_example.dart   # Exemple Badge complet
│   └── design_system_demo.dart # Démonstration complète
└── design_system.dart       # Export principal
```

## 🎯 Points Clés

- **Couleur principale** : `Color(0xFFF43F5E)` (rouge)
- **Rayon de bordure** : `12.0` (lg)
- **Hauteur navigation** : `64.0` pixels
- **Espacement** : système basé sur 4px
- **Ombres** : 3 niveaux (sm, md, lg)
- **Responsive** : mobile-first avec breakpoints

## 🚀 Utilisation

### Import du Design System
```dart
import 'package:alert_app/design_system/design_system.dart';
```

### Utilisation des Couleurs
```dart
Container(
  color: AppColors.primary,
  child: Text(
    'Texte',
    style: AppTypography.h1,
  ),
)
```

### Utilisation des Boutons
```dart
AppButton(
  text: 'Cliquer',
  variant: AppButtonVariant.primary,
  onPressed: () {},
)
```

### Utilisation des Badges
```dart
AppBadge(
  text: 'Nouveau',
  variant: AppBadgeVariant.success,
  icon: Icons.star,
)
```

### Utilisation du Thème
```dart
MaterialApp(
  theme: AppTheme.light,
  darkTheme: AppTheme.dark,
  themeMode: ThemeMode.system,
  // ...
)
```

## 🎨 Exemples

### Navigation
```dart
AppTopNavigation(
  title: 'Titre',
  actions: [IconButton(...)],
)

AppBottomNavigation(
  items: [
    AppBottomNavItem(icon: Icons.home, label: 'Accueil'),
    AppBottomNavItem(icon: Icons.settings, label: 'Paramètres'),
  ],
  currentIndex: 0,
  onTap: (index) {},
)
```

### Layout Responsive
```dart
AppContainer(
  size: AppContainerSize.medium,
  child: AppGrid(
    children: [
      AppCard(child: Text('Carte 1')),
      AppCard(child: Text('Carte 2')),
    ],
  ),
)
```

### Animations
```dart
Widget build(BuildContext context) {
  return Container()
    .fadeIn(duration: AppAnimations.fadeIn)
    .slideInFromRight()
    .scaleIn();
}
```

## 🌙 Mode Sombre

Le design system inclut un support complet du mode sombre avec des couleurs adaptées :

```dart
// Couleurs pour le mode sombre
AppColorsDark.background
AppColorsDark.foreground
AppColorsDark.card
AppColorsDark.border
```

## 📱 Responsive Design

Le système inclut des breakpoints et des composants responsives :

```dart
AppResponsiveLayout(
  mobile: MobileWidget(),
  tablet: TabletWidget(),
  desktop: DesktopWidget(),
)
```

## 🎯 Bonnes Pratiques

1. **Utilisez toujours les composants du design system** au lieu de créer des widgets personnalisés
2. **Respectez la hiérarchie typographique** définie
3. **Utilisez les espacements standardisés** (AppSpacing)
4. **Testez en mode clair et sombre**
5. **Vérifiez la responsivité** sur différentes tailles d'écran

## 🔧 Personnalisation

Pour personnaliser le design system, modifiez les fichiers dans `lib/design_system/` :

- **Couleurs** : `colors.dart`
- **Typographie** : `typography.dart`
- **Espacement** : `spacing.dart`
- **Thème** : `theme.dart`

## 📚 Documentation

Pour plus d'informations, consultez :
- [Exemple Badge](./examples/badge_example.dart)
- [Démonstration complète](./examples/design_system_demo.dart)
- [Thème Flutter](./theme.dart)

