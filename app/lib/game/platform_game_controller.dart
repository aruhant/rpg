import 'package:bonfire/bonfire.dart';
import 'player_one.dart';
import 'flammable_decoration.dart';
import 'package:flutter/material.dart';

class PlatformGameController extends GameComponent {
  bool showGameOver = false;
  bool showWin = false;
  final VoidCallback reset;

  PlatformGameController({required this.reset});
  @override
  void update(double dt) {
    if (checkInterval('check win', 500, dt)) {
      _checkWin();
      _checkGameOver();
    }
    super.update(dt);
  }

  void _checkWin() {
    var containGem = gameRef.query<FlammableDecoration>().isNotEmpty;
    if (!containGem && !showWin) {
      showWin = true;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('You have successfully destroyed Lanka!'),
            actions: [
              TextButton(
                onPressed: () {
                  reset();
                },
                child: const Text('Play Again'),
              ),
              TextButton(
                onPressed: null,
                child: const Text('Next Level'),
              ),
            ],
          );
        },
      );
    }
  }

  void _checkGameOver() {
    if (gameRef.query<PlayerOne>().isEmpty && !showGameOver) {
      showGameOver = true;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Game Over'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  reset();
                },
                child: const Text('TRY AGAIN'),
              ),
            ],
          );
        },
      );
    }
  }
}
