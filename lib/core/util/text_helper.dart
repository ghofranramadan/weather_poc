import 'package:intl/intl.dart';

class TextHelper {
  static String formatDate(String? rawDateTime) {
    if (rawDateTime == null) return '';
    try {
      final datePart = rawDateTime.split(' ').first;
      return DateFormat('MMM d, yyyy').format(DateTime.parse(datePart));
    } catch (_) {
      return '';
    }
  }

  static String formatTime(String? rawDateTime) {
    if (rawDateTime == null) return '';
    final parts = rawDateTime.split(' ');
    return parts.length > 1 ? parts[1] : '';
  }
}
