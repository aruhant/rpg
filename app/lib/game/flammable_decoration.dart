import 'package:bonfire/bonfire.dart';
import 'package:ramayana/user_prefs/audioController.dart';
import 'platform_spritesheet.dart';

class FlammableDecoration extends GameDecoration with Sensor {
  bool _onFire = false;
  FlammableDecoration({
    required Vector2 position,
  }) : super.withAnimation(
          animation: PlatformSpritesheet.fire,
          position: position..translate(0, -8),
          size: Vector2(128 * 1.5, 128 * 1.5),
        );

  @override
  void onContact(GameComponent component) {
    if (component is Player && !_onFire) {
// change the animation to burning fire
      AudioController.playEffect('fire.wav');
      PlatformSpritesheet.fireOn.then((fire) {
        setAnimation(fire);
        size = Vector2(128*1.5, 116 * 3);
        position = position..translate(0, -116);
        _onFire = true;
      });
    }
    super.onContact(component);
  }
}
