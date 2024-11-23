part of 'player_bloc.dart';


abstract class PlayerEvent extends Equatable {
  const PlayerEvent();
}

class PlayerHealthUpdated extends PlayerEvent{
  const PlayerHealthUpdated(this.health);

  final int health;

  @override
  List<Object?> get props => [health];
}
