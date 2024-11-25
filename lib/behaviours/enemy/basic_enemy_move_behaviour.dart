import 'package:flame_forge2d/flame_forge2d.dart';

import '../../enemy/enemy_settings.dart';
import '../../player/player_component.dart';
import 'enemy_move_behaviour.dart';

class BasicEnemyMoveBehaviour extends EnemyMoveBehaviour {
  @override
  void handleMovement(
      double deltaTime, Body body, Player player, EnemySettings enemySettings) {
    Vector2 normalizedDirection =
        (player.position - body.position).normalized();
    body.applyLinearImpulse(
        normalizedDirection * enemySettings.moveSpeed * deltaTime);
  }
}
