import '../../../types/pconn_props.dart';

/// Event handler utility functions
/// Similar to the React SDK's event-utils.ts

/// Handles events for form fields
void handleEvent(
  ActionsApi actionsApi,
  String eventType,
  String propName,
  dynamic value,
) {
  switch (eventType) {
    case 'change':
      // Handle change only
      _dispatchChange(actionsApi, propName, value);
      break;
    case 'blur':
      // Handle blur only
      _dispatchBlur(actionsApi, propName, value);
      break;
    case 'changeNblur':
      // Handle combined change and blur (most common case)
      _dispatchChange(actionsApi, propName, value);
      _dispatchBlur(actionsApi, propName, value);
      break;
    case 'focus':
      // Handle focus event
      break;
    default:
      // Unknown event type
      break;
  }
}

/// Dispatches a change event
void _dispatchChange(ActionsApi actionsApi, String propName, dynamic value) {
  // Create a synthetic event object
  final event = {
    'target': {
      'name': propName,
      'value': value,
    },
    'type': 'change',
  };

  // This would typically update the state through PCore
  // The actual implementation depends on the Pega Constellation JS engine
}

/// Dispatches a blur event
void _dispatchBlur(ActionsApi actionsApi, String propName, dynamic value) {
  // Create a synthetic event object
  final event = {
    'target': {
      'name': propName,
      'value': value,
    },
    'type': 'blur',
  };

  // This would typically trigger validation through PCore
  // The actual implementation depends on the Pega Constellation JS engine
}

/// Creates a synthetic change event
Map<String, dynamic> createChangeEvent(String propName, dynamic value) {
  return {
    'target': {
      'name': propName,
      'value': value,
    },
    'type': 'change',
  };
}

/// Creates a synthetic blur event
Map<String, dynamic> createBlurEvent(String propName, dynamic value) {
  return {
    'target': {
      'name': propName,
      'value': value,
    },
    'type': 'blur',
  };
}

/// Debounce utility for rate-limiting event handlers
class Debouncer {
  final Duration duration;
  DateTime? _lastCall;
  Function? _pendingCallback;

  Debouncer({this.duration = const Duration(milliseconds: 300)});

  void call(Function callback) {
    final now = DateTime.now();

    if (_lastCall == null ||
        now.difference(_lastCall!) > duration) {
      _lastCall = now;
      callback();
    } else {
      _pendingCallback = callback;
      Future.delayed(duration, () {
        if (_pendingCallback != null) {
          _pendingCallback!();
          _pendingCallback = null;
        }
      });
    }
  }

  void cancel() {
    _pendingCallback = null;
  }
}

/// Throttle utility for rate-limiting event handlers
class Throttler {
  final Duration duration;
  DateTime? _lastCall;

  Throttler({this.duration = const Duration(milliseconds: 300)});

  void call(Function callback) {
    final now = DateTime.now();

    if (_lastCall == null ||
        now.difference(_lastCall!) > duration) {
      _lastCall = now;
      callback();
    }
  }
}
