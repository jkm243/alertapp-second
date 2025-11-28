# Copilot / AI Agent Instructions for Alert App

This file gives an AI agent the immediate context and rules to be productive in this Flutter repo.

Summary
- Purpose: Flutter mobile app for user alerts; auth-backed REST API integration at `lib/services`.
- Big Picture: UI pages in `lib/pages` call local services in `lib/services`, which call the remote API via `ApiService`. Models are defined in `lib/models` and generated using `json_serializable` (build_runner).

Quick entry points
-- App start(s):
  - User: `lib/main.dart` (default) or `lib/main_user.dart` for explicit entry
  - Admin: `lib/main_admin.dart`
  - Supervisor: `lib/main_supervisor.dart`
- API integration: `lib/services/api_service.dart`, `lib/config/api_config.dart`.
 - API integration: `lib/services/api_service.dart`, `lib/config/api_config.dart`.
 - Role-specific services: `lib/services/supervisor_service.dart` contains supervisor-specific logic (alerts, drone missions, video attach mock). Add a `lib/services/admin_service.dart` if you need admin server endpoints later.
- Auth & state: `lib/services/authentication_service.dart`.
- Models: `lib/models/api_models.dart` (generated file `api_models.g.dart`).
- UI: `lib/pages/*` and reusable components in `lib/widgets`.

Conventions & patterns (repo-specific)
- Config lives in `ApiConfig` (baseUrl, endpoints, headers, tokens). Always update `ApiConfig` when endpoints change.
- Models use `json_serializable`. Add model classes to `api_models.dart` and run the generator (see workflow).
- Error handling: `ApiService` throws `ApiError` from `_handleHttpError` and `_handleNetworkError`. When consuming service methods, catch `ApiError` explicitly to provide user-friendly messages (see `AuthenticationService`).
- Authentication state: `AuthenticationService` uses `SharedPreferences` keys (constants in `ApiConfig`). Instances are commonly created inline (e.g., `AuthenticationService()`), not injected via DI.
- UI messages are in French; preserve language choices when modifying UX text.
- The design system lives under `lib/design_system`—use `PrimaryButton`, `TextLink`, etc., for consistent UI.

Per-app structure
- The repo supports 3 role apps living together under `lib/apps/` (e.g., `lib/apps/user`, `lib/apps/admin`, `lib/apps/supervisor`).
- Shared pages should stay in `lib/pages/`; role-specific pages should be placed under `lib/apps/<role>/` to keep them separate.
- Use shared services/models under `lib/services/`, `lib/models/` and `lib/config/` — avoid copying those folders into per-app directories.
 - The authentication flow is shared via `AuthenticationService` — role-specific pages use it and validate role after login. Use the role parameter when signing up (e.g., `role: 'Admin'` or `role: 'Supervisor'`).

How to add a role-specific page (example)
1. Create a page file: `lib/apps/admin/pages/user_management.dart`.
2. Import shared services (e.g., `import '../../../services/api_service.dart';`) and models from `lib/models`.
3. Add a route to `lib/main_admin.dart`:

```dart
routes: {
  '/users': (context) => const UserManagementPage(),
},
```
4. Register your new page on the admin home page if necessary.

Developer workflows (commands you should use)
- Get deps: `flutter pub get`
- Code generation (JSON model generation):
  - `flutter pub run build_runner build --delete-conflicting-outputs`
- Run app: `flutter run` (or `flutter run -d <device>`)
- Run a specific role app: `flutter run -t lib/main_admin.dart` or `flutter run -t lib/main_supervisor.dart`
- Build: `flutter build apk` / `flutter build ios` / `flutter build web`
- Analyze: `flutter analyze`
- Tests: `flutter test` (only `test/widget_test.dart` exists currently)
- Format: `dart format .`

Testing & debugging
- Manual API tests: `lib/services/api_test.dart` and UI widget `ApiTestWidget` (`lib/widgets/api_test_widget.dart`) — note these call `print()` and use snackbars. `TestPage` runs tests and notifies via snackbars.
- If you change models or endpoints, update `api_models.dart` and run the `build_runner` command.
- Use `flutter run --verbose` to see console logs and `print`/`debugPrint` outputs.

Patterns for adding a new API endpoint
1. Add DTO model(s) to `lib/models/api_models.dart` and annotate with `@JsonSerializable()`.
2. Run `flutter pub run build_runner build --delete-conflicting-outputs`.
3. Add a new method to `ApiService` in `lib/services/api_service.dart` using `ApiConfig` endpoints and `_defaultHeaders`/`_getAuthHeaders`.
4. Add higher-level integration in `AuthenticationService` or other `services/` if state persistence or validation is needed.
5. Add a small UI or extend `api_test.dart`/`ApiTestWidget` for manual testing; add a unit test under `test/` if possible.

Important notes & caveats
- There are discrepancies between some documentation and code: e.g., `API_INTEGRATION.md`, `API_TESTING_GUIDE.md`, and `INTEGRATION_SUMMARY.md` sometimes use different endpoints (`/auth/*` vs `/users/*`) or reference `ApiTest` vs `ApiTestService`. Always trust `ApiConfig` and actual code for endpoints.
- No DI container / global provider: services are instantiated locally in pages. If you plan to refactor into a DI framework or Provider/riverpod, do it with corresponding changes in all pages.
- Keep `json_serializable` and `build_runner` in sync; generated `.g.dart` files are committed but regenerate on change.
- Preserve French UI strings and error messages unless localization strategy is implemented.

Examples
- Adding a login call (see `lib/services/api_service.dart`). Use `ApiConfig`, build with `Uri.parse('${ApiConfig.baseUrl}${ApiConfig.loginEndpoint}')`, and handle `ApiError`.
- Using the API test widget: `lib/widgets/api_test_widget.dart` appears in the `HomePage` settings tab. Use it to manually trigger `ApiTestService` tests.

When in doubt
- Reference the actual code first (not `*.md` docs) for behavior; update docs as you change functionality.
- Run `flutter pub run build_runner build --delete-conflicting-outputs` after model changes.
- If adding or changing an endpoint, run the API test utilities and `flutter analyze`.

Gotchas & mismatches to watch for
- Docs (`API_INTEGRATION.md`, `API_TESTING_GUIDE.md`, `INTEGRATION_SUMMARY.md`) sometimes show different endpoints or method names than the code (e.g., `/auth/*` vs `/users/*` and `ApiTest` vs `ApiTestService`). The code is authoritative: prefer `ApiConfig` and `ApiService`.
- The code uses `print()` for API test output and snackbars for UI feedback; some docs claim popups or richer UI. Verify UI behavior by running the app.

Manual API test instructions (quick)
1. Run the app in debug mode:

```powershell
flutter pub get;
flutter run
```

2. In the running app, navigate to the **Paramètres** / **Settings** tab (Home Page) and use the `ApiTestWidget` or open the `TestPage` (menu route) to trigger API tests.

3. Check console output (or Snackbars) for test results.

Automated integration tests
- There is an integration test at `test/api_integration_test.dart` which attempts real API calls for login and token verification.
- To run this test locally, set environment variables for test credentials first:

```powershell
$env:API_TEST_EMAIL='test@example.com';
$env:API_TEST_PASSWORD='TestPassword123!';
flutter pub get;
flutter test test/api_integration_test.dart -r expanded
```

- In CI you can enable the integration test by adding `API_TEST_EMAIL` and `API_TEST_PASSWORD` to repository secrets. The workflow will run the integration test only if these secrets are present.

Contributing guidance & PR checklist
- Run `dart format .` and `flutter analyze` locally before opening PRs.
- When changing or adding models, regenerate the `.g.dart` with `flutter pub run build_runner build --delete-conflicting-outputs` and include generated files in PR.
- Update `ApiConfig` if endpoint paths or baseUrl change and double-check `ApiService` call sites.
- Preserve French UI strings unless explicitly working on localization.
- Add unit tests in `test/` for new services or helper logic when possible.
- If you update user-facing or API behavior, update `API_INTEGRATION.md`/`API_TESTING_GUIDE.md`/`INTEGRATION_SUMMARY.md`.


Please ping maintainers or request clarification in PRs for any API contract changes, design-system updates, or user-visible text changes.

---
Do you want me to: 1) incorporate more specifics (examples of code lines), 2) add additional command snippets, or 3) update/merge any existing documentation discrepancies? 
