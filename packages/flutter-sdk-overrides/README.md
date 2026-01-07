# Pega Flutter SDK Overrides

The **Flutter SDK Overrides** package provides the source code for SDK users who want to **override** the Flutter SDK's Pega-provided implementation.

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  pega_flutter_sdk_overrides: ^25.1.10
```

## Usage

This package re-exports all components from `pega_flutter_sdk_components`. To override a component:

```dart
import 'package:pega_flutter_sdk_overrides/pega_flutter_sdk_overrides.dart';

// Create your custom implementation
Widget myCustomTextInput(Map<String, dynamic> props, List<Widget> children) {
  return MyCustomTextField(
    label: props['label'],
    value: props['value'],
    // ... your custom implementation
  );
}

void main() {
  // Register your override - this takes precedence over Pega-provided components
  SdkComponentMap.registerLocalComponent('TextInput', myCustomTextInput);
  
  runApp(MyApp());
}
```

## Overriding Components

The override system works by maintaining two component maps:
1. **Pega-provided components** - Default implementations
2. **Local components** - Your custom overrides

When a component is requested, the system first checks the local components map. If found, it uses your override. Otherwise, it falls back to the Pega-provided implementation.

### Example: Custom Dropdown

```dart
import 'package:flutter/material.dart';
import 'package:pega_flutter_sdk_overrides/pega_flutter_sdk_overrides.dart';

Widget customDropdown(Map<String, dynamic> props, List<Widget> children) {
  return MyBrandedDropdown(
    label: props['label'] ?? '',
    value: props['value'],
    options: props['datasource'] ?? [],
    onChanged: (value) {
      final getPConnect = props['getPConnect'];
      final pConn = getPConnect();
      final actionsApi = pConn.getActionsApi();
      final stateProps = pConn.getStateProps();
      final propName = stateProps['value'] as String? ?? '';
      handleEvent(actionsApi, 'changeNblur', propName, value);
    },
    // Add your brand-specific styling
    style: MyBrandStyle.dropdownStyle,
  );
}

// Register the override
SdkComponentMap.registerLocalComponent('Dropdown', customDropdown);
```

## Available Components

All components from `pega_flutter_sdk_components` are available for override:

### Field Components
- TextInput, TextArea, Checkbox, Dropdown, RadioButtons
- DatePicker, DateTimePicker, TimePicker
- Email, Phone, URL, Currency, Decimal, Integer, Percentage
- AutoComplete, RichText

### Template Components
- OneColumn, TwoColumn, WideNarrow, NarrowWide
- DefaultForm, CaseView, CaseSummary, Details
- ListView, SimpleTable

### Widget Components
- Attachment, ToDo, CaseHistory, Followers
- FileUtility, SummaryItem, SummaryList

### Infrastructure Components
- Assignment, AssignmentCard, Region, View
- RootContainer, ErrorBoundary, NavBar, Stages
- ActionButtons, MultiStep

### Design System Extension Components
- FieldValueList, FieldGroup, AlertBanner, Banner, Operator

## License

This project is licensed under the terms of the **Apache 2** license.
