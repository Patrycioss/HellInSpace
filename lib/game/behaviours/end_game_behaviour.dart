import 'package:dutch_game_studio_assessment/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class EndGameBehaviour extends Component
    with FlameBlocListenable<PlayerBloc, PlayerState>, HasGameRef<Forge2DGame> {
  @override
  bool listenWhen(PlayerState previousState, PlayerState newState) {
    return previousState != newState;
  }

  @override
  void onNewState(PlayerState state) {
    //TODO: Implement end and restart
  }
}
