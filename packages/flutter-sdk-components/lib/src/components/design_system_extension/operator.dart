import 'package:flutter/material.dart';

/// Operator component for displaying operator/user information
/// Similar to the React SDK's Operator component
class OperatorComponent extends StatelessWidget {
  /// Widget properties
  final Map<String, dynamic> props;

  /// Child widgets
  final List<Widget> children;

  const OperatorComponent({
    super.key,
    required this.props,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final name = props['name'] as String? ?? '';
    final label = props['label'] as String?;
    final id = props['id'] as String?;
    final avatar = props['avatar'] as String?;
    final showLabel = props['showLabel'] as bool? ?? true;
    final variant = props['variant'] as String? ?? 'default';

    if (variant == 'compact') {
      return _buildCompactOperator(context, name, avatar);
    }

    return _buildDefaultOperator(context, name, label, id, avatar, showLabel);
  }

  Widget _buildDefaultOperator(BuildContext context, String name, String? label,
      String? id, String? avatar, bool showLabel) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildAvatar(context, name, avatar),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showLabel && label != null && label.isNotEmpty)
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            if (id != null && id.isNotEmpty)
              Text(
                id,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildCompactOperator(
      BuildContext context, String name, String? avatar) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildAvatar(context, name, avatar, size: 24),
        const SizedBox(width: 8),
        Text(
          name,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(BuildContext context, String name, String? avatar,
      {double size = 40}) {
    final initials = _getInitials(name);

    if (avatar != null && avatar.isNotEmpty) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: NetworkImage(avatar),
      );
    }

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Theme.of(context).primaryColor,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: size / 2.5,
          fontWeight: FontWeight.bold,
        ),
      ),
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

/// Builder function for Operator component
Widget buildOperator(Map<String, dynamic> props, List<Widget> children) {
  return OperatorComponent(
    props: props,
    children: children,
  );
}
