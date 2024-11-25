import 'package:dutch_game_studio_assessment/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

mixin HasHellInSpaceGameRef on Component {
  HellInSpaceGame? _game;

  HellInSpaceGame get game => _game ??= _findGame();

  set hellInSpaceGame(HellInSpaceGame? value) => _game = value;

  HellInSpaceGame get gameRef => game;

  late final HellInSpaceGame hellInSpaceGameRef;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    hellInSpaceGameRef = game;
  }

  HellInSpaceGame _findGame() {
    FlameGame<World>? game = super.findGame();
    assert(
        game != null,
        "Could not find Game instance: the component is "
        "detached from the component tree");

    return game as HellInSpaceGame;
  }
}
