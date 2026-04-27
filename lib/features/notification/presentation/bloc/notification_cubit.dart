import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/notification_models.dart';

class NotificationState extends Equatable {
  const NotificationState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.errorMessage,
    this.notifications = const <AppNotification>[],
  });

  final bool isLoading;
  final bool isRefreshing;
  final String? errorMessage;
  final List<AppNotification> notifications;

  bool get hasError => (errorMessage ?? '').isNotEmpty;

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  NotificationState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    String? errorMessage,
    bool clearError = false,
    List<AppNotification>? notifications,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  List<Object?> get props => [isLoading, isRefreshing, errorMessage, notifications];
}

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(const NotificationState()) {
    loadNotifications();
  }

  Future<void> loadNotifications({bool refresh = false}) async {
    if ((state.isLoading || state.isRefreshing) && !refresh) return;

    emit(
      state.copyWith(
        isLoading: !refresh,
        isRefreshing: refresh,
        clearError: true,
      ),
    );

    try {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      final notifications = buildMockNotifications();
      emit(
        state.copyWith(
          isLoading: false,
          isRefreshing: false,
          notifications: notifications,
          clearError: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          isRefreshing: false,
          errorMessage: 'Gagal memuat notifikasi. Coba lagi.',
        ),
      );
    }
  }

  Future<void> refreshNotifications() async {
    await loadNotifications(refresh: true);
  }

  void markAsRead(String notificationId) {
    final updated = state.notifications
        .map((n) => n.id == notificationId ? n.copyWith(isRead: true) : n)
        .toList();
    emit(state.copyWith(notifications: updated));
  }

  void markAllAsRead() {
    final updated =
        state.notifications.map((n) => n.copyWith(isRead: true)).toList();
    emit(state.copyWith(notifications: updated));
  }
}
