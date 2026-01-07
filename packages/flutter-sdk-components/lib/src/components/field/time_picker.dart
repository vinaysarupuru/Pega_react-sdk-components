import 'package:flutter/material.dart';

import '../../types/pconn_field_props.dart';
import '../helpers/event_utils.dart';
import '../helpers/date_format_utils.dart';
import '../../bridge/component_map.dart';

/// TimePicker component for time field input
/// Similar to the React SDK's Time component
class TimePickerField extends StatefulWidget {
  /// Field properties
  final PConnFieldProps props;

  /// Time format
  final String? timeFormat;

  const TimePickerField({
    super.key,
    required this.props,
    this.timeFormat,
  });

  @override
  State<TimePickerField> createState() => _TimePickerFieldState();
}

class _TimePickerFieldState extends State<TimePickerField> {
  late TextEditingController _controller;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _parseInitialTime();
    _controller = TextEditingController(
      text: _selectedTime != null ? _formatTimeOfDay(_selectedTime!) : '',
    );
  }

  void _parseInitialTime() {
    if (widget.props.value == null || widget.props.value!.isEmpty) {
      _selectedTime = null;
      return;
    }

    // Try to parse as datetime first
    final dateTime = parseDateTime(widget.props.value);
    if (dateTime != null) {
      _selectedTime = TimeOfDay.fromDateTime(dateTime);
      return;
    }

    // Try to parse as time string (HH:mm)
    final parts = widget.props.value!.split(':');
    if (parts.length >= 2) {
      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);
      if (hour != null && minute != null) {
        _selectedTime = TimeOfDay(hour: hour, minute: minute);
      }
    }
  }

  @override
  void didUpdateWidget(TimePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.props.value != oldWidget.props.value) {
      _parseInitialTime();
      _controller.text = _selectedTime != null ? _formatTimeOfDay(_selectedTime!) : '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return formatTime(dt, format: widget.timeFormat);
  }

  Future<void> _selectTime(BuildContext context) async {
    final pConn = widget.props.getPConnect();
    final actionsApi = pConn.getActionsApi();
    final stateProps = pConn.getStateProps();
    final propName = stateProps['value'] as String? ?? '';

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _controller.text = _formatTimeOfDay(picked);
      });

      // Send time as HH:mm format
      final timeString =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      handleEvent(actionsApi, 'changeNblur', propName, timeString);
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
        hintText: props.placeholder ?? 'Select time',
        helperText: helperTextToDisplay,
        errorText: props.status == 'error' ? helperTextToDisplay : null,
        border: props.readOnly
            ? InputBorder.none
            : const OutlineInputBorder(),
        suffixIcon: props.readOnly
            ? null
            : IconButton(
                icon: const Icon(Icons.access_time),
                onPressed: props.disabled ? null : () => _selectTime(context),
              ),
      ),
      onTap: props.disabled || props.readOnly ? null : () => _selectTime(context),
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

/// Builder function for TimePicker component
Widget buildTimePicker(Map<String, dynamic> props, List<Widget> children) {
  return TimePickerField(
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
    timeFormat: props['timeFormat'],
  );
}
