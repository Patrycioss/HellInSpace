import 'package:flame/components.dart';
import 'package:flutter/services.dart';

class HealthBar extends PositionComponent with KeyboardHandler {
  final int _maxHealth;
  final double _gapBetweenHearts = 40;
  final double _heartScale = 4;
  final List<Sprite> _sprites;
  final List<_HeartVisual> _hearts = [];

  int _currentHealth = 0;

  HealthBar(this._maxHealth, Vector2 position, this._sprites)
      : super(
          position: position,
        ) {
    _currentHealth = _maxHealth;
  }

  @override
  Future<void> onLoad() async {
    for (int i = 0; i < (_maxHealth / 2).ceil(); i++) {
      _hearts.add(_HeartVisual(Vector2(_gapBetweenHearts * i, 0), _heartScale));
      add(_hearts.last);
    }
    _updateHealthVisuals();

    return super.onLoad();
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.keyT)) {
      setHealth(_currentHealth - 1);
    }
    // TODO: implement onKeyEvent
    return super.onKeyEvent(event, keysPressed);
  }

  void setHealth(int health) {
    print("Setting health from: $_currentHealth to $health");
    _currentHealth = health;
    _updateHealthVisuals();
  }

  void _updateHealthVisuals() {
    int healthPool = _currentHealth;

    for (int i = 0; i < _hearts.length; i++) {
      healthPool -= 2;
      if (healthPool < 0) {
        if (healthPool < -1) {
          _hearts[i].sprite = _sprites[0];
        } else {
          _hearts[i].sprite = _sprites[1];
        }
      } else {
        _hearts[i].sprite = _sprites[2];
      }
    }
  }
}

class _HeartVisual extends SpriteComponent {
  _HeartVisual(Vector2 position, double scale)
      : super(
          anchor: Anchor.center,
          position: position,
          scale: Vector2(scale, scale),
        );
}
