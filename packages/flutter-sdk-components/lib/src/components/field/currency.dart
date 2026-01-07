import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../types/pconn_field_props.dart';
import '../helpers/event_utils.dart';
import '../helpers/utils.dart';
import '../../bridge/component_map.dart';

/// Currency component for currency field input
/// Similar to the React SDK's Currency component
class CurrencyField extends StatefulWidget {
  /// Field properties
  final PConnFieldProps props;

  /// Currency symbol
  final String currencySymbol;

  /// Decimal places
  final int decimalPlaces;

  const CurrencyField({
    super.key,
    required this.props,
    this.currencySymbol = '\$',
    this.decimalPlaces = 2,
  });

  @override
  State<CurrencyField> createState() => _CurrencyFieldState();
}

class _CurrencyFieldState extends State<CurrencyField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _formatValue(widget.props.value));
    _focusNode = FocusNode();
  }

  String _formatValue(String? value) {
    if (value == null || value.isEmpty) return '';
    final numValue = double.tryParse(value);
    if (numValue == null) return value;
    return numValue.toStringAsFixed(widget.decimalPlaces);
  }

  @override
  void didUpdateWidget(CurrencyField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.props.value != oldWidget.props.value) {
      _controller.text = _formatValue(widget.props.value);
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
        Utils.formatCurrency(props.value, symbol: widget.currencySymbol),
      );
    }

    if (props.displayMode == DisplayMode.stackedLargeVal) {
      return _buildFieldValueList(
        props.hideLabel ? '' : props.label,
        Utils.formatCurrency(props.value, symbol: widget.currencySymbol),
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
        prefixText: widget.currencySymbol,
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

/// Builder function for Currency component
Widget buildCurrency(Map<String, dynamic> props, List<Widget> children) {
  return CurrencyField(
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
    currencySymbol: props['currencySymbol'] ?? '\$',
    decimalPlaces: props['decimalPlaces'] ?? 2,
  );
}
