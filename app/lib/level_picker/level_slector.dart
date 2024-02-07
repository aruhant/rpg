import 'package:flutter/material.dart';
import 'package:ramayana/game/game_engine.dart';
import 'package:ramayana/level_picker/world_selector.dart';
import 'package:ramayana/title_screen/level_intro.dart';

class LevelSelector extends StatelessWidget {
  final LevelInfo world;
  static const width = 300.0;
  const LevelSelector({super.key, required this.world});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      clipBehavior: Clip.antiAlias,
      width: width,
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
      color: level.isAvailable ? Colors.orange : Colors.white60,
      onPressed: () {
        if (level.isAvailable) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => LevelIntro(level: level.map!),
          ));
        }
      },
      child: Text(level.name!,
          style: TextStyle(
              color: level.isAvailable ? Colors.black : Colors.black38)),
    );
  }
}
