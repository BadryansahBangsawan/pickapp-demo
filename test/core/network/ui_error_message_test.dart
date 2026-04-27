import 'package:flutter_test/flutter_test.dart';
import 'package:pickup/core/network/api_exceptions.dart';
import 'package:pickup/core/network/ui_error_message.dart';

void main() {
  group('mapUiErrorMessage', () {
    test('returns network-friendly copy for network-related exceptions', () {
      final message = mapUiErrorMessage(
        const NetworkException(),
        fallbackMessage: 'fallback',
      );

      expect(message, contains('Koneksi internet'));
    });

    test('returns server-friendly copy for server exceptions', () {
      final message = mapUiErrorMessage(
        const ServerException(),
        fallbackMessage: 'fallback',
      );

      expect(message, contains('Server'));
    });

    test('falls back when exception is unknown', () {
      final message = mapUiErrorMessage(
        Exception('x'),
        fallbackMessage: 'fallback',
      );

      expect(message, 'fallback');
    });
  });
}
