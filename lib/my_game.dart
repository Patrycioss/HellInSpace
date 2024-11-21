import 'package:dutch_game_studio_assessment/player.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flame_forge2d/forge2d_game.dart';


class MyGame extends Forge2DGame with KeyboardEvents {
  final Player player = Player(Vector2(50, 50));
  final Map<LogicalKeyboardKey, bool> pressedKeys = {
    LogicalKeyboardKey.keyW: false,
    LogicalKeyboardKey.keyA: false,
    LogicalKeyboardKey.keyS: false,
    LogicalKeyboardKey.keyD: false,
  };

  @override
  Future<void> onLoad() async {
    add(player);
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    
    for (LogicalKeyboardKey key in pressedKeys.keys){
      pressedKeys[key] = keysPressed.contains(key);
    }

    return super.onKeyEvent(event, keysPressed);
  }

  @override void update(double dt) {
    Vector2 direction = Vector2.zero();

    if (pressedKeys[LogicalKeyboardKey.keyW]!) {
      direction.y -= 1;
    }

    if (pressedKeys[LogicalKeyboardKey.keyS]!) {
      direction.y += 1;
    }

    if (pressedKeys[LogicalKeyboardKey.keyA]!){
      direction.x -= 1;
    }

    if (pressedKeys[LogicalKeyboardKey.keyD]!){
      direction.x += 1;
    }

    player.translate(direction * 1000 * dt);
    super.update(dt);
  }
}
