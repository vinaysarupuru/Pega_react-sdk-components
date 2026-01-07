import 'package:flutter/material.dart';

import '../../types/pconn_field_props.dart';
import '../helpers/event_utils.dart';
import '../helpers/date_format_utils.dart';
import '../../bridge/component_map.dart';

/// DateTimePicker component for datetime field input
/// Similar to the React SDK's DateTime component
class DateTimePickerField extends StatefulWidget {
  /// Field properties
  final PConnFieldProps props;

  /// Minimum datetime
  final DateTime? minDateTime;

  /// Maximum datetime
  final DateTime? maxDateTime;

  /// DateTime format
  final String? dateTimeFormat;

  const DateTimePickerField({
    super.key,
    required this.props,
    this.minDateTime,
    this.maxDateTime,
    this.dateTimeFormat,
  });

  @override
  State<DateTimePickerField> createState() => _DateTimePickerFieldState();
}

class _DateTimePickerFieldState extends State<DateTimePickerField> {
  late TextEditingController _controller;
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = parseDateTime(widget.props.value);
    _controller = TextEditingController(
      text: _selectedDateTime != null
          ? formatDateTime(_selectedDateTime, format: widget.dateTimeFormat)
          : '',
    );
  }

  @override
  void didUpdateWidget(DateTimePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.props.value != oldWidget.props.value) {
      _selectedDateTime = parseDateTime(widget.props.value);
      _controller.text = _selectedDateTime != null
          ? formatDateTime(_selectedDateTime, format: widget.dateTimeFormat)
          : '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final pConn = widget.props.getPConnect();
    final actionsApi = pConn.getActionsApi();
    final stateProps = pConn.getStateProps();
    final propName = stateProps['value'] as String? ?? '';

    // First, select date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: widget.minDateTime ?? DateTime(1900),
      lastDate: widget.maxDateTime ?? DateTime(2100),
    );

    if (pickedDate == null) return;

    // Then, select time
    if (!context.mounted) return;
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedDateTime != null
          ? TimeOfDay.fromDateTime(_selectedDateTime!)
          : TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final newDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      setState(() {
        _selectedDateTime = newDateTime;
        _controller.text = formatDateTime(newDateTime, format: widget.dateTimeFormat);
      });

      // Send ISO format to backend
      handleEvent(actionsApi, 'changeNblur', propName, newDateTime.toIso8601String());
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
        hintText: props.placeholder ?? 'Select date and time',
        helperText: helperTextToDisplay,
        errorText: props.status == 'error' ? helperTextToDisplay : null,
        border: props.readOnly
            ? InputBorder.none
            : const OutlineInputBorder(),
        suffixIcon: props.readOnly
            ? null
            : IconButton(
                icon: const Icon(Icons.calendar_month),
                onPressed: props.disabled ? null : () => _selectDateTime(context),
              ),
      ),
      onTap: props.disabled || props.readOnly ? null : () => _selectDateTime(context),
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

/// Builder function for DateTimePicker component
Widget buildDateTimePicker(Map<String, dynamic> props, List<Widget> children) {
  return DateTimePickerField(
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
    minDateTime: props['minDateTime'] is DateTime ? props['minDateTime'] : null,
    maxDateTime: props['maxDateTime'] is DateTime ? props['maxDateTime'] : null,
    dateTimeFormat: props['dateTimeFormat'],
  );
}
