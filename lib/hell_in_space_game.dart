import 'dart:async';
import 'dart:developer' as dev;

import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart' as audio;
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/events.dart';
import 'package:flame_texturepacker/flame_texturepacker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hell_in_space/sound/sound_helper.dart';

import 'behaviours/end_game_checker.dart';
import 'ui_components/end_screen.dart';
import 'enemy/enemy_spawner.dart';
import 'game_settings.dart';
import 'input/input_manager_component.dart';
import 'mixins/screen_shaker.dart';
import 'player/bloc/player_bloc.dart';
import 'ui_components/health_bar_component.dart';
import 'player/player_component.dart';
import 'utils/sprite_finder.dart';

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

  InputManager get inputManager => _inputManager;

  SpriteFinder get spriteFinder => _spriteFinder;

  HellInSpaceGame(this._onReplayCallback);

  void loseGame() {
    _gameTimer.cancel();
    _won = false;
    _gameOver = true;
  }

  void replay() {
    _onReplayCallback();
  }

  @override
  Future<void> onLoad() async {
    _spriteFinder =
        SpriteFinder(await atlasFromAssets(GameSettings.spriteAtlasPath));

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
        canvasSize / 2.0,
        spriteFinder.findSprites('player'),
      ),
      PlayerLossChecker(),
      HealthBar(Vector2(20, 20), spriteFinder.findSprites('heart')),
      _inputManager = InputManager(GameSettings.actionMap,
          additionalKeys: GameSettings.additionalKeys),
    ]));

    _gameTimer = Timer(GameSettings.timeToSurvive, _onGameTimerEnd);

    await _preloadAudio();
    
    await SoundHelper.playMusic(GameSettings.musicPath, hasToStart: true, replacesOld: true, volume: 0.4);
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

  void _onGameTimerEnd() {
    _gameOver = true;
    _won = true;
  }

  void _showEndScreen(bool hasWon) {
    stopScreenShake();
    for (var child in children) {
      remove(child);
    }
    add(EndScreen(hasWon));
  }

  Future<void> _preloadAudio() async {
    await audio.FlameAudio.audioCache.load('hit_sound.wav');
    await audio.FlameAudio.audioCache.load('music.mp3');
  }
}
