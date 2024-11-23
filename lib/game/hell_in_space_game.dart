import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame_texturepacker/flame_texturepacker.dart';

import 'player/player.dart';
import 'sprite_loader.dart';
import 'enemy.dart';
import 'health_bar.dart';

class HellInSpaceGame extends Forge2DGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  final int _maxPlayerHealth = 7;

  late SpriteFinder _spriteFinder;
  late HealthBar _healthBar;
  late Enemy _testEnemy;

  final PlayerBloc playerBloc;
  late final Player _player;

  HellInSpaceGame({
    required this.playerBloc,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    world.gravity = Vector2.zero();

    _spriteFinder =
        SpriteFinder(await atlasFromAssets('HellInSpaceTextures.atlas'));

    _healthBar = HealthBar(
      _maxPlayerHealth,
      Vector2(20, 20),
      _spriteFinder.findSprites('heart'),
    );

    add(FlameMultiBlocProvider(providers: [
      FlameBlocProvider<PlayerBloc, PlayerState>.value(
        value: playerBloc,
      ),
    ], children: [
      _player = Player(
          _maxPlayerHealth,
          Vector2(50, 50),
          _spriteFinder.findSprites('player'),
          (int health) => _healthBar.updateHealthBar(health))
    ]));

    // _player = Player(
    //     _maxPlayerHealth,
    //     Vector2(50, 50),
    //     _spriteFinder.findSprites('player'),
    //     (int health) => _healthBar.updateHealthBar(health));

    // Load enemy sprites
    // _testEnemy = Enemy(Vector2(300, 300));
    //
    // add(_healthBar);
    // add(_player);
    // add(_testEnemy);

    // camera.follow(_player);
  }

  @override
  Vector2 screenToWorld(Vector2 position) {
    throw UnimplementedError();
  }

  @override
  Vector2 worldToScreen(Vector2 position) {
    throw UnimplementedError();
  }
}
