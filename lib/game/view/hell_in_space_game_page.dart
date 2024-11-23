import 'package:dutch_game_studio_assessment/game/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HellInSpaceGamePage extends StatelessWidget {
  const HellInSpaceGamePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(builder: (context) {
      return MultiBlocProvider(providers: [
        BlocProvider<PlayerBloc>(create: (_) => PlayerBloc()),
      ], child: const HellInSpaceGamePage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return const HellInSpaceGameView();
  }
}
