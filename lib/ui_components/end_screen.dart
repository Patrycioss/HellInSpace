import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame_texturepacker/flame_texturepacker.dart';

import '../mixins/has_hell_in_space_game_ref.dart';

part 'retry_button.dart';

class EndScreen extends PositionComponent with HasHellInSpaceGameRef {
  final bool _hasWon;

  EndScreen(this._hasWon);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    anchor = Anchor.center;

    Vector2 screenPos = hellInSpaceGameRef.canvasSize / 2.0;

    TexturePackerSprite screenSprite;
    if (_hasWon) {
      screenSprite =
          hellInSpaceGameRef.spriteFinder.findSprite("victory_screen");
    } else {
      screenSprite =
          hellInSpaceGameRef.spriteFinder.findSprite("defeat_screen");
    }

    SpriteComponent spriteComponent;
    await add(spriteComponent = SpriteComponent(
        sprite: screenSprite, anchor: Anchor.center, position: screenPos));

    await spriteComponent.add(_RetryButton(() => hellInSpaceGameRef.replay(),
        hellInSpaceGameRef.spriteFinder.findSprite("retry_button")));
  }
}
