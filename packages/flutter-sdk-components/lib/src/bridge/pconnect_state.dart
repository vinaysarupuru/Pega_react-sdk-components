import 'package:flutter/foundation.dart';

import '../types/pconn_props.dart';

/// State management for PConnect components
class PConnectState extends ChangeNotifier {
  final PConnect Function() _getPConnect;
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic> _props = {};

  PConnectState({required PConnect Function() getPConnect})
      : _getPConnect = getPConnect;

  PConnect get pConnect => _getPConnect();
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic> get props => _props;

  /// Updates the properties
  void updateProps(Map<String, dynamic> newProps) {
    _props = {..._props, ...newProps};
    notifyListeners();
  }

  /// Sets the loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Sets an error
  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  /// Clears the error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Refreshes the state from PConnect
  void refresh() {
    try {
      _props = pConnect.getConfigProps();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }
}

/// Store context for Redux-like state management
class StoreContext extends InheritedWidget {
  final Map<String, dynamic> state;
  final Function(String action, dynamic payload)? dispatch;

  const StoreContext({
    super.key,
    required this.state,
    this.dispatch,
    required super.child,
  });

  static StoreContext? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StoreContext>();
  }

  @override
  bool updateShouldNotify(StoreContext oldWidget) {
    return state != oldWidget.state;
  }
}

/// Placeholder BuildContext for type compatibility
abstract class BuildContext {
  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>();
}
