part of 'game_bloc.dart';

enum GameStatus { initial, playing, finished }

class GameState extends Equatable {
  final GameStatus status;

  const GameState({
    required this.status,
  });

  const GameState.initial() : this(status: GameStatus.initial);

  GameState copyWith({
    GameStatus? status,
  }) {
    return GameState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => [status];
}