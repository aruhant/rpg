import 'package:bonfire/bonfire.dart';
import 'package:ramayana/game/ui/score_controller.dart';
import 'package:ramayana/user_prefs/audioController.dart';
import 'package:ramayana/utils/logging.dart';
import 'platform_spritesheet.dart';

class FlammableDecoration extends GameDecoration with Sensor {
  bool _onFire = false;
  final ProgressBarController controller = ProgressBarController();
  FlammableDecoration({
    required Vector2 position,
  }) : super.withAnimation(
          animation: PlatformSpritesheet.fire,
          position: position..translate(0, -20),
          size: Vector2(128 * 1.2, 128 * 1.2),
        ) {}

  @override
  void onContactExit(GameComponent component) => onContact(component);

  @override
  void onContact(GameComponent component) {
    if (component is Player && !_onFire) {
// change the animation to burning fire
      controller.goals--;
      AudioController.playEffect('fire.wav');
      PlatformSpritesheet.fireOn.then((fire) {
        setAnimation(fire);
        size = Vector2(128 * 1.5, 116 * 3);
        position = position..translate(0, -106);
        _onFire = true;
      });
    }
    super.onContact(component);
  }
}
