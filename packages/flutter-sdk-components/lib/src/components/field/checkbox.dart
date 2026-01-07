import 'package:flutter/material.dart';

import '../../types/pconn_field_props.dart';
import '../helpers/event_utils.dart';
import '../../bridge/component_map.dart';

/// Checkbox component for boolean field input
/// Similar to the React SDK's Checkbox component
class CheckboxField extends StatefulWidget {
  /// Field properties
  final PConnFieldProps props;

  /// The checkbox caption
  final String? caption;

  /// Label for true value
  final String trueLabel;

  /// Label for false value
  final String falseLabel;

  /// Selection mode (single or multi)
  final String selectionMode;

  /// Data source for multi-select
  final List<Map<String, dynamic>>? datasource;

  /// Selection key
  final String? selectionKey;

  /// Selection list
  final dynamic selectionList;

  /// Primary field
  final String? primaryField;

  /// Reference list
  final String? referenceList;

  /// Read-only context list
  final List<Map<String, dynamic>>? readonlyContextList;

  /// Variant (e.g., 'card')
  final String? variant;

  const CheckboxField({
    super.key,
    required this.props,
    this.caption,
    this.trueLabel = 'Yes',
    this.falseLabel = 'No',
    this.selectionMode = 'single',
    this.datasource,
    this.selectionKey,
    this.selectionList,
    this.primaryField,
    this.referenceList,
    this.readonlyContextList,
    this.variant,
  });

  @override
  State<CheckboxField> createState() => _CheckboxFieldState();
}

class _CheckboxFieldState extends State<CheckboxField> {
  late bool _checked;

  @override
  void initState() {
    super.initState();
    _checked = _parseValue(widget.props.value);
  }

  @override
  void didUpdateWidget(CheckboxField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.props.value != oldWidget.props.value) {
      _checked = _parseValue(widget.props.value);
    }
  }

  bool _parseValue(String? value) {
    if (value == null) return false;
    return value.toLowerCase() == 'true' || value == '1';
  }

  @override
  Widget build(BuildContext context) {
    final props = widget.props;
    final pConn = props.getPConnect();
    final actionsApi = pConn.getActionsApi();
    final stateProps = pConn.getStateProps();
    final propName = stateProps['value'] as String? ?? '';

    final helperTextToDisplay = props.validatemessage ?? props.helperText;
    final readOnlyMode = props.displayMode == DisplayMode.displayOnly || props.readOnly;

    // Handle display-only modes
    if (props.displayMode == DisplayMode.displayOnly) {
      return _buildFieldValueList(
        props.hideLabel ? '' : (widget.caption ?? ''),
        _checked ? widget.trueLabel : widget.falseLabel,
      );
    }

    if (props.displayMode == DisplayMode.stackedLargeVal) {
      return _buildFieldValueList(
        props.hideLabel ? '' : (widget.caption ?? ''),
        _checked ? widget.trueLabel : widget.falseLabel,
        variant: 'stacked',
      );
    }

    // Handle multi-select mode
    if (widget.selectionMode == 'multi') {
      return _buildMultiSelectCheckboxes();
    }

    // Single checkbox
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
        CheckboxListTile(
          value: _checked,
          title: Text(widget.caption ?? ''),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          enabled: !props.disabled && !readOnlyMode,
          onChanged: readOnlyMode
              ? null
              : (value) {
                  setState(() {
                    _checked = value ?? false;
                  });
                  handleEvent(actionsApi, 'changeNblur', propName, _checked);
                },
        ),
        if (helperTextToDisplay != null && helperTextToDisplay.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16),
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

  Widget _buildMultiSelectCheckboxes() {
    final props = widget.props;
    final datasource = widget.datasource ?? [];

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
        ...datasource.map((item) {
          final key = item['key'] ?? item['value'] ?? '';
          final text = item['text'] ?? item['value'] ?? '';
          final isSelected = widget.readonlyContextList?.any(
                (data) => data[widget.selectionKey?.split('.').last ?? ''] == key,
              ) ??
              false;

          return CheckboxListTile(
            value: isSelected,
            title: Text(text.toString()),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            enabled: !props.disabled && !props.readOnly,
            onChanged: props.readOnly
                ? null
                : (value) {
                    // Handle multi-select change
                  },
          );
        }),
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

    // Fallback if FieldValueList is not registered
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

/// Builder function for Checkbox component
Widget buildCheckbox(Map<String, dynamic> props, List<Widget> children) {
  return CheckboxField(
    props: PConnFieldProps(
      getPConnect: props['getPConnect'],
      label: props['label'] ?? '',
      required: props['required'] ?? false,
      disabled: props['disabled'] ?? false,
      value: props['value']?.toString(),
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
    caption: props['caption'],
    trueLabel: props['trueLabel'] ?? 'Yes',
    falseLabel: props['falseLabel'] ?? 'No',
    selectionMode: props['selectionMode'] ?? 'single',
    datasource: props['datasource'] is List ? List<Map<String, dynamic>>.from(props['datasource']) : null,
    selectionKey: props['selectionKey'],
    selectionList: props['selectionList'],
    primaryField: props['primaryField'],
    referenceList: props['referenceList'],
    readonlyContextList: props['readonlyContextList'] is List
        ? List<Map<String, dynamic>>.from(props['readonlyContextList'])
        : null,
    variant: props['variant'],
  );
}
