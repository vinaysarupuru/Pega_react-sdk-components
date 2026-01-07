import 'package:flutter/material.dart';

/// SummaryItem widget component
/// Similar to the React SDK's SummaryItem component
class SummaryItem extends StatelessWidget {
  /// Widget properties
  final Map<String, dynamic> props;

  /// Child widgets
  final List<Widget> children;

  const SummaryItem({
    super.key,
    required this.props,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final label = props['label'] as String? ?? '';
    final value = props['value']?.toString() ?? '';
    final variant = props['variant'] as String?;
    final status = props['status'] as String?;

    Color? statusColor;
    if (status == 'success') {
      statusColor = Colors.green;
    } else if (status == 'warning') {
      statusColor = Colors.orange;
    } else if (status == 'error') {
      statusColor = Colors.red;
    }

    if (variant == 'stacked') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: statusColor,
          ),
        ),
      ],
    );
  }
}

/// Builder function for SummaryItem component
Widget buildSummaryItem(Map<String, dynamic> props, List<Widget> children) {
  return SummaryItem(
    props: props,
    children: children,
  );
}
