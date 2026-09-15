abstract class DateTimeFormatter {
  static String formatDate(String? rawValue) {
    if (rawValue == null || rawValue.isEmpty) return '';
    final dt = DateTime.tryParse(rawValue);
    if (dt == null) return rawValue;
    
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final year = dt.year.toString();
    return '$day/$month/$year';
  }
  static String formatTime(String? rawValue) {
    if (rawValue == null || rawValue.isEmpty) return '';
    final dt = DateTime.tryParse(rawValue);
    if (dt == null) return rawValue;

    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    final second = dt.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }
  static String formatDateTime(String? rawValue) {
    if (rawValue == null || rawValue.isEmpty) return '';
    final time = formatTime(rawValue);
    final date = formatDate(rawValue);
    return '$time - $date';
  }
}