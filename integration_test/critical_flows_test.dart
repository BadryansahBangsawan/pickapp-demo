import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:pickup/features/notification/presentation/bloc/notification_cubit.dart';
import 'package:pickup/features/payment/presentation/bloc/wallet_cubit.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('critical flow: wallet top up updates balance and history', (
    tester,
  ) async {
    final walletCubit = WalletCubit();
    addTearDown(walletCubit.close);

    await tester.pump(const Duration(milliseconds: 700));
    final startingBalance = walletCubit.state.balance;

    await walletCubit.topUp(amount: 50000, methodId: 'bca');
    await tester.pump(const Duration(seconds: 3));

    expect(walletCubit.state.balance, greaterThan(startingBalance));
    expect(walletCubit.state.transactions.first.title, 'Top Up PickPay');
  });

  testWidgets('critical flow: mark all notifications as read', (tester) async {
    final notificationCubit = NotificationCubit();
    addTearDown(notificationCubit.close);

    await tester.pump(const Duration(milliseconds: 700));
    expect(notificationCubit.state.unreadCount, greaterThan(0));

    notificationCubit.markAllAsRead();
    await tester.pump();

    expect(notificationCubit.state.unreadCount, 0);
  });
}
