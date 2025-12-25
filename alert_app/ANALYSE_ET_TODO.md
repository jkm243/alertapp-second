# Analyse de l'application Alert App - État actuel et TODO

## 📊 État actuel des applications

### ✅ Ce qui est déjà implémenté

#### Infrastructure de base
- ✅ Architecture multi-app (User, Admin, Supervisor)
- ✅ Authentification complète (login/signup) pour les 3 apps
- ✅ Gestion des rôles et guards d'authentification
- ✅ Design system cohérent
- ✅ Service API de base avec gestion d'erreurs
- ✅ Onboarding
- ✅ Pages de permissions (localisation, notifications)

#### APP USER
- ✅ Structure de base avec navigation (Alertes, Carte, Paramètres)
- ✅ Page de création d'alerte basique (mais incomplète)
- ✅ Placeholder pour la carte
- ✅ Liste d'alertes mockée

#### APP ADMIN
- ✅ Dashboard avec statistiques mockées
- ✅ Gestion des utilisateurs (liste depuis API)
- ✅ Structure de navigation (Dashboard, Utilisateurs, Alertes, Paramètres)
- ✅ Page de gestion des alertes (mockée)

#### APP SUPERVISOR
- ✅ Page de révision des alertes
- ✅ Actions de validation/rejet (mockées)
- ✅ Structure de navigation

---

## ❌ Ce qui manque selon le cahier des charges

### 📱 APP USER (MVP Prioritaire)

#### 1. Carte interactive ⚠️ CRITIQUE
- ❌ Intégration Google Maps ou Mapbox
- ❌ Affichage des alertes sur la carte avec marqueurs
- ❌ Clustering des marqueurs
- ❌ Filtres (rayon, type, date)
- ❌ Détail alerte au clic sur marqueur
- ❌ Géolocalisation automatique

#### 2. Création d'alerte complète ⚠️ CRITIQUE
- ❌ Sélection du type d'alerte (liste depuis API)
- ❌ Upload photo/vidéo (caméra ou galerie)
- ❌ Géolocalisation GPS automatique
- ❌ Option "Rester anonyme"
- ❌ Validation et envoi à l'API

#### 3. Liste/timeline des alertes
- ❌ Affichage des alertes depuis l'API
- ❌ Filtres (date, type, région)
- ❌ Statuts visuels (Nouveau, Validé, En cours, Clos)
- ❌ Pull-to-refresh

#### 4. Détail d'alerte
- ❌ Page détaillée avec toutes les infos
- ❌ Affichage des médias (photos/vidéos)
- ❌ Statut actuel
- ❌ Bouton "Suivre" pour notifications

#### 5. Notifications push
- ❌ Intégration Firebase/APNs
- ❌ Notifications pour validation/rejet
- ❌ Notifications pour changement de statut
- ❌ Page de liste des notifications

#### 6. Visualisation vidéo drone
- ❌ Lecteur vidéo pour flux drone
- ❌ Accès conditionnel (si alerte validée)

#### 7. Profil utilisateur
- ❌ Page de profil
- ❌ Modification des coordonnées
- ❌ Avatar

#### 8. Paramètres
- ❌ Gestion des permissions (localisation, galerie, caméra)
- ❌ Paramètres de notifications
- ❌ Préférences

---

### 👮 APP SUPERVISOR (Opérateur)

#### 1. Validation/rejet d'alertes
- ⚠️ Connecter à l'API réelle (`/api/alert/alerts/{id}/validate/`)
- ❌ Affichage des détails complets de l'alerte
- ❌ Médias de l'alerte
- ❌ Localisation sur carte

#### 2. Déclenchement mission drone
- ⚠️ Connecter à l'API (création automatique via validation)
- ❌ Suivi de la mission
- ❌ Statut de la mission

#### 3. Gestion des missions
- ❌ Liste des missions
- ❌ Détails de mission
- ❌ Terminer une mission (`/api/missions/missions/{id}/finish/`)

#### 4. Logs de missions
- ❌ Affichage des logs (`/api/logs/missions/{id}/finish/`)

---

### 👨‍💼 APP ADMIN

#### 1. Dashboard
- ⚠️ Statistiques réelles depuis API
- ❌ Graphiques et métriques
- ❌ Alertes récentes

#### 2. Gestion des alertes
- ⚠️ Liste complète depuis API (`/api/alert/alerts/all/`)
- ❌ Filtres et recherche
- ❌ Actions (modifier, supprimer)
- ❌ Détails complets

#### 3. Gestion des types d'alertes
- ❌ Liste des types (`/api/alert/typealerts/`)
- ❌ Créer un type (`/api/alert/typealerts/create/`)
- ❌ Modifier un type
- ❌ Supprimer un type

#### 4. Gestion des missions
- ❌ Liste des missions
- ❌ Détails et logs

---

## 🔧 Services API à créer/améliorer

### Services manquants
1. **AlertService** - Gestion complète des alertes
   - `createAlert()` - Créer une alerte avec médias
   - `getAllAlerts()` - Liste toutes les alertes
   - `getMyAlerts()` - Alertes de l'utilisateur
   - `getAlertById()` - Détail d'une alerte
   - `updateAlert()` - Modifier une alerte
   - `deleteAlert()` - Supprimer une alerte
   - `validateAlert()` - Valider (Supervisor)

2. **TypeAlertService** - Gestion des types d'alertes
   - `getAllTypes()` - Liste des types
   - `getTypeById()` - Détail d'un type
   - `createType()` - Créer un type
   - `updateType()` - Modifier un type
   - `deleteType()` - Supprimer un type

3. **MissionService** - Gestion des missions
   - `getAllMissions()` - Liste des missions
   - `getMissionById()` - Détail d'une mission
   - `finishMission()` - Terminer une mission
   - `getMissionLogs()` - Logs d'une mission

4. **NotificationService** - Notifications push
   - `getNotifications()` - Liste des notifications
   - `getUnreadCount()` - Nombre non lu
   - `markAsRead()` - Marquer comme lu

---

## 📋 TODO List prioritaire

### Phase 1 : Services API (Fondation)
- [ ] Créer `AlertService` avec toutes les méthodes
- [ ] Créer `TypeAlertService`
- [ ] Créer `MissionService`
- [ ] Créer `NotificationService`
- [ ] Ajouter support upload multipart pour médias

### Phase 2 : APP USER - Fonctionnalités critiques
- [ ] Améliorer page création alerte (type, médias, GPS, anonyme)
- [ ] Intégrer carte interactive (Google Maps)
- [ ] Afficher alertes sur la carte
- [ ] Liste des alertes depuis API
- [ ] Page détail alerte
- [ ] Filtres sur liste/carte

### Phase 3 : APP USER - Fonctionnalités complémentaires
- [ ] Notifications push
- [ ] Visualisation vidéo drone
- [ ] Page profil utilisateur
- [ ] Page paramètres complète

### Phase 4 : APP SUPERVISOR
- [ ] Connecter validation/rejet à l'API
- [ ] Afficher détails complets des alertes
- [ ] Gestion des missions
- [ ] Logs de missions

### Phase 5 : APP ADMIN
- [ ] Dashboard avec statistiques réelles
- [ ] Gestion complète des alertes
- [ ] Gestion des types d'alertes (CRUD)
- [ ] Gestion des missions

---

## 🎯 Priorités immédiates

1. **Services API** - Fondation nécessaire pour tout le reste
2. **Création d'alerte complète** - Fonctionnalité principale MVP
3. **Carte interactive** - Fonctionnalité principale MVP
4. **Liste des alertes** - Affichage des données réelles
5. **Validation alertes (Supervisor)** - Connecter à l'API

---

## 📦 Dépendances à ajouter

```yaml
dependencies:
  # Carte
  google_maps_flutter: ^2.5.0
  # OU
  mapbox_maps_flutter: ^1.0.0
  
  # Géolocalisation
  geolocator: ^10.1.0
  
  # Permissions
  permission_handler: ^11.0.1
  
  # Upload fichiers
  image_picker: ^1.0.4
  file_picker: ^6.0.0
  
  # Notifications
  firebase_messaging: ^14.7.0
  flutter_local_notifications: ^16.0.0
  
  # Vidéo
  video_player: ^2.8.0
  chewie: ^1.7.0
  
  # Autres
  intl: ^0.19.0  # Format dates
  cached_network_image: ^3.3.0  # Images réseau
```

---

## 🔗 Références API

Tous les endpoints sont documentés dans `API Mon Projet.yaml` :
- Alertes : `/api/alert/`
- Types d'alertes : `/api/alert/typealerts/`
- Missions : `/api/missions/`
- Notifications : `/api/notifications/`
- Utilisateurs : `/api/users/`




