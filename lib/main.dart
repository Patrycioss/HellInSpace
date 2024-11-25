import 'package:bloc/bloc.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'bootstrap.dart';
import 'game/game.dart';

void main() {
  Bloc.observer = AppBlocObserver();
  runApp(MaterialApp(
    home: GamePage(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: HellInSpaceGame(() {
      setState(() {
        _count++;
      });
    }));
  }
}
