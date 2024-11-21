import 'package:flame/components.dart';
import 'package:flutter/services.dart';

class Player extends RectangleComponent with KeyboardHandler {
  Player(Vector2 position)
      : super(
          position: position,
          size: Vector2.all(128),
          anchor: Anchor.center,
        );

  void translate(Vector2 translation){
    position += translation;
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    Vector2 direction = Vector2.zero();

    if (keysPressed.contains(LogicalKeyboardKey.keyW)) {
      direction.y -= 1;
    }

    if (keysPressed.contains(LogicalKeyboardKey.keyS)){
      direction.y += 1;
    }

    if (keysPressed.contains(LogicalKeyboardKey.keyA)){
      direction.x -= 1;
    }

    if (keysPressed.contains(LogicalKeyboardKey.keyD)){
      direction.x += 1;
    }

    position += direction * 10;

    return super.onKeyEvent(event, keysPressed);
  }
}
