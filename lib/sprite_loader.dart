import 'package:flame_texturepacker/flame_texturepacker.dart';

class SpriteFinder {
  final TexturePackerAtlas atlas;

  SpriteFinder(this.atlas);

  TexturePackerSprite findSprite(String name){
    final sprite = atlas.findSpriteByName(name);
    assert(sprite != null);
    return sprite!;
  }

  List<TexturePackerSprite> findSprites(String name){
    return atlas.findSpritesByName(name);
  }
}
