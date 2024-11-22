import 'package:dutch_game_studio_assessment/player.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame_texturepacker/flame_texturepacker.dart';

class MyGame extends Forge2DGame with HasKeyboardHandlerComponents{
  late Player player;

  @override
  Future<void> onLoad() async {

    final atlas = await atlasFromAssets('HellInSpaceTextures.atlas');

    final playerSprite = atlas.findSpriteByName('player');
    assert(playerSprite != null);
    player = Player(Vector2(50, 50), playerSprite);


    world.gravity = Vector2.zero();
    add(player);
  }
}
