import 'package:flutter/material.dart';

/// Utility functions for the Flutter SDK components
class Utils {
  /// Generates option list from props and data object
  static List<Map<String, dynamic>> getOptionList(
    Map<String, dynamic> props,
    Map<String, dynamic> dataObject,
  ) {
    final List<Map<String, dynamic>> options = [];

    final datasource = props['datasource'];
    if (datasource == null) return options;

    if (datasource is List) {
      for (final item in datasource) {
        if (item is Map<String, dynamic>) {
          options.add({
            'key': item['key'] ?? item['value'] ?? '',
            'value': item['value'] ?? item['text'] ?? '',
          });
        }
      }
    } else if (datasource is Map && datasource.containsKey('source')) {
      final source = datasource['source'];
      if (source is List) {
        for (final item in source) {
          if (item is Map<String, dynamic>) {
            options.add({
              'key': item['key'] ?? item['value'] ?? '',
              'value': item['value'] ?? item['text'] ?? '',
            });
          }
        }
      }
    }

    return options;
  }

  /// Gets formatted value for display
  static String getFormattedValue(dynamic value, String format) {
    if (value == null) return '';

    switch (format.toLowerCase()) {
      case 'currency':
        return formatCurrency(value);
      case 'percentage':
        return formatPercentage(value);
      case 'date':
        return formatDate(value);
      case 'datetime':
        return formatDateTime(value);
      default:
        return value.toString();
    }
  }

  /// Formats a value as currency
  static String formatCurrency(dynamic value, {String symbol = '\$'}) {
    if (value == null) return '';
    final numValue = double.tryParse(value.toString());
    if (numValue == null) return value.toString();
    return '$symbol${numValue.toStringAsFixed(2)}';
  }

  /// Formats a value as percentage
  static String formatPercentage(dynamic value) {
    if (value == null) return '';
    final numValue = double.tryParse(value.toString());
    if (numValue == null) return value.toString();
    return '${(numValue * 100).toStringAsFixed(2)}%';
  }

  /// Formats a date value
  static String formatDate(dynamic value) {
    if (value == null) return '';
    if (value is DateTime) {
      return '${value.month}/${value.day}/${value.year}';
    }
    // Try to parse string date
    final date = DateTime.tryParse(value.toString());
    if (date != null) {
      return '${date.month}/${date.day}/${date.year}';
    }
    return value.toString();
  }

  /// Formats a datetime value
  static String formatDateTime(dynamic value) {
    if (value == null) return '';
    if (value is DateTime) {
      return '${value.month}/${value.day}/${value.year} ${_formatTime(value)}';
    }
    // Try to parse string datetime
    final dateTime = DateTime.tryParse(value.toString());
    if (dateTime != null) {
      return '${dateTime.month}/${dateTime.day}/${dateTime.year} ${_formatTime(dateTime)}';
    }
    return value.toString();
  }

  static String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  /// Checks if a string is not empty
  static bool isNotBlank(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// Gets nested property from a map
  static dynamic getNestedProperty(Map<String, dynamic> obj, String path) {
    final keys = path.split('.');
    dynamic current = obj;

    for (final key in keys) {
      if (current is Map<String, dynamic> && current.containsKey(key)) {
        current = current[key];
      } else {
        return null;
      }
    }

    return current;
  }

  /// Deep clones a map
  static Map<String, dynamic> deepClone(Map<String, dynamic> source) {
    return Map<String, dynamic>.from(source.map((key, value) {
      if (value is Map<String, dynamic>) {
        return MapEntry(key, deepClone(value));
      } else if (value is List) {
        return MapEntry(key, _deepCloneList(value));
      }
      return MapEntry(key, value);
    }));
  }

  static List _deepCloneList(List source) {
    return source.map((item) {
      if (item is Map<String, dynamic>) {
        return deepClone(item);
      } else if (item is List) {
        return _deepCloneList(item);
      }
      return item;
    }).toList();
  }

  /// Generates a unique identifier
  static String generateUID() {
    final now = DateTime.now();
    return '_${now.millisecondsSinceEpoch.toRadixString(36)}_${(1000 + now.microsecond).toString()}';
  }

  /// Formats a file size in bytes to a human-readable string
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Gets initials from a name (e.g., "John Doe" -> "JD")
  static String getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '?';
  }

  /// Checks if two objects are deeply equal
  static bool deepEqual(dynamic a, dynamic b) {
    if (a == b) return true;
    if (a == null || b == null) return false;
    if (a.runtimeType != b.runtimeType) return false;

    if (a is Map && b is Map) {
      if (a.length != b.length) return false;
      for (final key in a.keys) {
        if (!b.containsKey(key) || !deepEqual(a[key], b[key])) {
          return false;
        }
      }
      return true;
    }

    if (a is List && b is List) {
      if (a.length != b.length) return false;
      for (int i = 0; i < a.length; i++) {
        if (!deepEqual(a[i], b[i])) return false;
      }
      return true;
    }

    return false;
  }
}

/// Status constants
class ComponentStatus {
  static const String error = 'error';
  static const String warning = 'warning';
  static const String success = 'success';
  static const String info = 'info';
}

/// Visibility utility for list components
void setVisibilityForList(dynamic pConnect, bool visibility) {
  final config = pConnect.getComponentConfig?.() ?? {};
  final selectionMode = config['selectionMode'];
  final selectionList = config['selectionList'];
  final renderMode = config['renderMode'];
  final referenceList = config['referenceList'];

  // usecase: multiselect, fieldgroup, editable table
  if ((selectionMode == 'MULTI' && selectionList != null) ||
      (renderMode == 'Editable' && referenceList != null)) {
    pConnect.getListActions?.()?.setVisibility(visibility);
  }
}
