import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../models/payment_models.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.isCredit;
    final amountText =
        '${isCredit ? '+' : '-'} ${Formatters.currency(transaction.amount)}';
    final amountColor = isCredit ? AppColors.success : AppColors.textPrimary;

    return Padding(
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
              color: _iconBgColor,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            alignment: Alignment.center,
            child: Icon(_icon, size: 20, color: _iconColor),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${transaction.subtitle} · ${Formatters.relative(transaction.createdAt)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amountText,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: amountColor,
                ),
              ),
              if (transaction.status == TransactionStatus.pending)
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.badgeWarningBg,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: const Text(
                    'Pending',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.badgeWarningText,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  IconData get _icon {
    switch (transaction.type) {
      case TransactionType.topUp:
        return Icons.add_circle_outline;
      case TransactionType.payment:
        return Icons.shopping_bag_outlined;
      case TransactionType.transfer:
        return Icons.swap_horiz;
      case TransactionType.refund:
        return Icons.replay;
      case TransactionType.cashback:
        return Icons.local_offer_outlined;
    }
  }

  Color get _iconColor {
    switch (transaction.type) {
      case TransactionType.topUp:
        return AppColors.primary;
      case TransactionType.payment:
        return AppColors.badgeInfoText;
      case TransactionType.transfer:
        return AppColors.badgeWarningText;
      case TransactionType.refund:
        return AppColors.success;
      case TransactionType.cashback:
        return AppColors.primary;
    }
  }

  Color get _iconBgColor {
    switch (transaction.type) {
      case TransactionType.topUp:
        return AppColors.badgeSuccessBg;
      case TransactionType.payment:
        return AppColors.badgeInfoBg;
      case TransactionType.transfer:
        return AppColors.badgeWarningBg;
      case TransactionType.refund:
        return AppColors.badgeSuccessBg;
      case TransactionType.cashback:
        return AppColors.badgeSuccessBg;
    }
  }
}
