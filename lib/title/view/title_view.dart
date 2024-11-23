import 'package:flutter/material.dart';

import '../../game/game.dart';

class TitleView extends StatelessWidget {
  const TitleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(HellInSpaceGamePage.route());
            },
            child: const Text('Play!')),
      ),
    );
  }
}
