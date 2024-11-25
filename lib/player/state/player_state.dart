part of '../player_component.dart';

abstract class _PlayerState {
  bool get canBeHit;

  void start(Player player);

  void update(Player player, double dt);

  void stop(Player player);
}
