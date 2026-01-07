/// Case utility functions
/// Similar to the React SDK's case-utils.tsx

/// Gets the case type icon
String getCaseTypeIcon(String? caseTypeName) {
  if (caseTypeName == null || caseTypeName.isEmpty) {
    return 'folder';
  }
  return 'folder';
}

/// Formats case status
String formatCaseStatus(String? status) {
  if (status == null || status.isEmpty) {
    return '';
  }

  // Convert status codes to readable format
  switch (status.toLowerCase()) {
    case 'open':
      return 'Open';
    case 'resolved':
    case 'resolved-completed':
      return 'Resolved';
    case 'pending':
      return 'Pending';
    case 'new':
      return 'New';
    default:
      // Convert snake_case or camelCase to Title Case
      return _toTitleCase(status);
  }
}

/// Converts a string to title case
String _toTitleCase(String text) {
  if (text.isEmpty) return text;

  // Split on common separators
  final words = text.split(RegExp(r'[-_\s]'));

  return words.map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}

/// Gets case urgency color
String getCaseUrgencyColor(int? urgency) {
  if (urgency == null) return 'normal';

  if (urgency >= 80) return 'high';
  if (urgency >= 50) return 'medium';
  return 'low';
}

/// Gets the time since a date (for case history, etc.)
String getTimeSince(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inDays > 365) {
    final years = (difference.inDays / 365).floor();
    return '$years ${years == 1 ? 'year' : 'years'} ago';
  }
  if (difference.inDays > 30) {
    final months = (difference.inDays / 30).floor();
    return '$months ${months == 1 ? 'month' : 'months'} ago';
  }
  if (difference.inDays > 0) {
    return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
  }
  if (difference.inHours > 0) {
    return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
  }
  if (difference.inMinutes > 0) {
    return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
  }
  return 'Just now';
}

/// Parses a case ID from a full case reference
String parseCaseId(String? caseReference) {
  if (caseReference == null || caseReference.isEmpty) {
    return '';
  }

  // Common format: CLASSNAME CASEID
  final parts = caseReference.split(' ');
  if (parts.length >= 2) {
    return parts.last;
  }

  return caseReference;
}

/// Gets case summary fields from config
List<Map<String, dynamic>> getCaseSummaryFields(Map<String, dynamic> config) {
  final fields = <Map<String, dynamic>>[];

  final primaryFields = config['primaryFields'];
  if (primaryFields is List) {
    for (final field in primaryFields) {
      if (field is Map<String, dynamic>) {
        fields.add({
          ...field,
          'isPrimary': true,
        });
      }
    }
  }

  final secondaryFields = config['secondaryFields'];
  if (secondaryFields is List) {
    for (final field in secondaryFields) {
      if (field is Map<String, dynamic>) {
        fields.add({
          ...field,
          'isPrimary': false,
        });
      }
    }
  }

  return fields;
}

/// Checks if a case is resolved
bool isCaseResolved(String? status) {
  if (status == null) return false;

  final lowerStatus = status.toLowerCase();
  return lowerStatus.contains('resolved') ||
      lowerStatus.contains('completed') ||
      lowerStatus.contains('closed');
}

/// Gets the case stage index
int getCaseStageIndex(List<Map<String, dynamic>> stages, String? currentStage) {
  if (currentStage == null || stages.isEmpty) {
    return 0;
  }

  for (int i = 0; i < stages.length; i++) {
    if (stages[i]['name'] == currentStage ||
        stages[i]['ID'] == currentStage) {
      return i;
    }
  }

  return 0;
}
