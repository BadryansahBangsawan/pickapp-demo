import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/pickup_app_bar.dart';
import '../../../../core/widgets/pickup_button.dart';
import '../../../../core/widgets/pickup_empty_state.dart';
import '../../../../core/widgets/pickup_text_field.dart';
import '../bloc/profile_cubit.dart';
import '../models/profile_models.dart';

class SavedAddressesScreen extends StatelessWidget {
  const SavedAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PickupAppBar(title: 'Alamat Tersimpan', bottomBorder: true),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddressForm(context),
        label: const Text('Tambah Alamat'),
        icon: const Icon(Icons.add_location_alt_outlined),
      ),
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state.addresses.isEmpty) {
              return PickupEmptyState(
                title: 'Belum ada alamat',
                message:
                    'Tambahkan alamat favorit untuk mempercepat proses pemesanan ride, food, dan send.',
                icon: Icons.location_off_outlined,
                actionLabel: 'Tambah Alamat',
                onAction: () => _showAddressForm(context),
              );
            }

            return RefreshIndicator(
              onRefresh: () async =>
                  Future<void>.delayed(const Duration(milliseconds: 500)),
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.base,
                  AppSpacing.base,
                  AppSpacing.base,
                  100,
                ),
                itemCount: state.addresses.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final address = state.addresses[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(AppSpacing.base),
                      leading: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.place_outlined),
                      ),
                      title: Text(
                        address.label,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.xs),
                        child: Text(
                          [address.address, address.notes]
                              .whereType<String>()
                              .where((e) => e.trim().isNotEmpty)
                              .join('\n'),
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showAddressForm(context, existing: address);
                            return;
                          }
                          if (value == 'delete') {
                            context.read<ProfileCubit>().deleteAddress(
                              address.id,
                            );
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'edit', child: Text('Edit')),
                          PopupMenuItem(value: 'delete', child: Text('Hapus')),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showAddressForm(
    BuildContext context, {
    SavedAddress? existing,
  }) async {
    final labelController = TextEditingController(text: existing?.label);
    final addressController = TextEditingController(text: existing?.address);
    final notesController = TextEditingController(text: existing?.notes);

    final result = await showModalBottomSheet<_AddressFormResult>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.base,
            AppSpacing.base,
            AppSpacing.base,
            MediaQuery.of(context).viewInsets.bottom + AppSpacing.base,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                existing == null ? 'Tambah Alamat Baru' : 'Edit Alamat',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.base),
              PickupTextField(
                controller: labelController,
                label: 'Label',
                hint: 'Rumah, Kantor, Kos',
                prefixIcon: const Icon(Icons.label_outline),
              ),
              const SizedBox(height: AppSpacing.base),
              PickupTextField(
                controller: addressController,
                label: 'Alamat Lengkap',
                hint: 'Masukkan alamat',
                prefixIcon: const Icon(Icons.location_on_outlined),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: AppSpacing.base),
              PickupTextField(
                controller: notesController,
                label: 'Catatan',
                hint: 'Contoh: dekat minimarket',
                prefixIcon: const Icon(Icons.sticky_note_2_outlined),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: AppSpacing.base),
              PickupButton(
                label: existing == null ? 'Simpan Alamat' : 'Perbarui Alamat',
                onPressed: () {
                  final label = labelController.text.trim();
                  final address = addressController.text.trim();
                  final notes = notesController.text.trim();

                  if (label.isEmpty || address.isEmpty) return;

                  Navigator.of(context).pop(
                    _AddressFormResult(
                      id: existing?.id,
                      label: label,
                      address: address,
                      notes: notes.isEmpty ? null : notes,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );

    labelController.dispose();
    addressController.dispose();
    notesController.dispose();

    if (result == null || !context.mounted) return;

    final cubit = context.read<ProfileCubit>();
    final address = SavedAddress(
      id: result.id ?? 'addr-${DateTime.now().microsecondsSinceEpoch}',
      label: result.label,
      address: result.address,
      notes: result.notes,
    );

    if (result.id == null) {
      cubit.addAddress(address);
    } else {
      cubit.updateAddress(address);
    }
  }
}

class _AddressFormResult {
  const _AddressFormResult({
    this.id,
    required this.label,
    required this.address,
    this.notes,
  });

  final String? id;
  final String label;
  final String address;
  final String? notes;
}
