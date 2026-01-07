import 'package:flutter/material.dart';

/// Region component for rendering a region with children
/// Similar to the React SDK's Region component
class Region extends StatelessWidget {
  /// Widget properties
  final Map<String, dynamic> props;

  /// Child widgets
  final List<Widget> children;

  const Region({
    super.key,
    required this.props,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final title = props['title'] as String?;
    final showTitle = props['showTitle'] as bool? ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showTitle && title != null && title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ...children,
      ],
    );
  }
}

/// Builder function for Region component
Widget buildRegion(Map<String, dynamic> props, List<Widget> children) {
  return Region(
    props: props,
    children: children,
  );
}
