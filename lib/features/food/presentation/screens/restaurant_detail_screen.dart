import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/pickup_app_bar.dart';
import '../../../../core/widgets/pickup_button.dart';
import '../bloc/cart_cubit.dart';
import '../models/food_models.dart';
import '../widgets/menu_item_tile.dart';

class RestaurantDetailScreen extends StatelessWidget {
  const RestaurantDetailScreen({super.key, required this.restaurant});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    final menus = mockMenus
        .where((m) => m.restaurantId == restaurant.id)
        .toList();

    return Scaffold(
      appBar: const PickupAppBar(title: 'Detail Restoran', bottomBorder: true),
      body: SafeArea(
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: restaurant.imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Container(
                height: 180,
                color: AppColors.surface,
                alignment: Alignment.center,
                child: const Icon(Icons.restaurant_outlined, size: 48),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.base),
                children: [
                  Text(
                    restaurant.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${restaurant.category} · ${restaurant.deliveryMinutes} menit · ${restaurant.distanceKm.toStringAsFixed(1)} km',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const Text(
                    'Menu Pilihan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ...menus.map(
                    (menu) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: MenuItemTile(
                        item: menu,
                        onTap: () => _showMenuDetail(context, menu),
                        onAdd: () {
                          context.read<CartCubit>().addItem(menu);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${menu.name} ditambahkan ke keranjang.',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 92),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(
          AppSpacing.base,
          AppSpacing.sm,
          AppSpacing.base,
          AppSpacing.base,
        ),
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, cart) {
            return PickupButton(
              label: cart.totalItems > 0
                  ? 'Lihat Keranjang (${cart.totalItems})'
                  : 'Keranjang Masih Kosong',
              onPressed: cart.totalItems > 0
                  ? () => context.push(RouteNames.cart)
                  : null,
            );
          },
        ),
      ),
    );
  }

  Future<void> _showMenuDetail(BuildContext context, MenuItem menu) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.base,
              AppSpacing.base,
              AppSpacing.base,
              AppSpacing.xl,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  menu.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(menu.description),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  Formatters.currency(menu.price),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.base),
                PickupButton(
                  label: 'Tambah ke Keranjang',
                  onPressed: () {
                    context.read<CartCubit>().addItem(menu);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
