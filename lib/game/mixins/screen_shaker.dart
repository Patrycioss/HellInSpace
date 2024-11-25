import 'dart:async';
import 'dart:developer' as dev;

import 'package:dutch_game_studio_assessment/game/game.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/forge2d_game.dart';

mixin ScreenShaker on Forge2DGame {
  Matrix4 _transform = Matrix4.identity();
  Timer? _timer;
  bool _shaking = false;
  double _currentCycleLength = 0;
  bool _left = false;

  void updateScreenShaker(double dt) {
    _currentCycleLength += dt;
    if (_shaking) {
      late final int mod;
      if (!_left) {
        mod = 1;

        if (_currentCycleLength >= GameSettings.screenShakeInterval) {
          _currentCycleLength = 0;
          _left = true;
        }
      } else {
        mod = -1;
        if (_currentCycleLength >= GameSettings.screenShakeInterval) {
          _currentCycleLength = 0;
          _left = false;
        }
      }
      _transform.translate(GameSettings.screenShakeIntensity * dt * mod);
    }
  }

  void startScreenShake(int duration) {
    if (_shaking) {
      dev.log(
          "Won't start screen shake effect as another shake effect is already busy!");
      return;
    }

    _timer = Timer(Duration(seconds: duration), () {
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
    _transform = Matrix4.identity();
  }

  Matrix4 getScreenShakeTransform() => _transform;
}
