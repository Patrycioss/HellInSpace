import 'package:flame/components.dart';

class HealthBar extends PositionComponent {
  final SpriteAnimation animation;

  int maxHealth = 5;

  HealthBar(emptyHeart, halfHeart, fullHeart)
      : animation = SpriteAnimation.spriteList(
            [emptyHeart, halfHeart, fullHeart],
            stepTime: double.infinity,

  );

  @override
  Future<void> onLoad() async {
    for (int i = 0; i < maxHealth; i++) {
      add(_HeartVisual());
    }

    return super.onLoad();
  }
}

class _HeartVisual extends SpriteAnimationComponent {}
