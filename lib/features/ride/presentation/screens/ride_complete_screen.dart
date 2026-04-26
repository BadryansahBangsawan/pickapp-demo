import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/pickup_app_bar.dart';
import '../../../../core/widgets/pickup_button.dart';
import '../models/ride_models.dart';

class RideCompleteScreen extends StatefulWidget {
  const RideCompleteScreen({super.key, required this.quote});

  final RideQuote quote;

  @override
  State<RideCompleteScreen> createState() => _RideCompleteScreenState();
}

class _RideCompleteScreenState extends State<RideCompleteScreen> {
  int _rating = 5;
  int _tip = 0;

  static const _tips = <int>[0, 5000, 10000, 20000];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PickupAppBar(
        title: 'Perjalanan Selesai',
        bottomBorder: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.base),
                decoration: BoxDecoration(
                  color: AppColors.badgeSuccessBg,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Terima kasih, perjalanan selesai!',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: AppColors.badgeSuccessText,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Total bayar: ${Formatters.currency(widget.quote.estimatedPrice + _tip)}',
                      style: const TextStyle(
                        color: AppColors.badgeSuccessText,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const Text(
                'Beri rating untuk driver',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: List.generate(5, (index) {
                  final value = index + 1;
                  return IconButton(
                    iconSize: 36,
                    splashRadius: 24,
                    onPressed: () => setState(() => _rating = value),
                    icon: Icon(
                      value <= _rating ? Icons.star : Icons.star_border,
                      color: AppColors.amber,
                    ),
                  );
                }),
              ),
              const SizedBox(height: AppSpacing.base),
              const Text(
                'Tambah tip (opsional)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: _tips.map((tip) {
                  final selected = _tip == tip;
                  return ChoiceChip(
                    label: Text(
                      tip == 0 ? 'Tanpa tip' : Formatters.currency(tip),
                    ),
                    selected: selected,
                    onSelected: (_) => setState(() => _tip = tip),
                  );
                }).toList(),
              ),
              const Spacer(),
              PickupButton(
                label: 'Kirim Penilaian',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Terima kasih atas penilaianmu.'),
                    ),
                  );
                  context.go(RouteNames.home);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
