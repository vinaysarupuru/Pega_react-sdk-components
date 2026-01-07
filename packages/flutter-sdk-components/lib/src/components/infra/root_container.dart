import 'package:flutter/material.dart';

/// RootContainer component for the main application container
/// Similar to the React SDK's RootContainer component
class RootContainer extends StatelessWidget {
  /// Widget properties
  final Map<String, dynamic> props;

  /// Child widgets
  final List<Widget> children;

  const RootContainer({
    super.key,
    required this.props,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final httpMessages = props['httpMessages'] as List<dynamic>?;
    final showMessages = httpMessages != null && httpMessages.isNotEmpty;

    return Scaffold(
      body: Column(
        children: [
          if (showMessages)
            Container(
              color: Colors.orange.shade100,
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange.shade800),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      httpMessages!.first.toString(),
                      style: TextStyle(color: Colors.orange.shade900),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: children.isNotEmpty
                ? children.first
                : const Center(child: Text('No content')),
          ),
        ],
      ),
    );
  }
}

/// Builder function for RootContainer component
Widget buildRootContainer(Map<String, dynamic> props, List<Widget> children) {
  return RootContainer(
    props: props,
    children: children,
  );
}
