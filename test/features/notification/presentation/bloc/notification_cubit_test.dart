import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pickup/features/notification/presentation/bloc/notification_cubit.dart';

void main() {
  group('NotificationCubit', () {
    blocTest<NotificationCubit, NotificationState>(
      'loadNotifications emits loaded state with notifications',
      build: () => NotificationCubit(),
      wait: const Duration(seconds: 1),
      verify: (cubit) {
        expect(cubit.state.isLoading, false);
        expect(cubit.state.notifications, isNotEmpty);
        expect(cubit.state.hasError, false);
      },
    );

    blocTest<NotificationCubit, NotificationState>(
      'unreadCount reflects unread notifications',
      build: () => NotificationCubit(),
      wait: const Duration(seconds: 1),
      verify: (cubit) {
        final unread =
            cubit.state.notifications.where((n) => !n.isRead).length;
        expect(cubit.state.unreadCount, unread);
        expect(unread, greaterThan(0));
      },
    );

    blocTest<NotificationCubit, NotificationState>(
      'markAsRead marks a single notification as read',
      build: () => NotificationCubit(),
      act: (cubit) async {
        await Future<void>.delayed(const Duration(seconds: 1));
        final firstUnread = cubit.state.notifications.firstWhere(
          (n) => !n.isRead,
        );
        cubit.markAsRead(firstUnread.id);
      },
      wait: const Duration(seconds: 2),
      verify: (cubit) {
        // Started with 2 unread (notif-1, notif-2), marked one = 1 unread
        expect(cubit.state.unreadCount, 1);
      },
    );

    blocTest<NotificationCubit, NotificationState>(
      'markAllAsRead sets all notifications to read',
      build: () => NotificationCubit(),
      act: (cubit) async {
        await Future<void>.delayed(const Duration(seconds: 1));
        cubit.markAllAsRead();
      },
      wait: const Duration(seconds: 2),
      verify: (cubit) {
        expect(cubit.state.unreadCount, 0);
        expect(cubit.state.notifications.every((n) => n.isRead), true);
      },
    );
  });
}
