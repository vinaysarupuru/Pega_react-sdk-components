import 'package:flutter/material.dart';

/// Stages component for displaying case stages/workflow progress
/// Similar to the React SDK's Stages component
class Stages extends StatelessWidget {
  /// Widget properties
  final Map<String, dynamic> props;

  /// Child widgets
  final List<Widget> children;

  const Stages({
    super.key,
    required this.props,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final stages = props['stages'] as List<dynamic>? ?? [];
    final currentStageIndex = props['currentStageIndex'] as int? ?? 0;
    final orientation = props['orientation'] as String? ?? 'horizontal';

    if (stages.isEmpty) {
      return const SizedBox.shrink();
    }

    if (orientation == 'vertical') {
      return _buildVerticalStages(context, stages, currentStageIndex);
    }

    return _buildHorizontalStages(context, stages, currentStageIndex);
  }

  Widget _buildHorizontalStages(
      BuildContext context, List<dynamic> stages, int currentIndex) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: stages.asMap().entries.expand((entry) {
          final index = entry.key;
          final stage = entry.value as Map<String, dynamic>;
          final name = stage['name'] as String? ?? '';
          final isCompleted = index < currentIndex;
          final isCurrent = index == currentIndex;

          final widgets = <Widget>[
            _buildStageIndicator(context, index, name, isCompleted, isCurrent),
          ];

          if (index < stages.length - 1) {
            widgets.add(
              Expanded(
                child: Container(
                  height: 2,
                  color: isCompleted
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade300,
                ),
              ),
            );
          }

          return widgets;
        }).toList(),
      ),
    );
  }

  Widget _buildVerticalStages(
      BuildContext context, List<dynamic> stages, int currentIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: stages.asMap().entries.expand((entry) {
        final index = entry.key;
        final stage = entry.value as Map<String, dynamic>;
        final name = stage['name'] as String? ?? '';
        final isCompleted = index < currentIndex;
        final isCurrent = index == currentIndex;

        final widgets = <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _buildStageIndicator(
                context, index, name, isCompleted, isCurrent),
          ),
        ];

        if (index < stages.length - 1) {
          widgets.add(
            Container(
              width: 2,
              height: 24,
              margin: const EdgeInsets.only(left: 14),
              color: isCompleted
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade300,
            ),
          );
        }

        return widgets;
      }).toList(),
    );
  }

  Widget _buildStageIndicator(BuildContext context, int index, String name,
      bool isCompleted, bool isCurrent) {
    Color indicatorColor;
    IconData? icon;

    if (isCompleted) {
      indicatorColor = Theme.of(context).primaryColor;
      icon = Icons.check;
    } else if (isCurrent) {
      indicatorColor = Theme.of(context).primaryColor;
    } else {
      indicatorColor = Colors.grey.shade400;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: isCurrent || isCompleted ? indicatorColor : Colors.white,
            border: Border.all(color: indicatorColor, width: 2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isCompleted
                ? Icon(icon, size: 16, color: Colors.white)
                : Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: isCurrent ? Colors.white : indicatorColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          name,
          style: TextStyle(
            color: isCurrent
                ? Theme.of(context).primaryColor
                : isCompleted
                    ? Colors.grey[700]
                    : Colors.grey[500],
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

/// Builder function for Stages component
Widget buildStages(Map<String, dynamic> props, List<Widget> children) {
  return Stages(
    props: props,
    children: children,
  );
}
