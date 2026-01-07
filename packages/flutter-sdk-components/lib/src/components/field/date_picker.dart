import 'package:flutter/material.dart';

import '../../types/pconn_field_props.dart';
import '../helpers/event_utils.dart';
import '../helpers/date_format_utils.dart';
import '../../bridge/component_map.dart';

/// DatePicker component for date field input
/// Similar to the React SDK's Date component
class DatePickerField extends StatefulWidget {
  /// Field properties
  final PConnFieldProps props;

  /// Minimum date
  final DateTime? minDate;

  /// Maximum date
  final DateTime? maxDate;

  /// Date format
  final String? dateFormat;

  const DatePickerField({
    super.key,
    required this.props,
    this.minDate,
    this.maxDate,
    this.dateFormat,
  });

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  late TextEditingController _controller;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = parseDate(widget.props.value);
    _controller = TextEditingController(
      text: _selectedDate != null
          ? formatDate(_selectedDate, format: widget.dateFormat)
          : '',
    );
  }

  @override
  void didUpdateWidget(DatePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.props.value != oldWidget.props.value) {
      _selectedDate = parseDate(widget.props.value);
      _controller.text = _selectedDate != null
          ? formatDate(_selectedDate, format: widget.dateFormat)
          : '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final pConn = widget.props.getPConnect();
    final actionsApi = pConn.getActionsApi();
    final stateProps = pConn.getStateProps();
    final propName = stateProps['value'] as String? ?? '';

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: widget.minDate ?? DateTime(1900),
      lastDate: widget.maxDate ?? DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _controller.text = formatDate(picked, format: widget.dateFormat);
      });

      // Send ISO format to backend
      handleEvent(actionsApi, 'changeNblur', propName, picked.toIso8601String());
    }
  }

  @override
  Widget build(BuildContext context) {
    final props = widget.props;
    final helperTextToDisplay = props.validatemessage ?? props.helperText;

    // Handle display-only modes
    if (props.displayMode == DisplayMode.displayOnly) {
      return _buildFieldValueList(
        props.hideLabel ? '' : props.label,
        _controller.text,
      );
    }

    if (props.displayMode == DisplayMode.stackedLargeVal) {
      return _buildFieldValueList(
        props.hideLabel ? '' : props.label,
        _controller.text,
        variant: 'stacked',
      );
    }

    return TextField(
      controller: _controller,
      readOnly: true,
      enabled: !props.disabled && !props.readOnly,
      decoration: InputDecoration(
        labelText: props.label,
        hintText: props.placeholder ?? 'Select date',
        helperText: helperTextToDisplay,
        errorText: props.status == 'error' ? helperTextToDisplay : null,
        border: props.readOnly
            ? InputBorder.none
            : const OutlineInputBorder(),
        suffixIcon: props.readOnly
            ? null
            : IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: props.disabled ? null : () => _selectDate(context),
              ),
      ),
      onTap: props.disabled || props.readOnly ? null : () => _selectDate(context),
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

/// Builder function for DatePicker component
Widget buildDatePicker(Map<String, dynamic> props, List<Widget> children) {
  return DatePickerField(
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
    minDate: props['minDate'] is DateTime ? props['minDate'] : null,
    maxDate: props['maxDate'] is DateTime ? props['maxDate'] : null,
    dateFormat: props['dateFormat'],
  );
}
