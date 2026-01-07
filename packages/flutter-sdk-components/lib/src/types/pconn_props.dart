/// PConnProps - Base interface for PConnect component properties
///
/// This gives us a place to have each component (which is most DX Components)
/// that is expected to have a getPConnect extend its props such that every
/// component will be expected to have a getPConnect() function that returns
/// a PConnect object.
abstract class PConnProps {
  /// getPConnect should exist for every Constellation component.
  PConnect get getPConnect;
}

/// Abstract class representing the PConnect interface
/// This is the main interface for interacting with the Pega Constellation Engine
abstract class PConnect {
  /// Gets the component name
  String getComponentName();

  /// Gets the configuration properties
  Map<String, dynamic> getConfigProps();

  /// Gets the actions API
  ActionsApi getActionsApi();

  /// Gets the state properties
  Map<String, dynamic> getStateProps();

  /// Gets the validation API
  ValidationApi getValidationApi();

  /// Gets the context name
  String getContextName();

  /// Checks if the component has children
  bool hasChildren();

  /// Gets the children of the component
  List<Map<String, dynamic>>? getChildren();

  /// Gets the case info
  CaseInfo getCaseInfo();

  /// Gets the current view
  String getCurrentView();

  /// Gets the current class ID
  String? getCurrentClassID();

  /// Gets the data object
  Map<String, dynamic> getDataObject(String key);

  /// Gets the localized value
  String getLocalizedValue(String value, String path, String ruleName);

  /// Gets the locale rule name from keys
  String getLocaleRuleNameFromKeys(
      String className, String context, String name);

  /// Checks if the component is editable
  bool isEditable();

  /// Checks if a condition exists
  bool isConditionExist();

  /// Sets an action
  void setAction(String actionName, Function handler);

  /// Adds a form field
  void addFormField();

  /// Removes a form field
  void removeFormField();

  /// Clears error messages
  void clearErrorMessages(Map<String, dynamic> options);

  /// Sets the reference list
  void setReferenceList(dynamic list);

  /// Gets the list actions
  ListActions getListActions();

  /// Gets the raw metadata
  Map<String, dynamic> getRawMetadata();
}

/// Abstract class for Actions API
abstract class ActionsApi {
  /// Handles change events
  void changeHandler(PConnect pConnect, dynamic event);

  /// Handles general events
  void eventHandler(PConnect pConnect, dynamic event);

  /// OnClick handler
  void onClick(dynamic event);
}

/// Abstract class for Validation API
abstract class ValidationApi {
  /// Validates the value
  bool validate(dynamic value, [String? property]);
}

/// Abstract class for Case Info
abstract class CaseInfo {
  /// Gets the case ID
  String getID();

  /// Gets the class name
  String getClassName();
}

/// Abstract class for List Actions
abstract class ListActions {
  /// Sets visibility
  void setVisibility(bool visible);
}
