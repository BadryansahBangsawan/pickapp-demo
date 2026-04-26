import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static final _currency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static String currency(num value) => _currency.format(value);

  static String phone(String value) {
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.startsWith('0')) return '+62${digits.substring(1)}';
    if (digits.startsWith('62')) return '+$digits';
    return '+62$digits';
  }

  static String dateShort(DateTime date) =>
      DateFormat('d MMM yyyy', 'id_ID').format(date);

  static String dateTime(DateTime date) =>
      DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(date);

  static String relative(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inHours < 1) return '${diff.inMinutes} menit lalu';
    if (diff.inDays < 1) return '${diff.inHours} jam lalu';
    if (diff.inDays == 1) return 'Kemarin';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    return dateShort(date);
  }
}
