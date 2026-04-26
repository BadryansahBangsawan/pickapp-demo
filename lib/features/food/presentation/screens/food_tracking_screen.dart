import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/pickup_app_bar.dart';
import '../../../../core/widgets/pickup_button.dart';
import '../../../ride/presentation/widgets/map_widget.dart';
import '../bloc/cart_cubit.dart';

class FoodTrackingScreen extends StatefulWidget {
  const FoodTrackingScreen({super.key});

  @override
  State<FoodTrackingScreen> createState() => _FoodTrackingScreenState();
}

class _FoodTrackingScreenState extends State<FoodTrackingScreen> {
  int _step = 2;

  static const _steps = <String>[
    'Pesanan diterima',
    'Makanan disiapkan',
    'Driver mengambil pesanan',
    'Dalam perjalanan',
    'Pesanan sampai',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PickupAppBar(title: 'Tracking Pesanan', bottomBorder: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: Column(
            children: [
              const RideMapWidget(
                height: 220,
                pickupLabel: 'Restoran',
                destinationLabel: 'Alamatmu',
              ),
              const SizedBox(height: AppSpacing.base),
              Expanded(
                child: ListView.builder(
                  itemCount: _steps.length,
                  itemBuilder: (context, i) {
                    final done = i <= _step;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        done
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: done ? AppColors.primary : AppColors.textHint,
                      ),
                      title: Text(_steps[i]),
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: PickupButton(
                      label: _step >= _steps.length - 1
                          ? 'Selesai'
                          : 'Update Status (Mock)',
                      onPressed: () {
                        if (_step >= _steps.length - 1) {
                          context.read<CartCubit>().clear();
                          context.go(RouteNames.home);
                          return;
                        }
                        setState(() => _step += 1);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
