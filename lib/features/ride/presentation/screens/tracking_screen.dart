import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/pickup_app_bar.dart';
import '../../../../core/widgets/pickup_button.dart';
import '../models/ride_models.dart';
import '../widgets/driver_info_card.dart';
import '../widgets/map_widget.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key, required this.quote});

  final RideQuote quote;

  void _shareTrip(BuildContext context) async {
    const link = 'https://pickup.app/mock/trip/PKUP-001';
    await Clipboard.setData(const ClipboardData(text: link));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link perjalanan disalin ke clipboard.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final driver = quote.driver ?? defaultRideDriver;

    return Scaffold(
      appBar: const PickupAppBar(title: 'Live Tracking', bottomBorder: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    RideMapWidget(
                      pickupLabel: quote.pickup.address,
                      destinationLabel: quote.destination.address,
                      height: double.infinity,
                    ),
                    Positioned(
                      top: AppSpacing.base,
                      left: AppSpacing.base,
                      right: AppSpacing.base,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: const Text(
                          'Driver menuju titik jemput (ETA 4 menit)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: AppSpacing.base,
                      right: AppSpacing.base,
                      bottom: AppSpacing.base,
                      child: DriverInfoCard(driver: driver),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.base),
              Row(
                children: [
                  Expanded(
                    child: _ActionTile(
                      icon: Icons.chat_bubble_outline,
                      label: 'Chat',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Fitur chat menyusul.')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _ActionTile(
                      icon: Icons.phone_outlined,
                      label: 'Telepon',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Fitur telepon menyusul.'),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _ActionTile(
                      icon: Icons.share_outlined,
                      label: 'Share Trip',
                      onTap: () => _shareTrip(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: PickupButton(
                      label: 'SOS',
                      variant: PickupButtonVariant.secondary,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('SOS mock aktif.')),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    flex: 2,
                    child: PickupButton(
                      label: 'Selesaikan Perjalanan',
                      onPressed: () =>
                          context.push(RouteNames.rideComplete, extra: quote),
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

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Container(
            constraints: const BoxConstraints(
              minHeight: AppTouchTarget.minimum,
            ),
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Column(
              children: [
                Icon(icon, color: AppColors.primary),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
