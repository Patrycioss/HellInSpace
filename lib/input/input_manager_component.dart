import 'package:flame/components.dart';
import 'package:flutter/services.dart';

part 'key_state.dart';

class InputManager extends Component with KeyboardHandler {
  final Map<String, Set<LogicalKeyboardKey>> _actionMap;
  final Map<LogicalKeyboardKey, _KeyState> _keyRegister = {};

  InputManager(
    this._actionMap, {
    Set<LogicalKeyboardKey>? additionalKeys,
  }) {
    for (var keySet in _actionMap.values) {
      for (var key in keySet) {
        _keyRegister[key] = _KeyState();
      }
    }

    if (additionalKeys != null) {
      for (var key in additionalKeys) {
        _keyRegister[key] = _KeyState();
      }
    }
  }

  /// Returns true for every frame that  any keys in action are being pressed.
  bool isActionPressed(String action) {
    Set<LogicalKeyboardKey>? keys = _actionMap[action];
    assert(
        keys != null, "Cannot find action with name: $action in action map!");

    for (LogicalKeyboardKey key in keys!) {
      if (_keyRegister[key]!.down) {
        return true;
      }
    }

    return false;
  }

  /// Returns true one the first frame where any key for the action is pressed.
  bool isActionDown(String action) {
    Set<LogicalKeyboardKey>? keys = _actionMap[action];
    assert(
        keys != null, "Cannot find action with name: $action in action map!");

    for (LogicalKeyboardKey key in keys!) {
      _KeyState currentState = _keyRegister[key]!;

      if (!currentState.wasDown && currentState.down) {
        return true;
      }
    }

    return false;
  }

  /// Returns true for every frame that the key is pressed.
  bool isKeyPressed(LogicalKeyboardKey key) {
    return _keyRegister[key]!.down;
  }

  /// Returns true on the first frame where the key is pressed.
  bool isKeyDown(LogicalKeyboardKey key) {
    var state = _keyRegister[key]!;
    // log("was: ${state.wasDown}, is: ${state.down}");
    return (!state.wasDown && state.down);
  }

  void addKey(LogicalKeyboardKey key) {
    _keyRegister[key] = _KeyState();
  }

  void addKeyToAction(LogicalKeyboardKey key, String action) {
    Set<LogicalKeyboardKey>? map = _actionMap[action];
    assert(
        map != null,
        "Cannot add key to action as the actions isn't "
        "registered!");

    map!.add(key);
  }

  @override
  void update(double dt) {
    for (LogicalKeyboardKey key in _keyRegister.keys) {
      var currentState = _keyRegister[key]!;
      _keyRegister[key]!.wasDown = currentState.down;
    }

    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    for (LogicalKeyboardKey key in _keyRegister.keys) {
      if (event is KeyUpEvent) {
        if (!keysPressed.contains(key)) {
          _keyRegister[key]!.down = false;
        }
      } else if (event is KeyDownEvent) {
        if (!keysPressed.contains(key)) {
          continue;
        }

        _keyRegister[key]!.down = true;
      }
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
