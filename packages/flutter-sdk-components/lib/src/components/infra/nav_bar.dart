import 'package:flutter/material.dart';

/// NavBar component for navigation
/// Similar to the React SDK's NavBar component
class NavBar extends StatelessWidget {
  /// Widget properties
  final Map<String, dynamic> props;

  /// Child widgets
  final List<Widget> children;

  const NavBar({
    super.key,
    required this.props,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final title = props['title'] as String? ?? '';
    final pages = props['pages'] as List<dynamic>? ?? [];
    final currentPage = props['currentPage'] as String?;
    final onPageChange = props['onPageChange'] as Function(String)?;

    return Column(
      children: [
        AppBar(
          title: Text(title),
          automaticallyImplyLeading: false,
        ),
        if (pages.isNotEmpty)
          Container(
            color: Theme.of(context).primaryColor.withAlpha((0.1 * 255).round()),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: pages.map((page) {
                  final pageData = page as Map<String, dynamic>;
                  final pageName = pageData['name'] as String? ?? '';
                  final pageLabel = pageData['label'] as String? ?? pageName;
                  final isSelected = currentPage == pageName;

                  return InkWell(
                    onTap: () => onPageChange?.call(pageName),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        pageLabel,
                        style: TextStyle(
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.grey[700],
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        Expanded(
          child: children.isNotEmpty
              ? children.first
              : const Center(child: Text('No content')),
        ),
      ],
    );
  }
}

/// Builder function for NavBar component
Widget buildNavBar(Map<String, dynamic> props, List<Widget> children) {
  return NavBar(
    props: props,
    children: children,
  );
}
