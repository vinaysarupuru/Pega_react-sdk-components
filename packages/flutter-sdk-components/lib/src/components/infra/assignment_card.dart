import 'package:flutter/material.dart';

/// AssignmentCard component for displaying assignment summary
/// Similar to the React SDK's AssignmentCard component
class AssignmentCard extends StatelessWidget {
  /// Widget properties
  final Map<String, dynamic> props;

  /// Child widgets
  final List<Widget> children;

  /// On click callback
  final VoidCallback? onTap;

  const AssignmentCard({
    super.key,
    required this.props,
    required this.children,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final header = props['header'] as String? ?? '';
    final subheader = props['subheader'] as String?;
    final urgency = props['urgency'] as String?;
    final status = props['status'] as String?;
    final assignedTo = props['assignedTo'] as String?;

    Color urgencyColor = Colors.grey;
    if (urgency == 'high') {
      urgencyColor = Colors.red;
    } else if (urgency == 'medium') {
      urgencyColor = Colors.orange;
    } else if (urgency == 'low') {
      urgencyColor = Colors.blue;
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            // Urgency indicator
            Container(
              width: 4,
              constraints: const BoxConstraints(minHeight: 80),
              color: urgencyColor,
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            header,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (status != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              status,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                    if (subheader != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          subheader,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    if (assignedTo != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Icon(Icons.person_outline,
                                size: 16, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Text(
                              assignedTo,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (children.isNotEmpty) ...children,
                  ],
                ),
              ),
            ),
            // Arrow
            Padding(
              padding: const EdgeInsets.all(16),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Builder function for AssignmentCard component
Widget buildAssignmentCard(Map<String, dynamic> props, List<Widget> children) {
  return AssignmentCard(
    props: props,
    children: children,
    onTap: props['onTap'] as VoidCallback?,
  );
}
