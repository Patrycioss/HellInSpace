import 'dart:developer';

import 'package:dutch_game_studio_assessment/game/behaviours/enemy/random_direction_enemy_move_behaviour.dart';
import 'package:dutch_game_studio_assessment/game/game.dart';

class GameSettings {

  // Screen Effects
  static const double screenShakeInterval = 0.1;
  static const double screenShakeIntensity = 300;

  // Player
  static const int maxPlayerHealth = 7;
  static const double playerMoveSpeed = 10000;
  static const double invincibilityDuration = 3;

  // Enemy Spawner
  static const double minimumSpawnDistance = 50;
  static const int waveSize = 5;
  static const double waveInterval = 1;

  // Enemy Settings
  static const List<EnemySettings> differentEnemySettings = [
    EnemySettings("Basic"),
    EnemySettings(
      "Big",
      strength: 3,
      moveSpeed: 800,
      width: 30,
      height: 30,
    ),
    EnemySettings(
      "Tiny",
      strength: 2,
      lifeTime: Duration(seconds: 8),
      moveSpeed: 1800,
      width: 5,
      height: 5,
    )
  ];

  // Enemy Move Behaviours
  static const int enemyMoveBehaviourCount = 2;

  static EnemyMoveBehaviour getEnemyMoveBehaviour(int index) {
    switch (index) {
      case 0:
        return BasicEnemyMoveBehaviour();
      case 1:
        return RandomDirectionEnemyMoveBehaviour();

      default:
        log("Failed to get move behaviour with index: $index, "
            "did you forget to update the moveBehaviourCount with value: $enemyMoveBehaviourCount");
        return BasicEnemyMoveBehaviour();
    }
  }
}
