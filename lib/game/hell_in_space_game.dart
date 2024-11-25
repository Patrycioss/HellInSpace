import 'dart:async';
import 'dart:math';
import 'dart:developer' as dev;

import 'package:flame/effects.dart';
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

  final double _screenShakeInterval = 0.2;
  final double _screenShakeIntensity = 300;

  Matrix4 _worldTransformation = Matrix4.identity();

  HellInSpaceGame(this._onResetCallback);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // setUpsideDown(true);

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
      enemySpawner = EnemySpawner(),
      player = Player(
        Vector2(50, 50),
        _spriteFinder.findSprites('player'),
      ),
      HealthBar(Vector2(20, 20), _spriteFinder.findSprites('heart')),
      EndGameBehaviour(),
    ]));
  }

  void setUpsideDown(bool enable) {
    if (enable) {
      // _worldTransformation.scale(-1.0, -1.0);
      _worldTransformation.setRotationZ(pi);
      // _worldTransformation.scale(1, -1.0, 1.0);
      _worldTransformation
          .setTranslation(Vector3(canvasSize.x, canvasSize.y, 0));
    } else {
      _worldTransformation.setRotationZ(0);
      _worldTransformation.setTranslation(Vector3(0, 0, 0));
    }
  }

  void applyScreenSpaceEffect(Effect effect) {
    // effect.
  }

  bool left = false;

  double _currentCycleLength = 0;

  @override
  void update(double dt) {
    _currentCycleLength += dt;
    if (_shaking) {
      late final int mod;
      if (!left) {
        mod = 1;

        if (_currentCycleLength >= _screenShakeInterval) {
          _currentCycleLength = 0;
          left = true;
        }
      } else {
        mod = -1;
        if (_currentCycleLength >= _screenShakeInterval) {
          _currentCycleLength = 0;
          left = false;
        }
      }
      _worldTransformation.translate(_screenShakeIntensity * mod * dt);
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
    canvas.transform(_worldTransformation.storage);

    super.render(canvas);
  }

  Timer? _timer;
  bool _shaking = false;
  Matrix4? _recordedWorldTransformation;

  void startScreenShake(Duration duration) {

    if (_shaking){
      dev.log("Won't start screen shake effect as another shake effect is already busy!");
      return;
    }

    _recordedWorldTransformation = _worldTransformation;
    _timer = Timer(duration, () {
      stopScreenShake();
      _shaking = false;
      _timer = null;
    });
    _shaking = true;
  }

  void stopScreenShake() {
    if (!_shaking) {
      return;
    }

    _shaking = false;
    if (_timer!.isActive) {
      _timer!.cancel();
    }
    _timer = null;
    _worldTransformation = _recordedWorldTransformation!;
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

    if (keysPressed.contains(LogicalKeyboardKey.keyV)) {
      dev.log("Starting Screen Shake!");
      startScreenShake(const Duration(seconds: 1));
    }

    return super.onKeyEvent(event, keysPressed);
  }

  void reset() {
    _onResetCallback();
  }

  Game get game => game;
}
