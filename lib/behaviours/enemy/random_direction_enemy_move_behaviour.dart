import 'dart:math';

import 'package:flame_forge2d/flame_forge2d.dart';

import '../../enemy/enemy_settings.dart';
import '../../player/player_component.dart';
import 'enemy_move_behaviour.dart';

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
