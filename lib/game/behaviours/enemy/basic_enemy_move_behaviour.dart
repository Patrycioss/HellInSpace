import 'package:dutch_game_studio_assessment/game/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class BasicEnemyMoveBehaviour extends EnemyMoveBehaviour {
  @override
  void handleMovement(
      double deltaTime, Body body, Player player, EnemySettings enemySettings) {
    Vector2 normalizedDirection =
        (player.position - body.position).normalized();
    body.applyLinearImpulse(
        normalizedDirection * enemySettings.moveSpeed * deltaTime);

    // dev.log("Bla: ${normalizedDirection * enemySettings.moveSpeed * deltaTime}");
  }
}
