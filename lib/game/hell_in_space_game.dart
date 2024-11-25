import 'dart:math';
import 'dart:developer' as dev;

import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/events.dart';
import 'package:flame_texturepacker/flame_texturepacker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'game.dart';

class HellInSpaceGame extends Forge2DGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  late final PlayerBloc playerBloc;
  late final EnemySpawner enemySpawner;
  late final Player player;

  late final SpriteFinder _spriteFinder;

  final Random random = Random();

  final void Function() _onResetCallback;

  HellInSpaceGame(this._onResetCallback);

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
      player = Player(
        Vector2(50, 50),
        _spriteFinder.findSprites('player'),
      ),
      enemySpawner = EnemySpawner(),
      HealthBar(Vector2(20, 20), _spriteFinder.findSprites('heart')),
      EndGameBehaviour(),
    ]));
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      enemySpawner.spawnEnemy();
    }

    if (keysPressed.contains(LogicalKeyboardKey.keyR)) {
      dev.log("Resetting game!");
      reset();
    }

    return super.onKeyEvent(event, keysPressed);
  }

  void reset() {
    _onResetCallback();
  }

  Game get game => game;
}
