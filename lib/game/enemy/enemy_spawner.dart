import 'package:dutch_game_studio_assessment/game/component_pool.dart';
import 'package:dutch_game_studio_assessment/game/game.dart';
import 'package:dutch_game_studio_assessment/utils/random_generator.dart';
import 'package:flame/components.dart';

class EnemySpawner extends Component with HasHellInSpaceGameRef {
  late final ComponentPool<Enemy> _enemyPool;
  late double _intervalDuration = 0;

  EnemySpawner() {
    _enemyPool = ComponentPool<Enemy>(_createComponentCallback);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    _intervalDuration += dt;
    if (_intervalDuration >= GameSettings.waveInterval) {
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
      position = Vector2(
          RandomGenerator.get().random.nextDouble() *
              hellInSpaceGameRef.canvasSize.x,
          RandomGenerator.get().random.nextDouble() *
              hellInSpaceGameRef.canvasSize.y);
    } while (position.distanceTo(hellInSpaceGameRef.player.position) <
        GameSettings.minimumSpawnDistance);

    return position;
  }

  Enemy _createComponentCallback() {
    final Vector2 position = _decideSpawnPosition();
    final int settingIndex = RandomGenerator.get()
        .random
        .nextInt(GameSettings.differentEnemySettings.length);
    final EnemySettings enemySettings =
        GameSettings.differentEnemySettings[settingIndex];

    final int moveBehaviourIndex = RandomGenerator.get()
        .random
        .nextInt(GameSettings.enemyMoveBehaviourCount);
    final EnemyMoveBehaviour enemyMoveBehaviour =
        GameSettings.getEnemyMoveBehaviour(moveBehaviourIndex);

    return Enemy(position, enemySettings, enemyMoveBehaviour, _onDeathCallback);
  }

  void _onDeathCallback(Enemy enemy) {
    _enemyPool.returnComponent(enemy);
  }
}
