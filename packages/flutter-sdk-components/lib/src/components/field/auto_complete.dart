import 'package:flutter/material.dart';

import '../../types/pconn_field_props.dart';
import '../helpers/event_utils.dart';
import '../../bridge/component_map.dart';

/// AutoComplete component for autocomplete text field input
/// Similar to the React SDK's AutoComplete component
class AutoCompleteField extends StatefulWidget {
  /// Field properties
  final PConnFieldProps props;

  /// Data source for suggestions
  final List<Map<String, dynamic>>? datasource;

  /// Minimum characters before showing suggestions
  final int minChars;

  const AutoCompleteField({
    super.key,
    required this.props,
    this.datasource,
    this.minChars = 1,
  });

  @override
  State<AutoCompleteField> createState() => _AutoCompleteFieldState();
}

class _AutoCompleteFieldState extends State<AutoCompleteField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.props.value ?? '');
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(AutoCompleteField oldWidget) {
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

  List<String> _getSuggestions(String query) {
    if (query.length < widget.minChars) return [];

    final options = widget.datasource ?? [];
    return options
        .map((option) => (option['value'] ?? option['text'] ?? '').toString())
        .where((text) => text.toLowerCase().contains(query.toLowerCase()))
        .toList();
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Autocomplete<String>(
          initialValue: TextEditingValue(text: props.value ?? ''),
          optionsBuilder: (textEditingValue) {
            return _getSuggestions(textEditingValue.text);
          },
          onSelected: (selection) {
            handleEvent(actionsApi, 'changeNblur', propName, selection);
          },
          fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              readOnly: props.readOnly,
              enabled: !props.disabled,
              decoration: InputDecoration(
                labelText: props.label,
                hintText: props.placeholder,
                helperText: helperTextToDisplay,
                errorText: props.status == 'error' ? helperTextToDisplay : null,
                border: props.readOnly
                    ? InputBorder.none
                    : const OutlineInputBorder(),
                suffixIcon: const Icon(Icons.search),
              ),
              onEditingComplete: () {
                onEditingComplete();
                if (!props.readOnly) {
                  handleEvent(actionsApi, 'changeNblur', propName, controller.text);
                }
              },
            );
          },
        ),
      ],
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

/// Builder function for AutoComplete component
Widget buildAutoComplete(Map<String, dynamic> props, List<Widget> children) {
  return AutoCompleteField(
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
    datasource: props['datasource'] is List
        ? List<Map<String, dynamic>>.from(props['datasource'])
        : null,
    minChars: props['minChars'] ?? 1,
  );
}
