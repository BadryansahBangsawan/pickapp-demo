import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pickup/features/activity/presentation/bloc/activity_cubit.dart';

void main() {
  group('ActivityCubit', () {
    blocTest<ActivityCubit, ActivityState>(
      'loadOrders emits loaded state with orders',
      build: () => ActivityCubit(),
      wait: const Duration(seconds: 1),
      verify: (cubit) {
        expect(cubit.state.isLoading, false);
        expect(cubit.state.orders, isNotEmpty);
        expect(cubit.state.hasError, false);
        expect(cubit.state.selectedTab, 0);
      },
    );

    blocTest<ActivityCubit, ActivityState>(
      'ongoingOrders and completedOrders partition correctly',
      build: () => ActivityCubit(),
      wait: const Duration(seconds: 1),
      verify: (cubit) {
        final ongoing = cubit.state.ongoingOrders;
        final completed = cubit.state.completedOrders;
        expect(ongoing.every((o) => o.isOngoing), true);
        expect(completed.every((o) => !o.isOngoing), true);
        expect(
          ongoing.length + completed.length,
          cubit.state.orders.length,
        );
      },
    );

    blocTest<ActivityCubit, ActivityState>(
      'switchTab changes selectedTab',
      build: () => ActivityCubit(),
      act: (cubit) async {
        await Future<void>.delayed(const Duration(seconds: 1));
        cubit.switchTab(1);
      },
      wait: const Duration(seconds: 2),
      verify: (cubit) {
        expect(cubit.state.selectedTab, 1);
      },
    );
  });
}
