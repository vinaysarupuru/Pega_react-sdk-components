import 'package:flutter/material.dart';

/// FieldValueList component for displaying field name-value pairs
/// Similar to the React SDK's FieldValueList component
class FieldValueList extends StatelessWidget {
  /// Widget properties
  final Map<String, dynamic> props;

  /// Child widgets
  final List<Widget> children;

  const FieldValueList({
    super.key,
    required this.props,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final name = props['name'] as String? ?? '';
    final value = props['value']?.toString() ?? '';
    final variant = props['variant'] as String?;

    if (variant == 'stacked') {
      return _buildStackedLayout(context, name, value);
    }

    return _buildInlineLayout(context, name, value);
  }

  Widget _buildStackedLayout(BuildContext context, String name, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (name.isNotEmpty)
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
          ),
        const SizedBox(height: 2),
        Text(
          value.isEmpty ? '-' : value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInlineLayout(BuildContext context, String name, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (name.isNotEmpty)
          Expanded(
            flex: 1,
            child: Text(
              name,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
        Expanded(
          flex: 2,
          child: Text(
            value.isEmpty ? '-' : value,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

/// Builder function for FieldValueList component
Widget buildFieldValueList(Map<String, dynamic> props, List<Widget> children) {
  return FieldValueList(
    props: props,
    children: children,
  );
}
