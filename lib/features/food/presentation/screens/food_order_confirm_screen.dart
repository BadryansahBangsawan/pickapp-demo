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

class FoodOrderConfirmScreen extends StatefulWidget {
  const FoodOrderConfirmScreen({super.key});

  @override
  State<FoodOrderConfirmScreen> createState() => _FoodOrderConfirmScreenState();
}

class _FoodOrderConfirmScreenState extends State<FoodOrderConfirmScreen> {
  String _payment = 'Tunai';
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PickupAppBar(
        title: 'Konfirmasi Pesanan',
        bottomBorder: true,
      ),
      body: SafeArea(
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, cart) {
            if (cart.items.isEmpty) {
              return const Center(child: Text('Keranjang kosong'));
            }

            return Padding(
              padding: const EdgeInsets.all(AppSpacing.base),
              child: Column(
                children: [
                  PickupCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Alamat Pengantaran',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Text(
                          'Jl. Merdeka Raya No. 8, Bekasi',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  PickupCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Metode Pembayaran',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        DropdownMenu<String>(
                          initialSelection: _payment,
                          width: double.infinity,
                          dropdownMenuEntries: const [
                            DropdownMenuEntry(value: 'Tunai', label: 'Tunai'),
                            DropdownMenuEntry(
                              value: 'PickPay',
                              label: 'PickPay',
                            ),
                            DropdownMenuEntry(
                              value: 'Kartu Debit',
                              label: 'Kartu Debit',
                            ),
                          ],
                          onSelected: (v) =>
                              setState(() => _payment = v ?? 'Tunai'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  PickupCard(
                    child: TextField(
                      controller: _notesCtrl,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Catatan untuk restoran/driver',
                        hintText: 'Contoh: sambal dipisah',
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  PickupCard(
                    child: Row(
                      children: [
                        const Text(
                          'Total Bayar',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const Spacer(),
                        Text(
                          Formatters.currency(cart.total),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  PickupButton(
                    label: 'Konfirmasi Pesanan',
                    onPressed: () => context.go(RouteNames.foodTracking),
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
