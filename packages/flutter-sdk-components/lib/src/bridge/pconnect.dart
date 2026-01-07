import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../types/pconn_props.dart';
import 'pconnect_state.dart';
import 'component_map.dart';

/// PConnectWidget - Widget to create/initialize a PConnect environment
/// to pre-process metadata of each component.
/// - Wraps each child in a component with PConnect
/// - Process all actions and make them available in props
/// - Filters all properties in metadata and keeps them
/// internal for re-render process
class PConnectWidget extends StatefulWidget {
  /// The getPConnect function
  final PConnect Function() getPConnect;

  /// Additional properties
  final Map<String, dynamic>? additionalProps;

  /// Child widgets
  final List<Widget>? children;

  const PConnectWidget({
    super.key,
    required this.getPConnect,
    this.additionalProps,
    this.children,
  });

  @override
  State<PConnectWidget> createState() => _PConnectWidgetState();
}

class _PConnectWidgetState extends State<PConnectWidget> {
  late PConnect _pConnect;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _pConnect = widget.getPConnect();
    _processActions();
  }

  @override
  void didUpdateWidget(PConnectWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _pConnect = widget.getPConnect();
  }

  void _processActions() {
    if (_pConnect.isEditable()) {
      _pConnect.setAction('onChange', _changeHandler);
      _pConnect.setAction('onBlur', _eventHandler);
    }
  }

  void _changeHandler(dynamic event) {
    _pConnect.getActionsApi().changeHandler(_pConnect, event);
  }

  void _eventHandler(dynamic event) {
    _pConnect.getActionsApi().eventHandler(_pConnect, event);
  }

  @override
  void dispose() {
    _pConnect.removeFormField();
    super.dispose();
  }

  List<Widget> _createChildren() {
    if (_pConnect.hasChildren() && _pConnect.getChildren() != null) {
      final children = _pConnect.getChildren()!;
      return children.asMap().entries.map((entry) {
        final index = entry.key;
        final childProps = entry.value;
        return PConnectWidget(
          key: ValueKey('${_getKey()}_$index'),
          getPConnect: () => _createChildPConnect(childProps),
        );
      }).toList();
    }
    return [];
  }

  PConnect _createChildPConnect(Map<String, dynamic> childProps) {
    // This should be implemented based on the actual PConnect implementation
    // For now, return a placeholder
    throw UnimplementedError('Child PConnect creation needs implementation');
  }

  String _getKey() {
    final configProps = _pConnect.getConfigProps();
    final viewName = configProps['name'] ?? _pConnect.getCurrentView();
    if (viewName == null || viewName.isEmpty) {
      return _createUID();
    }
    String key = '$viewName!${_pConnect.getCurrentClassID() ?? _createUID()}';

    // In the case of pyDetails the key must be unique for each instance
    if (viewName.toUpperCase() == 'PYDETAILS') {
      key += '!${_pConnect.getCaseInfo().getID()}';
    }

    return key.toUpperCase();
  }

  static String _createUID() {
    return '_${DateTime.now().millisecondsSinceEpoch.toRadixString(36)}';
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return _buildErrorWidget();
    }

    try {
      final componentName = _pConnect.getComponentName();
      final componentBuilder = SdkComponentMap.getComponent(componentName);

      if (componentBuilder == null) {
        return _buildMissingComponentWidget(componentName);
      }

      final props = _pConnect.getConfigProps();
      final mergedProps = {
        ...props,
        'getPConnect': widget.getPConnect,
        ...?widget.additionalProps,
      };

      return componentBuilder(mergedProps, _createChildren());
    } catch (e, stackTrace) {
      debugPrint('Error rendering component: $e\n$stackTrace');
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
      });
      return _buildErrorWidget();
    }
  }

  Widget _buildErrorWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(height: 8),
          Text(
            'Error rendering component',
            style: TextStyle(
              color: Colors.red.shade900,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _errorMessage!,
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMissingComponentWidget(String componentName) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.warning_amber, color: Colors.orange),
          const SizedBox(height: 8),
          Text(
            'Component not found: $componentName',
            style: TextStyle(
              color: Colors.orange.shade900,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// PConnect Provider wrapper
class PConnectProvider extends StatelessWidget {
  final PConnect Function() getPConnect;
  final Widget child;

  const PConnectProvider({
    super.key,
    required this.getPConnect,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PConnectState(getPConnect: getPConnect),
      child: child,
    );
  }
}
