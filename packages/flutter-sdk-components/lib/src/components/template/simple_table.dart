import 'package:flutter/material.dart';

/// SimpleTable template component
/// Similar to the React SDK's SimpleTable component
class SimpleTable extends StatelessWidget {
  /// Template properties
  final Map<String, dynamic> props;

  /// Child widgets
  final List<Widget> children;

  const SimpleTable({
    super.key,
    required this.props,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final label = props['label'] as String?;
    final showLabel = props['showLabel'] as bool? ?? true;
    final fieldDefs = props['fieldDefs'] as List<dynamic>? ?? [];
    final referenceList = props['referenceList'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showLabel && label != null && label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        if (fieldDefs.isNotEmpty && referenceList.isNotEmpty)
          _buildTable(context, fieldDefs, referenceList)
        else if (children.isNotEmpty)
          ...children
        else
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text('No data available'),
            ),
          ),
      ],
    );
  }

  Widget _buildTable(
    BuildContext context,
    List<dynamic> fieldDefs,
    List<dynamic> data,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: fieldDefs.map((field) {
          final fieldDef = field as Map<String, dynamic>;
          return DataColumn(
            label: Text(
              fieldDef['label']?.toString() ?? fieldDef['name']?.toString() ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        }).toList(),
        rows: data.map((row) {
          final rowData = row as Map<String, dynamic>;
          return DataRow(
            cells: fieldDefs.map((field) {
              final fieldDef = field as Map<String, dynamic>;
              final name = fieldDef['name'] as String? ?? '';
              final value = rowData[name]?.toString() ?? '';
              return DataCell(Text(value));
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}

/// Builder function for SimpleTable component
Widget buildSimpleTable(Map<String, dynamic> props, List<Widget> children) {
  return SimpleTable(
    props: props,
    children: children,
  );
}
