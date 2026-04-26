# Pick Up - Implementation Checklist

## Pre-Development Setup

- [ ] Rename project dari `demo_pick` ke `pickup` di pubspec.yaml
- [ ] Setup folder structure sesuai `04_architecture.md`
- [ ] Install semua dependencies
- [ ] Setup `app_theme.dart` sesuai design system
- [ ] Setup `app_colors.dart`, `app_typography.dart`, `app_spacing.dart`
- [ ] Setup GoRouter dengan semua route names
- [ ] Setup Dio API client dengan interceptor
- [ ] Buat core widgets (button, text field, card, app bar)
- [ ] Setup Firebase project (auth, firestore, storage, messaging)
- [ ] Setup Google Maps API key (Android & iOS)
- [ ] Prepare assets folder (icons, illustrations, lottie)

## Sprint 1: Auth & Home

### Auth
- [ ] Splash screen dengan logo animation
- [ ] Onboarding (3 slides dengan PageView)
- [ ] Login screen (phone input + social login buttons)
- [ ] OTP verification screen (6 digit input, timer, resend)
- [ ] Auth BLoC (send OTP, verify OTP, check auth state)
- [ ] Setup profile screen (untuk user baru)
- [ ] Persistent login (secure storage untuk token)

### Home
- [ ] Home screen layout
- [ ] Service grid widget
- [ ] Promo banner carousel (auto-scroll)
- [ ] Recent orders section
- [ ] Nearby restaurants section (horizontal scroll)
- [ ] Search bar (navigasi ke search screen)
- [ ] Bottom navigation bar (5 tabs)

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
