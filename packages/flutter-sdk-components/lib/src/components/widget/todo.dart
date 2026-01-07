import 'package:flutter/material.dart';

/// ToDo widget component
/// Similar to the React SDK's ToDo component
class ToDoWidget extends StatelessWidget {
  /// Widget properties
  final Map<String, dynamic> props;

  /// Child widgets
  final List<Widget> children;

  const ToDoWidget({
    super.key,
    required this.props,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final title = props['title'] as String? ?? 'To Do';
    final tasks = props['tasks'] as List<dynamic>? ?? [];
    final showTitle = props['showTitle'] as bool? ?? true;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showTitle)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  const Icon(Icons.checklist, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withAlpha((0.1 * 255).round()),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${tasks.length}',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (tasks.isEmpty)
            _buildEmptyState()
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index] as Map<String, dynamic>;
                return _buildTaskItem(context, task);
              },
            ),
          if (children.isNotEmpty) ...children,
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Column(
          children: [
            Icon(Icons.check_circle_outline, size: 48, color: Colors.green),
            SizedBox(height: 8),
            Text(
              'No pending tasks',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, Map<String, dynamic> task) {
    final name = task['name'] as String? ?? '';
    final assignee = task['assignee'] as String?;
    final dueDate = task['dueDate'] as String?;
    final urgency = task['urgency'] as String?;

    Color urgencyColor = Colors.grey;
    if (urgency == 'high') {
      urgencyColor = Colors.red;
    } else if (urgency == 'medium') {
      urgencyColor = Colors.orange;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(
            color: urgencyColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (assignee != null)
              Text(
                'Assigned to: $assignee',
                style: const TextStyle(fontSize: 12),
              ),
            if (dueDate != null)
              Text(
                'Due: $dueDate',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 16),
          onPressed: () {
            // Navigate to task details
          },
        ),
        onTap: () {
          // Open task
        },
      ),
    );
  }
}

/// Builder function for ToDo component
Widget buildToDo(Map<String, dynamic> props, List<Widget> children) {
  return ToDoWidget(
    props: props,
    children: children,
  );
}
