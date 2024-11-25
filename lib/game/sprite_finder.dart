import 'dart:developer' as dev;

import 'package:flame_texturepacker/flame_texturepacker.dart';

class SpriteFinder {

  static late final SpriteFinder _instance;
  static bool _instantiated = false;

  final TexturePackerAtlas _atlas;

  SpriteFinder._(this._atlas);

  TexturePackerSprite findSprite(String name) {
    final sprite = _atlas.findSpriteByName(name);
    assert(sprite != null);
    return sprite!;
  }

  List<TexturePackerSprite> findSprites(String name) {
    return _atlas.findSpritesByName(name);
  }

  static SpriteFinder get() {
    return _instance;
  }

  static void createInstance(TexturePackerAtlas texturePackerAtlas) {
    if (!_instantiated) {
      _instance = SpriteFinder._(texturePackerAtlas);
      _instantiated = true;
    }
    else {
      dev.log("Cannot create another instance of the Sprite Finder!");
    }
  }
}
