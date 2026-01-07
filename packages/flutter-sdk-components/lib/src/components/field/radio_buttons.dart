import 'package:flutter/material.dart';

import '../../types/pconn_field_props.dart';
import '../helpers/event_utils.dart';
import '../../bridge/component_map.dart';

/// RadioButtons component for single selection from options
/// Similar to the React SDK's RadioButtons component
class RadioButtonsField extends StatefulWidget {
  /// Field properties
  final PConnFieldProps props;

  /// Data source for options
  final List<Map<String, dynamic>>? datasource;

  /// Orientation (horizontal/vertical)
  final String orientation;

  const RadioButtonsField({
    super.key,
    required this.props,
    this.datasource,
    this.orientation = 'vertical',
  });

  @override
  State<RadioButtonsField> createState() => _RadioButtonsFieldState();
}

class _RadioButtonsFieldState extends State<RadioButtonsField> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.props.value;
  }

  @override
  void didUpdateWidget(RadioButtonsField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.props.value != oldWidget.props.value) {
      _selectedValue = widget.props.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final props = widget.props;
    final pConn = props.getPConnect();
    final actionsApi = pConn.getActionsApi();
    final stateProps = pConn.getStateProps();
    final propName = stateProps['value'] as String? ?? '';

    final helperTextToDisplay = props.validatemessage ?? props.helperText;
    final options = widget.datasource ?? [];

    // Handle display-only modes
    if (props.displayMode == DisplayMode.displayOnly) {
      final displayValue = options.firstWhere(
        (option) => option['key'] == props.value,
        orElse: () => {'value': props.value ?? ''},
      )['value'];

      return _buildFieldValueList(
        props.hideLabel ? '' : props.label,
        displayValue?.toString() ?? '',
      );
    }

    if (props.displayMode == DisplayMode.stackedLargeVal) {
      final displayValue = options.firstWhere(
        (option) => option['key'] == props.value,
        orElse: () => {'value': props.value ?? ''},
      )['value'];

      return _buildFieldValueList(
        props.hideLabel ? '' : props.label,
        displayValue?.toString() ?? '',
        variant: 'stacked',
      );
    }

    final radioButtons = options.map((option) {
      final key = option['key']?.toString() ?? '';
      final text = option['text'] ?? option['value'] ?? '';

      return RadioListTile<String>(
        value: key,
        groupValue: _selectedValue,
        title: Text(text.toString()),
        contentPadding: EdgeInsets.zero,
        dense: true,
        onChanged: props.readOnly || props.disabled
            ? null
            : (value) {
                setState(() {
                  _selectedValue = value;
                });
                handleEvent(actionsApi, 'changeNblur', propName, value);
              },
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!props.hideLabel && props.label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Text(
                  props.label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (props.required)
                  const Text(
                    ' *',
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
        if (widget.orientation == 'horizontal')
          Wrap(
            spacing: 16,
            children: radioButtons,
          )
        else
          ...radioButtons,
        if (helperTextToDisplay != null && helperTextToDisplay.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              helperTextToDisplay,
              style: TextStyle(
                fontSize: 12,
                color: props.status == 'error' ? Colors.red : Colors.grey[600],
              ),
            ),
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

/// Builder function for RadioButtons component
Widget buildRadioButtons(Map<String, dynamic> props, List<Widget> children) {
  return RadioButtonsField(
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
    ),
    datasource: props['datasource'] is List
        ? List<Map<String, dynamic>>.from(props['datasource'])
        : null,
    orientation: props['orientation'] ?? 'vertical',
  );
}
