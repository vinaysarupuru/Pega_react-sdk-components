import 'package:flutter/material.dart';

import '../helpers/case_utils.dart';

/// CaseSummary template component
/// Similar to the React SDK's CaseSummary component
class CaseSummary extends StatelessWidget {
  /// Template properties
  final Map<String, dynamic> props;

  /// Child widgets
  final List<Widget> children;

  const CaseSummary({
    super.key,
    required this.props,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final primaryFields = props['primaryFields'] as List<dynamic>? ?? [];
    final secondaryFields = props['secondaryFields'] as List<dynamic>? ?? [];
    final status = props['status'] as String?;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (status != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildStatusBadge(status),
            ),
          // Primary fields
          if (primaryFields.isNotEmpty)
            Wrap(
              spacing: 24,
              runSpacing: 12,
              children: primaryFields.map((field) {
                if (field is Map<String, dynamic>) {
                  return _buildField(
                    context,
                    field['label']?.toString() ?? '',
                    field['value']?.toString() ?? '',
                    isPrimary: true,
                  );
                }
                return const SizedBox.shrink();
              }).toList(),
            ),
          if (primaryFields.isNotEmpty && secondaryFields.isNotEmpty)
            const Divider(height: 24),
          // Secondary fields
          if (secondaryFields.isNotEmpty)
            Wrap(
              spacing: 24,
              runSpacing: 12,
              children: secondaryFields.map((field) {
                if (field is Map<String, dynamic>) {
                  return _buildField(
                    context,
                    field['label']?.toString() ?? '',
                    field['value']?.toString() ?? '',
                    isPrimary: false,
                  );
                }
                return const SizedBox.shrink();
              }).toList(),
            ),
          // Children
          if (children.isNotEmpty) ...[
            const Divider(height: 24),
            ...children,
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;

    if (isCaseResolved(status)) {
      backgroundColor = Colors.green.shade100;
      textColor = Colors.green.shade900;
    } else {
      backgroundColor = Colors.blue.shade100;
      textColor = Colors.blue.shade900;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        formatCaseStatus(status),
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildField(BuildContext context, String label, String value,
      {bool isPrimary = false}) {
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
            fontSize: isPrimary ? 16 : 14,
            fontWeight: isPrimary ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

/// Builder function for CaseSummary component
Widget buildCaseSummary(Map<String, dynamic> props, List<Widget> children) {
  return CaseSummary(
    props: props,
    children: children,
  );
}
