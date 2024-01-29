import 'package:bonfire/bonfire.dart';
import 'platform_spritesheet.dart';
import 'package:flutter/services.dart';

class PlayerOne extends PlatformPlayer with HandleForces {
  bool inTrunk = false;
  PlayerOne({required Vector2 position})
      : super(
          position: position,
          size: Vector2.all(2 * 128),
          speed: 128 * 4,
          animation: PlatformAnimations(
            idleRight: PlatformSpritesheet.playerIdleRight,
            runRight: PlatformSpritesheet.playerRunRight,
            jump: PlatformJumpAnimations(
              jumpUpRight: PlatformSpritesheet.playerJumpUp,
              jumpDownRight: PlatformSpritesheet.playerJumpDown,
            ),
          ),
        );

  @override
  void onJoystickChangeDirectional(JoystickDirectionalEvent event) {
    if (event.directional == JoystickMoveDirectional.MOVE_LEFT ||
        event.directional == JoystickMoveDirectional.MOVE_RIGHT ||
        event.directional == JoystickMoveDirectional.IDLE) {
      super.onJoystickChangeDirectional(event);
    }
  }

  @override
  void onJoystickAction(JoystickActionEvent event) {
    if (event.event == ActionEvent.DOWN &&
        (event.id == LogicalKeyboardKey.space || event.id == 'joystickJump')) {
      jump(jumpSpeed: 128 * 3);
    }
    super.onJoystickAction(event);
  }

  @override
  Future<void> onLoad() {
    add(
      RectangleHitbox(
        size: Vector2.all(size.x / 2),
        position: Vector2(size.x / 4, size.y - size.x / 2),
        isSolid: true,
      ),
    );
    return super.onLoad();
  }

  @override
  void die() {
    removeFromParent();
    super.die();
  }
}