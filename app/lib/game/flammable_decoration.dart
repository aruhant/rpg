import 'package:bonfire/bonfire.dart';
import 'platform_spritesheet.dart';

class FlammableDecoration extends GameDecoration with Sensor {
  bool _onFire = false;
  FlammableDecoration({
    required Vector2 position,
  }) : super.withAnimation(
          animation: PlatformSpritesheet.fire,
          position: position,
          size: Vector2(344 / 4, 86),
        );

  @override
  void onContact(GameComponent component) {
    if (component is Player && !_onFire) {
// change the animation to burning fire
      PlatformSpritesheet.fireOn.then((fire) => setAnimation(fire));
      _onFire = true;
    }
    super.onContact(component);
  }
}
