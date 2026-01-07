import 'package:flutter/material.dart';

/// NarrowWide template component (1:2 ratio)
/// Similar to the React SDK's NarrowWide component
class NarrowWide extends StatelessWidget {
  /// Template properties
  final Map<String, dynamic> props;

  /// Child widgets - expected to have 2 children (narrow and wide columns)
  final List<Widget> children;

  const NarrowWide({
    super.key,
    required this.props,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final narrowChild = children.isNotEmpty ? children[0] : const SizedBox.shrink();
    final wideChild = children.length > 1 ? children[1] : const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Use responsive layout - stack columns on small screens
          if (constraints.maxWidth < 600) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                narrowChild,
                const SizedBox(height: 16),
                wideChild,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 1, child: narrowChild),
              const SizedBox(width: 16),
              Expanded(flex: 2, child: wideChild),
            ],
          );
        },
      ),
    );
  }
}

/// Builder function for NarrowWide component
Widget buildNarrowWide(Map<String, dynamic> props, List<Widget> children) {
  return NarrowWide(
    props: props,
    children: children,
  );
}
