import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/pickup_app_bar.dart';
import '../../../../core/widgets/pickup_button.dart';
import '../../../../core/widgets/pickup_card.dart';
import '../bloc/cart_cubit.dart';
import '../widgets/cart_item_tile.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PickupAppBar(title: 'Keranjang', bottomBorder: true),
      body: SafeArea(
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, cart) {
            if (cart.items.isEmpty) {
              return const Center(
                child: Text(
                  'Keranjang masih kosong',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(AppSpacing.base),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: cart.items.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, i) {
                        final item = cart.items[i];
                        return CartItemTile(
                          item: item,
                          onIncrement: () =>
                              context.read<CartCubit>().addItem(item.item),
                          onDecrement: () => context
                              .read<CartCubit>()
                              .decrementItem(item.item.id),
                          onRemove: () => context.read<CartCubit>().removeItem(
                            item.item.id,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.base),
                  PickupCard(
                    child: Column(
                      children: [
                        _SummaryRow(
                          label: 'Subtotal',
                          value: Formatters.currency(cart.subtotal),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _SummaryRow(
                          label: 'Biaya kirim',
                          value: Formatters.currency(cart.deliveryFee),
                        ),
                        const Divider(height: AppSpacing.xl),
                        _SummaryRow(
                          label: 'Total',
                          value: Formatters.currency(cart.total),
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.base),
                  PickupButton(
                    label: 'Lanjut Konfirmasi Pesanan',
                    onPressed: () => context.push(RouteNames.foodOrderConfirm),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  final String label;
  final String value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    final weight = isBold ? FontWeight.w700 : FontWeight.w500;
    return Row(
      children: [
        Text(label, style: TextStyle(fontWeight: weight)),
        const Spacer(),
        Text(value, style: TextStyle(fontWeight: weight)),
      ],
    );
  }
}
