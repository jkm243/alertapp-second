
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
