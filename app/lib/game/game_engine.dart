/*
This file is responsible for creating the game engine and setting up the game.
It uses the Bonfire library to create the game engine and the game world.
It also sets up the player and the enemies in the game. It also sets up the
joystick and the camera for the game. It also sets up the background music for
the game. It also sets up the reset function for the game. The reset function is 
hsed to reset the game when the player dies. The game engine is used in the game
screen to create the game world and the game engine. 
*/
/*MOVED IMPRESSIVE CODE SNIPPET to rakshasa.dart*/
import 'package:bonfire/bonfire.dart';
import 'player_one.dart';
import 'rakshasa.dart';
import 'flammable_decoration.dart';
import 'platform_game_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame_audio/flame_audio.dart';

class GameEngine extends StatefulWidget {
  const GameEngine({Key? key}) : super(key: key);

  @override
  State<GameEngine> createState() => _GameEngineState();
}

class _GameEngineState extends State<GameEngine> {
  Key _gameKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    // FlameAudio.bgm.play('bgm.m4a');
    // This is used to build sprites and related actions
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
      // This is used to build the joystick and the game controller
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
      // This is used to build the player and their position
      player: PlayerOne(position: Vector2(128 * 5, 128 * 12)),
    );
  }

  void reset() {
    setState(() {
      _gameKey = UniqueKey();
    });
  }
}
