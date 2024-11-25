import 'package:dutch_game_studio_assessment/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';

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
