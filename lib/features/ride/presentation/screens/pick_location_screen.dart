import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/pickup_app_bar.dart';
import '../../../../core/widgets/pickup_button.dart';
import '../../../../core/widgets/pickup_card.dart';
import '../models/ride_models.dart';
import '../widgets/location_input.dart';

class PickLocationScreen extends StatefulWidget {
  const PickLocationScreen({super.key});

  @override
  State<PickLocationScreen> createState() => _PickLocationScreenState();
}

class _PickLocationScreenState extends State<PickLocationScreen> {
  late final TextEditingController _pickupController;
  late final TextEditingController _destinationController;

  @override
  void initState() {
    super.initState();
    _pickupController = TextEditingController(text: 'Lokasi saya saat ini');
    _destinationController = TextEditingController();
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  List<RideLocation> get _suggestions {
    final q = _destinationController.text.trim().toLowerCase();
    if (q.isEmpty) return savedPlaces;
    return savedPlaces
        .where(
          (p) =>
              p.label.toLowerCase().contains(q) ||
              p.address.toLowerCase().contains(q),
        )
        .toList();
  }

  void _goChooseRide() {
    final destinationText = _destinationController.text.trim();
    if (destinationText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan dulu lokasi tujuan.')),
      );
      return;
    }

    final pickup = RideLocation(
      label: 'Jemput',
      address: _pickupController.text.trim(),
    );
    final destination = RideLocation(label: 'Tujuan', address: destinationText);

    context.push(
      RouteNames.chooseRide,
      extra: RideQuote(
        pickup: pickup,
        destination: destination,
        distanceKm: 8.4,
        durationMinutes: 22,
        option: rideOptions.first,
        paymentMethod: 'Tunai',
        estimatedPrice: 29000,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final suggestions = _suggestions;

    return Scaffold(
      appBar: const PickupAppBar(title: 'Pilih Lokasi', bottomBorder: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RideLocationInput(
                label: 'Lokasi Jemput',
                controller: _pickupController,
                icon: Icons.my_location,
              ),
              const SizedBox(height: AppSpacing.base),
              RideLocationInput(
                label: 'Lokasi Tujuan',
                controller: _destinationController,
                icon: Icons.location_on_outlined,
                hint: 'Contoh: Mall Kota Kasablanka',
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: AppSpacing.base),
              const Text(
                'Tempat tersimpan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: suggestions.isEmpty
                    ? const Center(
                        child: Text(
                          'Lokasi tidak ditemukan',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      )
                    : ListView.separated(
                        itemCount: suggestions.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, i) {
                          final item = suggestions[i];
                          return PickupCard(
                            onTap: () {
                              _destinationController.text = item.address;
                              setState(() {});
                            },
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Row(
                              children: [
                                Container(
                                  width: AppTouchTarget.minimum,
                                  height: AppTouchTarget.minimum,
                                  decoration: BoxDecoration(
                                    color: AppColors.searchFill,
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.md,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.place_outlined,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.label,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: AppSpacing.xs),
                                      Text(
                                        item.address,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: AppSpacing.base),
              PickupButton(
                label: 'Lanjut Pilih Kendaraan',
                onPressed: _goChooseRide,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
