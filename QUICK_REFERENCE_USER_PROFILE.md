# Quick Reference Guide: User Profile API Integration

## 🎯 En une Page

### 3 Endpoints Implémentés

#### 1️⃣ GET /api/users/me/ - Récupérer l'utilisateur
```dart
final user = await ApiService.getCurrentUser(token);
// Retourne: User object avec tous les champs
```

#### 2️⃣ POST /api/users/edit-profile/ - Éditer le profil
```dart
final updatedUser = await ApiService.editUserProfile(
  token: token,
  firstname: 'John',
  lastname: 'Doe',
  email: 'john@example.com',
  telephone: '+33612345678',
);
// Retourne: User object mis à jour
```

#### 3️⃣ POST /api/users/change-password/ - Changer le mot de passe
```dart
await ApiService.changePassword(
  token: token,
  oldPassword: 'ancien_mot_de_passe',
  newPassword: 'nouveau_mot_de_passe',
  confirmPassword: 'nouveau_mot_de_passe',
);
// Retourne: void (pas de contenu)
```

---

## 📍 Où Sont les Fichiers?

| Composant | Fichier | Ligne |
|-----------|---------|------|
| API Methods | `lib/services/api_service.dart` | 599-697 |
| UI Page | `lib/pages/user_profile_page.dart` | 1-490 |
| Integration | `lib/pages/home_page.dart` | 476 (UserProfilePage) |
| Design | `lib/design_system/colors.dart` | Existant |

---

## 🔗 Points d'Intégration

### Dans HomePage
```dart
// Déjà intégré - onglet Profil affiche UserProfilePage
_ProfileTab()
  └─ UserProfilePage()
```

### Authentication
```dart
final token = AuthenticationService().accessToken;
```

### Erreur Handling
```dart
try {
  // Appel API
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red)
  );
}
```

---

## ✅ Checklist de Test

### Test Manuel
- [ ] Se connecter à l'app
- [ ] Aller à l'onglet "Profil"
- [ ] Vérifier que le nom, email, avatar s'affichent
- [ ] Cliquer "Éditer le profil"
- [ ] Modifier le prénom et cliquer "Enregistrer"
- [ ] Vérifier que ça a été sauvegardé
- [ ] Cliquer "Changer le mot de passe"
- [ ] Entrer l'ancien MDP et un nouveau
- [ ] Vérifier le message de succès
- [ ] Vérifier que l'historique des alertes s'affiche

### Test API Direct
```bash
# Récupérer l'utilisateur
curl -H "Authorization: Bearer <token>" \
  https://api.example.com/api/users/me/

# Éditer le profil
curl -X POST \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"firstname":"John","lastname":"Doe"}' \
  https://api.example.com/api/users/edit-profile/

# Changer le mot de passe
curl -X POST \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"old_password":"old","new_password":"new","confirm_password":"new"}' \
  https://api.example.com/api/users/change-password/
```

---

## 🐛 Troubleshooting

### Token non disponible?
```
Error: Token non disponible
→ Assurez-vous que l'utilisateur est connecté
→ Vérifiez que AuthenticationService().accessToken n'est pas null
```

### Erreur 401 Unauthorized?
```
→ Token expiré
→ Connectez-vous à nouveau
→ Vérifiez le format Bearer token dans _getAuthHeaders()
```

### Erreur 400 Bad Request?
```
→ Format de la requête incorrect
→ Vérifiez que le JSON est bien formaté
→ Vérifiez que tous les champs requis sont présents
```

### Erreur 500 Server Error?
```
→ Problème côté serveur
→ Vérifiez les logs du serveur
→ Contactez le support API
```

---

## 📱 UI Flows

### Éditer Profil
```
HomePage
  ↓ (onglet Profil)
UserProfilePage
  ↓ (clic Éditer)
Dialog avec TextFields
  ↓ (clic Enregistrer)
API editUserProfile()
  ↓
SnackBar ✓ ou ✗
  ↓
setState() recharge les données
```

### Changer Mot de Passe
```
HomePage
  ↓ (onglet Profil)
UserProfilePage
  ↓ (clic Changer MDP)
Dialog avec 3 TextFields + toggles
  ↓ (validation côté client)
  ↓ (clic Changer)
API changePassword()
  ↓
SnackBar ✓ ou ✗
```

---

## 🎨 Design Utilisé

### Couleurs
- Primary: `#FA3333` (rouge)
- Background: `#F8F5F5` (beige clair)
- Dark: `#230F0F` (marron foncé)

### Composants
- Avatar cercle avec border blanche
- Role badge avec couleur primaire
- Dialogues standard Material
- SnackBar pour les confirmations

### Langue
- Français partout (Profil, Éditer le profil, etc.)
- Messages d'erreur en français

---

## 🔐 Sécurité - Checklist

- ✅ Token Bearer utilisé
- ✅ HTTPS requis
- ✅ Validation côté client (6+ chars pour MDP)
- ✅ Pas de log des tokens
- ✅ Champs MDP obscurcis
- ✅ Toggles pour afficher/masquer
- ✅ Pas de mots de passe en plaintext

---

## 📊 Performance Notes

- FutureBuilder pour async operations
- Pas de setState inutiles
- Images avatars gérées avec error handling
- Alerts history optionnelle (peut être paginée)
- Token cacheé (pas de requête à chaque fois)

---

## 🔄 Dépendances

```pubspec.yaml
dependencies:
  - flutter (existant)
  - http (pour ApiService)
  - shared_preferences (pour token storage)
  - material (pour UI)
```

Tous déjà installés ✓

---

## 📞 Support

Fichiers de documentation complète:
- `USER_PROFILE_IMPLEMENTATION.md` - Doc complète
- `IMPLEMENTATION_REPORT_USER_PROFILE.md` - Rapport détaillé
- Ce fichier - Quick reference

---

**Status**: ✅ Terminé - Prêt pour tests et production
**Compilation**: ✅ flutter analyze PASS
**Integration**: ✅ Complète dans HomePage
**Security**: ✅ Validée
