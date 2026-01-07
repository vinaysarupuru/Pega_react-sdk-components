import 'package:flutter/material.dart';

/// OneColumn template component
/// Similar to the React SDK's OneColumn component
class OneColumn extends StatelessWidget {
  /// Template properties
  final Map<String, dynamic> props;

  /// Child widgets
  final List<Widget> children;

  const OneColumn({
    super.key,
    required this.props,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

/// Builder function for OneColumn component
Widget buildOneColumn(Map<String, dynamic> props, List<Widget> children) {
  return OneColumn(
    props: props,
    children: children,
  );
}
