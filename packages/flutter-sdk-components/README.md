# Pega Flutter SDK Components

The **Flutter SDK Components** package contains the source code for the Pega-provided **bridge** from the ConstellationJS Engine to the **DX components**. The DX Components are a reference implementation that use Flutter's Material Design system.

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  pega_flutter_sdk_components: ^25.1.10
```

## Usage

```dart
import 'package:pega_flutter_sdk_components/pega_flutter_sdk_components.dart';

// Register components
void main() {
  // Register Pega-provided components
  SdkComponentMap.registerPegaComponent('TextInput', buildTextInput);
  SdkComponentMap.registerPegaComponent('Checkbox', buildCheckbox);
  SdkComponentMap.registerPegaComponent('Dropdown', buildDropdown);
  // ... register other components

  runApp(MyApp());
}
```

## Components

### Field Components

- **TextInput** - Single-line text input
- **TextArea** - Multi-line text input
- **Checkbox** - Checkbox for boolean values
- **Dropdown** - Dropdown select
- **RadioButtons** - Radio button group
- **DatePicker** - Date selection
- **DateTimePicker** - Date and time selection
- **TimePicker** - Time selection
- **Email** - Email input with validation
- **Phone** - Phone number input
- **URL** - URL input
- **Currency** - Currency input
- **Decimal** - Decimal number input
- **Integer** - Integer input
- **Percentage** - Percentage input
- **AutoComplete** - Autocomplete text input
- **RichText** - Rich text/HTML input

### Template Components

- **OneColumn** - Single column layout
- **TwoColumn** - Two column layout (50/50)
- **WideNarrow** - Two column layout (2:1)
- **NarrowWide** - Two column layout (1:2)
- **DefaultForm** - Form layout with instructions
- **CaseView** - Case detail view
- **CaseSummary** - Case summary display
- **Details** - Detail view
- **ListView** - List display with data table
- **SimpleTable** - Simple table display

### Widget Components

- **Attachment** - File attachment handling
- **ToDo** - Task list display
- **CaseHistory** - Case history timeline
- **Followers** - Case followers display
- **FileUtility** - File management utility
- **SummaryItem** - Single summary field
- **SummaryList** - List of summary items

### Infrastructure Components

- **Assignment** - Work assignment container
- **AssignmentCard** - Assignment summary card
- **Region** - Generic region container
- **View** - View container
- **RootContainer** - Root application container
- **ErrorBoundary** - Error handling wrapper
- **NavBar** - Navigation bar
- **Stages** - Workflow stages indicator
- **ActionButtons** - Form action buttons
- **MultiStep** - Multi-step wizard

### Design System Extension Components

- **FieldValueList** - Field name-value display
- **FieldGroup** - Field grouping container
- **AlertBanner** - Alert/notification banner
- **Banner** - Hero banner
- **Operator** - User/operator display

## Bridge

The bridge provides the connection between the Pega Constellation Engine and Flutter widgets:

- **PConnectWidget** - Main widget for rendering Pega components
- **PConnectState** - State management for PConnect
- **SdkComponentMap** - Component registry
- **ActionsApi** - Event handling utilities

## Overriding Components

To override a component, register your custom implementation:

```dart
import 'package:pega_flutter_sdk_components/pega_flutter_sdk_components.dart';

Widget myCustomTextInput(Map<String, dynamic> props, List<Widget> children) {
  // Your custom implementation
  return MyCustomTextField(...);
}

// Register as local component (takes precedence over Pega-provided)
SdkComponentMap.registerLocalComponent('TextInput', myCustomTextInput);
```

## License

This project is licensed under the terms of the **Apache 2** license.

## Additional Resources

- [Constellation SDKs Documentation](https://docs.pega.com/bundle/constellation-sdk/page/constellation-sdks/sdks/constellation-sdks.html)
- [Material Design for Flutter](https://docs.flutter.dev/development/ui/widgets/material)
