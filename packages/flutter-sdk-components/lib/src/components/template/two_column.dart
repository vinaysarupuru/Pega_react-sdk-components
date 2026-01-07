import 'package:flutter/material.dart';

/// TwoColumn template component
/// Similar to the React SDK's TwoColumn component
class TwoColumn extends StatelessWidget {
  /// Template properties
  final Map<String, dynamic> props;

  /// Child widgets - expected to have 2 children (left and right columns)
  final List<Widget> children;

  const TwoColumn({
    super.key,
    required this.props,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final leftChild = children.isNotEmpty ? children[0] : const SizedBox.shrink();
    final rightChild = children.length > 1 ? children[1] : const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Use responsive layout - stack columns on small screens
          if (constraints.maxWidth < 600) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                leftChild,
                const SizedBox(height: 16),
                rightChild,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: leftChild),
              const SizedBox(width: 16),
              Expanded(child: rightChild),
            ],
          );
        },
      ),
    );
  }
}

/// Builder function for TwoColumn component
Widget buildTwoColumn(Map<String, dynamic> props, List<Widget> children) {
  return TwoColumn(
    props: props,
    children: children,
  );
}
