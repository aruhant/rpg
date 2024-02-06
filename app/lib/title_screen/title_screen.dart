import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ramayana/game/game_engine.dart';
import 'package:ramayana/level_picker/world_selector.dart';
import 'package:ramayana/title_screen/language_picker.dart';
import 'package:ramayana/title_screen/level_intro.dart';
import 'package:ramayana/user_prefs/audioController.dart';
import 'package:video_player/video_player.dart';

class TitleScreen extends StatefulWidget {
  const TitleScreen({super.key});

  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen> {
  VideoPlayerController? _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/splash/splash.mp4')
      ..initialize().then((_) {
        _controller?.play();
        _controller?.setLooping(true);
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned.fill(
              child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                      width: 720,
                      height: 720,
                      child: (_controller == null)
                          ? Container()
                          : VideoPlayer(_controller!))),
            ),
            SafeArea(
              minimum: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  LanguagePicker(),
                  const SizedBox(height: 20),
                  IconButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white70)),
                      onPressed: () => setState(AudioController.toggleMusic),
                      color: Colors.black,
                      icon: Icon(AudioController.musicOn
                          ? Icons.music_note
                          : Icons.music_off)),
                  const SizedBox(height: 20),
                  IconButton(
                      color: Colors.black,
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white70)),
                      onPressed: () => setState(AudioController.toggleSound),
                      icon: Icon(AudioController.soundOn
                          ? Icons.volume_up
                          : Icons.volume_off)),
                  const Spacer(),
                  ElevatedButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  WorldMapWidget(locale: context.locale))),
                      child: Text('select_level'.tr())),
                  const SizedBox(height: 18),
                  ElevatedButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LevelIntro(level: 'lanka_dahan'))),
                      // const GameEngine(level: 'lanka_dahan'))),
                      child: Text('start_game'.tr())),
                ],
              ),
            ),
          ],
        ));
  }
}
