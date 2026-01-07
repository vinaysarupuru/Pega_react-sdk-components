import 'pconn_props.dart';

/// PConnFieldProps extends PConnProps to bring in the common properties
/// that are associated with most field components (ex: Dropdown, TextInput, etc.)
/// in the components/field directory
class PConnFieldProps {
  /// The getPConnect function
  final PConnect Function() getPConnect;

  /// The label for the field
  final String label;

  /// Whether the field is required
  final bool required;

  /// Whether the field is disabled
  final bool disabled;

  /// The current value
  final String? value;

  /// Validation message
  final String? validatemessage;

  /// Status (e.g., 'error')
  final String? status;

  /// OnChange callback
  final Function(dynamic)? onChange;

  /// OnBlur callback
  final Function(dynamic)? onBlur;

  /// Whether the field is read-only
  final bool readOnly;

  /// Test ID for testing
  final String? testId;

  /// Helper text
  final String? helperText;

  /// Display mode
  final String? displayMode;

  /// Whether to hide the label
  final bool hideLabel;

  /// Placeholder text
  final String? placeholder;

  /// Field metadata
  final Map<String, dynamic>? fieldMetadata;

  /// Additional properties
  final Map<String, dynamic>? additionalProps;

  PConnFieldProps({
    required this.getPConnect,
    required this.label,
    required this.required,
    required this.disabled,
    this.value,
    this.validatemessage,
    this.status,
    this.onChange,
    this.onBlur,
    required this.readOnly,
    this.testId,
    this.helperText,
    this.displayMode,
    required this.hideLabel,
    this.placeholder,
    this.fieldMetadata,
    this.additionalProps,
  });

  /// Creates a copy with modified fields
  PConnFieldProps copyWith({
    PConnect Function()? getPConnect,
    String? label,
    bool? required,
    bool? disabled,
    String? value,
    String? validatemessage,
    String? status,
    Function(dynamic)? onChange,
    Function(dynamic)? onBlur,
    bool? readOnly,
    String? testId,
    String? helperText,
    String? displayMode,
    bool? hideLabel,
    String? placeholder,
    Map<String, dynamic>? fieldMetadata,
    Map<String, dynamic>? additionalProps,
  }) {
    return PConnFieldProps(
      getPConnect: getPConnect ?? this.getPConnect,
      label: label ?? this.label,
      required: required ?? this.required,
      disabled: disabled ?? this.disabled,
      value: value ?? this.value,
      validatemessage: validatemessage ?? this.validatemessage,
      status: status ?? this.status,
      onChange: onChange ?? this.onChange,
      onBlur: onBlur ?? this.onBlur,
      readOnly: readOnly ?? this.readOnly,
      testId: testId ?? this.testId,
      helperText: helperText ?? this.helperText,
      displayMode: displayMode ?? this.displayMode,
      hideLabel: hideLabel ?? this.hideLabel,
      placeholder: placeholder ?? this.placeholder,
      fieldMetadata: fieldMetadata ?? this.fieldMetadata,
      additionalProps: additionalProps ?? this.additionalProps,
    );
  }
}

/// Display mode constants
class DisplayMode {
  static const String displayOnly = 'DISPLAY_ONLY';
  static const String stackedLargeVal = 'STACKED_LARGE_VAL';
  static const String editable = 'EDITABLE';
}
