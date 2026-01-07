import 'package:flutter/material.dart';

import '../../types/pconn_field_props.dart';
import '../helpers/event_utils.dart';
import '../../bridge/component_map.dart';

/// TextArea component for multi-line text field input
/// Similar to the React SDK's TextArea component
class TextAreaField extends StatefulWidget {
  /// Field properties
  final PConnFieldProps props;

  /// Number of rows
  final int rows;

  const TextAreaField({
    super.key,
    required this.props,
    this.rows = 5,
  });

  @override
  State<TextAreaField> createState() => _TextAreaFieldState();
}

class _TextAreaFieldState extends State<TextAreaField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.props.value ?? '');
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(TextAreaField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.props.value != oldWidget.props.value) {
      _controller.text = widget.props.value ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final props = widget.props;
    final pConn = props.getPConnect();
    final actionsApi = pConn.getActionsApi();
    final stateProps = pConn.getStateProps();
    final propName = stateProps['value'] as String? ?? '';

    final helperTextToDisplay = props.validatemessage ?? props.helperText;
    final maxLength = props.fieldMetadata?['maxLength'] as int?;

    // Handle display-only modes
    if (props.displayMode == DisplayMode.displayOnly) {
      return _buildFieldValueList(props.hideLabel ? '' : props.label, props.value ?? '');
    }

    if (props.displayMode == DisplayMode.stackedLargeVal) {
      return _buildFieldValueList(
        props.hideLabel ? '' : props.label,
        props.value ?? '',
        variant: 'stacked',
      );
    }

    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      readOnly: props.readOnly,
      enabled: !props.disabled,
      maxLines: widget.rows,
      minLines: 3,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: props.label,
        hintText: props.placeholder,
        helperText: helperTextToDisplay,
        errorText: props.status == 'error' ? helperTextToDisplay : null,
        border: props.readOnly
            ? InputBorder.none
            : const OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      onChanged: (value) {
        setState(() {});
      },
      onEditingComplete: () {
        if (!props.readOnly) {
          handleEvent(actionsApi, 'changeNblur', propName, _controller.text);
        }
      },
    );
  }

  Widget _buildFieldValueList(String name, String value, {String? variant}) {
    final fieldValueListBuilder = SdkComponentMap.getComponentFromMap('FieldValueList');
    if (fieldValueListBuilder != null) {
      return fieldValueListBuilder({
        'name': name,
        'value': value,
        'variant': variant,
      }, []);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (name.isNotEmpty)
          Text(
            name,
            style: TextStyle(
              fontSize: variant == 'stacked' ? 12 : 14,
              color: Colors.grey[600],
            ),
          ),
        Text(
          value,
          style: TextStyle(
            fontSize: variant == 'stacked' ? 18 : 16,
            fontWeight: variant == 'stacked' ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

/// Builder function for TextArea component
Widget buildTextArea(Map<String, dynamic> props, List<Widget> children) {
  return TextAreaField(
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
      fieldMetadata: props['fieldMetadata'],
    ),
    rows: props['rows'] ?? 5,
  );
}
