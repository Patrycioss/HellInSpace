import 'package:dutch_game_studio_assessment/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class EndScreen extends SpriteComponent with HasHellInSpaceGameRef {
  final bool _hasWon;

  EndScreen(this._hasWon);

  @override
  Future<void> onLoad() async {
    await super.onLoad();


    if (_hasWon) {
      sprite = SpriteFinder.get().findSprite("victory_screen");
    } else {
      sprite = SpriteFinder.get().findSprite("defeat_screen");
    }

    add(_RetryButton(() {
      hellInSpaceGameRef.replay();
    }));
  }
}

class _RetryButton extends ButtonComponent {
  _RetryButton(void Function() onPress)
      : super(
          onPressed: onPress,
        );
}
