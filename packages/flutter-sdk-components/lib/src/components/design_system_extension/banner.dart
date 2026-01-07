import 'package:flutter/material.dart';

/// Banner component for displaying hero banners
/// Similar to the React SDK's Banner component
class BannerComponent extends StatelessWidget {
  /// Widget properties
  final Map<String, dynamic> props;

  /// Child widgets
  final List<Widget> children;

  const BannerComponent({
    super.key,
    required this.props,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final title = props['title'] as String?;
    final subtitle = props['subtitle'] as String?;
    final imageUrl = props['imageUrl'] as String?;
    final backgroundColor = props['backgroundColor'] as Color?;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).primaryColor,
        image: imageUrl != null
            ? DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withAlpha((0.3 * 255).round()),
                  BlendMode.darken,
                ),
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null && title.isNotEmpty)
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          if (subtitle != null && subtitle.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withAlpha((0.9 * 255).round()),
                    ),
              ),
            ),
          if (children.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: children,
              ),
            ),
        ],
      ),
    );
  }
}

/// Builder function for Banner component
Widget buildBanner(Map<String, dynamic> props, List<Widget> children) {
  return BannerComponent(
    props: props,
    children: children,
  );
}
