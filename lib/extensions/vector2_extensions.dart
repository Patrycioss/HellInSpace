import 'dart:math';

import 'package:flame/game.dart';

extension Math on Vector2 {
  double distanceTo(Vector2 other) {
    double v1 = x - other.x;
    double v2 = y - other.y;
    return sqrt((v1 * v1) + (v2 * v2));
  }
}
