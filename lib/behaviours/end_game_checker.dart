import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';

import '../mixins/has_hell_in_space_game_ref.dart';
import '../player/bloc/player_bloc.dart';

class PlayerLossChecker extends Component
    with FlameBlocListenable<PlayerBloc, PlayerState>, HasHellInSpaceGameRef {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  @override
  bool listenWhen(PlayerState previousState, PlayerState newState) {
    return previousState != newState;
  }

  @override
  void onNewState(PlayerState state) {
    if (state.health <= 0) {
      hellInSpaceGameRef.loseGame();
    }
  }
}
