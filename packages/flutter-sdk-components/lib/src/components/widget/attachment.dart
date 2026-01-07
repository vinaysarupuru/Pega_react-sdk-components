import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

/// Attachment widget component
/// Similar to the React SDK's Attachment component
class Attachment extends StatefulWidget {
  /// Widget properties
  final Map<String, dynamic> props;

  /// Child widgets
  final List<Widget> children;

  const Attachment({
    super.key,
    required this.props,
    required this.children,
  });

  @override
  State<Attachment> createState() => _AttachmentState();
}

class _AttachmentState extends State<Attachment> {
  List<PlatformFile> _attachments = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final label = widget.props['label'] as String? ?? 'Attachments';
    final allowMultiple = widget.props['allowMultiple'] as bool? ?? true;
    final readOnly = widget.props['readOnly'] as bool? ?? false;
    final extensions = widget.props['extensions'] as List<String>?;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (!readOnly)
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : () => _pickFiles(allowMultiple, extensions),
                  icon: const Icon(Icons.attach_file),
                  label: const Text('Add'),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_attachments.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey.shade300,
                  style: BorderStyle.solid,
                ),
              ),
              child: const Center(
                child: Column(
                  children: [
                    Icon(Icons.cloud_upload_outlined, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('No attachments'),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _attachments.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final file = _attachments[index];
                return _buildAttachmentItem(file, readOnly);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildAttachmentItem(PlatformFile file, bool readOnly) {
    return ListTile(
      leading: Icon(_getFileIcon(file.extension)),
      title: Text(file.name),
      subtitle: Text(_formatFileSize(file.size)),
      trailing: readOnly
          ? IconButton(
              icon: const Icon(Icons.download),
              onPressed: () => _downloadFile(file),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () => _downloadFile(file),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _removeFile(file),
                ),
              ],
            ),
    );
  }

  IconData _getFileIcon(String? extension) {
    switch (extension?.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  Future<void> _pickFiles(bool allowMultiple, List<String>? extensions) async {
    setState(() => _isLoading = true);

    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: allowMultiple,
        type: extensions != null ? FileType.custom : FileType.any,
        allowedExtensions: extensions,
      );

      if (result != null) {
        setState(() {
          _attachments.addAll(result.files);
        });
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _downloadFile(PlatformFile file) {
    // Download logic would go here
  }

  void _removeFile(PlatformFile file) {
    setState(() {
      _attachments.remove(file);
    });
  }
}

/// Builder function for Attachment component
Widget buildAttachment(Map<String, dynamic> props, List<Widget> children) {
  return Attachment(
    props: props,
    children: children,
  );
}
