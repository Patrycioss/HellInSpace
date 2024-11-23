part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();
}

class GameStarted extends GameEvent{
  const GameStarted();

  @override
  List<Object?> get props => [];
}

class GameEnded extends GameEvent{
  const GameEnded();

  @override
  List<Object?> get props => [];
}
