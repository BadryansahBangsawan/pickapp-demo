part of 'auth_bloc.dart';

enum AuthStatus {
  unknown,
  unauthenticated,
  otpSending,
  otpSent,
  otpVerifying,
  needsProfile,
  authenticated,
  failure,
}

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.pendingPhone,
    this.errorMessage,
  });

  final AuthStatus status;
  final User? user;
  final String? pendingPhone;
  final String? errorMessage;

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? pendingPhone,
    String? errorMessage,
    bool clearError = false,
  }) =>
      AuthState(
        status: status ?? this.status,
        user: user ?? this.user,
        pendingPhone: pendingPhone ?? this.pendingPhone,
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      );

  @override
  List<Object?> get props => [status, user, pendingPhone, errorMessage];
}
