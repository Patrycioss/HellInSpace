import 'dart:async';
import 'dart:developer' as dev;

import 'package:dutch_game_studio_assessment/game/end_game_checker.dart';
import 'package:dutch_game_studio_assessment/input/input.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/events.dart';
import 'package:flame_texturepacker/flame_texturepacker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'end_screen.dart';
import 'game.dart';

class HellInSpaceGame extends Forge2DGame
    with HasKeyboardHandlerComponents, HasCollisionDetection, ScreenShaker {
  final void Function() _onReplayCallback;
  late final PlayerBloc _playerBloc;
  late final EnemySpawner _enemySpawner;
  late final Player _player;
  late final Timer _gameTimer;
  late final InputManager _inputManager;
  late final SpriteFinder _spriteFinder;
  bool _gameOver = false;
  bool _won = false;

  Player get player => _player;

  PlayerBloc get playerBloc => _playerBloc;

  HellInSpaceGame(this._onReplayCallback);

  InputManager get inputManager => _inputManager;

  get spriteFinder => _spriteFinder;


  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _spriteFinder = SpriteFinder(await atlasFromAssets(GameSettings.spriteAtlasPath));

    world.gravity = Vector2.zero();

    await add(FlameMultiBlocProvider(providers: [
      FlameBlocProvider<PlayerBloc, PlayerState>(
        create: () {
          _playerBloc = PlayerBloc();
          return playerBloc;
        },
      )
    ], children: [
      _enemySpawner = EnemySpawner(),
      _player = Player(
        Vector2(50, 50),
        spriteFinder.findSprites('player'),
      ),
      PlayerLossChecker(),
      HealthBar(Vector2(20, 20), spriteFinder.findSprites('heart')),
      _inputManager = InputManager(GameSettings.actionMap,
          additionalKeys: GameSettings.additionalKeys),
    ]));

    _gameTimer = Timer(const Duration(seconds: GameSettings.secondsToSurvive),
        _onGameTimerEnd);
  }

  void loseGame() {
    _gameTimer.cancel();
    // _showEndScreen(true);
    _won = false;
    _gameOver = true;
  }

  void _onGameTimerEnd() {
    // _showEndScreen(true);
    _gameOver = true;
    _won = true;
  }

  // void setUpsideDown(bool enable) {
  //   if (enable) {
  //     // _worldTransformation.scale(-1.0, -1.0);
  //     _worldTransformation.setRotationZ(pi);
  //     // _worldTransformation.scale(1, -1.0, 1.0);
  //     _worldTransformation
  //         .setTranslation(Vector3(canvasSize.x, canvasSize.y, 0));
  //   } else {
  //     _worldTransformation.setRotationZ(0);
  //     _worldTransformation.setTranslation(Vector3(0, 0, 0));
  //   }
  // }

  @override
  void update(double dt) {
    updateScreenShaker(dt);

    if (kDebugMode) {
      if (inputManager.isKeyPressed(LogicalKeyboardKey.space)) {
        _enemySpawner.spawnEnemy();
      }

      if (inputManager.isKeyPressed(LogicalKeyboardKey.keyR)) {
        dev.log("Resetting game!");
        replay();
      }

      if (inputManager.isKeyPressed(LogicalKeyboardKey.keyV)) {
        dev.log("Starting Screen Shake!");
        startScreenShake(GameSettings.screenShakeDuration);
      }
    }

    if (_gameOver) {
      _showEndScreen(_won);

      _gameOver = false;
    }

    // Vector2 translation = canvasSize / 2.0;

    // _worldTransformation.translate(translation.x, translation.y);
    // _worldTransformation.rotateZ(1 * dt);
    // _worldTransformation.translate(-translation.x, -translation.y);

    // _worldTransformation.setFromTranslationRotation(Vector3(canvasSize.x/2.0, canvasSize.y/2.0, 0), Quaternion.fromRotation(Matrix3.rotationZ(0.1 * pi * dt)));

    // _worldTransformation.rotateZ(10 * dt);
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    Matrix4 transform = Matrix4.identity();
    transform *= getScreenShakeTransform();
    canvas.transform(transform.storage);
    super.render(canvas);
  }

  void replay() {
    _onReplayCallback();
  }

  void _showEndScreen(bool hasWon) {
    // Remove all components beside player
    // removeAll(children);
    for (var child in children) {
      remove(child);
    }

    add(EndScreen(hasWon));
  }
}
