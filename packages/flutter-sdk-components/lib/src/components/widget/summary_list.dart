import 'package:flutter/material.dart';

/// SummaryList widget component
/// Similar to the React SDK's SummaryList component
class SummaryList extends StatelessWidget {
  /// Widget properties
  final Map<String, dynamic> props;

  /// Child widgets
  final List<Widget> children;

  const SummaryList({
    super.key,
    required this.props,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final title = props['title'] as String?;
    final showTitle = props['showTitle'] as bool? ?? true;
    final items = props['items'] as List<dynamic>? ?? [];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showTitle && title != null && title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          if (items.isNotEmpty)
            ...items.map((item) {
              final itemData = item as Map<String, dynamic>;
              final label = itemData['label'] as String? ?? '';
              final value = itemData['value']?.toString() ?? '';

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        value,
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          if (children.isNotEmpty) ...children,
        ],
      ),
    );
  }
}

/// Builder function for SummaryList component
Widget buildSummaryList(Map<String, dynamic> props, List<Widget> children) {
  return SummaryList(
    props: props,
    children: children,
  );
}
