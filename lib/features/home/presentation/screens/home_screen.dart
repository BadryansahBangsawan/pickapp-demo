import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/route_names.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../widgets/nearby_restaurants.dart';
import '../widgets/promo_banner.dart';
import '../widgets/recent_orders.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/service_grid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: _Header()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.base,
                  AppSpacing.md,
                  AppSpacing.base,
                  AppSpacing.lg,
                ),
                child: SearchBarWidget(
                  onTap: () => context.push(RouteNames.pickLocation),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.base,
                ),
                child: ServiceGrid(items: _serviceItems(context)),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.base,
                ),
                child: PromoBanner(slides: _promoSlides),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
            const SliverToBoxAdapter(child: RecentOrders(items: _recentOrders)),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
            const SliverToBoxAdapter(child: NearbyRestaurants(items: _nearby)),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final user = context.select<AuthBloc, String?>((b) => b.state.user?.name);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.base,
        AppSpacing.md,
        AppSpacing.base,
        0,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: AppColors.textPrimary),
            onPressed: () {},
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, ${user ?? 'teman Pick Up'} 👋',
                  style: AppTypography.bodyMedium,
                ),
                const Text(
                  'Mau pakai layanan apa hari ini?',
                  style: AppTypography.small,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.textPrimary,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.qr_code_scanner_outlined,
              color: AppColors.textPrimary,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

List<ServiceItem> _serviceItems(BuildContext context) => [
  ServiceItem(
    icon: Icons.two_wheeler_outlined,
    label: 'PickRide',
    color: const Color(0xFF00C853),
    onTap: () => context.push(RouteNames.pickLocation),
  ),
  ServiceItem(
    icon: Icons.local_shipping_outlined,
    label: 'PickSend',
    color: const Color(0xFFFF9500),
    onTap: () => context.push(RouteNames.sendPackage),
  ),
  ServiceItem(
    icon: Icons.restaurant_outlined,
    label: 'PickFood',
    color: const Color(0xFFE91E63),
    onTap: () => context.push(RouteNames.foodHome),
  ),
  ServiceItem(
    icon: Icons.shopping_basket_outlined,
    label: 'PickMart',
    color: const Color(0xFF1976D2),
    onTap: () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PickMart masuk fase berikutnya.')),
      );
    },
  ),
  ServiceItem(
    icon: Icons.account_balance_wallet_outlined,
    label: 'PickPay',
    color: const Color(0xFF9C27B0),
    onTap: () => context.go(RouteNames.payment),
  ),
  ServiceItem(
    icon: Icons.more_horiz,
    label: 'Lainnya',
    color: AppColors.textSecondary,
    onTap: () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Menu tambahan akan segera hadir.')),
      );
    },
  ),
];

const _promoSlides = <PromoSlide>[
  PromoSlide(
    title: 'Diskon 50% PickRide',
    subtitle: 'Berlaku untuk perjalanan pertamamu',
    color: Color(0xFF00C853),
  ),
  PromoSlide(
    title: 'Cashback PickFood',
    subtitle: 'Setiap pesan di atas Rp 50.000',
    color: Color(0xFFE91E63),
  ),
  PromoSlide(
    title: 'Top Up Gratis Admin',
    subtitle: 'Top up minimal Rp 100.000',
    color: Color(0xFF1976D2),
  ),
];

const _recentOrders = <RecentOrderItem>[
  RecentOrderItem(
    label: 'Kantor',
    address: 'Jl. Jend. Sudirman No. 12, Jakarta',
  ),
  RecentOrderItem(label: 'Rumah', address: 'Jl. Merdeka Raya No. 8, Bekasi'),
];

const _nearby = <NearbyRestaurantItem>[
  NearbyRestaurantItem(
    name: 'Warung Bu Tini',
    cuisine: 'Indonesian • Nasi Padang',
    rating: 4.8,
    distanceKm: 0.6,
  ),
  NearbyRestaurantItem(
    name: 'Ramen Sora',
    cuisine: 'Japanese • Ramen',
    rating: 4.7,
    distanceKm: 1.2,
  ),
  NearbyRestaurantItem(
    name: 'Burger Bar',
    cuisine: 'Western • Burger',
    rating: 4.6,
    distanceKm: 1.5,
  ),
  NearbyRestaurantItem(
    name: 'Kopi Kenangan',
    cuisine: 'Coffee • Drinks',
    rating: 4.9,
    distanceKm: 0.4,
  ),
];
