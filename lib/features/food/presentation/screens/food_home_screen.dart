import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/pickup_app_bar.dart';
import '../../../../core/widgets/pickup_empty_state.dart';
import '../../../../core/widgets/pickup_error_state.dart';
import '../../../../core/widgets/pickup_shimmer.dart';
import '../models/food_models.dart';
import '../widgets/category_chips.dart';
import '../widgets/restaurant_card.dart';

class FoodHomeScreen extends StatefulWidget {
  const FoodHomeScreen({super.key});

  @override
  State<FoodHomeScreen> createState() => _FoodHomeScreenState();
}

class _FoodHomeScreenState extends State<FoodHomeScreen> {
  String _selectedCategory = foodCategories.first;
  String _query = '';
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  List<Restaurant> get _filtered {
    return mockRestaurants.where((r) {
      final matchesCategory =
          _selectedCategory == 'Semua' || r.category == _selectedCategory;
      final q = _query.trim().toLowerCase();
      final matchesQuery =
          q.isEmpty ||
          r.name.toLowerCase().contains(q) ||
          r.category.toLowerCase().contains(q);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  Future<void> _loadInitial() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await Future<void>.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;
      setState(() => _loading = false);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Gagal memuat restoran. Coba lagi.';
      });
    }
  }

  Future<void> _refresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _error = null);
  }

  Widget _buildContent(List<Restaurant> restaurants) {
    if (_loading) return const _FoodHomeLoading();
    if (_error != null) {
      return PickupErrorState(
        title: 'Tidak bisa memuat restoran',
        message: _error!,
        onRetry: _loadInitial,
        icon: Icons.cloud_off_outlined,
      );
    }
    if (restaurants.isEmpty) {
      return const PickupEmptyState(
        title: 'Restoran tidak ditemukan',
        message: 'Coba kata kunci lain atau ganti kategori pencarian.',
        icon: Icons.storefront_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: restaurants.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppSpacing.base),
        itemBuilder: (context, i) {
          final restaurant = restaurants[i];
          return RestaurantCard(
            restaurant: restaurant,
            onTap: () =>
                context.push(RouteNames.restaurantDetail, extra: restaurant),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final restaurants = _filtered;

    return Scaffold(
      appBar: const PickupAppBar(title: 'PickFood', bottomBorder: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: Column(
            children: [
              TextField(
                onChanged: (value) => setState(() => _query = value),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Cari restoran atau makanan',
                ),
              ),
              const SizedBox(height: AppSpacing.base),
              FoodCategoryChips(
                categories: foodCategories,
                selected: _selectedCategory,
                onSelected: (v) => setState(() => _selectedCategory = v),
              ),
              const SizedBox(height: AppSpacing.base),
              Expanded(child: _buildContent(restaurants)),
            ],
          ),
        ),
      ),
    );
  }
}

class _FoodHomeLoading extends StatelessWidget {
  const _FoodHomeLoading();

  @override
  Widget build(BuildContext context) {
    return PickupListShimmer(
      itemCount: 5,
      itemBuilder: (context, index) => Container(
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: const [
            PickupShimmerBox(height: 68, width: 68, radius: AppRadius.md),
            SizedBox(width: AppSpacing.base),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PickupShimmerBox(height: 14, width: 150),
                  SizedBox(height: AppSpacing.sm),
                  PickupShimmerBox(height: 12, width: double.infinity),
                  SizedBox(height: AppSpacing.sm),
                  PickupShimmerBox(height: 12, width: 110),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
