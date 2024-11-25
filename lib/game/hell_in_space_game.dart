import 'dart:async';
import 'dart:developer' as dev;

import 'package:dutch_game_studio_assessment/game/end_game_checker.dart';
import 'package:dutch_game_studio_assessment/input/input.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart' as audio;
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

    _spriteFinder =
        SpriteFinder(await atlasFromAssets(GameSettings.spriteAtlasPath));

    world.gravity = Vector2.zero();

    await _preloadAudio();

    if (!audio.FlameAudio.bgm.isPlaying){
     audio.FlameAudio.bgm.play('music.mp3', volume: 0.4);
    }

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
    _won = false;
    _gameOver = true;
  }

  void _onGameTimerEnd() {
    _gameOver = true;
    _won = true;
  }

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
    stopScreenShake();
    for (var child in children) {
      remove(child);
    }
    add(EndScreen(hasWon));
  }

  Future<void> _preloadAudio() async{
    await audio.FlameAudio.audioCache.load('hit_sound.wav');
    await audio.FlameAudio.audioCache.load('music.mp3');
  }
}
