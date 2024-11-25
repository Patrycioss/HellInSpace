part of '../player_component.dart';

class _RegularPlayerState extends _PlayerState {
  @override
  bool get canBeHit => true;

  @override
  void start(Player player) {}

  @override
  void stop(Player player) {}

  @override
  void update(Player player, double dt) {}
}
