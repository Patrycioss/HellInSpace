import 'dart:developer';

import 'package:dutch_game_studio_assessment/game/behaviours/enemy/random_direction_enemy_move_behaviour.dart';
import 'package:dutch_game_studio_assessment/game/game.dart';

class GameSettings {
  // Player
  static const int maxPlayerHealth = 7;
  static const double playerMoveSpeed = 10000;

  // Enemy Spawner
  static const double minimumSpawnDistance = 50;

  static const List<EnemySettings> differentEnemySettings = [
    EnemySettings("Basic"),
    EnemySettings(
      "Big",
      strength: 3,
      moveSpeed: 800,
      breaksOnAnyCollision: false,
      width: 30,
      height: 30,
      lifeTime: Duration(seconds: 8),
    ),
    EnemySettings(
      "Tiny",
      strength: 2,
      lifeTime: Duration(seconds: 5),
      moveSpeed: 1800,
      width: 5,
      height: 5,
    )
  ];

  static const int moveBehaviourCount = 2;

  static EnemyMoveBehaviour getMoveBehaviour(int index) {
    switch (index) {
      case 0:
        return BasicEnemyMoveBehaviour();
      case 1:
        return RandomDirectionEnemyMoveBehaviour();

      default:
        log("Failed to get move behaviour with index: $index, "
            "did you forget to update the moveBehaviourCount with value: $moveBehaviourCount");
        return BasicEnemyMoveBehaviour();
    }
  }
}
