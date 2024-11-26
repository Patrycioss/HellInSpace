import 'dart:async';

import 'package:flame_audio/flame_audio.dart';

class SoundHelper {
  static const Duration _checkInterval = Duration(milliseconds: 50);

  static Future<void> playMusic(String file,
      {bool hasToStart = false,
      bool replacesOld = false,
      double volume = 1.0}) async {
    if (FlameAudio.bgm.isPlaying) {
      if (replacesOld) {
        FlameAudio.bgm.stop();
        await _tryPlayMusic(file, hasToStart: hasToStart, volume: volume);
      } else {
        return;
      }
    } else {
      await _tryPlayMusic(file, hasToStart: hasToStart, volume: volume);
    }
  }

  static Future<void> playSound(String file,
      {bool hasToStart = false, double volume = 1.0}) async {
    await _tryPlaySound(file, hasToStart: hasToStart, volume: volume);
  }

  static Future<void> _tryPlayMusic(String file,
      {bool hasToStart = false, double volume = 1.0}) async {
    try {
      await FlameAudio.bgm.play(file, volume: volume);
    } catch (e) {
      if (hasToStart) {
        Timer(_checkInterval, () {
          _tryPlayMusic(file, hasToStart: hasToStart, volume: volume);
        });
      }
    }
  }

  static Future<void> _tryPlaySound(String file,
      {bool hasToStart = false, double volume = 1.0}) async {
    try {
      await FlameAudio.play(file, volume: volume);
    } catch (e) {
      if (hasToStart) {
        Timer(_checkInterval, () {
          _tryPlaySound(file, hasToStart: hasToStart, volume: volume);
        });
      }
    }
  }
}
