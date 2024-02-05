import 'package:bonfire/bonfire.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ramayana/level_picker/world_selector.dart';
import 'package:ramayana/title_screen/title_screen.dart';
import 'game/game_engine.dart';
import 'user_prefs/audioController.dart';

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
  const RamayanRPGApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        // home: WorldMapWidget(
        //   game: GameEngine(level: 'lanka_dahan'),
        // ));
        home: TitleScreen(
          game: GameEngine(level: 'lanka_dahan'),
        ));
  }
}
