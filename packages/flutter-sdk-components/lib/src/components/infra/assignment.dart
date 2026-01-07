import 'package:flutter/material.dart';

/// Assignment component for handling work assignments
/// Similar to the React SDK's Assignment component
class Assignment extends StatelessWidget {
  /// Widget properties
  final Map<String, dynamic> props;

  /// Child widgets
  final List<Widget> children;

  const Assignment({
    super.key,
    required this.props,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final header = props['header'] as String?;
    final subheader = props['subheader'] as String?;
    final itemKey = props['itemKey'] as String?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (header != null || subheader != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withAlpha((0.05 * 255).round()),
              border: Border(
                bottom: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (header != null)
                  Text(
                    header,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                if (subheader != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      subheader,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ),
                if (itemKey != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      itemKey,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[500],
                          ),
                    ),
                  ),
              ],
            ),
          ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ],
    );
  }
}

/// Builder function for Assignment component
Widget buildAssignment(Map<String, dynamic> props, List<Widget> children) {
  return Assignment(
    props: props,
    children: children,
  );
}
