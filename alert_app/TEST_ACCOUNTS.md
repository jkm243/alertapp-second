# Comptes de Test pour le Développement

Ces comptes peuvent être utilisés pour tester les trois applications (User, Admin, Supervisor).

## 📱 APP USER

**Email:** `dev.user@test.com`  
**Mot de passe:** `devuser123`  
**Rôle:** User

## 👨‍💼 APP ADMIN

**Email:** `dev.admin@test.com`  
**Mot de passe:** `devadmin123`  
**Rôle:** Admin

## 👮 APP SUPERVISOR

**Email:** `dev.supervisor@test.com`  
**Mot de passe:** `devsuper123`  
**Rôle:** Operator (Supervisor)

---

## Notes

- Si ces comptes n'existent pas encore dans la base de données, vous pouvez les créer via l'interface d'inscription de chaque application.
- Les mots de passe respectent les exigences minimales (6 caractères minimum).
- Ces comptes sont destinés uniquement au développement et aux tests.

## Création via Script

Pour créer ces comptes automatiquement, exécutez :

```bash
dart scripts/create_test_accounts.dart
```

Si le script rencontre des timeouts, créez les comptes manuellement via l'interface d'inscription de chaque application.

