import 'package:flutter/material.dart';

import '../helpers/case_utils.dart';

/// CaseView template component
/// Similar to the React SDK's CaseView component
class CaseView extends StatelessWidget {
  /// Template properties
  final Map<String, dynamic> props;

  /// Child widgets
  final List<Widget> children;

  const CaseView({
    super.key,
    required this.props,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final header = props['header'] as String? ?? '';
    final subheader = props['subheader'] as String?;
    final status = props['status'] as String?;
    final caseId = props['caseId'] as String?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Case header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withAlpha((0.1 * 255).round()),
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      header,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  if (status != null)
                    _buildStatusChip(context, status),
                ],
              ),
              if (subheader != null && subheader.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    subheader,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ),
              if (caseId != null && caseId.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Case ID: $caseId',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                        ),
                  ),
                ),
            ],
          ),
        ),
        // Case content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    Color backgroundColor;
    Color textColor;

    if (isCaseResolved(status)) {
      backgroundColor = Colors.green.shade100;
      textColor = Colors.green.shade900;
    } else {
      backgroundColor = Colors.blue.shade100;
      textColor = Colors.blue.shade900;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        formatCaseStatus(status),
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// Builder function for CaseView component
Widget buildCaseView(Map<String, dynamic> props, List<Widget> children) {
  return CaseView(
    props: props,
    children: children,
  );
}
