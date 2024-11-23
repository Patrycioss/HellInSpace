import 'package:dutch_game_studio_assessment/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';

class HealthBar extends PositionComponent
    with KeyboardHandler, FlameBlocListenable<PlayerBloc, PlayerState> {
  static const double _gapBetweenHearts = 40;
  static const double _heartScale = 4;

  final List<Sprite> _sprites;
  final List<SpriteComponent> _hearts = [];

  HealthBar(Vector2 position, this._sprites)
      : super(
          position: position,
        );

  @override
  Future<void> onLoad() async {
    for (int i = 0; i < (GameSettings.maxPlayerHealth / 2).ceil(); i++) {
      _hearts.add(SpriteComponent(
          position: Vector2(_gapBetweenHearts * i, 0),
          scale: Vector2(_heartScale, _heartScale)));
      await add(_hearts.last);
    }
    updateHealthBar(GameSettings.maxPlayerHealth);

    return super.onLoad();
  }

  void updateHealthBar(int health) {
    int healthPool = health;

    for (int i = 0; i < _hearts.length; i++) {
      healthPool -= 2;
      if (healthPool < 0) {
        if (healthPool < -1) {
          _hearts[i].sprite = _sprites[0];
        } else {
          _hearts[i].sprite = _sprites[1];
        }
      } else {
        _hearts[i].sprite = _sprites[2];
      }
    }
  }

  @override
  bool listenWhen(PlayerState previousState, PlayerState newState) {
    return previousState != newState;
  }

  @override
  void onNewState(PlayerState state) {
    updateHealthBar(state.health);
  }
}
