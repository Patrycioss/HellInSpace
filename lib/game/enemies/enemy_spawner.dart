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
    Vector2 position;
    do {
      position = Vector2(_random.nextDouble() * gameRef.canvasSize.x,
          _random.nextDouble() * gameRef.canvasSize.y);
    } while (position.distanceTo(hellInSpaceGame.player.position) <
        GameSettings.minimumSpawnDistance);

    Enemy enemy = Enemy(position);
    add(enemy);
    dev.log(
        "Spawned Enemy of type: ${enemy.runtimeType.toString()} at: ${position}");
  }
}
