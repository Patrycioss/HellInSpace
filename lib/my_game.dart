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
  late SpriteFinder spriteFinder;
  late HealthBar healthBar;
  late Player player;
  late Enemy testEnemy;

  @override
  Future<void> onLoad() async {
    spriteFinder =
        SpriteFinder(await atlasFromAssets('HellInSpaceTextures.atlas'));

    player = Player(Vector2(50, 50), spriteFinder.findSprites('player'));

    healthBar = HealthBar(
      7,
      Vector2(20, 20),
      spriteFinder.findSprites('heart'),
    );

    // Load enemy sprites
    testEnemy = Enemy(Vector2(300, 300));

    world.gravity = Vector2.zero();
    add(healthBar);
    add(player);
    add(testEnemy);
  }
}
