import 'package:dutch_game_studio_assessment/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flame_texturepacker/flame_texturepacker.dart';

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

class _RetryButton extends SpriteComponent with TapCallbacks, HoverCallbacks {
  final void Function() _tapCallback;
  final EffectController _effectController;

  _RetryButton(this._tapCallback, Sprite sprite)
      : _effectController = LinearEffectController(0.3),
        super(
          sprite: sprite,
          anchor: Anchor.center,
          size: Vector2(100, 100),
          position: Vector2(50, 50),
        );

  @override
  void onTapDown(TapDownEvent event) {
    _tapCallback();
  }

  @override
  void onHoverEnter() {
    _effectController.setToEnd();
    add(ScaleEffect.to(Vector2(1.3,1.3), _effectController));
  }

  @override
  void onHoverExit() {
    _effectController.setToEnd();
    add(ScaleEffect.to(Vector2(1.0,1.0), _effectController));
  }
}
