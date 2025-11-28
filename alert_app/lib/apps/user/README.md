# User App

This folder contains user-facing pages and wrappers that are specific to the User application. Shared pages remain in `lib/pages/` and can be imported here.

How to add a user page:
1. Create `lib/apps/user/pages/<your_page>.dart`.
2. Import shared services and models from `lib/services/` and `lib/models/`.
3. Add the route to `lib/main_user.dart`.

Entrypoint: `lib/main_user.dart` — runs a user-oriented build of the app.