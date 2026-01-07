import 'package:flutter/material.dart';

/// WideNarrow template component (2:1 ratio)
/// Similar to the React SDK's WideNarrow component
class WideNarrow extends StatelessWidget {
  /// Template properties
  final Map<String, dynamic> props;

  /// Child widgets - expected to have 2 children (wide and narrow columns)
  final List<Widget> children;

  const WideNarrow({
    super.key,
    required this.props,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final wideChild = children.isNotEmpty ? children[0] : const SizedBox.shrink();
    final narrowChild = children.length > 1 ? children[1] : const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Use responsive layout - stack columns on small screens
          if (constraints.maxWidth < 600) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                wideChild,
                const SizedBox(height: 16),
                narrowChild,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: wideChild),
              const SizedBox(width: 16),
              Expanded(flex: 1, child: narrowChild),
            ],
          );
        },
      ),
    );
  }
}

/// Builder function for WideNarrow component
Widget buildWideNarrow(Map<String, dynamic> props, List<Widget> children) {
  return WideNarrow(
    props: props,
    children: children,
  );
}
