import 'package:flutter/material.dart';

import '../../types/pconn_field_props.dart';
import '../helpers/event_utils.dart';
import '../helpers/utils.dart';
import '../helpers/data_page.dart';
import '../../bridge/component_map.dart';

/// Dropdown component for select field input
/// Similar to the React SDK's Dropdown component
class Dropdown extends StatefulWidget {
  /// Field properties
  final PConnFieldProps props;

  /// Data source
  final dynamic datasource;

  /// On record change callback
  final Function(dynamic)? onRecordChange;

  /// List type
  final String listType;

  /// Defer data source
  final bool deferDatasource;

  /// Data source metadata
  final Map<String, dynamic>? datasourceMetadata;

  /// Parameters
  final Map<String, dynamic>? parameters;

  /// Columns
  final List<Map<String, dynamic>>? columns;

  const Dropdown({
    super.key,
    required this.props,
    this.datasource,
    this.onRecordChange,
    this.listType = 'associated',
    this.deferDatasource = false,
    this.datasourceMetadata,
    this.parameters,
    this.columns,
  });

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  List<Map<String, dynamic>> _options = [];
  String? _selectedValue;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.props.value;
    _loadOptions();
  }

  @override
  void didUpdateWidget(Dropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.props.value != oldWidget.props.value) {
      _selectedValue = widget.props.value;
    }
    if (!Utils.deepEqual(widget.datasource, oldWidget.datasource)) {
      _loadOptions();
    }
  }

  Future<void> _loadOptions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Map<String, dynamic>> options = [];

      if (widget.datasource != null) {
        options = Utils.getOptionList(
          {'datasource': widget.datasource},
          {},
        );
      } else if (widget.listType == 'datapage' && widget.datasource is String) {
        final results = await getDataPage(
          widget.datasource as String,
          widget.parameters,
          widget.props.getPConnect().getContextName(),
        );

        final columns = widget.columns != null
            ? preProcessColumns(widget.columns!)
            : <Map<String, dynamic>>[];
        final displayColumn = getDisplayFieldsMetaData(columns);

        for (final element in results) {
          final val = element[displayColumn['primary']]?.toString() ?? '';
          options.add({
            'key': element[displayColumn['key']] ?? element['pyGUID'] ?? '',
            'value': val,
          });
        }
      }

      // Add placeholder option
      final placeholder = widget.props.placeholder ?? 'Select...';
      options.insert(0, {
        'key': placeholder,
        'value': placeholder,
      });

      setState(() {
        _options = options;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
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
    final placeholder = props.placeholder ?? 'Select...';

    // Handle display-only modes
    if (props.displayMode == DisplayMode.displayOnly) {
      final displayValue = _options.firstWhere(
        (option) => option['key'] == props.value,
        orElse: () => {'value': props.value ?? ''},
      )['value'];

      return _buildFieldValueList(
        props.hideLabel ? '' : props.label,
        displayValue?.toString() ?? '',
      );
    }

    if (props.displayMode == DisplayMode.stackedLargeVal) {
      final displayValue = _options.firstWhere(
        (option) => option['key'] == props.value,
        orElse: () => {'value': props.value ?? ''},
      )['value'];

      return _buildFieldValueList(
        props.hideLabel ? '' : props.label,
        displayValue?.toString() ?? '',
        variant: 'stacked',
      );
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_options.isEmpty) {
      return const SizedBox.shrink();
    }

    return DropdownButtonFormField<String>(
      value: _selectedValue == null || _selectedValue!.isEmpty
          ? (props.readOnly ? null : placeholder)
          : _selectedValue,
      decoration: InputDecoration(
        labelText: props.label,
        helperText: helperTextToDisplay,
        errorText: props.status == 'error' ? helperTextToDisplay : null,
        border: props.readOnly
            ? InputBorder.none
            : const OutlineInputBorder(),
      ),
      items: _options.map((option) {
        return DropdownMenuItem<String>(
          value: option['key']?.toString(),
          child: Text(option['value']?.toString() ?? ''),
        );
      }).toList(),
      onChanged: props.readOnly || props.disabled
          ? null
          : (value) {
              final selectedValue = value == placeholder ? '' : value;
              setState(() {
                _selectedValue = selectedValue;
              });
              handleEvent(actionsApi, 'changeNblur', propName, selectedValue);
              widget.onRecordChange?.call({'target': {'value': selectedValue}});
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

/// Builder function for Dropdown component
Widget buildDropdown(Map<String, dynamic> props, List<Widget> children) {
  return Dropdown(
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
    datasource: props['datasource'],
    onRecordChange: props['onRecordChange'],
    listType: props['listType'] ?? 'associated',
    deferDatasource: props['deferDatasource'] ?? false,
    datasourceMetadata: props['datasourceMetadata'],
    parameters: props['parameters'],
    columns: props['columns'] is List
        ? List<Map<String, dynamic>>.from(props['columns'])
        : null,
  );
}
