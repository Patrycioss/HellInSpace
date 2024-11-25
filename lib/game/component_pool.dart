import 'package:flame/components.dart';

abstract class Resettable {
  void reset();
}

class ComponentPool<T extends Component> {
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

  int get componentsAvailable => _componentsReady.length;

  void returnComponent(T component) {
    (component as Resettable).reset();
    _componentsReady.add(component);
  }
}}
