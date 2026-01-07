import 'package:flutter/material.dart';

import '../../types/pconn_field_props.dart';
import '../helpers/event_utils.dart';
import '../../bridge/component_map.dart';

/// Email component for email field input
/// Similar to the React SDK's Email component
class EmailField extends StatefulWidget {
  /// Field properties
  final PConnFieldProps props;

  const EmailField({
    super.key,
    required this.props,
  });

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.props.value ?? '');
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(EmailField oldWidget) {
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
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      enableSuggestions: false,
      decoration: InputDecoration(
        labelText: props.label,
        hintText: props.placeholder ?? 'Enter email',
        helperText: helperTextToDisplay,
        errorText: props.status == 'error' ? helperTextToDisplay : null,
        border: props.readOnly
            ? InputBorder.none
            : const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.email_outlined),
        suffixIcon: props.required
            ? const Icon(Icons.star, size: 8, color: Colors.red)
            : null,
      ),
      onChanged: (value) {
        setState(() {});
      },
      onEditingComplete: () {
        if (!props.readOnly) {
          handleEvent(actionsApi, 'changeNblur', propName, _controller.text);
        }
      },
      onSubmitted: (value) {
        if (!props.readOnly) {
          handleEvent(actionsApi, 'changeNblur', propName, value);
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

/// Builder function for Email component
Widget buildEmail(Map<String, dynamic> props, List<Widget> children) {
  return EmailField(
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
