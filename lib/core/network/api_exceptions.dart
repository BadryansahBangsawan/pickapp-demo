sealed class ApiException implements Exception {
  const ApiException(this.message, {this.code});
  final String message;
  final String? code;

  @override
  String toString() => 'ApiException($code): $message';
}

class NetworkException extends ApiException {
  const NetworkException([super.message = 'Tidak ada koneksi internet'])
      : super(code: 'NETWORK');
}

class TimeoutException extends ApiException {
  const TimeoutException([super.message = 'Permintaan timeout'])
      : super(code: 'TIMEOUT');
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException([super.message = 'Sesi berakhir, silakan login ulang'])
      : super(code: 'UNAUTHORIZED');
}

class NotFoundException extends ApiException {
  const NotFoundException([super.message = 'Data tidak ditemukan'])
      : super(code: 'NOT_FOUND');
}

class ServerException extends ApiException {
  const ServerException([super.message = 'Server bermasalah, coba lagi nanti'])
      : super(code: 'SERVER');
}

class BadRequestException extends ApiException {
  const BadRequestException(super.message, {super.code});
}

class UnknownException extends ApiException {
  const UnknownException([super.message = 'Terjadi kesalahan'])
      : super(code: 'UNKNOWN');
}
