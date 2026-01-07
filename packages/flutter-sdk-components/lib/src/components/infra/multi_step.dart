import 'package:flutter/material.dart';

/// MultiStep component for multi-step forms/wizards
/// Similar to the React SDK's MultiStep component
class MultiStep extends StatelessWidget {
  /// Widget properties
  final Map<String, dynamic> props;

  /// Child widgets
  final List<Widget> children;

  const MultiStep({
    super.key,
    required this.props,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final steps = props['steps'] as List<dynamic>? ?? [];
    final currentStep = props['currentStep'] as int? ?? 0;
    final showStepIndicator = props['showStepIndicator'] as bool? ?? true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showStepIndicator && steps.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildStepIndicator(context, steps, currentStep),
          ),
        Expanded(
          child: children.isNotEmpty
              ? children.first
              : const Center(child: Text('No step content')),
        ),
      ],
    );
  }

  Widget _buildStepIndicator(
      BuildContext context, List<dynamic> steps, int currentStep) {
    return Row(
      children: steps.asMap().entries.expand((entry) {
        final index = entry.key;
        final step = entry.value as Map<String, dynamic>;
        final label = step['label'] as String? ?? 'Step ${index + 1}';
        final isCompleted = index < currentStep;
        final isCurrent = index == currentStep;

        final widgets = <Widget>[
          _buildStepItem(context, index, label, isCompleted, isCurrent),
        ];

        if (index < steps.length - 1) {
          widgets.add(
            Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color: isCompleted
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade300,
              ),
            ),
          );
        }

        return widgets;
      }).toList(),
    );
  }

  Widget _buildStepItem(BuildContext context, int index, String label,
      bool isCompleted, bool isCurrent) {
    Color circleColor;
    Color textColor;
    Widget circleContent;

    if (isCompleted) {
      circleColor = Theme.of(context).primaryColor;
      textColor = Colors.grey[700]!;
      circleContent = const Icon(Icons.check, size: 16, color: Colors.white);
    } else if (isCurrent) {
      circleColor = Theme.of(context).primaryColor;
      textColor = Theme.of(context).primaryColor;
      circleContent = Text(
        '${index + 1}',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      );
    } else {
      circleColor = Colors.grey.shade400;
      textColor = Colors.grey.shade500;
      circleContent = Text(
        '${index + 1}',
        style: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isCurrent || isCompleted ? circleColor : Colors.white,
            border: Border.all(color: circleColor, width: 2),
            shape: BoxShape.circle,
          ),
          child: Center(child: circleContent),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 12,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

/// Builder function for MultiStep component
Widget buildMultiStep(Map<String, dynamic> props, List<Widget> children) {
  return MultiStep(
    props: props,
    children: children,
  );
}
