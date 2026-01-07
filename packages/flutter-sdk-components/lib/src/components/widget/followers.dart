import 'package:flutter/material.dart';

/// Followers widget component
/// Similar to the React SDK's Followers component
class Followers extends StatelessWidget {
  /// Widget properties
  final Map<String, dynamic> props;

  /// Child widgets
  final List<Widget> children;

  const Followers({
    super.key,
    required this.props,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final title = props['title'] as String? ?? 'Followers';
    final followers = props['followers'] as List<dynamic>? ?? [];
    final showTitle = props['showTitle'] as bool? ?? true;
    final readOnly = props['readOnly'] as bool? ?? false;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showTitle)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.people_outline, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${followers.length}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (!readOnly)
                    TextButton.icon(
                      onPressed: () {
                        // Add follower logic
                      },
                      icon: const Icon(Icons.person_add_outlined, size: 20),
                      label: const Text('Follow'),
                    ),
                ],
              ),
            ),
          if (followers.isEmpty)
            _buildEmptyState()
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: followers.map((follower) {
                final user = follower as Map<String, dynamic>;
                return _buildFollowerChip(context, user, readOnly);
              }).toList(),
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
            Icon(Icons.person_off_outlined, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              'No followers',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFollowerChip(
      BuildContext context, Map<String, dynamic> user, bool readOnly) {
    final name = user['name'] as String? ?? '';
    final avatar = user['avatar'] as String?;
    final initials = _getInitials(name);

    return Chip(
      avatar: avatar != null
          ? CircleAvatar(
              backgroundImage: NetworkImage(avatar),
            )
          : CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
      label: Text(name),
      deleteIcon: readOnly ? null : const Icon(Icons.close, size: 18),
      onDeleted: readOnly
          ? null
          : () {
              // Remove follower logic
            },
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '?';
  }
}

/// Builder function for Followers component
Widget buildFollowers(Map<String, dynamic> props, List<Widget> children) {
  return Followers(
    props: props,
    children: children,
  );
}
