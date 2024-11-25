import 'package:flame/components.dart';

import 'resettable.dart';

class ComponentPool<T extends Component> {
  int get componentsAvailable => _componentsReady.length;

  final List<T> _componentsReady = [];
  final T Function() _createComponentCallback;

  ComponentPool(this._createComponentCallback);

  T getComponent() {
    if (_componentsReady.isEmpty) {
      return _createComponentCallback();
    } else {
      return _componentsReady.removeLast();
    }
  }

  void returnComponent(T component) {
    (component as Resettable).reset();
    _componentsReady.add(component);
  }
}
