import 'dart:developer';

import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame/events.dart';
import 'package:flame_texturepacker/flame_texturepacker.dart';

import 'game.dart';

class HellInSpaceGame extends Forge2DGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  late final RouterComponent _router;

  late final Enemy _testEnemy;
  late final SpriteFinder _spriteFinder;

  late final PlayerBloc playerBloc;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _spriteFinder =
        SpriteFinder(await atlasFromAssets('HellInSpaceTextures.atlas'));

    world.gravity = Vector2.zero();

    await add(FlameMultiBlocProvider(providers: [
      FlameBlocProvider<PlayerBloc, PlayerState>(
        create: () {
          playerBloc = PlayerBloc();
          return playerBloc;
        },
      )
    ], children: [
      Player(
        GameSettings.maxPlayerHealth,
        Vector2(50, 50),
        _spriteFinder.findSprites('player'),
      ),
      Enemy(
        Vector2(300,300),
      ),
      HealthBar(GameSettings.maxPlayerHealth, Vector2(20, 20),
          _spriteFinder.findSprites('heart')),
      EndGameBehaviour(),
    ]));
  }
}
