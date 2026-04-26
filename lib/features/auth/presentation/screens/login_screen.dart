import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/pickup_button.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/phone_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    final phoneRaw = _phoneController.text.trim();
    final err = Validators.phone(phoneRaw);
    if (err != null) {
      setState(() => _error = err);
      return;
    }
    setState(() => _error = null);
    final phone = '+62$phoneRaw';
    context.read<AuthBloc>().add(AuthOtpRequested(phone));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (state.status == AuthStatus.otpSent) {
            context.go(RouteNames.otp);
          } else if (state.status == AuthStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Gagal kirim OTP')),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.xl),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.local_taxi_outlined,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                const Text('Masuk ke Pick Up', style: AppTypography.h1),
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  'Masukkan nomor HP untuk menerima kode OTP.',
                  style: AppTypography.caption,
                ),
                const SizedBox(height: AppSpacing.xxl),
                const Text('Nomor HP', style: AppTypography.label),
                const SizedBox(height: AppSpacing.sm),
                PhoneInput(
                  controller: _phoneController,
                  onSubmitted: (_) => _submit(),
                ),
                if (_error != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _error!,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
                BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (prev, curr) => prev.status != curr.status,
                  builder: (context, state) => PickupButton(
                    label: 'Lanjut',
                    isLoading: state.status == AuthStatus.otpSending,
                    onPressed: _submit,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                const _OrDivider(),
                const SizedBox(height: AppSpacing.xl),
                _SocialButton(
                  icon: Icons.g_mobiledata,
                  label: 'Lanjut dengan Google',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Google Sign-In belum tersedia'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                _SocialButton(
                  icon: Icons.apple,
                  label: 'Lanjut dengan Apple',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Apple Sign-In belum tersedia'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xxl),
                const _TosFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: Divider(color: AppColors.divider)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text('atau', style: AppTypography.small),
        ),
        Expanded(child: Divider(color: AppColors.divider)),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      label: Text(label),
    );
  }
}

class _TosFooter extends StatelessWidget {
  const _TosFooter();

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'Dengan masuk, kamu menyetujui ',
        style: AppTypography.small,
        children: [
          TextSpan(
            text: 'Syarat & Ketentuan',
            style: AppTypography.small.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const TextSpan(text: ' dan '),
          TextSpan(
            text: 'Kebijakan Privasi',
            style: AppTypography.small.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const TextSpan(text: ' Pick Up.'),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
