part of 'player_bloc.dart';

abstract class PlayerEvent extends Equatable {
  const PlayerEvent();
}

class PlayerHealthUpdated extends PlayerEvent {
  @override
  List<Object?> get props => [health];

  final int health;

  const PlayerHealthUpdated(this.health);
}
