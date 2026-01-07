import 'package:flutter/material.dart';

/// Details template component
/// Similar to the React SDK's Details component
class Details extends StatelessWidget {
  /// Template properties
  final Map<String, dynamic> props;

  /// Child widgets
  final List<Widget> children;

  const Details({
    super.key,
    required this.props,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final showLabel = props['showLabel'] as bool? ?? true;
    final label = props['label'] as String?;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showLabel && label != null && label.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ...children.map((child) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: child,
              )),
        ],
      ),
    );
  }
}

/// Builder function for Details component
Widget buildDetails(Map<String, dynamic> props, List<Widget> children) {
  return Details(
    props: props,
    children: children,
  );
}
