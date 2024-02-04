import 'package:bonfire/bonfire.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ramayan/game/platform_game_controller.dart';
import 'game/game_engine.dart';
import 'user_prefs/audioController.dart';
import 'title_screen/title_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AudioController.init();
  if (!kIsWeb) {
    await Flame.device.setLandscape();
    await Flame.device.fullScreen();
  }

  runApp(const RamayanRPGApp());
}

class RamayanRPGApp extends StatelessWidget {
  const RamayanRPGApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TitleScreen(
          game: GameEngine(level: 'lanka_dahan'),
        ));
  }
}
