import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ramayana/level_picker/level_slector.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class WorldMapWidget extends StatefulWidget {
  const WorldMapWidget({super.key, required this.locale});
  final Locale locale;

  @override
  State<WorldMapWidget> createState() => _WorldMapWidgetState();
}

class _WorldMapWidgetState extends State<WorldMapWidget> {
  // List of worlds and levels.
  List<LevelInfo> worlds = [];
  LevelInfo? selectedWorld;

  @override
  void initState() {
    super.initState();
    loadWorlds();
  }

  // Load world and level information from a JSON file.
  Future<void> loadWorlds() async {
    final String jsonString = widget.locale.languageCode == 'hi'
        ? await rootBundle.loadString('assets/worlds/world_map_hi.json')
        : await rootBundle.loadString('assets/worlds/world_map_en.json');
    // worlds = jsonDecode(jsonString).map((e) => LevelInfo.fromJson(e)).toList();
    worlds = (jsonDecode(jsonString)['worlds'] as List)
        .map((e) => LevelInfo.fromJson(e))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double side = max(size.width, size.height);
    double scale = side / 1000;
    print(scale);
    return Material(
      color: Colors.red,
      child: SingleChildScrollView(
        child: Container(
          width: side,
          height: side,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/worlds/world_map.jpg'),
              fit: BoxFit.cover,
              alignment: Alignment.topLeft,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Container(
              //   width: side,
              //   height: side,
              //   decoration: BoxDecoration(
              //     color: Colors.green.withOpacity(0.3),
              //     image: DecorationImage(
              //       image: AssetImage('assets/worlds/world_map.png'),
              //       opacity: 0.3,
              //       fit: BoxFit.cover,
              //       alignment: Alignment.topLeft,
              //     ),
              //   ),
              // ),
              ...worlds.map((e) => WorldTile(
                  world: e,
                  scale: scale,
                  onSlelect: () => setState(() {
                        selectedWorld = e;
                      }))),
              if (selectedWorld != null)
                Positioned(
                    left: (scale * selectedWorld!.x) - 100,
                    top: (scale * selectedWorld!.y) - 100,
                    child: LevelSelector(world: selectedWorld!)),
            ],
          ),
        ),
      ),
    );
  }
}

class WorldTile extends StatelessWidget {
  final LevelInfo world;
  final VoidCallback onSlelect;
  final double scale;
  const WorldTile(
      {super.key,
      this.scale = 1,
      required this.world,
      required this.onSlelect});
  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: world.x * scale,
        top: world.y * scale,
        child: MaterialButton(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.0),
          ),
          onPressed: () {
            if (!world.isAvailable) {
              showDialog(
                  context: context,
                  builder: (context) => LevelInfoDialog(world: world));
            } else {
              onSlelect();
            }
          },
          color: world.isAvailable ? Colors.red : Colors.red.withOpacity(0.8),
          child: Text(world.name ?? '',
              style: TextStyle(
                  fontSize: 16,
                  color: world.isAvailable ? Colors.black : Colors.black45)),
        ));
  }
}

class LevelInfo {
  final String? name;
  final String? map;
  final double x, y;
  final bool isAvailable;
  final List<LevelInfo>? levels;

  final String? info;
  LevelInfo({
    this.name,
    this.map,
    this.x = 0,
    this.y = 0,
    this.isAvailable = false,
    this.levels,
    this.info,
  });
  LevelInfo.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        map = json['map'],
        x = (json['x'] ?? 300).toDouble(),
        y = (json['y'] ?? 300).toDouble(),
        isAvailable = json['isAvailable'] ?? false,
        levels = (json['levels'] ?? [])
            .map<LevelInfo>((e) => LevelInfo.fromJson(e))
            .toList(),
        info = json['info'];
}

class LevelInfoDialog extends StatelessWidget {
  final LevelInfo world;

  const LevelInfoDialog({super.key, required this.world});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(world.name ?? ''),
      content: Text(world.info ?? 'coming_soon'.tr()),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('close'.tr()),
        )
      ],
    );
  }
}
