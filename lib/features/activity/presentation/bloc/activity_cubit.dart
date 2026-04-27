import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/activity_models.dart';

class ActivityState extends Equatable {
  const ActivityState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.errorMessage,
    this.orders = const <OrderItem>[],
    this.selectedTab = 0,
  });

  final bool isLoading;
  final bool isRefreshing;
  final String? errorMessage;
  final List<OrderItem> orders;
  final int selectedTab;

  bool get hasError => (errorMessage ?? '').isNotEmpty;

  List<OrderItem> get ongoingOrders =>
      orders.where((o) => o.isOngoing).toList();

  List<OrderItem> get completedOrders =>
      orders.where((o) => !o.isOngoing).toList();

  ActivityState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    String? errorMessage,
    bool clearError = false,
    List<OrderItem>? orders,
    int? selectedTab,
  }) {
    return ActivityState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      orders: orders ?? this.orders,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isRefreshing,
    errorMessage,
    orders,
    selectedTab,
  ];
}

class ActivityCubit extends Cubit<ActivityState> {
  ActivityCubit() : super(const ActivityState()) {
    loadOrders();
  }

  Future<void> loadOrders({bool refresh = false}) async {
    if ((state.isLoading || state.isRefreshing) && !refresh) return;

    emit(
      state.copyWith(
        isLoading: !refresh,
        isRefreshing: refresh,
        clearError: true,
      ),
    );

    try {
      await Future<void>.delayed(const Duration(milliseconds: 600));
      final orders = buildMockOrders();
      emit(
        state.copyWith(
          isLoading: false,
          isRefreshing: false,
          orders: orders,
          clearError: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          isRefreshing: false,
          errorMessage: 'Gagal memuat riwayat pesanan. Coba lagi.',
        ),
      );
    }
  }

  Future<void> refreshOrders() async {
    await loadOrders(refresh: true);
  }

  void switchTab(int index) {
    emit(state.copyWith(selectedTab: index));
  }
}
