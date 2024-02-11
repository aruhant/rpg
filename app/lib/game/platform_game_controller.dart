import 'package:bonfire/bonfire.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ramayana/game/rakshasa.dart';
import 'package:ramayana/game/ui/score_controller.dart';
import 'package:ramayana/title_screen/title_screen.dart';
import 'package:ramayana/utils/logging.dart';
import 'player_one.dart';
import 'flammable_decoration.dart';
import 'package:flutter/material.dart';

class PlatformGameController extends GameComponent {
  bool showGameOver = false;
  bool showWin = false;
  ProgressBarController _controller = ProgressBarController();
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
    var winCondition = (_controller.enemies <= 0) && (_controller.goals <= 0);
    // gameRef.query<FlammableDecoration>().isNotEmpty;
    if (winCondition && !showWin) {
      showWin = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('win_message'.tr()),
            actions: [
              TextButton(
                onPressed: () {
                  reset();
                },
                child: Text('play_again'.tr()),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const TitleScreen()),
                    (route) => false),
                child: Text('next_level'.tr()),
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
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('game_over'.tr()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  reset();
                },
                child: Text('try_again'.tr()),
              ),
            ],
          );
        },
      );
    }
  }
}
