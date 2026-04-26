import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repo) : super(const AuthState()) {
    on<AuthCheckRequested>(_onCheck);
    on<AuthOtpRequested>(_onOtpRequested);
    on<AuthOtpVerified>(_onOtpVerified);
    on<AuthProfileSubmitted>(_onProfile);
    on<AuthLoggedOut>(_onLogout);
  }

  final AuthRepository _repo;

  Future<void> _onCheck(AuthCheckRequested event, Emitter<AuthState> emit) async {
    final user = await _repo.currentUser();
    if (user == null) {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
      return;
    }
    emit(state.copyWith(
      status: user.isProfileComplete ? AuthStatus.authenticated : AuthStatus.needsProfile,
      user: user,
    ));
  }

  Future<void> _onOtpRequested(AuthOtpRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.otpSending, pendingPhone: event.phone, clearError: true));
    try {
      await _repo.sendOtp(event.phone);
      emit(state.copyWith(status: AuthStatus.otpSent, pendingPhone: event.phone));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onOtpVerified(AuthOtpVerified event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.otpVerifying, clearError: true));
    try {
      final user = await _repo.verifyOtp(phone: event.phone, otp: event.otp);
      emit(state.copyWith(
        status: user.isProfileComplete ? AuthStatus.authenticated : AuthStatus.needsProfile,
        user: user,
      ));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onProfile(AuthProfileSubmitted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.otpVerifying, clearError: true));
    try {
      final user = await _repo.updateProfile(
        name: event.name,
        email: event.email,
        photoPath: event.photoPath,
      );
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onLogout(AuthLoggedOut event, Emitter<AuthState> emit) async {
    await _repo.logout();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
