import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../types/pconn_field_props.dart';
import '../helpers/event_utils.dart';
import '../../bridge/component_map.dart';

/// RichText component for rich text/HTML field input
/// Similar to the React SDK's RichText component
class RichTextField extends StatefulWidget {
  /// Field properties
  final PConnFieldProps props;

  const RichTextField({
    super.key,
    required this.props,
  });

  @override
  State<RichTextField> createState() => _RichTextFieldState();
}

class _RichTextFieldState extends State<RichTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.props.value ?? '');
  }

  @override
  void didUpdateWidget(RichTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.props.value != oldWidget.props.value) {
      _controller.text = widget.props.value ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final props = widget.props;
    final helperTextToDisplay = props.validatemessage ?? props.helperText;

    // Handle display-only modes
    if (props.displayMode == DisplayMode.displayOnly ||
        props.displayMode == DisplayMode.stackedLargeVal ||
        props.readOnly) {
      return _buildRichTextDisplay(props);
    }

    // For editing, use a basic TextField with HTML preview
    // A full rich text editor would require additional packages
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!props.hideLabel && props.label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              props.label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        TextField(
          controller: _controller,
          readOnly: props.readOnly,
          enabled: !props.disabled,
          maxLines: 5,
          minLines: 3,
          decoration: InputDecoration(
            hintText: props.placeholder ?? 'Enter text...',
            helperText: helperTextToDisplay,
            errorText: props.status == 'error' ? helperTextToDisplay : null,
            border: const OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {});
          },
        ),
        if (_controller.text.isNotEmpty) ...[
          const SizedBox(height: 8),
          const Text(
            'Preview:',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Html(data: _controller.text),
          ),
        ],
      ],
    );
  }

  Widget _buildRichTextDisplay(PConnFieldProps props) {
    final variant = props.displayMode == DisplayMode.stackedLargeVal ? 'stacked' : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!props.hideLabel && props.label.isNotEmpty)
          Text(
            props.label,
            style: TextStyle(
              fontSize: variant == 'stacked' ? 12 : 14,
              color: Colors.grey[600],
            ),
          ),
        if (props.value != null && props.value!.isNotEmpty)
          Html(
            data: props.value!,
            style: {
              'body': Style(
                fontSize: FontSize(variant == 'stacked' ? 18 : 16),
                fontWeight: variant == 'stacked' ? FontWeight.bold : FontWeight.normal,
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
              ),
            },
          )
        else
          const Text(''),
      ],
    );
  }
}

/// Builder function for RichText component
Widget buildRichText(Map<String, dynamic> props, List<Widget> children) {
  return RichTextField(
    props: PConnFieldProps(
      getPConnect: props['getPConnect'],
      label: props['label'] ?? '',
      required: props['required'] ?? false,
      disabled: props['disabled'] ?? false,
      value: props['value'],
      validatemessage: props['validatemessage'],
      status: props['status'],
      onChange: props['onChange'],
      onBlur: props['onBlur'],
      readOnly: props['readOnly'] ?? false,
      testId: props['testId'],
      helperText: props['helperText'],
      displayMode: props['displayMode'],
      hideLabel: props['hideLabel'] ?? false,
      placeholder: props['placeholder'],
    ),
  );
}
