import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._client);

  final ApiClient _client;

  Future<void> sendOtp(String phone) async {
    await _client.post<dynamic>(ApiEndpoints.sendOtp, body: {'phone': phone});
  }

  /// Returns (token, user)
  Future<(String, UserModel)> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    final res = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.verifyOtp,
      body: {'phone': phone, 'otp': otp},
    );
    final data = (res.data?['data'] as Map<String, dynamic>?) ?? {};
    final token = data['token'] as String;
    final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
    return (token, user);
  }

  Future<UserModel> updateProfile({required String name, String? email}) async {
    final body = <String, dynamic>{'name': name};
    if (email != null) {
      body['email'] = email;
    }

    final res = await _client.put<Map<String, dynamic>>(
      ApiEndpoints.userMe,
      body: body,
    );
    final data = (res.data?['data'] as Map<String, dynamic>?) ?? {};
    return UserModel.fromJson(data);
  }

  Future<void> logout() async {
    await _client.delete<dynamic>(ApiEndpoints.logout);
  }
}
