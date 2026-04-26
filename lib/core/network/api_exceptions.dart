sealed class ApiException implements Exception {
  const ApiException(this.message, {this.code});
  final String message;
  final String? code;

  @override
  String toString() => 'ApiException($code): $message';
}

class NetworkException extends ApiException {
  const NetworkException([String message = 'Tidak ada koneksi internet'])
      : super(message, code: 'NETWORK');
}

class TimeoutException extends ApiException {
  const TimeoutException([String message = 'Permintaan timeout'])
      : super(message, code: 'TIMEOUT');
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException([String message = 'Sesi berakhir, silakan login ulang'])
      : super(message, code: 'UNAUTHORIZED');
}

class NotFoundException extends ApiException {
  const NotFoundException([String message = 'Data tidak ditemukan'])
      : super(message, code: 'NOT_FOUND');
}

class ServerException extends ApiException {
  const ServerException([String message = 'Server bermasalah, coba lagi nanti'])
      : super(message, code: 'SERVER');
}

class BadRequestException extends ApiException {
  const BadRequestException(super.message, {super.code});
}

class UnknownException extends ApiException {
  const UnknownException([String message = 'Terjadi kesalahan'])
      : super(message, code: 'UNKNOWN');
}
