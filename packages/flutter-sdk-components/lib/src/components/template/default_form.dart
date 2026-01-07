import 'package:flutter/material.dart';

/// DefaultForm template component
/// Similar to the React SDK's DefaultForm component
class DefaultForm extends StatelessWidget {
  /// Template properties
  final Map<String, dynamic> props;

  /// Child widgets (form fields)
  final List<Widget> children;

  const DefaultForm({
    super.key,
    required this.props,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final instructions = props['instructions'] as String?;
    final showInstructions = instructions != null && instructions.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showInstructions)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        instructions!,
                        style: TextStyle(color: Colors.blue.shade900),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ...children.map((child) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: child,
              )),
        ],
      ),
    );
  }
}

/// Builder function for DefaultForm component
Widget buildDefaultForm(Map<String, dynamic> props, List<Widget> children) {
  return DefaultForm(
    props: props,
    children: children,
  );
}
