import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'game_event.dart';

part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(const GameState.initial()) {
    on<GameStarted>(_onGameStarted);
    on<GameEnded>(_onGameEnded);
  }

  _onGameStarted(GameStarted event, emit) {
    emit(state.copyWith(status: GameStatus.playing));
  }

  _onGameEnded(GameEnded event, emit) {
    emit(state.copyWith(status: GameStatus.finished));
  }
}
