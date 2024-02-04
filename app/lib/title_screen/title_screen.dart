import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:ramayan/game/game_engine.dart';
import 'package:ramayan/game/platform_game_controller.dart';
import 'package:ramayan/user_prefs/audioController.dart';
import 'package:video_player/video_player.dart';

class TitleScreen extends StatefulWidget {
  // Reference to parent game.
  final GameEngine game;

  const TitleScreen({super.key, required this.game});

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
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                      onPressed: () => setState(AudioController.toggleMusic),
                      icon: Icon(AudioController.musicOn
                          ? Icons.music_off
                          : Icons.music_note)),
                  IconButton(
                      onPressed: () => setState(AudioController.toggleSound),
                      icon: Icon(AudioController.soundOn
                          ? Icons.volume_up
                          : Icons.volume_off)),
                  ElevatedButton(
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => widget.game)),
                      child: const Text('Start Game')),
                ],
              ),
            ),
          ],
        ));
  }
}
