# Pick Up - Implementation Checklist

## Status Terakhir (Current Progress)

Progress terakhir sudah sampai:

- **Step 1 — Pre-Development Setup**: selesai
- **Step 2 — Sprint 1: Auth & Home**: selesai
- Bagian yang memang ditunda karena butuh konfigurasi manual tetap ditandai terpisah

## Pre-Development Setup

- [x] Rename project dari `demo_pick` ke `pickup` di pubspec.yaml
- [x] Setup folder structure sesuai `04_architecture.md`
- [x] Install dependencies inti (BLoC, GoRouter, Dio, Maps, Firebase, secure storage, pin code, lottie, dll)
- [x] Setup `app_theme.dart` sesuai design system (Material 3, putih, hijau #00C853, button 52, radius 12)
- [x] Setup `app_colors.dart`, `app_typography.dart`, `app_spacing.dart`, `app_assets.dart`, `api_endpoints.dart`
- [x] Setup GoRouter + ShellRoute + auth redirect + route names
- [x] Setup Dio API client + interceptor + error mapper
- [x] Buat core widgets (button, text field, card, app bar)
- [x] Setup validator & formatter (locale `id_ID`)

### Ditunda (Manual Configuration)

- [ ] Setup Firebase project (`firebase init`, `google-services.json`, `GoogleService-Info.plist`)
- [ ] Setup Google Maps API key (Android Manifest + iOS AppDelegate)
- [ ] Ganti native bundle ID (masih `com.example.demo_pick`)
- [ ] Finalisasi file asset aktual (SVG, JSON lottie, logo PNG)

## Sprint 1: Auth & Home

### Auth
- [x] Splash screen dengan logo animation 1.2s
- [x] Onboarding (3 slides + smooth indicator)
- [x] Login screen (phone +62 + placeholder Google/Apple)
- [x] OTP verification screen (pin code 6 digit + timer 60s + resend)
- [x] Auth BLoC (send OTP, verify OTP, check auth state)
- [x] Setup profile screen (untuk user baru)
- [x] Persistent login (`flutter_secure_storage` untuk token, bukan SharedPreferences)
- [x] Mock mode OTP (`useMock=true`, OTP: `123456`)

### Home
- [x] Home screen layout
- [x] Service grid widget (3 kolom)
- [x] Promo banner carousel (auto-scroll 4 detik)
- [x] Recent orders section
- [x] Nearby restaurants section (horizontal scroll)
- [x] Search bar (navigasi ke search screen)
- [x] Main shell + bottom navigation bar (5 tabs)

## Sprint 2: PickRide

- [ ] Location search screen (autocomplete)
- [ ] Pick location on map screen
- [ ] Saved places integration
- [ ] Choose ride screen (map + route + options)
- [ ] Price estimation API call
- [ ] Payment method selector bottom sheet
- [ ] Searching driver screen (Lottie animation)
- [ ] Driver found - info card
- [ ] Live tracking screen (map + driver marker)
- [ ] WebSocket connection untuk real-time location
- [ ] Ride complete screen (rating + tip)
- [ ] SOS button
- [ ] Share trip link

## Sprint 3: PickFood

- [ ] Food home screen (categories + restaurant list)
- [ ] Restaurant card widget
- [ ] Category filter chips
- [ ] Search restoran & makanan
- [ ] Restaurant detail screen (info + menu)
- [ ] Menu item detail bottom sheet
- [ ] Add to cart logic (BLoC)
- [ ] Cart screen (items, qty, total)
- [ ] Cart badge on bottom sheet
- [ ] Food order confirmation screen
- [ ] Food tracking screen (status stepper + map)

## Sprint 4: Payment & Activity

### Payment
- [ ] Wallet screen (balance + actions + history)
- [ ] Top up screen (amount input + payment method)
- [ ] Top up flow dengan Midtrans/Xendit
- [ ] Transaction history list
- [ ] Payment method management

### Activity
- [ ] Activity screen (tabs: ongoing / completed)
- [ ] Order card widget
- [ ] Order detail screen
- [ ] Receipt view

### Notifications
- [ ] FCM setup (Android & iOS)
- [ ] Notification center screen
- [ ] Push notification handling (foreground & background)
- [ ] Deep linking dari notification

## Sprint 5: Chat & Profile

### Chat
- [ ] Chat list screen
- [ ] Chat room screen
- [ ] Message bubble widget
- [ ] Quick reply chips
- [ ] WebSocket real-time chat
- [ ] Image sharing (optional)

### Profile
- [ ] Profile screen (header + menu)
- [ ] Edit profile screen (name, photo, email)
- [ ] Photo picker & upload
- [ ] Saved addresses screen (CRUD)
- [ ] Settings screen (language, notification toggle)
- [ ] Help & FAQ screen
- [ ] Logout flow

## Sprint 6: PickSend & Polish

### PickSend
- [ ] Send package screen (pickup & delivery address)
- [ ] Package detail screen (size selector, photo, notes)
- [ ] Send tracking screen

### Polish
- [ ] Shimmer loading untuk semua list screens
- [ ] Empty state illustrations
- [ ] Error handling screens (no internet, server error)
- [ ] Pull to refresh
- [ ] Smooth page transitions
- [ ] Haptic feedback pada button press
- [ ] App icon & splash screen asset
- [ ] Performance profiling & optimization
- [ ] Unit tests (BLoC, repository, use cases)
- [ ] Widget tests (core widgets)
- [ ] Integration tests (critical flows)

---

## Post-Launch
- [ ] Analytics (Firebase Analytics / Mixpanel)
- [ ] Crashlytics
- [ ] A/B testing
- [ ] Dark mode
- [ ] Multi-language (l10n)
- [ ] PickMart feature
- [ ] PickService feature
- [ ] Driver app
- [ ] Admin dashboard
