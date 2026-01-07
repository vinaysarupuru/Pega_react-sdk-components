import 'package:flutter/material.dart';

/// View component for rendering a view with children
/// Similar to the React SDK's View component
class ViewComponent extends StatelessWidget {
  /// Widget properties
  final Map<String, dynamic> props;

  /// Child widgets
  final List<Widget> children;

  const ViewComponent({
    super.key,
    required this.props,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final name = props['name'] as String?;
    final title = props['title'] as String?;
    final showLabel = props['showLabel'] as bool? ?? false;

    return Container(
      key: name != null ? ValueKey(name) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showLabel && title != null && title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ...children,
        ],
      ),
    );
  }
}

/// Builder function for View component
Widget buildView(Map<String, dynamic> props, List<Widget> children) {
  return ViewComponent(
    props: props,
    children: children,
  );
}
