import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ramayana/game/game_engine.dart';

class LevelIntro extends StatelessWidget {
  const LevelIntro({Key? key, required String level}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                  padding: const EdgeInsets.all(20),
                  child: AnimatedTextKit(
                      isRepeatingAnimation: false,
                      animatedTexts: [
                        TypewriterAnimatedText('lanka_dahan_intro'.tr(),
                            textStyle: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ])),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                GameEngine(level: 'lanka_dahan'))),
                    child: Text('start_game'.tr())),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
