import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Data Page utility functions
/// Similar to the React SDK's data_page.ts

/// Gets data from a Pega data page
Future<List<Map<String, dynamic>>> getDataPage(
  String dataPageName, [
  Map<String, dynamic>? parameters,
  String? context,
]) async {
  // This would typically call PCore to get data page
  // The actual implementation depends on the Pega Constellation JS engine

  // Placeholder implementation
  return [];
}

/// Gets data page with caching
class DataPageCache {
  static final Map<String, _CacheEntry> _cache = {};
  static const Duration _defaultTtl = Duration(minutes: 5);

  /// Gets data from cache or fetches it
  static Future<List<Map<String, dynamic>>> getOrFetch(
    String dataPageName, {
    Map<String, dynamic>? parameters,
    String? context,
    Duration? ttl,
  }) async {
    final cacheKey = _generateCacheKey(dataPageName, parameters);
    final entry = _cache[cacheKey];

    if (entry != null && !entry.isExpired) {
      return entry.data;
    }

    final data = await getDataPage(dataPageName, parameters, context);

    _cache[cacheKey] = _CacheEntry(
      data: data,
      expiry: DateTime.now().add(ttl ?? _defaultTtl),
    );

    return data;
  }

  /// Clears a specific cache entry
  static void clear(String dataPageName, [Map<String, dynamic>? parameters]) {
    final cacheKey = _generateCacheKey(dataPageName, parameters);
    _cache.remove(cacheKey);
  }

  /// Clears all cache entries
  static void clearAll() {
    _cache.clear();
  }

  /// Clears expired cache entries
  static void clearExpired() {
    _cache.removeWhere((_, entry) => entry.isExpired);
  }

  static String _generateCacheKey(
    String dataPageName,
    Map<String, dynamic>? parameters,
  ) {
    if (parameters == null || parameters.isEmpty) {
      return dataPageName;
    }

    final sortedParams = Map.fromEntries(
      parameters.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );

    return '$dataPageName:${json.encode(sortedParams)}';
  }
}

class _CacheEntry {
  final List<Map<String, dynamic>> data;
  final DateTime expiry;

  _CacheEntry({required this.data, required this.expiry});

  bool get isExpired => DateTime.now().isAfter(expiry);
}

/// Flattens parameters for data page calls
Map<String, dynamic> flattenParameters(Map<String, dynamic> params) {
  final flatParams = <String, dynamic>{};

  for (final entry in params.entries) {
    final value = entry.value;
    if (value is Map && value.containsKey('name') && value.containsKey('value')) {
      flatParams[value['name'] as String] = value['value'];
    } else {
      flatParams[entry.key] = value;
    }
  }

  return flatParams;
}

/// Pre-processes columns for display
List<Map<String, dynamic>> preProcessColumns(List<Map<String, dynamic>> columnList) {
  return columnList.map((col) {
    final tempColObj = Map<String, dynamic>.from(col);
    final value = tempColObj['value'] as String?;
    if (value != null && value.startsWith('.')) {
      tempColObj['value'] = value.substring(1);
    }
    return tempColObj;
  }).toList();
}

/// Gets display fields metadata from column list
Map<String, dynamic> getDisplayFieldsMetaData(List<Map<String, dynamic>> columnList) {
  final displayColumns = columnList.where(
    (col) => col['display'] == 'true' || col['display'] == true,
  ).toList();

  final metaDataObj = <String, dynamic>{
    'key': '',
    'primary': '',
    'secondary': <String>[],
  };

  final keyCol = columnList.where(
    (col) => col['key'] == 'true' || col['key'] == true,
  ).toList();

  metaDataObj['key'] = keyCol.isNotEmpty ? keyCol.first['value'] : 'auto';

  for (final col in displayColumns) {
    if (col['primary'] == 'true' || col['primary'] == true) {
      metaDataObj['primary'] = col['value'];
    } else {
      (metaDataObj['secondary'] as List<String>).add(col['value'] as String);
    }
  }

  return metaDataObj;
}

/// Makes a REST API call (placeholder for actual implementation)
Future<Map<String, dynamic>> makeApiCall(
  String endpoint, {
  String method = 'GET',
  Map<String, String>? headers,
  Map<String, dynamic>? body,
}) async {
  // This would typically use the actual API client
  // For now, this is a placeholder

  final uri = Uri.parse(endpoint);

  http.Response response;

  switch (method.toUpperCase()) {
    case 'POST':
      response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          ...?headers,
        },
        body: body != null ? json.encode(body) : null,
      );
      break;
    case 'PUT':
      response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          ...?headers,
        },
        body: body != null ? json.encode(body) : null,
      );
      break;
    case 'DELETE':
      response = await http.delete(
        uri,
        headers: headers,
      );
      break;
    default:
      response = await http.get(uri, headers: headers);
  }

  if (response.statusCode >= 200 && response.statusCode < 300) {
    return json.decode(response.body) as Map<String, dynamic>;
  }

  throw Exception('API call failed with status: ${response.statusCode}');
}
