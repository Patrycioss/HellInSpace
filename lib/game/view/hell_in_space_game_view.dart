import 'package:dutch_game_studio_assessment/game/game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HellInSpaceGameView extends StatefulWidget {
  const HellInSpaceGameView({super.key});

  @override
  State<StatefulWidget> createState() => HellInSpaceGameViewState();
}

class HellInSpaceGameViewState extends State<HellInSpaceGameView> {
  late FocusNode gameFocusNode;

  @override
  void initState() {
    super.initState();

    gameFocusNode = FocusNode();
  }

  @override
  void dispose() {
    gameFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: MouseRegion(
              onHover: (_) {
                if (!gameFocusNode.hasFocus) {
                  gameFocusNode.requestFocus();
                }
              },
              child: GameWidget(
                focusNode: gameFocusNode,
                game: HellInSpaceGame(
                  playerBloc: context.read<PlayerBloc>(),
                  // inventoryBloc: context.read<InventoryBloc>(),
                ),
              ),
            ),
          ),
          // const SizedBox(
          //   width: 250,
          //   height: double.infinity,
          //   child: Column(
          //     children: [
          //       // PlayerView(),
          //       // Expanded(child: InventoryView()),
          //       SizedBox(height: 8),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
