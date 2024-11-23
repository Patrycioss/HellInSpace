part of 'game_bloc.dart';

abstract class GameEvent {
  const GameEvent();
}

class EndGameEvent extends GameEvent{
  const EndGameEvent();
}

class ReplayGameEvent extends GameEvent{
  const ReplayGameEvent();
}


