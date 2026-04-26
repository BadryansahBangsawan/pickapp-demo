import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

/// Mock-aware repository: when [useMock] is true, network calls are short-circuited
/// with deterministic fake data so the app can run without backend wired.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.remote,
    required this.local,
    this.useMock = true,
  });

  final AuthRemoteDataSource remote;
  final AuthLocalDataSource local;
  final bool useMock;

  @override
  Future<void> sendOtp(String phone) async {
    if (useMock) {
      await Future.delayed(const Duration(milliseconds: 600));
      return;
    }
    await remote.sendOtp(phone);
  }

  @override
  Future<User> verifyOtp({required String phone, required String otp}) async {
    if (useMock) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (otp != '123456') {
        throw Exception('OTP salah. Coba 123456 (mock).');
      }
      final user = UserModel(
        id: 'mock-${phone.hashCode}',
        phone: phone,
      );
      await local.saveToken('mock-token-${DateTime.now().millisecondsSinceEpoch}');
      await local.saveUser(user);
      return user;
    }

    final (token, user) = await remote.verifyOtp(phone: phone, otp: otp);
    await local.saveToken(token);
    await local.saveUser(user);
    return user;
  }

  @override
  Future<User> updateProfile({
    required String name,
    String? email,
    String? photoPath,
  }) async {
    final existing = await local.readUser();
    if (existing == null) {
      throw Exception('User belum login');
    }

    if (useMock) {
      await Future.delayed(const Duration(milliseconds: 400));
      final updated = UserModel(
        id: existing.id,
        phone: existing.phone,
        name: name,
        email: email,
        photoUrl: photoPath,
        isProfileComplete: true,
      );
      await local.saveUser(updated);
      return updated;
    }

    final updated = await remote.updateProfile(name: name, email: email);
    final completed = UserModel(
      id: updated.id,
      phone: updated.phone,
      name: updated.name,
      email: updated.email,
      photoUrl: updated.photoUrl,
      isProfileComplete: true,
    );
    await local.saveUser(completed);
    return completed;
  }

  @override
  Future<User?> currentUser() => local.readUser();

  @override
  Future<void> logout() async {
    if (!useMock) {
      try {
        await remote.logout();
      } catch (_) {
        // ignore — clear local state regardless
      }
    }
    await local.clear();
  }
}
