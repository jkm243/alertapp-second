# 🚀 DÉMARRAGE RAPIDE - 5 MINUTES

## ⚡ Les 4 commandes essentielles

### 1️⃣ Démarrer le serveur Django (Terminal 1)
```powershell
cd H:\Coding\Flutter\alert-app-backend\Alert-app
python manage.py migrate
python manage.py runserver
```

### 2️⃣ Vérifier la connexion (Terminal 2 - optionnel)
```powershell
cd h:\Coding\Flutter\alert-app
dart run test_complete_app_user.dart
```

### 3️⃣ Lancer l'app Flutter (Terminal 3)
```powershell
cd h:\Coding\Flutter\alert-app
flutter run -t lib/main_user.dart
```

### 4️⃣ Se connecter dans l'app
```
Email: jkm243@yandex.ru
Mot de passe: Kinshasa243
```

---

## ✅ C'est tout!

L'app devrait maintenant être opérationnelle avec:
- ✅ 4 onglets (Carte, Alertes, Profil, Paramètres)
- ✅ Bouton "Signaler une alerte"
- ✅ Liste des alertes
- ✅ Création d'alerte en 3 étapes

---

## 🆘 En cas d'erreur

| Erreur | Solution |
|--------|----------|
| Connection refused | Django n'est pas lancé: `python manage.py runserver` |
| "no such table" | Migrations non appliquées: `python manage.py migrate` |
| Login échoue | Email ou mot de passe incorrect |
| Port 8000 occupé | `netstat -ano \| findstr 8000` puis tuer le process |

---

## 📚 Pour plus de détails

- **Guide complet**: [REINTEGRATION_USER_APP_GUIDE.md](REINTEGRATION_USER_APP_GUIDE.md)
- **Checklist**: [REINTEGRATION_APP_USER_CHECKLIST.md](REINTEGRATION_APP_USER_CHECKLIST.md)
- **Index**: [DOCUMENTATION_INDEX.md](DOCUMENTATION_INDEX.md)

---

**Créé**: 2025-12-19
**Status**: 🟢 Prêt à fonctionner
