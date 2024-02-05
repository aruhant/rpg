// The game consists of worlds, with multiple levels within each.
// The player can select a world and then a level to play.
// The world and level information is loaded from a JSON file.

// The WorldSelector class is a StatefulWidget that displays the list of worlds and levels.
// It also allows the player to select a world and level to play.

// The WorldSelector class has a reference to the parent game, which is used to start the game with the selected world and level.

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:ramayana/game/game_engine.dart';
import 'package:ramayana/level_picker/level_slector.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class WorldSelector extends StatefulWidget {
  // Reference to parent game.
  final GameEngine game;

  const WorldSelector({Key? key, required this.game}) : super(key: key);

  @override
  State<WorldSelector> createState() => _WorldSelectorState();
}

class _WorldSelectorState extends State<WorldSelector> {
  // List of worlds and levels.
  List<LevelInfo> worlds = [];

  @override
  void initState() {
    super.initState();
    loadWorlds();
  }

  // Load world and level information from a JSON file.
  Future<void> loadWorlds() async {
    final String jsonString = await rootBundle.loadString('assets/levels.json');
    // worlds = jsonDecode(jsonString).map((e) => LevelInfo.fromJson(e)).toList();
    worlds = (jsonDecode(jsonString)['worlds'] as List)
        .map((e) => LevelInfo.fromJson(e))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        minimum: const EdgeInsets.all(18.0),
        child: GridView.count(
          crossAxisCount: 3,
          padding: const EdgeInsets.all(4.0),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          children: List.generate(worlds.length, (index) {
            return InkWell(
              onTap: () {
                // When a world is selected, navigate to the LevelSelector screen.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LevelSelector(),
                  ),
                );
              },
              child: WorldTile(
                world: worlds[index],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class WorldTile extends StatelessWidget {
  final LevelInfo world;

  const WorldTile({Key? key, required this.world}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: (world.image != null)
            ? DecorationImage(
                image: AssetImage(world.image!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: Center(
        child: Text(
          world.name ?? '',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}

class LevelInfo {
  final String? name;
  final String? map;
  final String? image;
  final List<LevelInfo>? levels;
  final String? info;

  LevelInfo({this.name, this.map, this.image, this.levels, this.info});
  LevelInfo.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        map = json['map'],
        image = json['image'],
        levels = json['levels'] != null
            ? (json['levels'] as List)
                .map((i) => LevelInfo.fromJson(i))
                .toList()
            : null,
        info = json['info'];
}
