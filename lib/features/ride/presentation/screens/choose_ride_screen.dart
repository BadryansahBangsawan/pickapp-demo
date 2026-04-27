import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/pickup_app_bar.dart';
import '../../../../core/widgets/pickup_button.dart';
import '../../../../core/widgets/pickup_card.dart';
import '../models/ride_models.dart';
import '../widgets/map_widget.dart';
import '../widgets/ride_option_card.dart';
import '../widgets/slide_to_act_widget.dart';

class ChooseRideScreen extends StatefulWidget {
  const ChooseRideScreen({super.key, this.initialQuote});

  final RideQuote? initialQuote;

  @override
  State<ChooseRideScreen> createState() => _ChooseRideScreenState();
}

class _ChooseRideScreenState extends State<ChooseRideScreen> {
  late RideQuote _quote;

  @override
  void initState() {
    super.initState();
    _quote =
        widget.initialQuote ??
        RideQuote(
          pickup: const RideLocation(
            label: 'Jemput',
            address: 'Lokasi saya saat ini',
          ),
          destination: const RideLocation(
            label: 'Tujuan',
            address: 'Mall Kota Kasablanka',
          ),
          distanceKm: 8.4,
          durationMinutes: 22,
          option: rideOptions.first,
          paymentMethod: 'Tunai',
          estimatedPrice: 29000,
        );
    _quote = _quote.copyWith(estimatedPrice: _estimatePrice(_quote.option));
  }

  int _estimatePrice(RideOption option) {
    const basePerKm = 2800;
    const serviceFee = 3500;
    final dynamicFare = (_quote.distanceKm * basePerKm * option.multiplier)
        .round();
    return dynamicFare + serviceFee;
  }

  void _selectOption(RideOption option) {
    setState(() {
      _quote = _quote.copyWith(
        option: option,
        estimatedPrice: _estimatePrice(option),
      );
    });
  }

  Future<void> _pickPaymentMethod() async {
    final methods = ['Tunai', 'PickPay', 'Kartu Debit'];

    final result = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        var selected = _quote.paymentMethod;
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                    const Text(
                      'Pilih Metode Pembayaran',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ...methods.map(
                      (m) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        minVerticalPadding: 0,
                        onTap: () => setModalState(() => selected = m),
                        title: Text(m),
                        trailing: Icon(
                          selected == m
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: selected == m
                              ? AppColors.primary
                              : AppColors.textHint,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    PickupButton(
                      label: 'Gunakan Pembayaran Ini',
                      onPressed: () => Navigator.of(context).pop(selected),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        _quote = _quote.copyWith(paymentMethod: result);
      });
    }
  }

  void _startSearchingDriver() {
    context.push(RouteNames.searchingDriver, extra: _quote);
  }

  @override
  Widget build(BuildContext context) {
    final quote = _quote;

    return Scaffold(
      appBar: const PickupAppBar(title: 'Pilih Kendaraan', bottomBorder: true),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.base),
              child: RideMapWidget(
                pickupLabel: quote.pickup.address,
                destinationLabel: quote.destination.address,
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.base,
                ),
                children: [
                  PickupCard(
                    padding: const EdgeInsets.all(AppSpacing.base),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.route_outlined,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                '${quote.distanceKm.toStringAsFixed(1)} km · ${quote.durationMinutes} menit',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Text(
                              Formatters.currency(quote.estimatedPrice),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SizedBox(
                          height: 110,
                          child: _FareBarChart(
                            baseFare: (quote.estimatedPrice - 3500).toDouble(),
                            serviceFee: 3500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.base),
                  ...rideOptions.map(
                    (option) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: RideOptionCard(
                        option: option,
                        price: _estimatePrice(option),
                        selected: quote.option.id == option.id,
                        onTap: () => _selectOption(option),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  PickupCard(
                    onTap: _pickPaymentMethod,
                    child: Row(
                      children: [
                        const Icon(Icons.account_balance_wallet_outlined),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Metode Pembayaran',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                quote.paymentMethod,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.base,
                AppSpacing.sm,
                AppSpacing.base,
                AppSpacing.base,
              ),
              child: SlideToActWidget(
                label: 'Pesan ${quote.option.title}',
                onSubmitted: _startSearchingDriver,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FareBarChart extends StatelessWidget {
  const _FareBarChart({required this.baseFare, required this.serviceFee});

  final double baseFare;
  final double serviceFee;

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (baseFare + serviceFee) * 1.2,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final text = switch (value.toInt()) {
                  0 => 'Tarif Dasar',
                  1 => 'Biaya Layanan',
                  _ => '',
                };
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: baseFare,
                width: 28,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                color: AppColors.primary,
              ),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: serviceFee,
                width: 28,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                color: AppColors.warning,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
