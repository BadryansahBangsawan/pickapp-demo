import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'core/network/api_client.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/datasources/auth_local_datasource.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/activity/presentation/bloc/activity_cubit.dart';
import 'features/chat/presentation/bloc/chat_cubit.dart';
import 'features/food/presentation/bloc/cart_cubit.dart';
import 'features/notification/presentation/bloc/notification_cubit.dart';
import 'features/payment/presentation/bloc/wallet_cubit.dart';
import 'features/profile/presentation/bloc/profile_cubit.dart';

class PickUpApp extends StatefulWidget {
  const PickUpApp({super.key});

  @override
  State<PickUpApp> createState() => _PickUpAppState();
}

class _PickUpAppState extends State<PickUpApp> {
  late final AuthBloc _authBloc;
  late final CartCubit _cartCubit;
  late final ChatCubit _chatCubit;
  late final ProfileCubit _profileCubit;
  late final WalletCubit _walletCubit;
  late final ActivityCubit _activityCubit;
  late final NotificationCubit _notificationCubit;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    const storage = FlutterSecureStorage();
    final apiClient = ApiClient.create(storage: storage);

    final authRepo = AuthRepositoryImpl(
      remote: AuthRemoteDataSource(apiClient),
      local: AuthLocalDataSource(storage),
      useMock: true, // toggle off when backend is wired
    );
    _authBloc = AuthBloc(authRepo);
    _cartCubit = CartCubit();
    _chatCubit = ChatCubit();
    _profileCubit = ProfileCubit();
    _walletCubit = WalletCubit();
    _activityCubit = ActivityCubit();
    _notificationCubit = NotificationCubit();
    _appRouter = AppRouter(_authBloc);
  }

  @override
  void dispose() {
    _authBloc.close();
    _cartCubit.close();
    _chatCubit.close();
    _profileCubit.close();
    _walletCubit.close();
    _activityCubit.close();
    _notificationCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider.value(value: _cartCubit),
        BlocProvider.value(value: _chatCubit),
        BlocProvider.value(value: _profileCubit),
        BlocProvider.value(value: _walletCubit),
        BlocProvider.value(value: _activityCubit),
        BlocProvider.value(value: _notificationCubit),
      ],
      child: MaterialApp.router(
        title: 'Pick Up',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: _appRouter.router,
      ),
    );
  }
}
