import 'package:bonfire/bonfire.dart';
import 'package:flutter/foundation.dart';
import 'package:ramayana/game/ui/score_controller.dart';
import 'package:ramayana/game/ui/score_widget.dart';
import 'package:ramayana/title_screen/title_screen.dart';
import 'package:ramayana/user_prefs/audioController.dart';
import 'player_one.dart';
import 'rakshasa.dart';
import 'flammable_decoration.dart';
import 'platform_game_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:ui' as ui;

/*
This file is responsible for creating the game engine and setting up the game.
It uses the Bonfire library to create the game engine and the game world.
It also sets up the player and the enemies in the game. It also sets up the
joystick and the camera for the game. It also sets up the background music for
the game. It also sets up the reset function for the game. The reset function is 
hsed to reset the game when the player dies. The game engine is used in the game
screen to create the game world and the game engine. 

I think, the boids algorithm below is pretty cool. 

This implementation is based on the following chapter of the book "The Nature of Code" by Daniel Shiffman:
 https://natureofcode.com/autonomous-agents/
 Also refer to Craig Reynolds' "Boids" algorithm, which simulates the flocking behavior of birds.
 In the context of the game, the boids are used to simulate the behavior of the enemies.
 For example, the Rakshasa enemies in the game can use this to simulate their flocking behavior.
 In general this is a better approach than using a simple pathfinding algorithm which directly calculates the path to the player.
 This gives a more natural and realistic behavior to the enemies.
 Also, avoids the enemies from getting stuck in obstacles or against each other.
*/
class Boid {
  static final Random r = Random();
  static final Vec migrate = Vec(0.02, 0);
  static const double size = 3;
  static final Path shape = Path()
    ..moveTo(0, -size * 2)
    ..lineTo(-size, size * 2)
    ..lineTo(size, size * 2)
    ..close();

  final double maxForce, maxSpeed;

  Vec location, velocity, acceleration;
  bool included = true;

  Boid(double x, double y)
      : acceleration = Vec(0, 0),
        velocity = Vec(r.nextInt(3) + 1, r.nextInt(3) - 1),
        location = Vec(x, y),
        maxSpeed = 3.0,
        maxForce = 0.05;

  void update() {
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    location.add(velocity);
    acceleration.multiply(0);
  }

  void applyForce(Vec force) {
    acceleration.add(force);
  }

  Vec seek(Vec target) {
    Vec steer = Vec.diff(target, location);
    steer.normalize();
    steer.multiply(maxSpeed);
    steer.substract(velocity);
    steer.limit(maxForce);
    return steer;
  }

  void flock(ui.Canvas canvas, List<Boid> boids) {
    view(canvas, boids);

    Vec rule1 = separation(boids);
    Vec rule2 = alignment(boids);
    Vec rule3 = cohesion(boids);

    rule1.multiply(2.5);
    rule2.multiply(1.5);
    rule3.multiply(1.3);

    applyForce(rule1);
    applyForce(rule2);
    applyForce(rule3);
    applyForce(migrate);
  }

  void view(ui.Canvas canvas, List<Boid> boids) {
    double sightDistance = 100;
    double peripheryAngle = pi * 0.85;

    for (Boid b in boids) {
      b.included = false;

      if (b == this) continue;

      double d = Vec.dist(location, b.location);
      if (d <= 0 || d > sightDistance) continue;

      Vec lineOfSight = Vec.diff(b.location, location);

      double angle = Vec.angleBetween(lineOfSight, velocity);
      if (angle < peripheryAngle) b.included = true;
    }
  }

  Vec separation(List<Boid> boids) {
    double desiredSeparation = 25;

    Vec steer = Vec(0, 0);
    int count = 0;
    for (Boid b in boids) {
      if (!b.included) continue;

      double d = Vec.dist(location, b.location);
      if ((d > 0) && (d < desiredSeparation)) {
        Vec diff = Vec.diff(location, b.location);
        diff.normalize();
        diff.divide(d); // weight by distance
        steer.add(diff);
        count++;
      }
    }
    if (count > 0) {
      steer.divide(count.toDouble());
    }

    if (steer.magnitude() > 0) {
      steer.normalize();
      steer.multiply(maxSpeed);
      steer.substract(velocity);
      steer.limit(maxForce);
      return steer;
    }
    return Vec(0, 0);
  }

  Vec alignment(List<Boid> boids) {
    double preferredDist = 50;

    Vec steer = Vec(0, 0);
    int count = 0;

    for (Boid b in boids) {
      if (!b.included) continue;

      double d = Vec.dist(location, b.location);
      if ((d > 0) && (d < preferredDist)) {
        steer.add(b.velocity);
        count++;
      }
    }

    if (count > 0) {
      steer.divide(count.toDouble());
      steer.normalize();
      steer.multiply(maxSpeed);
      steer.substract(velocity);
      steer.limit(maxForce);
    }
    return steer;
  }

  Vec cohesion(List<Boid> boids) {
    double preferredDist = 50;

    Vec target = Vec(0, 0);
    int count = 0;

    for (Boid b in boids) {
      if (!b.included) continue;

      double d = Vec.dist(location, b.location);
      if ((d > 0) && (d < preferredDist)) {
        target.add(b.location);
        count++;
      }
    }
    if (count > 0) {
      target.divide(count.toDouble());
      return seek(target);
    }
    return target;
  }

  void draw(ui.Canvas canvas) {
    canvas.save();

    canvas.translate(location.x, location.y);
    canvas.rotate(velocity.heading() + pi / 2);

    Paint paint = Paint()..color = Colors.white;
    canvas.drawPath(shape, paint);

    paint = Paint()..color = Colors.black;
    paint.style = PaintingStyle.stroke;
    canvas.drawPath(shape, paint);

    canvas.restore();
  }

  void run(ui.Canvas canvas, List<Boid> boids, int w, int h) {
    flock(canvas, boids);
    update();
    draw(canvas);
  }
}

class Flock {
  List<Boid> boids = [];

  Flock() {
    boids = [];
  }

  void run(ui.Canvas canvas, int w, int h) {
    for (Boid b in boids) {
      b.run(canvas, boids, w, h);
    }
  }

  bool hasLeftTheBuilding(int w) {
    int count = 0;
    for (Boid b in boids) {
      if (b.location.x + Boid.size > w) count++;
    }
    return boids.length == count;
  }

  void addBoid(Boid b) {
    boids.add(b);
  }

  static Flock spawn(double w, double h, int numBoids) {
    Flock flock = Flock();
    for (int i = 0; i < numBoids; i++) {
      flock.addBoid(Boid(w, h));
    }
    return flock;
  }
}

class Vec {
  double x = 0, y = 0;

  Vec(this.x, this.y);

  void add(Vec v) {
    x += v.x;
    y += v.y;
  }

  void substract(Vec v) {
    x -= v.x;
    y -= v.y;
  }

  void divide(double val) {
    x /= val;
    y /= val;
  }

  void multiply(double val) {
    x *= val;
    y *= val;
  }

  double magnitude() {
    return sqrt(pow(x, 2) + pow(y, 2));
  }

  double dot(Vec v) {
    return x * v.x + y * v.y;
  }

  void normalize() {
    double m = magnitude();
    if (m != 0) {
      x /= m;
      y /= m;
    }
  }

  void limit(double lim) {
    double m = magnitude();
    if (m != 0 && m > lim) {
      x *= lim / m;
      y *= lim / m;
    }
  }

  double heading() {
    return atan2(y, x);
  }

  static Vec diff(Vec v, Vec v2) {
    return Vec(v.x - v2.x, v.y - v2.y);
  }

  static double dist(Vec v, Vec v2) {
    return sqrt(pow(v.x - v2.x, 2) + pow(v.y - v2.y, 2));
  }

  static double angleBetween(Vec v, Vec v2) {
    return acos(v.dot(v2) / (v.magnitude() * v2.magnitude()));
  }
}

class GameEngine extends StatefulWidget {
  const GameEngine({super.key, required this.level});
  final String level;
  @override
  State<GameEngine> createState() => _GameEngineState();
}

class _GameEngineState extends State<GameEngine> {
  @override
  void initState() {
    super.initState();
    AudioController.playBgm(widget.level);
    ProgressBarController().reset();
  }

  Key _gameKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    // This is used to build sprites and related actions
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/maps/${widget.level}_bg.jpg'),
            alignment: Alignment.topCenter,
            fit: BoxFit.cover,
          ),
        ),
        child: BonfireWidget(
          key: _gameKey,
          // showCollisionArea: kDebugMode,
          map: WorldMapByTiled(
            TiledReader.asset('maps/${widget.level}_map.tmj'),
            forceTileSize: Vector2(128 * 1.5, 128 * 1.5),
            objectsBuilder: {
              'rakshasa': (properties) =>
                  Rakshasa(position: properties.position),
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
                color: Colors.grey,
              ),
              actions: [
                JoystickAction(
                  actionId: 'joystickJump',
                  margin: const EdgeInsets.all(70),
                  color: Colors.grey,
                ),
              ]),
          components: [PlatformGameController(reset: reset)],
          backgroundColor: const Color.fromARGB(0, 0, 0, 0),
          // lightingColorGame: Colors.black.withOpacity(0.7),
          overlayBuilderMap: {
            'scoreWidget': (context, game) => const ProgressBarWidget(),
            'exit': (context, game) => Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const TitleScreen()));
                        }),
                  ),
                ),
          },

          initialActiveOverlays: const ['scoreWidget', 'exit'],
          globalForces: [GravityForce2D()],
          cameraConfig: CameraConfig(
            moveOnlyMapArea: true,
            zoom: getZoomFromMaxVisibleTile(context, 12, 128),
            speed: 2,
          ),
          // This is used to build the player and their position
          player: PlayerOne(position: Vector2(128 * 5, 128 * 18)),
        ),
      );
    });
  }

  void reset() {
    setState(() {
      ProgressBarController().reset();
      _gameKey = UniqueKey();
    });
  }
}
