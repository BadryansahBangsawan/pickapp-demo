import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/setup_profile_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/chat/presentation/models/chat_models.dart';
import '../../features/chat/presentation/screens/chat_list_screen.dart';
import '../../features/chat/presentation/screens/chat_room_screen.dart';
import '../../features/food/presentation/models/food_models.dart';
import '../../features/food/presentation/screens/cart_screen.dart';
import '../../features/food/presentation/screens/food_home_screen.dart';
import '../../features/food/presentation/screens/food_order_confirm_screen.dart';
import '../../features/food/presentation/screens/food_tracking_screen.dart';
import '../../features/food/presentation/screens/restaurant_detail_screen.dart';
import '../../features/activity/presentation/models/activity_models.dart';
import '../../features/activity/presentation/screens/activity_screen.dart';
import '../../features/activity/presentation/screens/order_detail_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/main_shell.dart';
import '../../features/notification/presentation/screens/notification_screen.dart';
import '../../features/payment/presentation/screens/payment_methods_screen.dart';
import '../../features/payment/presentation/screens/top_up_screen.dart';
import '../../features/payment/presentation/screens/wallet_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/help_faq_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/saved_addresses_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/ride/presentation/models/ride_models.dart';
import '../../features/ride/presentation/screens/choose_ride_screen.dart';
import '../../features/ride/presentation/screens/pick_location_screen.dart';
import '../../features/ride/presentation/screens/ride_complete_screen.dart';
import '../../features/ride/presentation/screens/searching_driver_screen.dart';
import '../../features/ride/presentation/screens/tracking_screen.dart';
import '../../features/send/presentation/models/send_models.dart';
import '../../features/send/presentation/screens/package_detail_screen.dart';
import '../../features/send/presentation/screens/send_package_screen.dart';
import '../../features/send/presentation/screens/send_tracking_screen.dart';
import 'route_names.dart';

class AppRouter {
  AppRouter(this._authBloc);

  final AuthBloc _authBloc;

  late final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    refreshListenable: _AuthListenable(_authBloc),
    redirect: _redirect,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SplashScreen()),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const OnboardingScreen()),
      ),
      GoRoute(
        path: RouteNames.login,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const LoginScreen()),
      ),
      GoRoute(
        path: RouteNames.otp,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const OtpScreen()),
      ),
      GoRoute(
        path: RouteNames.setupProfile,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const SetupProfileScreen()),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: RouteNames.home,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: RouteNames.activity,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ActivityScreen()),
          ),
          GoRoute(
            path: RouteNames.payment,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: WalletScreen()),
          ),
          GoRoute(
            path: RouteNames.chat,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ChatListScreen()),
          ),
          GoRoute(
            path: RouteNames.profile,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ProfileScreen()),
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.chatRoom,
        pageBuilder: (context, state) {
          final thread = state.extra is ChatThread
              ? state.extra as ChatThread
              : null;
          if (thread == null) {
            return _buildTransitionPage(state, const ChatListScreen());
          }
          return _buildTransitionPage(state, ChatRoomScreen(thread: thread));
        },
      ),
      GoRoute(
        path: RouteNames.pickLocation,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const PickLocationScreen()),
      ),
      GoRoute(
        path: RouteNames.chooseRide,
        pageBuilder: (context, state) => _buildTransitionPage(
          state,
          ChooseRideScreen(
            initialQuote: state.extra is RideQuote
                ? state.extra as RideQuote
                : null,
          ),
        ),
      ),
      GoRoute(
        path: RouteNames.searchingDriver,
        pageBuilder: (context, state) {
          final quote = state.extra is RideQuote
              ? state.extra as RideQuote
              : null;
          if (quote == null) {
            return _buildTransitionPage(state, const PickLocationScreen());
          }
          return _buildTransitionPage(
            state,
            SearchingDriverScreen(quote: quote),
          );
        },
      ),
      GoRoute(
        path: RouteNames.tracking,
        pageBuilder: (context, state) {
          final quote = state.extra is RideQuote
              ? state.extra as RideQuote
              : null;
          if (quote == null) {
            return _buildTransitionPage(state, const PickLocationScreen());
          }
          return _buildTransitionPage(state, TrackingScreen(quote: quote));
        },
      ),
      GoRoute(
        path: RouteNames.rideComplete,
        pageBuilder: (context, state) {
          final quote = state.extra is RideQuote
              ? state.extra as RideQuote
              : null;
          if (quote == null) {
            return _buildTransitionPage(state, const PickLocationScreen());
          }
          return _buildTransitionPage(state, RideCompleteScreen(quote: quote));
        },
      ),
      GoRoute(
        path: RouteNames.foodHome,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const FoodHomeScreen()),
      ),
      GoRoute(
        path: RouteNames.restaurantDetail,
        pageBuilder: (context, state) {
          final restaurant = state.extra is Restaurant
              ? state.extra as Restaurant
              : null;
          if (restaurant == null) {
            return _buildTransitionPage(state, const FoodHomeScreen());
          }
          return _buildTransitionPage(
            state,
            RestaurantDetailScreen(restaurant: restaurant),
          );
        },
      ),
      GoRoute(
        path: RouteNames.cart,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const CartScreen()),
      ),
      GoRoute(
        path: RouteNames.foodOrderConfirm,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const FoodOrderConfirmScreen()),
      ),
      GoRoute(
        path: RouteNames.foodTracking,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const FoodTrackingScreen()),
      ),
      GoRoute(
        path: RouteNames.sendPackage,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const SendPackageScreen()),
      ),
      GoRoute(
        path: RouteNames.packageDetail,
        pageBuilder: (context, state) {
          final draft = state.extra is SendDraft
              ? state.extra as SendDraft
              : null;
          if (draft == null) {
            return _buildTransitionPage(state, const SendPackageScreen());
          }
          return _buildTransitionPage(state, PackageDetailScreen(draft: draft));
        },
      ),
      GoRoute(
        path: RouteNames.sendTracking,
        pageBuilder: (context, state) {
          final order = state.extra is SendOrder
              ? state.extra as SendOrder
              : null;
          if (order == null) {
            return _buildTransitionPage(state, const SendPackageScreen());
          }
          return _buildTransitionPage(state, SendTrackingScreen(order: order));
        },
      ),
      GoRoute(
        path: RouteNames.editProfile,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const EditProfileScreen()),
      ),
      GoRoute(
        path: RouteNames.savedAddresses,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const SavedAddressesScreen()),
      ),
      GoRoute(
        path: RouteNames.settings,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const SettingsScreen()),
      ),
      GoRoute(
        path: RouteNames.helpFaq,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const HelpFaqScreen()),
      ),
      GoRoute(
        path: RouteNames.topUp,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const TopUpScreen()),
      ),
      GoRoute(
        path: RouteNames.paymentMethods,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const PaymentMethodsScreen()),
      ),
      GoRoute(
        path: RouteNames.orderDetail,
        pageBuilder: (context, state) {
          final order = state.extra is OrderItem
              ? state.extra as OrderItem
              : null;
          if (order == null) {
            return _buildTransitionPage(state, const ActivityScreen());
          }
          return _buildTransitionPage(
            state,
            OrderDetailScreen(order: order),
          );
        },
      ),
      GoRoute(
        path: RouteNames.notifications,
        pageBuilder: (context, state) =>
            _buildTransitionPage(state, const NotificationScreen()),
      ),
    ],
  );

  CustomTransitionPage<void> _buildTransitionPage(
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      transitionDuration: const Duration(milliseconds: 260),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        final offset = Tween<Offset>(
          begin: const Offset(0, 0.04),
          end: Offset.zero,
        ).animate(curve);

        return FadeTransition(
          opacity: curve,
          child: SlideTransition(position: offset, child: child),
        );
      },
    );
  }

  String? _redirect(BuildContext context, GoRouterState state) {
    final status = _authBloc.state.status;
    final loc = state.uri.path;

    final atSplash = loc == RouteNames.splash;
    final atAuthFlow =
        loc == RouteNames.onboarding ||
        loc == RouteNames.login ||
        loc == RouteNames.otp;
    final atSetup = loc == RouteNames.setupProfile;

    switch (status) {
      case AuthStatus.unknown:
        return atSplash ? null : RouteNames.splash;
      case AuthStatus.unauthenticated:
        if (atSplash || (!atAuthFlow && !atSetup)) return RouteNames.onboarding;
        if (atSetup) return RouteNames.onboarding;
        return null;
      case AuthStatus.otpSending:
      case AuthStatus.otpSent:
      case AuthStatus.otpVerifying:
      case AuthStatus.failure:
        return null;
      case AuthStatus.needsProfile:
        return atSetup ? null : RouteNames.setupProfile;
      case AuthStatus.authenticated:
        if (atSplash || atAuthFlow || atSetup) return RouteNames.home;
        return null;
    }
  }
}

class _AuthListenable extends ChangeNotifier {
  _AuthListenable(AuthBloc bloc) {
    _sub = bloc.stream.listen((_) => notifyListeners());
  }
  late final StreamSubscription<AuthState> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
