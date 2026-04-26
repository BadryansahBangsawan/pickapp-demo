part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthOtpRequested extends AuthEvent {
  const AuthOtpRequested(this.phone);
  final String phone;
  @override
  List<Object?> get props => [phone];
}

class AuthOtpVerified extends AuthEvent {
  const AuthOtpVerified({required this.phone, required this.otp});
  final String phone;
  final String otp;
  @override
  List<Object?> get props => [phone, otp];
}

class AuthProfileSubmitted extends AuthEvent {
  const AuthProfileSubmitted({required this.name, this.email, this.photoPath});
  final String name;
  final String? email;
  final String? photoPath;
  @override
  List<Object?> get props => [name, email, photoPath];
}

class AuthLoggedOut extends AuthEvent {
  const AuthLoggedOut();
}
