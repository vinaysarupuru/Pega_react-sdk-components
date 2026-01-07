import 'package:flutter/material.dart';

/// ListView template component
/// Similar to the React SDK's ListView component
class ListViewTemplate extends StatelessWidget {
  /// Template properties
  final Map<String, dynamic> props;

  /// Child widgets
  final List<Widget> children;

  const ListViewTemplate({
    super.key,
    required this.props,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final title = props['title'] as String?;
    final showTitle = props['showTitle'] as bool? ?? true;
    final data = props['data'] as List<dynamic>? ?? [];
    final columns = props['columns'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showTitle && title != null && title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        if (data.isNotEmpty && columns.isNotEmpty)
          _buildDataTable(context, data, columns)
        else if (children.isNotEmpty)
          ...children
        else
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('No data available'),
            ),
          ),
      ],
    );
  }

  Widget _buildDataTable(
    BuildContext context,
    List<dynamic> data,
    List<dynamic> columns,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: columns.map((col) {
          final column = col as Map<String, dynamic>;
          return DataColumn(
            label: Text(
              column['label']?.toString() ?? column['value']?.toString() ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        }).toList(),
        rows: data.map((row) {
          final rowData = row as Map<String, dynamic>;
          return DataRow(
            cells: columns.map((col) {
              final column = col as Map<String, dynamic>;
              final field = column['value'] as String? ?? '';
              final value = rowData[field]?.toString() ?? '';
              return DataCell(Text(value));
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}

/// Builder function for ListView component
Widget buildListView(Map<String, dynamic> props, List<Widget> children) {
  return ListViewTemplate(
    props: props,
    children: children,
  );
}
