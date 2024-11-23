import 'package:flutter/material.dart';

import 'package:flame/game.dart';
import 'my_game.dart';

void main() {
  runApp(
    GameWidget(
      game: MyGame(),
    ),
  );
}