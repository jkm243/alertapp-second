# Contributing to Alert App

This project uses a single repository to hold three app entry points: user, admin, supervisor. Each role has a dedicated entry point (`lib/main_*.dart`) and a dedicated app folder under `lib/apps/` for role-specific pages.

How to run apps from the repo root:

- User app (default):
```powershell
flutter run
```

- Admin app:
```powershell
flutter run -t lib/main_admin.dart
```

- Supervisor app:
```powershell
flutter run -t lib/main_supervisor.dart
```

Directory layout and responsibilities:

- `lib/apps/user/` — Pages and role-specific widgets for the User app. Imports shared pages and services where useful.
- `lib/apps/admin/` — Admin app pages and custom components (e.g., `admin_home.dart`).
- `lib/apps/supervisor/` — Supervisor pages and components (e.g., `supervisor_home.dart`).
- `lib/pages/` — Shared pages (onboarding, auth, permissions) used across multiple apps.
- `lib/services/`, `lib/models/`, `lib/config/`, `lib/widgets/`, `lib/design_system/` — Shared modules used by all three apps.

Guidance for creating role-specific pages:
1. If a page is specific to a role (e.g., Admin dashboard), add it to `lib/apps/<role>/pages/` and import shared services.
2. Keep common pages in `lib/pages/` so they can be reused across apps.
3. Avoid duplicating services; prefer shared `lib/services` and only add role-specific methods in their own service wrappers if necessary.


PR checklist:
- Run `dart format .` and `flutter analyze`
- Add or update `api_models.dart` and run `build_runner` when changing models
- Add unit tests in `test/` for business logic
- When changing endpoints, update `ApiConfig` and `ApiService`

Notes:
- UI strings are French — maintain them unless localization is added.
- Services are instantiated locally; if switching to DI, update pages accordingly.
