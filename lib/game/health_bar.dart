import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';

import 'game.dart';

class HealthBar extends PositionComponent with KeyboardHandler {
  final int _maxHealth;
  final double _gapBetweenHearts = 40;
  final double _heartScale = 4;
  final List<Sprite> _sprites;
  final List<_HeartVisual> _hearts = [];

  HealthBar(this._maxHealth, Vector2 position, this._sprites)
      : super(
          position: position,
        );

  @override
  Future<void> onLoad() async {

    for (int i = 0; i < (_maxHealth / 2).ceil(); i++) {
      _hearts.add(_HeartVisual(Vector2(_gapBetweenHearts * i, 0), _heartScale));
      await add(_hearts.last);
    }
    updateHealthBar(_maxHealth);

    await add(FlameBlocListener<PlayerBloc, PlayerState>(onNewState: _handleNewState));

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

  void _handleNewState(PlayerState state) {
    updateHealthBar(state.health);
  }
}

class _HeartVisual extends SpriteComponent {
  _HeartVisual(Vector2 position, double scale)
      : super(
          anchor: Anchor.center,
          position: position,
          scale: Vector2(scale, scale),
        );
}