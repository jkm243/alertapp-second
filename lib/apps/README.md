# Multi-App Structure

This directory contains three role-specific app folders; each app shares common code in `lib/`:

- `lib/apps/user/` — User-specific components and pages
- `lib/apps/admin/` — Admin-specific components and pages
- `lib/apps/supervisor/` — Supervisor-specific components and pages

Shared code (services, models, design system) remains under the top-level `lib/` directory. This lets each app reuse functionality and keep custom UI or UX separate.

### Running apps
- Default / User: `flutter run`
- Admin: `flutter run -t lib/main_admin.dart`
- Supervisor: `flutter run -t lib/main_supervisor.dart`