import 'package:flutter/material.dart';

/// Type definition for component builder function
typedef ComponentBuilder = Widget Function(
  Map<String, dynamic> props,
  List<Widget> children,
);

/// SDK Component Map - Maps component names to their builders
/// This is similar to the React SDK's sdk_component_map.js
class SdkComponentMap {
  static final Map<String, ComponentBuilder> _pegaProvidedComponents = {};
  static final Map<String, ComponentBuilder> _localComponents = {};

  /// Registers a Pega-provided component
  static void registerPegaComponent(String name, ComponentBuilder builder) {
    _pegaProvidedComponents[name] = builder;
  }

  /// Registers a local/override component
  static void registerLocalComponent(String name, ComponentBuilder builder) {
    _localComponents[name] = builder;
  }

  /// Gets a component by name (local overrides take precedence)
  static ComponentBuilder? getComponent(String name) {
    // Check local components first (for overrides)
    if (_localComponents.containsKey(name)) {
      return _localComponents[name];
    }
    // Fall back to Pega-provided components
    return _pegaProvidedComponents[name];
  }

  /// Gets the Pega-provided component map
  static Map<String, ComponentBuilder> getPegaProvidedComponentMap() {
    return Map.unmodifiable(_pegaProvidedComponents);
  }

  /// Gets the local component map
  static Map<String, ComponentBuilder> getLocalComponentMap() {
    return Map.unmodifiable(_localComponents);
  }

  /// Checks if a component exists
  static bool hasComponent(String name) {
    return _localComponents.containsKey(name) ||
        _pegaProvidedComponents.containsKey(name);
  }

  /// Clears all registered components (useful for testing)
  static void clear() {
    _pegaProvidedComponents.clear();
    _localComponents.clear();
  }

  /// Gets a component from the map or returns null
  /// This is a convenience method similar to React's getComponentFromMap
  static ComponentBuilder? getComponentFromMap(String name) {
    return getComponent(name);
  }
}

/// LazyComponentMap for components that are loaded lazily
class LazyComponentMap {
  static final Map<String, Future<ComponentBuilder> Function()>
      _lazyComponents = {};

  /// Registers a lazy component
  static void register(
      String name, Future<ComponentBuilder> Function() loader) {
    _lazyComponents[name] = loader;
  }

  /// Loads and returns a component
  static Future<ComponentBuilder?> load(String name) async {
    if (_lazyComponents.containsKey(name)) {
      return await _lazyComponents[name]!();
    }
    return null;
  }

  /// Checks if a lazy component exists
  static bool has(String name) {
    return _lazyComponents.containsKey(name);
  }
}
