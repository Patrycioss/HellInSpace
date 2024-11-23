import 'package:dutch_game_studio_assessment/health_bar.dart';
import 'package:dutch_game_studio_assessment/player.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame_texturepacker/flame_texturepacker.dart';

import 'enemy.dart';
import 'sprite_loader.dart';

class MyGame extends Forge2DGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  final int _maxPlayerHealth = 7;

  late SpriteFinder _spriteFinder;
  late HealthBar _healthBar;
  late Player _player;
  late Enemy _testEnemy;

  @override
  Future<void> onLoad() async {
    _spriteFinder =
        SpriteFinder(await atlasFromAssets('HellInSpaceTextures.atlas'));

    _healthBar = HealthBar(
      _maxPlayerHealth,
      Vector2(20, 20),
      _spriteFinder.findSprites('heart'),
    );

    _player = Player(
        _maxPlayerHealth,
        Vector2(50, 50),
        _spriteFinder.findSprites('player'),
            (int health) => _healthBar.updateHealthBar(health));

    // Load enemy sprites
    _testEnemy = Enemy(Vector2(300, 300));

    world.gravity = Vector2.zero();
    add(_healthBar);
    add(_player);
    add(_testEnemy);
  }
}
