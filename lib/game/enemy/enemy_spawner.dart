import 'dart:developer' as dev;
import 'dart:math';

import 'package:dutch_game_studio_assessment/game/component_pool.dart';
import 'package:dutch_game_studio_assessment/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/forge2d_game.dart';

class EnemySpawner extends Component with HasGameRef<Forge2DGame> {
  final Random _random;
  late final HellInSpaceGame hellInSpaceGame;
  late final ComponentPool<Enemy> _enemyPool;
  late double _intervalDuration = 0;

  EnemySpawner({int? seed}) : _random = Random(seed) {
    _enemyPool = ComponentPool<Enemy>(_createComponentCallback);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    hellInSpaceGame = gameRef as HellInSpaceGame;
  }

  @override
  void update(double dt) {
    super.update(dt);

    _intervalDuration += dt;
    if (_intervalDuration >= GameSettings.waveInterval.inSeconds) {
      for (int i = 0; i < GameSettings.waveSize; i++) {
        spawnEnemy();
      }

      _intervalDuration = 0;
    }
  }

  void spawnEnemy() {
    add(_enemyPool.getComponent()..setPosition(_decideSpawnPosition()));
  }

  Vector2 _decideSpawnPosition() {
    late Vector2 position;
    do {
      position = Vector2(_random.nextDouble() * gameRef.canvasSize.x,
          _random.nextDouble() * gameRef.canvasSize.y);
    } while (position.distanceTo(hellInSpaceGame.player.position) <
        GameSettings.minimumSpawnDistance);

    return position;
  }

  Enemy _createComponentCallback() {
    final Vector2 position = _decideSpawnPosition();
    final int settingIndex =
        _random.nextInt(GameSettings.differentEnemySettings.length);
    final EnemySettings enemySettings =
        GameSettings.differentEnemySettings[settingIndex];

    final int moveBehaviourIndex =
        _random.nextInt(GameSettings.enemyMoveBehaviourCount);
    final EnemyMoveBehaviour enemyMoveBehaviour =
        GameSettings.getEnemyMoveBehaviour(moveBehaviourIndex);

    // dev.log("Created Enemy with settings: ${enemySettings.name} "
    //     "with move behaviour: ${enemyMoveBehaviour.runtimeType.toString()} "
    //     "at: ${position}");

    return Enemy(position, enemySettings, enemyMoveBehaviour, _onDeathCallback);
  }

  void _onDeathCallback(Enemy enemy) {
    _enemyPool.returnComponent(enemy);
  }
}
