import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/pickup_app_bar.dart';
import '../../../../core/widgets/pickup_button.dart';
import '../../../../core/widgets/pickup_card.dart';
import '../bloc/wallet_cubit.dart';
import '../models/payment_models.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({super.key});

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  int? _selectedAmount;
  String _selectedMethodId = defaultTopUpMethods.first.id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: const PickupAppBar(title: 'Top Up PickPay'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.base),
                children: [
                  Text('Pilih Nominal', style: AppTypography.h3),
                  const SizedBox(height: AppSpacing.md),
                  _buildNominalGrid(),
                  const SizedBox(height: AppSpacing.xl),
                  Text('Metode Pembayaran', style: AppTypography.h3),
                  const SizedBox(height: AppSpacing.md),
                  ..._buildMethodList(),
                ],
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildNominalGrid() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.4,
      children: topUpNominals.map((nominal) {
        final selected = _selectedAmount == nominal.amount;
        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() => _selectedAmount = nominal.amount);
          },
          child: Container(
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : AppColors.background,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.border,
                width: selected ? 2 : 1,
              ),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Formatters.currency(nominal.amount),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                if (nominal.bonus > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      '+${Formatters.currency(nominal.bonus)}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? Colors.white70
                            : AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  List<Widget> _buildMethodList() {
    return defaultTopUpMethods.map((method) {
      final isSelected = _selectedMethodId == method.id;
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: PickupCard(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() => _selectedMethodId = method.id);
          },
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
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                alignment: Alignment.center,
                child: Icon(
                  method.iconName == 'qr_code'
                      ? Icons.qr_code
                      : Icons.account_balance,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.label,
                      style: AppTypography.bodyMedium.copyWith(fontSize: 15),
                    ),
                    Text(method.subtitle, style: AppTypography.small),
                  ],
                ),
              ),
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isSelected ? AppColors.primary : AppColors.textHint,
                size: 22,
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildBottomBar() {
    final canSubmit = _selectedAmount != null;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: const BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BlocConsumer<WalletCubit, WalletState>(
        listenWhen: (prev, curr) =>
            prev.isTopUpProcessing && !curr.isTopUpProcessing,
        listener: (context, state) {
          if (!state.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Top up berhasil!'),
                backgroundColor: AppColors.success,
              ),
            );
            context.pop();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Top up gagal'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_selectedAmount != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total top up', style: AppTypography.caption),
                      Text(
                        Formatters.currency(_selectedAmount!),
                        style: AppTypography.h3,
                      ),
                    ],
                  ),
                ),
              PickupButton(
                label: 'Top Up Sekarang',
                isLoading: state.isTopUpProcessing,
                onPressed: canSubmit
                    ? () => context.read<WalletCubit>().topUp(
                          amount: _selectedAmount!,
                          methodId: _selectedMethodId,
                        )
                    : null,
              ),
            ],
          );
        },
      ),
    );
  }
}
