import 'package:dutch_game_studio_assessment/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

abstract class EnemyMoveBehaviour extends Component {
  void handleMovement(
      double deltaTime, Body body, Player player, EnemySettings enemySettings);
}
