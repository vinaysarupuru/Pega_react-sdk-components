import 'package:flutter/material.dart';

/// FieldGroup component for grouping related fields
/// Similar to the React SDK's FieldGroup component
class FieldGroup extends StatelessWidget {
  /// Widget properties
  final Map<String, dynamic> props;

  /// Child widgets
  final List<Widget> children;

  const FieldGroup({
    super.key,
    required this.props,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final name = props['name'] as String?;
    final label = props['label'] as String?;
    final showLabel = props['showLabel'] as bool? ?? true;
    final collapsible = props['collapsible'] as bool? ?? false;
    final collapsed = props['collapsed'] as bool? ?? false;

    final displayLabel = label ?? name ?? '';

    if (collapsible) {
      return _buildCollapsibleGroup(context, displayLabel, showLabel, collapsed);
    }

    return _buildStaticGroup(context, displayLabel, showLabel);
  }

  Widget _buildStaticGroup(
      BuildContext context, String label, bool showLabel) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showLabel && label.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children.map((child) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: child,
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsibleGroup(
      BuildContext context, String label, bool showLabel, bool collapsed) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ExpansionTile(
        title: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        initiallyExpanded: !collapsed,
        childrenPadding: const EdgeInsets.all(16),
        children: children.map((child) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: child,
        )).toList(),
      ),
    );
  }
}

/// Builder function for FieldGroup component
Widget buildFieldGroup(Map<String, dynamic> props, List<Widget> children) {
  return FieldGroup(
    props: props,
    children: children,
  );
}
