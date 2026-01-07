import 'package:flutter/material.dart';

/// AlertBanner component for displaying alerts/notifications
/// Similar to the React SDK's AlertBanner component
class AlertBanner extends StatelessWidget {
  /// Widget properties
  final Map<String, dynamic> props;

  /// Child widgets
  final List<Widget> children;

  const AlertBanner({
    super.key,
    required this.props,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final message = props['message'] as String? ?? '';
    final variant = props['variant'] as String? ?? 'info';
    final dismissible = props['dismissible'] as bool? ?? true;
    final onDismiss = props['onDismiss'] as VoidCallback?;

    Color backgroundColor;
    Color borderColor;
    Color textColor;
    IconData icon;

    switch (variant) {
      case 'success':
        backgroundColor = Colors.green.shade50;
        borderColor = Colors.green.shade200;
        textColor = Colors.green.shade900;
        icon = Icons.check_circle_outline;
        break;
      case 'warning':
        backgroundColor = Colors.orange.shade50;
        borderColor = Colors.orange.shade200;
        textColor = Colors.orange.shade900;
        icon = Icons.warning_amber_outlined;
        break;
      case 'error':
        backgroundColor = Colors.red.shade50;
        borderColor = Colors.red.shade200;
        textColor = Colors.red.shade900;
        icon = Icons.error_outline;
        break;
      default: // info
        backgroundColor = Colors.blue.shade50;
        borderColor = Colors.blue.shade200;
        textColor = Colors.blue.shade900;
        icon = Icons.info_outline;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(color: textColor),
                ),
                if (children.isNotEmpty) ...children,
              ],
            ),
          ),
          if (dismissible)
            IconButton(
              icon: Icon(Icons.close, color: textColor, size: 18),
              onPressed: onDismiss,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}

/// Builder function for AlertBanner component
Widget buildAlertBanner(Map<String, dynamic> props, List<Widget> children) {
  return AlertBanner(
    props: props,
    children: children,
  );
}
