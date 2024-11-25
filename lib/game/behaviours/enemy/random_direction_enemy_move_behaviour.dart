import 'dart:math';

import 'package:dutch_game_studio_assessment/game/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class RandomDirectionEnemyMoveBehaviour extends EnemyMoveBehaviour {
  final Vector2 direction;

  RandomDirectionEnemyMoveBehaviour()
      : direction = Vector2.random() * ((Random().nextInt(2) == 0) ? -1 : 1);

  @override
  void handleMovement(
      double deltaTime, Body body, Player player, EnemySettings enemySettings) {
    body.applyLinearImpulse((direction * enemySettings.moveSpeed * deltaTime));
  }
}
