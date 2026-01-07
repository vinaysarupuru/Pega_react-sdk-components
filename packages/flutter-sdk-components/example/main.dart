import 'package:flutter/material.dart';
import 'package:pega_flutter_sdk_components/pega_flutter_sdk_components.dart';

/// Example application demonstrating the use of Pega Flutter SDK Components
void main() {
  // Register all Pega-provided components
  _registerComponents();

  runApp(const MyApp());
}

/// Register all available components
void _registerComponents() {
  // Field components
  SdkComponentMap.registerPegaComponent('TextInput', buildTextInput);
  SdkComponentMap.registerPegaComponent('Checkbox', buildCheckbox);
  SdkComponentMap.registerPegaComponent('Dropdown', buildDropdown);
  SdkComponentMap.registerPegaComponent('Date', buildDatePicker);
  SdkComponentMap.registerPegaComponent('DateTime', buildDateTimePicker);
  SdkComponentMap.registerPegaComponent('Time', buildTimePicker);
  SdkComponentMap.registerPegaComponent('Email', buildEmail);
  SdkComponentMap.registerPegaComponent('Phone', buildPhone);
  SdkComponentMap.registerPegaComponent('URL', buildUrl);
  SdkComponentMap.registerPegaComponent('TextArea', buildTextArea);
  SdkComponentMap.registerPegaComponent('Currency', buildCurrency);
  SdkComponentMap.registerPegaComponent('Decimal', buildDecimal);
  SdkComponentMap.registerPegaComponent('Integer', buildInteger);
  SdkComponentMap.registerPegaComponent('Percentage', buildPercentage);
  SdkComponentMap.registerPegaComponent('RadioButtons', buildRadioButtons);
  SdkComponentMap.registerPegaComponent('AutoComplete', buildAutoComplete);
  SdkComponentMap.registerPegaComponent('RichText', buildRichText);

  // Template components
  SdkComponentMap.registerPegaComponent('OneColumn', buildOneColumn);
  SdkComponentMap.registerPegaComponent('TwoColumn', buildTwoColumn);
  SdkComponentMap.registerPegaComponent('WideNarrow', buildWideNarrow);
  SdkComponentMap.registerPegaComponent('NarrowWide', buildNarrowWide);
  SdkComponentMap.registerPegaComponent('DefaultForm', buildDefaultForm);
  SdkComponentMap.registerPegaComponent('CaseView', buildCaseView);
  SdkComponentMap.registerPegaComponent('CaseSummary', buildCaseSummary);
  SdkComponentMap.registerPegaComponent('Details', buildDetails);
  SdkComponentMap.registerPegaComponent('ListView', buildListView);
  SdkComponentMap.registerPegaComponent('SimpleTable', buildSimpleTable);

  // Widget components
  SdkComponentMap.registerPegaComponent('Attachment', buildAttachment);
  SdkComponentMap.registerPegaComponent('ToDo', buildToDo);
  SdkComponentMap.registerPegaComponent('CaseHistory', buildCaseHistory);
  SdkComponentMap.registerPegaComponent('Followers', buildFollowers);
  SdkComponentMap.registerPegaComponent('FileUtility', buildFileUtility);
  SdkComponentMap.registerPegaComponent('SummaryItem', buildSummaryItem);
  SdkComponentMap.registerPegaComponent('SummaryList', buildSummaryList);

  // Infra components
  SdkComponentMap.registerPegaComponent('Assignment', buildAssignment);
  SdkComponentMap.registerPegaComponent('AssignmentCard', buildAssignmentCard);
  SdkComponentMap.registerPegaComponent('Region', buildRegion);
  SdkComponentMap.registerPegaComponent('View', buildView);
  SdkComponentMap.registerPegaComponent('RootContainer', buildRootContainer);
  SdkComponentMap.registerPegaComponent('ErrorBoundary', buildErrorBoundary);
  SdkComponentMap.registerPegaComponent('NavBar', buildNavBar);
  SdkComponentMap.registerPegaComponent('Stages', buildStages);
  SdkComponentMap.registerPegaComponent('ActionButtons', buildActionButtons);
  SdkComponentMap.registerPegaComponent('MultiStep', buildMultiStep);

  // Design system extension components
  SdkComponentMap.registerPegaComponent('FieldValueList', buildFieldValueList);
  SdkComponentMap.registerPegaComponent('FieldGroup', buildFieldGroup);
  SdkComponentMap.registerPegaComponent('AlertBanner', buildAlertBanner);
  SdkComponentMap.registerPegaComponent('Banner', buildBanner);
  SdkComponentMap.registerPegaComponent('Operator', buildOperator);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pega Flutter SDK Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DemoHomePage(),
    );
  }
}

class DemoHomePage extends StatelessWidget {
  const DemoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pega Flutter SDK Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Field Components',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            // Demo TextInput
            buildTextInput({
              'getPConnect': _mockGetPConnect,
              'label': 'Full Name',
              'placeholder': 'Enter your name',
              'required': true,
              'readOnly': false,
              'disabled': false,
              'hideLabel': false,
            }, []),
            const SizedBox(height: 16),
            // Demo Dropdown
            buildDropdown({
              'getPConnect': _mockGetPConnect,
              'label': 'Country',
              'datasource': [
                {'key': 'us', 'value': 'United States'},
                {'key': 'uk', 'value': 'United Kingdom'},
                {'key': 'ca', 'value': 'Canada'},
              ],
              'required': false,
              'readOnly': false,
              'disabled': false,
              'hideLabel': false,
            }, []),
            const SizedBox(height: 16),
            // Demo Checkbox
            buildCheckbox({
              'getPConnect': _mockGetPConnect,
              'label': 'Terms',
              'caption': 'I agree to the terms and conditions',
              'required': true,
              'readOnly': false,
              'disabled': false,
              'hideLabel': false,
            }, []),
            const SizedBox(height: 32),
            Text(
              'Design System Components',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            // Demo AlertBanner
            buildAlertBanner({
              'message': 'This is an informational message',
              'variant': 'info',
              'dismissible': true,
            }, []),
            const SizedBox(height: 8),
            buildAlertBanner({
              'message': 'Operation completed successfully!',
              'variant': 'success',
              'dismissible': true,
            }, []),
            const SizedBox(height: 32),
            Text(
              'Stages Component',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            buildStages({
              'stages': [
                {'name': 'Create'},
                {'name': 'Review'},
                {'name': 'Approve'},
                {'name': 'Complete'},
              ],
              'currentStageIndex': 1,
              'orientation': 'horizontal',
            }, []),
          ],
        ),
      ),
    );
  }
}

/// Mock PConnect for demonstration
MockPConnect _mockGetPConnect() => MockPConnect();

class MockPConnect implements PConnect {
  @override
  String getComponentName() => 'MockComponent';

  @override
  Map<String, dynamic> getConfigProps() => {};

  @override
  ActionsApi getActionsApi() => MockActionsApi();

  @override
  Map<String, dynamic> getStateProps() => {'value': 'mockValue'};

  @override
  ValidationApi getValidationApi() => MockValidationApi();

  @override
  String getContextName() => 'primary';

  @override
  bool hasChildren() => false;

  @override
  List<Map<String, dynamic>>? getChildren() => null;

  @override
  CaseInfo getCaseInfo() => MockCaseInfo();

  @override
  String getCurrentView() => 'MockView';

  @override
  String? getCurrentClassID() => 'MockClass';

  @override
  Map<String, dynamic> getDataObject(String key) => {};

  @override
  String getLocalizedValue(String value, String path, String ruleName) => value;

  @override
  String getLocaleRuleNameFromKeys(
          String className, String context, String name) =>
      name;

  @override
  bool isEditable() => true;

  @override
  bool isConditionExist() => false;

  @override
  void setAction(String actionName, Function handler) {}

  @override
  void addFormField() {}

  @override
  void removeFormField() {}

  @override
  void clearErrorMessages(Map<String, dynamic> options) {}

  @override
  void setReferenceList(dynamic list) {}

  @override
  ListActions getListActions() => MockListActions();

  @override
  Map<String, dynamic> getRawMetadata() => {};
}

class MockActionsApi implements ActionsApi {
  @override
  void changeHandler(PConnect pConnect, dynamic event) {}

  @override
  void eventHandler(PConnect pConnect, dynamic event) {}

  @override
  void onClick(dynamic event) {}
}

class MockValidationApi implements ValidationApi {
  @override
  bool validate(dynamic value, [String? property]) => true;
}

class MockCaseInfo implements CaseInfo {
  @override
  String getID() => 'MOCK-001';

  @override
  String getClassName() => 'MockClass';
}

class MockListActions implements ListActions {
  @override
  void setVisibility(bool visible) {}
}
