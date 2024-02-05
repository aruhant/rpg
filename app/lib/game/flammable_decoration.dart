import 'package:bonfire/bonfire.dart';
import 'package:ramayana/user_prefs/audioController.dart';
import 'platform_spritesheet.dart';

class FlammableDecoration extends GameDecoration with Sensor {
  bool _onFire = false;
  FlammableDecoration({
    required super.position,
  }) : super.withAnimation(
          animation: PlatformSpritesheet.fire,
          size: Vector2(344 / 4, 86),
        );

  @override
  void onContact(GameComponent component) {
    if (component is Player && !_onFire) {
// change the animation to burning fire
      AudioController.playEffect('fire.wav');
      PlatformSpritesheet.fireOn.then((fire) {
        setAnimation(fire);
        size = Vector2(76 * 3, 116 * 3);
        position = position..translate(-76 * 1, -2 * 116);
        _onFire = true;
      });
    }
    super.onContact(component);
  }
}
