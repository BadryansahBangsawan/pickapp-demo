import 'api_exceptions.dart';

String mapUiErrorMessage(Object error, {required String fallbackMessage}) {
  if (error is NetworkException || error is TimeoutException) {
    return 'Koneksi internet bermasalah. Cek jaringan lalu coba lagi.';
  }

  if (error is ServerException) {
    return 'Server sedang bermasalah. Coba lagi beberapa saat.';
  }

  if (error is ApiException) {
    final message = error.message.trim();
    if (message.isNotEmpty) return message;
  }

  return fallbackMessage;
}
