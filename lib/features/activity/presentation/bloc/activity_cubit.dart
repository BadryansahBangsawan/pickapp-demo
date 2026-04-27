import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/ui_error_message.dart';
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
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          isRefreshing: false,
          errorMessage: mapUiErrorMessage(
            error,
            fallbackMessage: 'Gagal memuat riwayat pesanan. Coba lagi.',
          ),
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

  void cancelOrder(String orderId) {
    final updated = state.orders.map((o) {
      if (o.id != orderId) return o;
      return OrderItem(
        id: o.id,
        serviceType: o.serviceType,
        title: o.title,
        subtitle: o.subtitle,
        status: OrderStatus.cancelled,
        amount: o.amount,
        createdAt: o.createdAt,
        driverName: o.driverName,
        driverPhone: o.driverPhone,
        driverPhoto: o.driverPhoto,
        vehicleInfo: o.vehicleInfo,
        rating: o.rating,
        items: o.items,
      );
    }).toList();
    emit(state.copyWith(orders: updated));
  }

  void completeOrder(String orderId) {
    final updated = state.orders.map((o) {
      if (o.id != orderId) return o;
      return OrderItem(
        id: o.id,
        serviceType: o.serviceType,
        title: o.title,
        subtitle: o.subtitle,
        status: OrderStatus.completed,
        amount: o.amount,
        createdAt: o.createdAt,
        driverName: o.driverName,
        driverPhone: o.driverPhone,
        driverPhoto: o.driverPhoto,
        vehicleInfo: o.vehicleInfo,
        rating: 5.0,
        items: o.items,
      );
    }).toList();
    emit(state.copyWith(orders: updated));
  }
}
