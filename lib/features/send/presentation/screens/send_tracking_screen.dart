import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/pickup_app_bar.dart';
import '../../../../core/widgets/pickup_button.dart';
import '../models/send_models.dart';

class SendTrackingScreen extends StatefulWidget {
  const SendTrackingScreen({super.key, required this.order});

  final SendOrder order;

  @override
  State<SendTrackingScreen> createState() => _SendTrackingScreenState();
}

class _SendTrackingScreenState extends State<SendTrackingScreen> {
  Timer? _timer;
  int _activeStep = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) return;
      if (_activeStep >= sendTrackingSteps.length - 1) {
        timer.cancel();
        return;
      }
      setState(() => _activeStep += 1);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool get _completed => _activeStep == sendTrackingSteps.length - 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PickupAppBar(title: 'Lacak PickSend', bottomBorder: true),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.base),
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.base),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Kode Tracking',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          widget.order.trackingCode,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Dibuat ${Formatters.dateTime(widget.order.createdAt)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    Formatters.currency(widget.order.fee),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.base),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Container(
                height: 190,
                color: AppColors.surface,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        'https://picsum.photos/seed/send-map/1200/700',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const Positioned(
                      left: 22,
                      top: 26,
                      child: Icon(
                        Icons.radio_button_checked,
                        color: AppColors.primary,
                        size: 30,
                      ),
                    ),
                    const Positioned(
                      right: 30,
                      bottom: 26,
                      child: Icon(
                        Icons.location_on,
                        color: AppColors.error,
                        size: 34,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.base),
            Container(
              padding: const EdgeInsets.all(AppSpacing.base),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Status Pengiriman',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: AppSpacing.base),
                  for (var i = 0; i < sendTrackingSteps.length; i++)
                    _TrackingStepItem(
                      title: sendTrackingSteps[i],
                      done: i <= _activeStep,
                      isLast: i == sendTrackingSteps.length - 1,
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            PickupButton(
              label: _completed ? 'Selesai' : 'Hubungi Kurir',
              onPressed: () {
                if (_completed) {
                  context.go(RouteNames.home);
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Kurir akan segera menghubungi Anda.'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackingStepItem extends StatelessWidget {
  const _TrackingStepItem({
    required this.title,
    required this.done,
    required this.isLast,
  });

  final String title;
  final bool done;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = done ? AppColors.primary : AppColors.textHint;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: done ? AppColors.primary : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
              alignment: Alignment.center,
              child: done
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 32,
                color: done ? AppColors.primary : AppColors.border,
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.base),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              title,
              style: TextStyle(
                color: done ? AppColors.textPrimary : AppColors.textSecondary,
                fontWeight: done ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
