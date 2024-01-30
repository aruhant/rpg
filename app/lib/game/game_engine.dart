import 'package:bonfire/bonfire.dart';
import 'player_one.dart';
import 'rakshasa.dart';
import 'flammable_decoration.dart';
import 'platform_game_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GameEngine extends StatefulWidget {
  const GameEngine({Key? key}) : super(key: key);

  @override
  State<GameEngine> createState() => _GameEngineState();
}

class _GameEngineState extends State<GameEngine> {
  Key _gameKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BonfireWidget(
      key: _gameKey,
      showCollisionArea: false,
      map: WorldMapByTiled(
        TiledReader.asset(
          'maps/lanka_map.tmj',
        ),
        objectsBuilder: {
          'rakshasa': (properties) => Rakshasa(position: properties.position),
          'fire': (properties) =>
              FlammableDecoration(position: properties.position),
        },
      ),
      joystick: Joystick(
          keyboardConfig: KeyboardConfig(acceptedKeys: [
            LogicalKeyboardKey.space,
          ]),
          directional: JoystickDirectional(
            color: Color.fromARGB(255, 13, 116, 68),
          ),
          actions: [
            JoystickAction(
                actionId: 'joystickJump',
                margin: const EdgeInsets.all(70),
                color: const Color.fromARGB(255, 72, 121, 99))
          ]),
      components: [PlatformGameController(reset: reset)],
      backgroundColor: Color.fromARGB(255, 41, 140, 185),
      globalForces: [GravityForce2D()],
      cameraConfig: CameraConfig(
        moveOnlyMapArea: true,
        zoom: getZoomFromMaxVisibleTile(context, 12, 128),
        speed: 1,
      ),
      player: PlayerOne(position: Vector2(128 * 5, 128 * 12)),
    );
  }

  void reset() {
    setState(() {
      _gameKey = UniqueKey();
    });
  }
}
