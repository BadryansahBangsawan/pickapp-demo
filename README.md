# Pick Up (`pickapp-demo`)

Flutter demo for an on-demand services app: **ride**, **food**, and **send**, with activity history and notifications.

> Package name in `pubspec.yaml` is `pickup`. This repo is a UI/architecture demo — not a production backend.

## Features (demo)

- **Food**: restaurant list, detail, cart (Cubit), order confirm, live tracking screen
- **Activity**: past/current orders with detail views
- **Home shell**: bottom navigation via `go_router`
- **Notifications**: in-app notification list (mock-friendly)

State uses `flutter_bloc` / Cubits; routing uses `go_router`. Maps/location and Firebase packages are wired for future integration.

## Prerequisites

- Flutter SDK matching `environment.sdk` in `pubspec.yaml` (currently `^3.11.5`)
- Platform toolchains for the target you run (`ios`, `android`, `macos`, `web`, …)

## Run

```bash
flutter pub get
flutter run
```

Pick a device/simulator when prompted. For a specific platform:

```bash
flutter run -d macos
# or: chrome, iPhone, etc.
```

## Project layout

```
lib/features/   # feature modules (food, activity, home, notification, …)
plan/           # product/architecture notes (overview, flows, checklist)
test/           # unit/widget tests
integration_test/
```

See `plan/01_app_overview.md` and `plan/04_architecture.md` for intended structure.

## Notes

- `publish_to: 'none'` — not published to pub.dev
- Many network/Firebase calls are scaffolded; screens can run with local/mock data
- Assets expected under `assets/images/`, `assets/icons/`, `assets/lottie/` (create empty dirs if missing before first run)
