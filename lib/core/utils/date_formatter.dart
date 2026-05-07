import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _fullDate = DateFormat('dd MMM yyyy');
  static final DateFormat _shortDate = DateFormat('dd MMM');
  static final DateFormat _timeOnly = DateFormat('hh:mm a');
  static final DateFormat _dayMonth = DateFormat('d MMMM');
  static final DateFormat _monthYear = DateFormat('MMM yyyy');
  static final DateFormat _fullDateTime = DateFormat('dd MMM yyyy, hh:mm a');

  static String formatFull(DateTime date) => _fullDate.format(date);
  static String formatShort(DateTime date) => _shortDate.format(date);
  static String formatTime(DateTime date) => _timeOnly.format(date);
  static String formatDayMonth(DateTime date) => _dayMonth.format(date);
  static String formatMonthYear(DateTime date) => _monthYear.format(date);
  static String formatFullDateTime(DateTime date) => _fullDateTime.format(date);

  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'min' : 'mins'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      if (days == 1) return 'Yesterday';
      return '$days days ago';
    } else {
      return formatShort(date);
    }
  }

  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    if (hour < 21) return 'Good Evening';
    return 'Good Night';
  }

  static String formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) return 'Today';
    if (dateOnly == today.subtract(const Duration(days: 1))) return 'Yesterday';
    if (now.difference(date).inDays < 7) {
      return DateFormat('EEEE').format(date);
    }
    return formatFull(date);
  }
}
