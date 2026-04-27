import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/ui_error_message.dart';
import '../models/payment_models.dart';

enum WalletHistoryFilter { purchases, all }

class WalletState extends Equatable {
  const WalletState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.errorMessage,
    this.balance = 0,
    this.transactions = const <Transaction>[],
    this.paymentMethods = defaultPaymentMethods,
    this.isTopUpProcessing = false,
    this.historyFilter = WalletHistoryFilter.purchases,
  });

  final bool isLoading;
  final bool isRefreshing;
  final String? errorMessage;
  final int balance;
  final List<Transaction> transactions;
  final List<PaymentMethod> paymentMethods;
  final bool isTopUpProcessing;
  final WalletHistoryFilter historyFilter;

  bool get hasError => (errorMessage ?? '').isNotEmpty;

  List<Transaction> get purchaseTransactions => transactions
      .where(
        (tx) =>
            tx.type == TransactionType.payment ||
            tx.type == TransactionType.refund ||
            tx.type == TransactionType.cashback,
      )
      .toList();

  List<Transaction> get visibleTransactions =>
      historyFilter == WalletHistoryFilter.purchases
      ? purchaseTransactions
      : transactions;

  WalletState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    String? errorMessage,
    bool clearError = false,
    int? balance,
    List<Transaction>? transactions,
    List<PaymentMethod>? paymentMethods,
    bool? isTopUpProcessing,
    WalletHistoryFilter? historyFilter,
  }) {
    return WalletState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      isTopUpProcessing: isTopUpProcessing ?? this.isTopUpProcessing,
      historyFilter: historyFilter ?? this.historyFilter,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isRefreshing,
    errorMessage,
    balance,
    transactions,
    paymentMethods,
    isTopUpProcessing,
    historyFilter,
  ];
}

class WalletCubit extends Cubit<WalletState> {
  WalletCubit() : super(const WalletState()) {
    loadWallet();
  }

  Future<void> loadWallet({bool refresh = false}) async {
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
      final transactions = buildMockTransactions();
      emit(
        state.copyWith(
          isLoading: false,
          isRefreshing: false,
          balance: 347000,
          transactions: transactions,
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
            fallbackMessage: 'Gagal memuat data wallet. Coba lagi.',
          ),
        ),
      );
    }
  }

  Future<void> refreshWallet() async {
    await loadWallet(refresh: true);
  }

  Future<void> topUp({required int amount, required String methodId}) async {
    emit(state.copyWith(isTopUpProcessing: true, clearError: true));

    try {
      await Future<void>.delayed(const Duration(seconds: 2));

      final method = defaultTopUpMethods.firstWhere(
        (m) => m.id == methodId,
        orElse: () => defaultTopUpMethods.first,
      );

      final nominal = topUpNominals.where((n) => n.amount == amount);
      final bonus = nominal.isEmpty ? 0 : nominal.first.bonus;
      final totalCredit = amount + bonus;

      final newTx = Transaction(
        id: 'tx-${DateTime.now().microsecondsSinceEpoch}',
        type: TransactionType.topUp,
        title: 'Top Up PickPay',
        subtitle: method.label,
        amount: totalCredit,
        status: TransactionStatus.success,
        createdAt: DateTime.now(),
      );

      emit(
        state.copyWith(
          isTopUpProcessing: false,
          balance: state.balance + totalCredit,
          transactions: [newTx, ...state.transactions],
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isTopUpProcessing: false,
          errorMessage: mapUiErrorMessage(
            error,
            fallbackMessage: 'Top up gagal. Coba lagi.',
          ),
        ),
      );
    }
  }

  void setDefaultPaymentMethod(String methodId) {
    final updated = state.paymentMethods
        .map((m) => m.copyWith(isDefault: m.id == methodId))
        .toList();
    emit(state.copyWith(paymentMethods: updated));
  }

  void removePaymentMethod(String methodId) {
    final updated = state.paymentMethods
        .where((m) => m.id != methodId)
        .toList();
    emit(state.copyWith(paymentMethods: updated));
  }

  void setHistoryFilter(WalletHistoryFilter filter) {
    emit(state.copyWith(historyFilter: filter));
  }
}
