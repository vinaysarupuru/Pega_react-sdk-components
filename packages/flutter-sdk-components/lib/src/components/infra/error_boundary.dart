import 'package:flutter/material.dart';

/// ErrorBoundary component for error handling
/// Similar to the React SDK's ErrorBoundary component
class ErrorBoundary extends StatelessWidget {
  /// Widget properties
  final Map<String, dynamic> props;

  /// Child widgets
  final List<Widget> children;

  const ErrorBoundary({
    super.key,
    required this.props,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final error = props['error'] as String?;
    final isInternalError = props['isInternalError'] as bool? ?? false;
    final componentName = props['componentName'] as String?;

    if (error != null || isInternalError) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          border: Border.all(color: Colors.red.shade200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red.shade700,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              isInternalError
                  ? 'Something went wrong'
                  : 'Error rendering component',
              style: TextStyle(
                color: Colors.red.shade900,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            if (componentName != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Component: $componentName',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 14,
                  ),
                ),
              ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  error,
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      );
    }

    // If no error, render children
    if (children.isNotEmpty) {
      return Column(
        children: children,
      );
    }

    return const SizedBox.shrink();
  }
}

/// Builder function for ErrorBoundary component
Widget buildErrorBoundary(Map<String, dynamic> props, List<Widget> children) {
  return ErrorBoundary(
    props: props,
    children: children,
  );
}
