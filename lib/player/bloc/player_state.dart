part of 'player_bloc.dart';

class PlayerState extends Equatable {
  @override
  List<Object?> get props => [health];

  final int health;

  const PlayerState({required this.health});

  const PlayerState.initial()
      : this(
          health: GameSettings.maxPlayerHealth,
        );

  PlayerState copyWith({required int health}) {
    return PlayerState(health: health);
  }
}
