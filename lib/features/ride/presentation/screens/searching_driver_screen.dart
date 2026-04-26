import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/pickup_app_bar.dart';
import '../../../../core/widgets/pickup_button.dart';
import '../models/ride_models.dart';

class SearchingDriverScreen extends StatefulWidget {
  const SearchingDriverScreen({super.key, required this.quote});

  final RideQuote quote;

  @override
  State<SearchingDriverScreen> createState() => _SearchingDriverScreenState();
}

class _SearchingDriverScreenState extends State<SearchingDriverScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), _onDriverFound);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onDriverFound() {
    if (!mounted) return;
    final quote = widget.quote.copyWith(driver: defaultRideDriver);
    context.go(RouteNames.tracking, extra: quote);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PickupAppBar(title: 'Mencari Driver', bottomBorder: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: Column(
            children: [
              const Spacer(),
              SizedBox(
                height: 220,
                child: Lottie.asset(
                  AppAssets.lottieSearchingDriver,
                  fit: BoxFit.contain,
                  repeat: true,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.radar_outlined,
                        size: 92,
                        color: AppColors.primary,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.base),
              const Text(
                'Sedang mencari driver terdekat...',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Biasanya butuh 5-15 detik. Mohon tunggu sebentar ya.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const Spacer(),
              PickupButton(
                label: 'Batalkan Pencarian',
                variant: PickupButtonVariant.secondary,
                onPressed: () => context.pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
