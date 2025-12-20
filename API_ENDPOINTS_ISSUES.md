# Problèmes identifiés avec l'API

## 🔴 Problèmes critiques

### 1. Timeout sur `/users/signup/`
- **Problème** : L'endpoint `/users/signup/` prend plus de 30 secondes à répondre
- **Cause** : Le serveur Render est probablement en veille (service gratuit)
- **Solution** : 
  - Timeout augmenté à 60 secondes
  - Le premier appel peut prendre du temps car Render doit "réveiller" le serveur
  - Les appels suivants seront plus rapides

### 2. Endpoints incorrects corrigés

#### ✅ Endpoints corrigés :
- `/auth/me` → `/users/me/` ✅
- `/auth/refresh` → `/users/account/refresh/` ✅
- `/users/profile` → `/users/edit-profile/` ✅
- `/alerts/` → `/alert/` (singulier) ✅
- `/notifications/count/` → `/notifications/unread_count/` ✅

#### ⚠️ Endpoints à vérifier :
- `/alert/types/` - À vérifier si cet endpoint existe
- `/missions/` - Endpoint existe mais peut nécessiter un chemin spécifique
- `/notifications/` - Endpoint existe mais peut nécessiter un chemin spécifique

## 📋 Endpoints fonctionnels (testés)

### Authentification
- ✅ `POST /users/login/` - Fonctionne (retourne 401 avec mauvais credentials, ce qui est normal)
- ⚠️ `POST /users/signup/` - Timeout (serveur en veille)
- ✅ `GET /users/me/` - Existe (nécessite authentification)
- ✅ `POST /users/account/refresh/` - Existe

### Gestion des utilisateurs
- ✅ `GET /users/all/` - Existe (nécessite Admin)
- ✅ `GET /users/pagination/` - Existe (nécessite Admin)
- ✅ `GET /users/user/{id}/` - Existe
- ✅ `PUT /users/update-by-id/{id}/` - Existe
- ✅ `DELETE /users/delete/{id}/` - Existe

### Alertes
- ⚠️ `GET /alert/` - À tester avec authentification
- ⚠️ `GET /alert/types/` - À vérifier si existe

### Missions
- ⚠️ `GET /missions/` - À tester avec authentification

### Notifications
- ⚠️ `GET /notifications/` - À tester avec authentification
- ✅ `GET /notifications/unread_count/` - Existe

## 🔧 Solutions appliquées

1. **Timeout augmenté** : De 30 à 60 secondes pour gérer le réveil du serveur Render
2. **Endpoints corrigés** : Tous les endpoints ont été mis à jour dans `ApiConfig`
3. **Gestion d'erreurs améliorée** : Messages d'erreur plus clairs pour les timeouts

## 📝 Recommandations

1. **Pour le développement** :
   - Attendre 30-60 secondes lors du premier appel après une période d'inactivité
   - Les appels suivants seront plus rapides
   - Considérer utiliser un service de "ping" pour maintenir le serveur actif

2. **Pour la production** :
   - Utiliser un plan payant Render pour éviter la mise en veille
   - Ou implémenter un système de "keep-alive" qui ping le serveur régulièrement

3. **Tests** :
   - Tester tous les endpoints avec authentification
   - Vérifier les endpoints d'alertes, missions et notifications

## 🧪 Comment tester

Exécutez le script de test :
```bash
dart scripts/test_api_endpoints.dart
```

Ou testez manuellement avec curl :
```bash
# Test de connexion
curl -X POST https://alert-app-nc1y.onrender.com/api/users/login/ \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"test123"}'

# Test d'inscription (peut prendre du temps)
curl -X POST https://alert-app-nc1y.onrender.com/api/users/signup/ \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password1":"test123","password2":"test123","firstname":"Test","lastname":"User","role":"User"}'
```

