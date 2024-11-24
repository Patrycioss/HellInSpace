import 'dart:developer' as dev;
import 'dart:math';

import 'package:dutch_game_studio_assessment/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/forge2d_game.dart';

class EnemySpawner extends Component with HasGameRef<Forge2DGame> {
  final Random _random;
  late final HellInSpaceGame hellInSpaceGame;

  EnemySpawner({int? seed}) : _random = Random(seed);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    hellInSpaceGame = gameRef as HellInSpaceGame;
  }

  void spawnEnemy() {
    late Vector2 position;
    do {
      position = Vector2(_random.nextDouble() * gameRef.canvasSize.x,
          _random.nextDouble() * gameRef.canvasSize.y);
    } while (position.distanceTo(hellInSpaceGame.player.position) <
        GameSettings.minimumSpawnDistance);

    final int settingIndex =
        _random.nextInt(GameSettings.differentEnemySettings.length);
    final EnemySettings enemySettings =
        GameSettings.differentEnemySettings[settingIndex];

    final int moveBehaviourIndex =
        _random.nextInt(GameSettings.moveBehaviourCount);
    final EnemyMoveBehaviour enemyMoveBehaviour =
        GameSettings.getMoveBehaviour(moveBehaviourIndex);

    final Enemy enemy = Enemy(position, enemySettings, enemyMoveBehaviour);

    add(enemy as Component);
    dev.log("Spawned Enemy with settings: ${enemySettings.name} "
        "with move behaviour: ${enemyMoveBehaviour.runtimeType.toString()} "
        "at: ${position}");
  }
}
