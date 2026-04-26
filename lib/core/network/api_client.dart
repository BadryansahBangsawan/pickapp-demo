import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_endpoints.dart';
import 'api_exceptions.dart';
import 'api_interceptor.dart';

class ApiClient {
  ApiClient._(this.dio);

  final Dio dio;

  factory ApiClient.create({FlutterSecureStorage? storage}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 15),
        responseType: ResponseType.json,
      ),
    );

    dio.interceptors.add(AuthInterceptor(storage ?? const FlutterSecureStorage()));
    if (kDebugMode) dio.interceptors.add(LoggingInterceptor());

    return ApiClient._(dio);
  }

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? query}) async {
    try {
      return await dio.get<T>(path, queryParameters: query);
    } on DioException catch (e) {
      throw _map(e);
    }
  }

  Future<Response<T>> post<T>(String path, {Object? body}) async {
    try {
      return await dio.post<T>(path, data: body);
    } on DioException catch (e) {
      throw _map(e);
    }
  }

  Future<Response<T>> put<T>(String path, {Object? body}) async {
    try {
      return await dio.put<T>(path, data: body);
    } on DioException catch (e) {
      throw _map(e);
    }
  }

  Future<Response<T>> delete<T>(String path) async {
    try {
      return await dio.delete<T>(path);
    } on DioException catch (e) {
      throw _map(e);
    }
  }

  ApiException _map(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode ?? 0;
        final data = e.response?.data;
        final message = (data is Map && data['error'] is Map)
            ? (data['error']['message'] as String?) ?? 'Permintaan gagal'
            : 'Permintaan gagal';
        final code = (data is Map && data['error'] is Map)
            ? data['error']['code'] as String?
            : null;
        if (status == 401) return const UnauthorizedException();
        if (status == 404) return NotFoundException(message);
        if (status >= 500) return const ServerException();
        return BadRequestException(message, code: code);
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return const UnknownException();
    }
  }
}
