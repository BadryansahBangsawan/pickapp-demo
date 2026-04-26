import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/pickup_app_bar.dart';
import '../bloc/profile_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PickupAppBar(title: 'Pengaturan', bottomBorder: true),
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.base),
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile.adaptive(
                        value: state.notificationsEnabled,
                        onChanged: (value) => context
                            .read<ProfileCubit>()
                            .toggleNotifications(value),
                        title: const Text('Notifikasi Push'),
                        subtitle: const Text(
                          'Info promo, update order, dan pesan penting',
                        ),
                      ),
                      const Divider(height: 1),
                      SwitchListTile.adaptive(
                        value: state.useEnglish,
                        onChanged: (value) =>
                            context.read<ProfileCubit>().toggleLanguage(value),
                        title: const Text('Bahasa Inggris'),
                        subtitle: const Text(
                          'Aktifkan tampilan bahasa Inggris',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.base),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  padding: const EdgeInsets.all(AppSpacing.base),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Pengaturan keamanan tambahan (PIN/biometric) akan diaktifkan di sprint berikutnya.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
