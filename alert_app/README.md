
# alert_app

This repository contains a Flutter application split into three role-specific apps that share the same codebase. The three roles are:

- User (default) — entrypoint: `lib/main.dart`
- Admin — entrypoint: `lib/main_admin.dart`
- Supervisor — entrypoint: `lib/main_supervisor.dart`

## Running the apps

Run the default user app:

```powershell
flutter run
```

Run the admin app:
## Pushing to a remote repository

If you want to push local changes to a remote Git repo, use the script in `.github/scripts/push_changes.ps1`.

Example:

```powershell
powershell -ExecutionPolicy Bypass -File .github/scripts/push_changes.ps1 -RemoteUrl 'https://github.com/jkm243/alertapp-second.git' -Branch 'feature/role-split' -CommitMessage 'Add role-based apps and Supervisor features'
```

If you prefer manual steps:

```powershell
git remote add origin https://github.com/jkm243/alertapp-second.git
git checkout -b feature/role-split
git add -A
git commit -m "Add role-based apps and Supervisor features"
git push --set-upstream origin feature/role-split
```


```powershell
flutter run -t lib/main_admin.dart
```

Run the supervisor app:

```powershell
flutter run -t lib/main_supervisor.dart
```

## Developer workflows

- Install dependencies: `flutter pub get`
- Build generated models: `flutter pub run build_runner build --delete-conflicting-outputs`
- Analyze: `flutter analyze`
- Format: `dart format .`
- Tests: `flutter test`

The high-level architecture remains the same: UI in `lib/pages` talks to `lib/services` which call the API configured in `lib/config/api_config.dart`.

## Contributing
See `.github/CONTRIBUTING.md` for repository-specific contribution rules and guidelines.
