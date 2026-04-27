import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pickup/features/payment/presentation/bloc/wallet_cubit.dart';
import 'package:pickup/features/payment/presentation/models/payment_models.dart';

void main() {
  group('WalletCubit', () {
    blocTest<WalletCubit, WalletState>(
      'loadWallet emits loaded state with balance and transactions',
      build: () => WalletCubit(),
      wait: const Duration(seconds: 1),
      verify: (cubit) {
        expect(cubit.state.isLoading, false);
        expect(cubit.state.balance, 347000);
        expect(cubit.state.transactions, isNotEmpty);
        expect(cubit.state.hasError, false);
      },
    );

    blocTest<WalletCubit, WalletState>(
      'topUp increases balance and prepends transaction',
      build: () => WalletCubit(),
      act: (cubit) async {
        await Future<void>.delayed(const Duration(seconds: 1));
        await cubit.topUp(amount: 100000, methodId: 'bca');
      },
      wait: const Duration(seconds: 4),
      verify: (cubit) {
        // 347000 + 100000 + 5000 bonus = 452000
        expect(cubit.state.balance, 452000);
        expect(cubit.state.transactions.first.type, TransactionType.topUp);
        expect(cubit.state.isTopUpProcessing, false);
      },
    );

    blocTest<WalletCubit, WalletState>(
      'setDefaultPaymentMethod updates default flag',
      build: () => WalletCubit(),
      act: (cubit) async {
        await Future<void>.delayed(const Duration(seconds: 1));
        cubit.setDefaultPaymentMethod('pm-2');
      },
      wait: const Duration(seconds: 2),
      verify: (cubit) {
        final defaultMethod = cubit.state.paymentMethods.firstWhere(
          (m) => m.isDefault,
        );
        expect(defaultMethod.id, 'pm-2');
      },
    );

    blocTest<WalletCubit, WalletState>(
      'removePaymentMethod removes the method',
      build: () => WalletCubit(),
      act: (cubit) async {
        await Future<void>.delayed(const Duration(seconds: 1));
        cubit.removePaymentMethod('pm-3');
      },
      wait: const Duration(seconds: 2),
      verify: (cubit) {
        expect(
          cubit.state.paymentMethods.any((m) => m.id == 'pm-3'),
          false,
        );
      },
    );
  });
}
