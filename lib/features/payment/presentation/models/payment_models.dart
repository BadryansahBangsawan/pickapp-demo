import 'package:equatable/equatable.dart';

// ──────────────────── Payment Method ────────────────────

enum PaymentMethodType { wallet, bankTransfer, creditCard, eWallet }

class PaymentMethod extends Equatable {
  const PaymentMethod({
    required this.id,
    required this.type,
    required this.label,
    required this.detail,
    this.iconName = 'account_balance_wallet',
    this.isDefault = false,
  });

  final String id;
  final PaymentMethodType type;
  final String label;
  final String detail;
  final String iconName;
  final bool isDefault;

  PaymentMethod copyWith({bool? isDefault}) {
    return PaymentMethod(
      id: id,
      type: type,
      label: label,
      detail: detail,
      iconName: iconName,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  List<Object?> get props => [id, type, label, detail, iconName, isDefault];
}

// ──────────────────── Transaction ────────────────────

enum TransactionType { topUp, payment, transfer, refund, cashback }

enum TransactionStatus { success, pending, failed }

class Transaction extends Equatable {
  const Transaction({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final TransactionType type;
  final String title;
  final String subtitle;
  final int amount;
  final TransactionStatus status;
  final DateTime createdAt;

  bool get isCredit =>
      type == TransactionType.topUp ||
      type == TransactionType.refund ||
      type == TransactionType.cashback;

  @override
  List<Object?> get props =>
      [id, type, title, subtitle, amount, status, createdAt];
}

// ���─────────────────── Top-Up Nominal ────��───────────────

class TopUpNominal {
  const TopUpNominal(this.amount, {this.bonus = 0});
  final int amount;
  final int bonus;
}

const topUpNominals = <TopUpNominal>[
  TopUpNominal(20000),
  TopUpNominal(50000),
  TopUpNominal(100000, bonus: 5000),
  TopUpNominal(200000, bonus: 15000),
  TopUpNominal(500000, bonus: 50000),
  TopUpNominal(1000000, bonus: 120000),
];

// ──────────────────── Top-Up Source Method ────────────────────

class TopUpMethod extends Equatable {
  const TopUpMethod({
    required this.id,
    required this.label,
    required this.subtitle,
    this.iconName = 'account_balance',
  });

  final String id;
  final String label;
  final String subtitle;
  final String iconName;

  @override
  List<Object?> get props => [id, label, subtitle, iconName];
}

const defaultTopUpMethods = <TopUpMethod>[
  TopUpMethod(
    id: 'bca',
    label: 'BCA Virtual Account',
    subtitle: 'Verifikasi otomatis',
    iconName: 'account_balance',
  ),
  TopUpMethod(
    id: 'bni',
    label: 'BNI Virtual Account',
    subtitle: 'Verifikasi otomatis',
    iconName: 'account_balance',
  ),
  TopUpMethod(
    id: 'mandiri',
    label: 'Mandiri Virtual Account',
    subtitle: 'Verifikasi otomatis',
    iconName: 'account_balance',
  ),
  TopUpMethod(
    id: 'gopay',
    label: 'GoPay',
    subtitle: 'Saldo langsung masuk',
    iconName: 'qr_code',
  ),
  TopUpMethod(
    id: 'ovo',
    label: 'OVO',
    subtitle: 'Saldo langsung masuk',
    iconName: 'qr_code',
  ),
];

// ──────────────────── Mock Data ────────────────────

const defaultPaymentMethods = <PaymentMethod>[
  PaymentMethod(
    id: 'pm-1',
    type: PaymentMethodType.wallet,
    label: 'PickPay',
    detail: 'Saldo utama',
    iconName: 'account_balance_wallet',
    isDefault: true,
  ),
  PaymentMethod(
    id: 'pm-2',
    type: PaymentMethodType.bankTransfer,
    label: 'BCA',
    detail: '•••• 4821',
    iconName: 'account_balance',
  ),
  PaymentMethod(
    id: 'pm-3',
    type: PaymentMethodType.eWallet,
    label: 'GoPay',
    detail: 'Terhubung',
    iconName: 'qr_code',
  ),
  PaymentMethod(
    id: 'pm-4',
    type: PaymentMethodType.creditCard,
    label: 'Visa',
    detail: '••��• 9012',
    iconName: 'credit_card',
  ),
];

List<Transaction> buildMockTransactions() {
  final now = DateTime.now();
  return [
    Transaction(
      id: 'tx-1',
      type: TransactionType.topUp,
      title: 'Top Up PickPay',
      subtitle: 'BCA Virtual Account',
      amount: 200000,
      status: TransactionStatus.success,
      createdAt: now.subtract(const Duration(hours: 2)),
    ),
    Transaction(
      id: 'tx-2',
      type: TransactionType.payment,
      title: 'PickRide - Motor',
      subtitle: 'Jl. Sudirman → Jl. Thamrin',
      amount: 25000,
      status: TransactionStatus.success,
      createdAt: now.subtract(const Duration(hours: 5)),
    ),
    Transaction(
      id: 'tx-3',
      type: TransactionType.payment,
      title: 'PickFood - Warung Bu Tini',
      subtitle: '2 items',
      amount: 45000,
      status: TransactionStatus.success,
      createdAt: now.subtract(const Duration(days: 1)),
    ),
    Transaction(
      id: 'tx-4',
      type: TransactionType.cashback,
      title: 'Cashback PickFood',
      subtitle: 'Promo akhir pekan',
      amount: 5000,
      status: TransactionStatus.success,
      createdAt: now.subtract(const Duration(days: 1, hours: 1)),
    ),
    Transaction(
      id: 'tx-5',
      type: TransactionType.topUp,
      title: 'Top Up PickPay',
      subtitle: 'GoPay',
      amount: 100000,
      status: TransactionStatus.success,
      createdAt: now.subtract(const Duration(days: 2)),
    ),
    Transaction(
      id: 'tx-6',
      type: TransactionType.payment,
      title: 'PickSend - Paket Kecil',
      subtitle: 'Bekasi → Jakarta Selatan',
      amount: 18000,
      status: TransactionStatus.success,
      createdAt: now.subtract(const Duration(days: 3)),
    ),
    Transaction(
      id: 'tx-7',
      type: TransactionType.refund,
      title: 'Refund PickFood',
      subtitle: 'Pesanan dibatalkan restoran',
      amount: 32000,
      status: TransactionStatus.success,
      createdAt: now.subtract(const Duration(days: 4)),
    ),
    Transaction(
      id: 'tx-8',
      type: TransactionType.topUp,
      title: 'Top Up PickPay',
      subtitle: 'BNI Virtual Account',
      amount: 500000,
      status: TransactionStatus.pending,
      createdAt: now.subtract(const Duration(days: 5)),
    ),
  ];
}
