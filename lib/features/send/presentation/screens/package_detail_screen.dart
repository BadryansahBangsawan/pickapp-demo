import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/pickup_app_bar.dart';
import '../../../../core/widgets/pickup_button.dart';
import '../../../../core/widgets/pickup_text_field.dart';
import '../models/send_models.dart';

class PackageDetailScreen extends StatefulWidget {
  const PackageDetailScreen({super.key, required this.draft});

  final SendDraft draft;

  @override
  State<PackageDetailScreen> createState() => _PackageDetailScreenState();
}

class _PackageDetailScreenState extends State<PackageDetailScreen> {
  final _notesController = TextEditingController();

  PackageSize _selectedSize = PackageSize.small;
  bool _isFragile = false;
  String? _pickedPhotoPath;
  String? _pickedPhotoName;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  int get _estimatedFee {
    final fragileFee = _isFragile ? 4000 : 0;
    return _selectedSize.baseFee + fragileFee;
  }

  Future<void> _pickPackagePhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      imageQuality: 80,
    );

    if (picked == null || !mounted) return;
    setState(() {
      _pickedPhotoPath = picked.path;
      _pickedPhotoName = picked.name;
    });
  }

  void _startDelivery() {
    final order = SendOrder(
      trackingCode:
          'PKS-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      draft: widget.draft,
      packageSize: _selectedSize,
      isFragile: _isFragile,
      notes: _notesController.text.trim(),
      photoPath: _pickedPhotoPath,
      fee: _estimatedFee,
      createdAt: DateTime.now(),
    );

    context.push(RouteNames.sendTracking, extra: order);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PickupAppBar(title: 'Detail Paket', bottomBorder: true),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.base),
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.border),
              ),
              padding: const EdgeInsets.all(AppSpacing.base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ukuran Paket',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  const SizedBox(height: AppSpacing.base),
                  ...PackageSize.values.map((size) {
                    final selected = _selectedSize == size;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: InkWell(
                        onTap: () => setState(() => _selectedSize = size),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.base),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primary.withValues(alpha: 0.08)
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(size.icon, color: AppColors.textPrimary),
                              const SizedBox(width: AppSpacing.base),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      size.label,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      size.description,
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                Formatters.currency(size.baseFee),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: _isFragile,
                    onChanged: (value) => setState(() => _isFragile = value),
                    title: const Text('Barang mudah pecah'),
                    subtitle: const Text('Tambahan biaya pengamanan Rp 4.000'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.base),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.border),
              ),
              padding: const EdgeInsets.all(AppSpacing.base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Foto Paket (Dummy dulu)',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  const SizedBox(height: AppSpacing.base),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    child: Stack(
                      children: [
                        Image.network(
                          'https://picsum.photos/seed/package-photo/1200/800',
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        if (_pickedPhotoName != null)
                          Positioned(
                            left: AppSpacing.sm,
                            right: AppSpacing.sm,
                            bottom: AppSpacing.sm,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(
                                  AppRadius.sm,
                                ),
                              ),
                              child: Text(
                                'Foto dipilih: $_pickedPhotoName',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.base),
                  PickupButton(
                    label: 'Pilih Foto Paket',
                    variant: PickupButtonVariant.secondary,
                    onPressed: _pickPackagePhoto,
                    icon: Icons.camera_alt_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.base),
            PickupTextField(
              controller: _notesController,
              label: 'Catatan untuk Driver',
              hint: 'Contoh: paket dititip ke satpam jika tidak ada orang',
              prefixIcon: const Icon(Icons.note_alt_outlined),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: AppSpacing.base),
            Container(
              padding: const EdgeInsets.all(AppSpacing.base),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Estimasi Biaya Pengiriman',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    Formatters.currency(_estimatedFee),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            PickupButton(label: 'Pesan PickSend', onPressed: _startDelivery),
          ],
        ),
      ),
    );
  }
}
