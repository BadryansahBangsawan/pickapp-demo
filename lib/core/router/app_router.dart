import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/setup_profile_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/main_shell.dart';
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
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.otp,
        builder: (context, state) => const OtpScreen(),
      ),
      GoRoute(
        path: RouteNames.setupProfile,
        builder: (context, state) => const SetupProfileScreen(),
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
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PlaceholderTabScreen(title: 'Activity', icon: Icons.receipt_long_outlined),
            ),
          ),
          GoRoute(
            path: RouteNames.payment,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PlaceholderTabScreen(title: 'PickPay', icon: Icons.account_balance_wallet_outlined),
            ),
          ),
          GoRoute(
            path: RouteNames.chat,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PlaceholderTabScreen(title: 'Chat', icon: Icons.chat_bubble_outline),
            ),
          ),
          GoRoute(
            path: RouteNames.profile,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PlaceholderTabScreen(title: 'Akun', icon: Icons.person_outline),
            ),
          ),
        ],
      ),
    ],
  );

  String? _redirect(BuildContext context, GoRouterState state) {
    final status = _authBloc.state.status;
    final loc = state.uri.path;

    final atSplash = loc == RouteNames.splash;
    final atAuthFlow = loc == RouteNames.onboarding ||
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
