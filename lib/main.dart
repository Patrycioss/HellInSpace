import 'package:bloc/bloc.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

import 'bootstrap.dart';
import 'game/game.dart';

void main() {
  Bloc.observer = AppBlocObserver();
  runApp(GameWidget(game: HellInSpaceGame()));
}
