import 'package:intl/intl.dart';

/// Date format utility functions
/// Similar to the React SDK's date-format-utils.ts

/// Default date format
const String defaultDateFormat = 'MM/dd/yyyy';

/// Default time format
const String defaultTimeFormat = 'hh:mm a';

/// Default datetime format
const String defaultDateTimeFormat = 'MM/dd/yyyy hh:mm a';

/// Formats a date to a string
String formatDate(DateTime? date, {String? format}) {
  if (date == null) return '';

  final dateFormat = format ?? defaultDateFormat;

  try {
    return DateFormat(dateFormat).format(date);
  } catch (e) {
    return DateFormat(defaultDateFormat).format(date);
  }
}

/// Formats a time to a string
String formatTime(DateTime? time, {String? format}) {
  if (time == null) return '';

  final timeFormat = format ?? defaultTimeFormat;

  try {
    return DateFormat(timeFormat).format(time);
  } catch (e) {
    return DateFormat(defaultTimeFormat).format(time);
  }
}

/// Formats a datetime to a string
String formatDateTime(DateTime? dateTime, {String? format}) {
  if (dateTime == null) return '';

  final dateTimeFormat = format ?? defaultDateTimeFormat;

  try {
    return DateFormat(dateTimeFormat).format(dateTime);
  } catch (e) {
    return DateFormat(defaultDateTimeFormat).format(dateTime);
  }
}

/// Parses a date string to DateTime
DateTime? parseDate(String? dateString, {String? format}) {
  if (dateString == null || dateString.isEmpty) return null;

  // Try ISO 8601 format first
  final isoDate = DateTime.tryParse(dateString);
  if (isoDate != null) return isoDate;

  // Try custom format
  if (format != null) {
    try {
      return DateFormat(format).parse(dateString);
    } catch (e) {
      // Fall through to try other formats
    }
  }

  // Try common formats
  final commonFormats = [
    'MM/dd/yyyy',
    'yyyy-MM-dd',
    'dd/MM/yyyy',
    'MM-dd-yyyy',
    'yyyy/MM/dd',
  ];

  for (final fmt in commonFormats) {
    try {
      return DateFormat(fmt).parse(dateString);
    } catch (e) {
      // Try next format
    }
  }

  return null;
}

/// Parses a datetime string to DateTime
DateTime? parseDateTime(String? dateTimeString, {String? format}) {
  if (dateTimeString == null || dateTimeString.isEmpty) return null;

  // Try ISO 8601 format first
  final isoDateTime = DateTime.tryParse(dateTimeString);
  if (isoDateTime != null) return isoDateTime;

  // Try custom format
  if (format != null) {
    try {
      return DateFormat(format).parse(dateTimeString);
    } catch (e) {
      // Fall through to try other formats
    }
  }

  // Try common formats
  final commonFormats = [
    'MM/dd/yyyy hh:mm a',
    'yyyy-MM-dd HH:mm:ss',
    'dd/MM/yyyy HH:mm',
    'MM-dd-yyyy hh:mm a',
    "yyyy-MM-dd'T'HH:mm:ss",
    "yyyy-MM-dd'T'HH:mm:ss.SSS",
    "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
  ];

  for (final fmt in commonFormats) {
    try {
      return DateFormat(fmt).parse(dateTimeString);
    } catch (e) {
      // Try next format
    }
  }

  return null;
}

/// Converts a Pega date format to Dart format
String convertPegaDateFormat(String pegaFormat) {
  // Pega uses different format tokens than Dart
  return pegaFormat
      .replaceAll('YYYY', 'yyyy')
      .replaceAll('DD', 'dd')
      .replaceAll('D', 'd')
      .replaceAll('A', 'a')
      .replaceAll('h', 'hh')
      .replaceAll('H', 'HH');
}

/// Gets the relative date string
String getRelativeDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final dateOnly = DateTime(date.year, date.month, date.day);

  final difference = today.difference(dateOnly).inDays;

  if (difference == 0) return 'Today';
  if (difference == 1) return 'Yesterday';
  if (difference == -1) return 'Tomorrow';
  if (difference > 0 && difference < 7) return '$difference days ago';
  if (difference < 0 && difference > -7) return 'In ${-difference} days';

  return formatDate(date);
}

/// Checks if a date is today
bool isToday(DateTime date) {
  final now = DateTime.now();
  return date.year == now.year &&
      date.month == now.month &&
      date.day == now.day;
}

/// Checks if a date is in the past
bool isPast(DateTime date) {
  return date.isBefore(DateTime.now());
}

/// Checks if a date is in the future
bool isFuture(DateTime date) {
  return date.isAfter(DateTime.now());
}

/// Gets the start of day for a date
DateTime startOfDay(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

/// Gets the end of day for a date
DateTime endOfDay(DateTime date) {
  return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
}
