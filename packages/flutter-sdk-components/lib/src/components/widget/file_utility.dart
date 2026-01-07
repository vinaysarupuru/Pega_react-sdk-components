import 'package:flutter/material.dart';

import '../helpers/utils.dart';

/// FileUtility widget component
/// Similar to the React SDK's FileUtility component
class FileUtility extends StatelessWidget {
  /// Widget properties
  final Map<String, dynamic> props;

  /// Child widgets
  final List<Widget> children;

  const FileUtility({
    super.key,
    required this.props,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final title = props['title'] as String? ?? 'Files';
    final files = props['files'] as List<dynamic>? ?? [];
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
                      const Icon(Icons.folder_outlined, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  if (!readOnly)
                    ElevatedButton.icon(
                      onPressed: () {
                        // Upload file logic
                      },
                      icon: const Icon(Icons.upload_file, size: 20),
                      label: const Text('Upload'),
                    ),
                ],
              ),
            ),
          if (files.isEmpty)
            _buildEmptyState()
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: files.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final file = files[index] as Map<String, dynamic>;
                return _buildFileItem(context, file, readOnly);
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
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Center(
        child: Column(
          children: [
            Icon(Icons.cloud_upload_outlined, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              'No files uploaded',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 4),
            Text(
              'Drag and drop or click to upload',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileItem(
      BuildContext context, Map<String, dynamic> file, bool readOnly) {
    final name = file['name'] as String? ?? '';
    final size = file['size'] as int? ?? 0;
    final type = file['type'] as String?;
    final uploadedBy = file['uploadedBy'] as String?;
    final uploadedAt = file['uploadedAt'] as String?;

    return ListTile(
      leading: Icon(_getFileIcon(type)),
      title: Text(name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Utils.formatFileSize(size)),
          if (uploadedBy != null)
            Text(
              'Uploaded by $uploadedBy${uploadedAt != null ? ' on $uploadedAt' : ''}',
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
        ],
      ),
      trailing: PopupMenuButton<String>(
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'download',
            child: ListTile(
              leading: Icon(Icons.download),
              title: Text('Download'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const PopupMenuItem(
            value: 'preview',
            child: ListTile(
              leading: Icon(Icons.visibility),
              title: Text('Preview'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          if (!readOnly)
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete', style: TextStyle(color: Colors.red)),
                contentPadding: EdgeInsets.zero,
              ),
            ),
        ],
        onSelected: (value) {
          // Handle menu selection
        },
      ),
    );
  }

  IconData _getFileIcon(String? type) {
    if (type == null) return Icons.insert_drive_file;

    if (type.contains('pdf')) return Icons.picture_as_pdf;
    if (type.contains('word') || type.contains('doc')) return Icons.description;
    if (type.contains('excel') || type.contains('xls')) return Icons.table_chart;
    if (type.contains('image')) return Icons.image;
    if (type.contains('video')) return Icons.video_file;
    if (type.contains('audio')) return Icons.audio_file;

    return Icons.insert_drive_file;
  }
}

/// Builder function for FileUtility component
Widget buildFileUtility(Map<String, dynamic> props, List<Widget> children) {
  return FileUtility(
    props: props,
    children: children,
  );
}
