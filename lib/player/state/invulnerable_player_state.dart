part of '../player_component.dart';

class _InvulnerablePlayerState extends _PlayerState {
  @override
  bool get canBeHit => false;

  final void Function() _onEndCallback;

  _InvulnerablePlayerState(this._onEndCallback);

  @override
  void start(Player player) {
    async.Timer(GameSettings.invincibilityDuration, _onEndCallback);

    player._animationComponent.decorator
        .addLast(PaintDecorator.tint(const Color.fromARGB(180, 255, 1, 1)));
  }

  @override
  void update(Player player, double dt) {}

  @override
  void stop(Player player) {
    player._animationComponent.decorator.removeLast();
  }
}
