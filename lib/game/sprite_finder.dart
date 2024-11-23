import 'package:flame_texturepacker/flame_texturepacker.dart';

class SpriteFinder {
  late final TexturePackerAtlas _atlas;

  SpriteFinder(this._atlas);

  TexturePackerSprite findSprite(String name) {
    final sprite = _atlas.findSpriteByName(name);
    assert(sprite != null);
    return sprite!;
  }

  List<TexturePackerSprite> findSprites(String name) {
    return _atlas.findSpritesByName(name);
  }
}