import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/pickup_app_bar.dart';
import '../../../../core/widgets/pickup_button.dart';
import '../../../../core/widgets/pickup_text_field.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/profile_cubit.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  String? _pickedPhotoPath;
  String? _pickedPhotoName;

  @override
  void initState() {
    super.initState();
    final authUser = context.read<AuthBloc>().state.user;
    final profile = context.read<ProfileCubit>().state;

    _nameController.text = (authUser?.name ?? profile.name).trim();
    _emailController.text = (authUser?.email ?? profile.email ?? '').trim();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      imageQuality: 85,
    );

    if (picked == null || !mounted) return;
    setState(() {
      _pickedPhotoPath = picked.path;
      _pickedPhotoName = picked.name;
    });
  }

  void _save() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nama wajib diisi.')));
      return;
    }

    final current = context.read<ProfileCubit>().state;
    context.read<ProfileCubit>().updateProfile(
      name: name,
      email: email.isEmpty ? null : email,
      photoUrl: _pickedPhotoPath == null ? current.photoUrl : current.photoUrl,
    );

    final authUser = context.read<AuthBloc>().state.user;
    if (authUser != null) {
      context.read<AuthBloc>().add(
        AuthProfileSubmitted(
          name: name,
          email: email.isEmpty ? null : email,
          photoPath: _pickedPhotoPath,
        ),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil diperbarui.')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileCubit>().state;

    return Scaffold(
      appBar: const PickupAppBar(title: 'Edit Profil', bottomBorder: true),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.base),
          children: [
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    child: Image.network(
                      profile.photoUrl,
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 96,
                        height: 96,
                        color: AppColors.surface,
                        alignment: Alignment.center,
                        child: const Icon(Icons.person, size: 40),
                      ),
                    ),
                  ),
                  Positioned(
                    right: -6,
                    bottom: -6,
                    child: IconButton.filled(
                      onPressed: _pickPhoto,
                      icon: const Icon(Icons.camera_alt_outlined, size: 20),
                      iconSize: 20,
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_pickedPhotoName != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Center(
                child: Text(
                  'Foto dipilih: $_pickedPhotoName',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            PickupTextField(
              controller: _nameController,
              label: 'Nama Lengkap',
              hint: 'Masukkan nama lengkap',
              prefixIcon: const Icon(Icons.person_outline),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: AppSpacing.base),
            PickupTextField(
              controller: _emailController,
              label: 'Email',
              hint: 'nama@email.com',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            const SizedBox(height: AppSpacing.xl),
            PickupButton(label: 'Simpan Perubahan', onPressed: _save),
          ],
        ),
      ),
    );
  }
}
