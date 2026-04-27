import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/pickup_app_bar.dart';
import '../../../../core/widgets/pickup_card.dart';
import '../../../../core/widgets/pickup_empty_state.dart';
import '../bloc/wallet_cubit.dart';
import '../models/payment_models.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: const PickupAppBar(title: 'Metode Pembayaran'),
      body: BlocBuilder<WalletCubit, WalletState>(
        builder: (context, state) {
          if (state.paymentMethods.isEmpty) {
            return const PickupEmptyState(
              title: 'Belum ada metode pembayaran',
              message: 'Tambahkan kartu, e-wallet, atau rekening bank.',
              icon: Icons.credit_card_outlined,
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.base),
            itemCount: state.paymentMethods.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final method = state.paymentMethods[index];
              return _PaymentMethodTile(method: method);
            },
          );
        },
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({required this.method});

  final PaymentMethod method;

  IconData get _icon {
    switch (method.iconName) {
      case 'account_balance_wallet':
        return Icons.account_balance_wallet_outlined;
      case 'account_balance':
        return Icons.account_balance_outlined;
      case 'credit_card':
        return Icons.credit_card_outlined;
      case 'qr_code':
        return Icons.qr_code;
      default:
        return Icons.payment_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PickupCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: method.isDefault
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            alignment: Alignment.center,
            child: Icon(
              _icon,
              size: 20,
              color: method.isDefault
                  ? AppColors.primary
                  : AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      method.label,
                      style:
                          AppTypography.bodyMedium.copyWith(fontSize: 15),
                    ),
                    if (method.isDefault) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.badgeSuccessBg,
                          borderRadius:
                              BorderRadius.circular(AppRadius.full),
                        ),
                        child: const Text(
                          'Utama',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.badgeSuccessText,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(method.detail, style: AppTypography.small),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              HapticFeedback.selectionClick();
              final cubit = context.read<WalletCubit>();
              if (value == 'default') {
                cubit.setDefaultPaymentMethod(method.id);
              } else if (value == 'remove') {
                cubit.removePaymentMethod(method.id);
              }
            },
            itemBuilder: (context) => [
              if (!method.isDefault)
                const PopupMenuItem(
                  value: 'default',
                  child: Text('Jadikan Utama'),
                ),
              if (method.type != PaymentMethodType.wallet)
                const PopupMenuItem(
                  value: 'remove',
                  child: Text('Hapus', style: TextStyle(color: AppColors.error)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
