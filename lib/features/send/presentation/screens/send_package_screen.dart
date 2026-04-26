import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/pickup_app_bar.dart';
import '../../../../core/widgets/pickup_button.dart';
import '../../../../core/widgets/pickup_text_field.dart';
import '../../../ride/presentation/models/ride_models.dart';
import '../models/send_models.dart';

class SendPackageScreen extends StatefulWidget {
  const SendPackageScreen({super.key});

  @override
  State<SendPackageScreen> createState() => _SendPackageScreenState();
}

class _SendPackageScreenState extends State<SendPackageScreen> {
  final _pickupController = TextEditingController(text: 'Lokasi saya saat ini');
  final _deliveryController = TextEditingController();
  final _recipientNameController = TextEditingController();
  final _recipientPhoneController = TextEditingController();

  @override
  void dispose() {
    _pickupController.dispose();
    _deliveryController.dispose();
    _recipientNameController.dispose();
    _recipientPhoneController.dispose();
    super.dispose();
  }

  bool get _canContinue {
    return _pickupController.text.trim().isNotEmpty &&
        _deliveryController.text.trim().isNotEmpty &&
        _recipientNameController.text.trim().isNotEmpty &&
        _recipientPhoneController.text.trim().isNotEmpty;
  }

  void _continue() {
    if (!_canContinue) return;

    final draft = SendDraft(
      pickupAddress: _pickupController.text.trim(),
      deliveryAddress: _deliveryController.text.trim(),
      recipientName: _recipientNameController.text.trim(),
      recipientPhone: _recipientPhoneController.text.trim(),
    );

    context.push(RouteNames.packageDetail, extra: draft);
  }

  void _fillPickup(String value) {
    setState(() => _pickupController.text = value);
  }

  void _fillDelivery(String value) {
    setState(() => _deliveryController.text = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PickupAppBar(title: 'Kirim Paket', bottomBorder: true),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.base),
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.base),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rute Pengiriman',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: AppSpacing.base),
                  Row(
                    children: [
                      const Column(
                        children: [
                          Icon(
                            Icons.radio_button_checked,
                            color: AppColors.primary,
                          ),
                          SizedBox(height: 14),
                          Icon(Icons.more_vert, color: AppColors.textHint),
                          Icon(Icons.location_on, color: AppColors.error),
                        ],
                      ),
                      const SizedBox(width: AppSpacing.base),
                      Expanded(
                        child: Column(
                          children: [
                            PickupTextField(
                              controller: _pickupController,
                              label: 'Alamat Pickup',
                              hint: 'Masukkan lokasi penjemputan',
                              prefixIcon: const Icon(
                                Icons.my_location_outlined,
                              ),
                              textCapitalization: TextCapitalization.sentences,
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: AppSpacing.base),
                            PickupTextField(
                              controller: _deliveryController,
                              label: 'Alamat Tujuan',
                              hint: 'Masukkan alamat tujuan',
                              prefixIcon: const Icon(Icons.pin_drop_outlined),
                              textCapitalization: TextCapitalization.sentences,
                              onChanged: (_) => setState(() {}),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.base),
            const Text(
              'Alamat cepat',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final place in savedPlaces)
                  ActionChip(
                    avatar: const Icon(Icons.bookmark_border, size: 16),
                    label: Text(place.label),
                    onPressed: () => _fillDelivery(place.address),
                  ),
                ActionChip(
                  avatar: const Icon(Icons.home_outlined, size: 16),
                  label: const Text('Gunakan Rumah sebagai pickup'),
                  onPressed: () => _fillPickup(savedPlaces.first.address),
                ),
              ],
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
                children: [
                  PickupTextField(
                    controller: _recipientNameController,
                    label: 'Nama Penerima',
                    hint: 'Masukkan nama penerima',
                    prefixIcon: const Icon(Icons.person_outline),
                    textCapitalization: TextCapitalization.words,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: AppSpacing.base),
                  PickupTextField(
                    controller: _recipientPhoneController,
                    label: 'Nomor HP Penerima',
                    hint: '08xxxxxxxxxx',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    keyboardType: TextInputType.phone,
                    onChanged: (_) => setState(() {}),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            PickupButton(
              label: 'Lanjut Detail Paket',
              onPressed: _canContinue ? _continue : null,
            ),
          ],
        ),
      ),
    );
  }
}
