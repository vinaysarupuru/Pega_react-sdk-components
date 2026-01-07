import 'package:flutter/material.dart';

/// ActionButtons component for form action buttons
/// Similar to the React SDK's ActionButtons component
class ActionButtons extends StatelessWidget {
  /// Widget properties
  final Map<String, dynamic> props;

  /// Child widgets
  final List<Widget> children;

  const ActionButtons({
    super.key,
    required this.props,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final primaryLabel = props['primaryLabel'] as String? ?? 'Submit';
    final secondaryLabel = props['secondaryLabel'] as String? ?? 'Cancel';
    final showPrimary = props['showPrimary'] as bool? ?? true;
    final showSecondary = props['showSecondary'] as bool? ?? true;
    final onPrimary = props['onPrimary'] as VoidCallback?;
    final onSecondary = props['onSecondary'] as VoidCallback?;
    final isLoading = props['isLoading'] as bool? ?? false;
    final alignment = props['alignment'] as String? ?? 'end';

    MainAxisAlignment mainAxisAlignment;
    switch (alignment) {
      case 'start':
        mainAxisAlignment = MainAxisAlignment.start;
        break;
      case 'center':
        mainAxisAlignment = MainAxisAlignment.center;
        break;
      case 'spaceBetween':
        mainAxisAlignment = MainAxisAlignment.spaceBetween;
        break;
      default:
        mainAxisAlignment = MainAxisAlignment.end;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          if (showSecondary)
            OutlinedButton(
              onPressed: isLoading ? null : onSecondary,
              child: Text(secondaryLabel),
            ),
          if (showSecondary && showPrimary) const SizedBox(width: 12),
          if (showPrimary)
            ElevatedButton(
              onPressed: isLoading ? null : onPrimary,
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(primaryLabel),
            ),
        ],
      ),
    );
  }
}

/// Builder function for ActionButtons component
Widget buildActionButtons(Map<String, dynamic> props, List<Widget> children) {
  return ActionButtons(
    props: props,
    children: children,
  );
}
