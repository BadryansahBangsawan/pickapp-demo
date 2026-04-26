import '../entities/user.dart';

abstract class AuthRepository {
  /// Send OTP to the given phone (E.164 format).
  Future<void> sendOtp(String phone);

  /// Verify OTP. Returns the authenticated user.
  Future<User> verifyOtp({required String phone, required String otp});

  /// Update profile (name, email, photo) — used after first OTP verification.
  Future<User> updateProfile({
    required String name,
    String? email,
    String? photoPath,
  });

  /// Currently signed-in user, or null when signed out.
  Future<User?> currentUser();

  /// Sign out and clear local credentials.
  Future<void> logout();
}
