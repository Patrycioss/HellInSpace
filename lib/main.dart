import 'package:bloc/bloc.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'bootstrap.dart';
import 'game/game.dart';

void main() {
  Bloc.observer = AppBlocObserver();
  runApp(const MaterialApp(
    home: GamePage(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  // Use to reset game
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
