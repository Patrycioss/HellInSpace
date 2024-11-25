part of 'end_screen.dart';

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
    add(ScaleEffect.to(Vector2(1.3, 1.3), _effectController));
  }

  @override
  void onHoverExit() {
    _effectController.setToEnd();
    add(ScaleEffect.to(Vector2(1.0, 1.0), _effectController));
  }
}
