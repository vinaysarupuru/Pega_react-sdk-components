import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../types/pconn_field_props.dart';
import '../helpers/event_utils.dart';
import '../helpers/utils.dart';
import '../../bridge/component_map.dart';

/// Percentage component for percentage field input
/// Similar to the React SDK's Percentage component
class PercentageField extends StatefulWidget {
  /// Field properties
  final PConnFieldProps props;

  /// Decimal places
  final int decimalPlaces;

  const PercentageField({
    super.key,
    required this.props,
    this.decimalPlaces = 2,
  });

  @override
  State<PercentageField> createState() => _PercentageFieldState();
}

class _PercentageFieldState extends State<PercentageField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.props.value ?? '');
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(PercentageField oldWidget) {
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
      return _buildFieldValueList(
        props.hideLabel ? '' : props.label,
        Utils.formatPercentage(props.value),
      );
    }

    if (props.displayMode == DisplayMode.stackedLargeVal) {
      return _buildFieldValueList(
        props.hideLabel ? '' : props.label,
        Utils.formatPercentage(props.value),
        variant: 'stacked',
      );
    }

    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      readOnly: props.readOnly,
      enabled: !props.disabled,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d\.\-]')),
      ],
      decoration: InputDecoration(
        labelText: props.label,
        hintText: props.placeholder,
        helperText: helperTextToDisplay,
        errorText: props.status == 'error' ? helperTextToDisplay : null,
        border: props.readOnly
            ? InputBorder.none
            : const OutlineInputBorder(),
        suffixText: '%',
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

/// Builder function for Percentage component
Widget buildPercentage(Map<String, dynamic> props, List<Widget> children) {
  return PercentageField(
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
    decimalPlaces: props['decimalPlaces'] ?? 2,
  );
}
