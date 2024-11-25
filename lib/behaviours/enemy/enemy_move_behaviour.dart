import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import '../../enemy/enemy_settings.dart';
import '../../player/player_component.dart';

abstract class EnemyMoveBehaviour extends Component {
  void handleMovement(
      double deltaTime, Body body, Player player, EnemySettings enemySettings);
}
