import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ramayana/game/game_engine.dart';
import 'package:ramayana/utils/logging.dart';

class LevelIntro extends StatefulWidget {
  const LevelIntro({Key? key, required this.onFinished, required this.level})
      : super(key: key);
  final Function (BuildContext c ) onFinished;
  final String level;

  @override
  State<LevelIntro> createState() => _LevelIntroState();
}

class _LevelIntroState extends State<LevelIntro> {
  List<String> _introPages = [""];
  int _currentPage = 0;
  bool _animationStopped = false;
  @override
  void initState() {
    super.initState();
    _introPages = "${widget.level}_intro".tr().split('~');
  }

  @override
  Widget build(BuildContext context) {
    String page = _introPages[_currentPage];
    Log.d('LevelIntro: $page');
    return Material(
      color: Colors.black,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/intro.jpg'),
                  opacity: 0.5,
                  fit: BoxFit.cover)),
          child: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                      padding: const EdgeInsets.all(50),
                      child: AnimatedTextKit(
                          key: ValueKey(page),
                          isRepeatingAnimation: false,
                          onFinished: () => setState(() {
                                _animationStopped = true;
                              }),
                          onTap: onTap,
                          displayFullTextOnTap: true,
                          animatedTexts: [
                            TypewriterAnimatedText(page,
                                textStyle: const TextStyle(
                                  fontSize: 32,
                                  color: Colors.white,
                                )),
                          ])),
                ),
                /*     Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: ElevatedButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    GameEngine(level: widget.level))),
                        child: Text('start_game'.tr())),
                  ),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onTap() {
    if (_currentPage < _introPages.length - 1) {
      setState(() {
        _currentPage++;
        _animationStopped = false;
      });
    } else {
      widget.onFinished(context);
    }
  }
}
