import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:ramayana/game/game_engine.dart';
import 'package:ramayana/level_picker/level_slector.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class WorldMapWidget extends StatefulWidget {
  // Reference to parent game.
  final GameEngine game;

  const WorldMapWidget({super.key, required this.game});

  @override
  State<WorldMapWidget> createState() => _WorldMapWidgetState();
}

class _WorldMapWidgetState extends State<WorldMapWidget> {
  // List of worlds and levels.
  List<LevelInfo> worlds = [];

  @override
  void initState() {
    super.initState();
    loadWorlds();
  }

  // Load world and level information from a JSON file.
  Future<void> loadWorlds() async {
    final String jsonString =
        await rootBundle.loadString('assets/worlds/world_map.json');
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
        // minimum: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
            child: Stack(
          children: [
            Image.asset('assets/worlds/world_map.png'),
            ...worlds.map((e) => WorldTile(world: e)).toList(),
          ],
        )),
      ),
    );
  }
}

class WorldTile extends StatefulWidget {
  final LevelInfo world;

  const WorldTile({super.key, required this.world});

  @override
  State<WorldTile> createState() => _WorldTileState();
}

class _WorldTileState extends State<WorldTile> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: widget.world.x,
        top: widget.world.y,
        child: MaterialButton(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.0),
          ),
          onPressed: () {
            if (!widget.world.isAvailable) {
              showDialog(
                  context: context,
                  builder: (context) => LevelInfoDialog(info: widget.world));
            }
          },
          child: Text(widget.world.name ?? '',
              style: TextStyle(
                  fontSize: 16,
                  color: widget.world.isAvailable
                      ? Colors.black
                      : Colors.black45)),
          color: widget.world.isAvailable
              ? Colors.red
              : Colors.red.withOpacity(0.5),
        ));
  }
}

class LevelInfo {
  final String? name;
  final String? map;
  final double x, y;
  final bool isAvailable;

  final String? info;
  LevelInfo({
    this.name,
    this.map,
    this.x = 0,
    this.y = 0,
    this.isAvailable = false,
    this.info,
  });
  LevelInfo.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        map = json['map'],
        x = (json['x'] ?? 300).toDouble(),
        y = (json['y'] ?? 300).toDouble(),
        isAvailable = json['isAvailable'] ?? false,
        info = json['info'];
}

class LevelInfoDialog extends StatelessWidget {
  final LevelInfo info;

  const LevelInfoDialog({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(info.name ?? ''),
      content: Text(info.info ?? 'Coming Soon!'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        )
      ],
    );
  }
}
