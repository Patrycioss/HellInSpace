import 'package:flame/components.dart';
import 'package:flutter/services.dart';

class HealthBar extends PositionComponent with KeyboardHandler {
  final List<Sprite> sprites;

  final int _maxHealth; // Should be divisible by 2
  final double gapBetweenHearts = 40;
  final double heartScale = 4;

  final List<_HeartVisual> _hearts = [];

  int currentHealth = 0;

  HealthBar(this._maxHealth, Vector2 position, this.sprites)
      : super(
          position: position,
        ) {
    currentHealth = _maxHealth;
  }

  @override
  Future<void> onLoad() async {
    for (int i = 0; i < (_maxHealth / 2).ceil(); i++) {
      _hearts.add(_HeartVisual(Vector2(gapBetweenHearts * i, 0), heartScale));
      add(_hearts.last);
    }
    _updateHealthVisuals();

    return super.onLoad();
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.keyT)) {
      setHealth(currentHealth - 1);
      //
      // final heart = children.last as _HeartVisual;
      // heart.sprite = sprites[1];
    }
    // TODO: implement onKeyEvent
    return super.onKeyEvent(event, keysPressed);
  }

  void setHealth(int health) {
    currentHealth = health;
    print("Current Health: $currentHealth");
    _updateHealthVisuals();
  }

  void _updateHealthVisuals() {
    int healthPool = currentHealth;

    for (int i = 0; i < _hearts.length; i++) {
      healthPool -= 2;
      if (healthPool < 0) {
        if (healthPool == -1) {
          _hearts[i].sprite = sprites[1];
        } else {
          _hearts[i].sprite = sprites[0];
        }
      } else {
        _hearts[i].sprite = sprites[2];
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
