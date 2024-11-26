import 'dart:developer';

import 'package:flutter/services.dart';

import 'behaviours/enemy/basic_enemy_move_behaviour.dart';
import 'behaviours/enemy/enemy_move_behaviour.dart';
import 'behaviours/enemy/random_direction_enemy_move_behaviour.dart';
import 'enemy/enemy_settings.dart';

class GameSettings {
  // Game
  static const Duration timeToSurvive = Duration(seconds: 30);

  // Audio
  static const String musicPath = "music.mp3";
  static const String hitSoundPath = "hit_sound.wav";

  // Input
  static final Map<String, Set<LogicalKeyboardKey>> actionMap = {
    'move_left': {LogicalKeyboardKey.keyA, LogicalKeyboardKey.arrowLeft},
    'move_right': {LogicalKeyboardKey.keyD, LogicalKeyboardKey.arrowRight},
    'move_up': {LogicalKeyboardKey.keyW, LogicalKeyboardKey.arrowUp},
    'move_down': {LogicalKeyboardKey.keyS, LogicalKeyboardKey.arrowDown},
    'increase_player_health': {LogicalKeyboardKey.add},
    'decrease_player_health': {LogicalKeyboardKey.minus},
  };

  static final Set<LogicalKeyboardKey> additionalKeys = {
    LogicalKeyboardKey.space,
    LogicalKeyboardKey.keyR,
    LogicalKeyboardKey.keyV,
    LogicalKeyboardKey.add,
    LogicalKeyboardKey.minus,
  };

  // Sprites
  static const String spriteAtlasPath = "HellInSpaceTextures.atlas";

  // Screen Effects
  static const double screenShakeInterval = 0.1;
  static const Duration screenShakeDuration = Duration(milliseconds: 80);
  static const double screenShakeIntensity = 300;

  // Player
  static const double playerHitBoxRadius = 13;
  static const int maxPlayerHealth = 7;
  static const double playerMoveSpeed = 10000;
  static const Duration invincibilityDuration =
      Duration(seconds: 2, milliseconds: 50);

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
