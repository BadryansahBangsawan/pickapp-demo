import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/pickup_app_bar.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/otp_input.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _controller = TextEditingController();
  Timer? _timer;
  int _seconds = 60;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _seconds = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_seconds <= 0) {
        t.cancel();
      } else {
        setState(() => _seconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _verify(String otp) {
    final phone = context.read<AuthBloc>().state.pendingPhone;
    if (phone == null) return;
    context.read<AuthBloc>().add(AuthOtpVerified(phone: phone, otp: otp));
  }

  void _resend() {
    final phone = context.read<AuthBloc>().state.pendingPhone;
    if (phone == null) return;
    context.read<AuthBloc>().add(AuthOtpRequested(phone));
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PickupAppBar(),
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (state.status == AuthStatus.needsProfile) {
            context.go(RouteNames.setupProfile);
          } else if (state.status == AuthStatus.authenticated) {
            context.go(RouteNames.home);
          } else if (state.status == AuthStatus.failure) {
            _controller.clear();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Verifikasi gagal')),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final phone = state.pendingPhone ?? '';
            final loading = state.status == AuthStatus.otpVerifying;
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Masukkan Kode OTP', style: AppTypography.h1),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Kode 6 digit telah dikirim ke $phone.\nGunakan 123456 (mock).',
                      style: AppTypography.caption,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    OtpInput(controller: _controller, onCompleted: _verify),
                    const SizedBox(height: AppSpacing.xl),
                    if (loading)
                      const Center(child: CircularProgressIndicator()),
                    if (!loading)
                      Center(
                        child: _seconds > 0
                            ? Text(
                                'Kirim ulang dalam $_seconds detik',
                                style: AppTypography.caption,
                              )
                            : TextButton(
                                onPressed: _resend,
                                child: const Text('Kirim ulang OTP'),
                              ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
