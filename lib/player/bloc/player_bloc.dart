import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../game_settings.dart';

part 'player_event.dart';

part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  PlayerBloc() : super(const PlayerState.initial()) {
    on<PlayerHealthUpdated>(_onPlayerHealthUpdated);
  }

  void _onPlayerHealthUpdated(
      PlayerHealthUpdated event, Emitter<PlayerState> emit) {
    emit(state.copyWith(health: event.health));
  }
}
