import 'dart:math';
import 'package:bonfire/bonfire.dart';
import 'package:ramayana/game/ui/score_controller.dart';
import 'package:ramayana/user_prefs/audioController.dart';
import 'player_one.dart';
import 'platform_spritesheet.dart';

class Rakshasa extends PlatformEnemy with HandleForces {
  int _timeToWaitBeforeJump = 4000;
  ProgressBarController controller = ProgressBarController();
  Rakshasa({required super.position})
      : super(
          size: Vector2(471 * .7, 480 * .7),
          speed: 150,
          animation: PlatformAnimations(
            idleRight: PlatformSpritesheet.rakshasaIdleRight,
            runRight: PlatformSpritesheet.rakshasaIdleRight,
            jump: PlatformJumpAnimations(
              jumpUpRight: PlatformSpritesheet.rakshasaJumpUp,
              jumpDownRight: PlatformSpritesheet.rakshasaJumpDown,
            ),
          ),
        );

  @override
  bool onBlockMovement(Set<Vector2> intersectionPoints, GameComponent other) {
    if (other is PlayerOne && isDead) return false;
    return super.onBlockMovement(intersectionPoints, other);
  }

  @override
  void onBlockedMovement(
    PositionComponent other,
    CollisionData collisionData,
  ) {
    super.onBlockedMovement(other, collisionData);
    if (other is PlayerOne) {
      if (collisionData.direction.isUpSide) {
        if (!isDead) {
          other.jump(jumpSpeed: 100, force: true);
          die();
        }
      } else {
        other.die();
      }
    }
  }

  @override
  void die() {
    controller.enemies--;
    AudioController.playEffect('enemy_die.mp3');
    super.die();
    animation?.playOnce(
      PlatformSpritesheet.enemyExplosion,
      runToTheEnd: true,
      onFinish: removeFromParent,
    );
  }

  /*IMPRESSIVE CODE SNIPPET*/
  @override
  // update method is used to update sprites position and related actions
  void update(double dt) {
    super.update(dt);
    // make sure the enemy is not dead and is visible
    if (checkInterval('jump', _timeToWaitBeforeJump, dt) &&
        !isDead &&
        isVisible) {
      // play the jump animation
      animation?.playOnce(
        PlatformSpritesheet.rakshasaActionRight,
        // flip the sprite horizontally
        flipX: lastDirectionHorizontal == Direction.left,
        onFinish: () async {
          await Future.delayed(const Duration(seconds: 2));
          // make sure the enemy is not dead
          if (!isDead) {
            jump(jumpSpeed: 260);
            // sprite moves left or right randomly
            Random().nextBool() ? moveRight() : moveLeft();
          }
        },
      );
    }
  }
  /*IMPRESSIVE CODE SNIPPET*/

  @override
  void onJump(JumpingStateEnum state) {
    if (state == JumpingStateEnum.idle) {
      stopMove(isY: false);
    }
    super.onJump(state);
  }

  @override
  Future<void> onLoad() {
    add(
      RectangleHitbox(
        size: size / 2,
        position: Vector2(size.x / 4, size.y / 2),
        isSolid: true,
      ),
    );
    _timeToWaitBeforeJump += Random().nextInt(1000);
    return super.onLoad();
  }
}
