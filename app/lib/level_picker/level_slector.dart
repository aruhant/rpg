import 'package:flutter/material.dart';
import 'package:ramayana/game/game_engine.dart';
import 'package:ramayana/level_picker/world_selector.dart';

class LevelSelector extends StatelessWidget {
  final LevelInfo world;
  const LevelSelector({super.key, required this.world});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      width: 200,
      child: ListView(
        shrinkWrap: true,
        children: world.levels!.map((e) => LevelTile(level: e)).toList(),
      ),
    );
  }
}

class LevelTile extends StatelessWidget {
  final LevelInfo level;
  const LevelTile({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      color: level.isAvailable ? Colors.orange : Colors.white54,
      onPressed: () {
        if (level.isAvailable) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => GameEngine(level: level.map!),
          ));
        }
      },
      child: Text(level.name!,
          style: TextStyle(
              color: level.isAvailable ? Colors.white : Colors.black45)),
    );
  }
}
