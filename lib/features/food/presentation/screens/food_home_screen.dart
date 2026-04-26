import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/pickup_app_bar.dart';
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
              Expanded(
                child: restaurants.isEmpty
                    ? const Center(
                        child: Text(
                          'Restoran tidak ditemukan',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      )
                    : ListView.separated(
                        itemCount: restaurants.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: AppSpacing.base),
                        itemBuilder: (context, i) {
                          final restaurant = restaurants[i];
                          return RestaurantCard(
                            restaurant: restaurant,
                            onTap: () => context.push(
                              RouteNames.restaurantDetail,
                              extra: restaurant,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
