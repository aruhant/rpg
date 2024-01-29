import 'package:bonfire/bonfire.dart';

class PlatformSpritesheet {
  static Future<SpriteAnimation> get enemyExplosion => SpriteAnimation.load(
        "platform/enemy-death.png",
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.08,
          textureSize: Vector2(40, 42),
        ),
      );

  static Future<SpriteAnimation> get playerIdleRight => SpriteAnimation.load(
        "platform/hanuman/hanuman-idle.png",
        SpriteAnimationData.sequenced(
          amount: 3,
          stepTime: 0.2,
          textureSize: Vector2(108, 108),
        ),
      );

  static Future<SpriteAnimation> get playerRunRight => SpriteAnimation.load(
        "platform/hanuman/hanuman-run.png",
        SpriteAnimationData.sequenced(
          amount: 5,
          stepTime: 0.1,
          textureSize: Vector2(108, 108),
        ),
      );

  static Future<SpriteAnimation> get playerJumpUp {
    return Sprite.load("platform/hanuman/hanuman-jump.png",
            srcSize: Vector2(108, 108))
        .then((value) {
      return SpriteAnimation.spriteList([value], stepTime: 1);
    });
  }

  static Future<SpriteAnimation> get playerJumpDown {
    return Sprite.load("platform/hanuman/hanuman-jump.png",
            srcPosition: Vector2(108, 0), srcSize: Vector2(108, 108))
        .then((value) {
      return SpriteAnimation.spriteList([value], stepTime: 1);
    });
  }

  static Future<SpriteAnimation> get rakshasaIdleRight {
    return Sprite.load(
      "platform/rakshasa/rakshasa-idle.png",
      srcSize: Vector2(89, 110),
    ).then((value) {
      return SpriteAnimation.spriteList([value], stepTime: 1);
    });
  }

  static Future<SpriteAnimation> get rakshasaActionRight =>
      SpriteAnimation.load(
        "platform/rakshasa/rakshasa-idle.png",
        SpriteAnimationData.sequenced(
          amount: 3,
          stepTime: 0.1,
          textureSize: Vector2(89, 110),
        ),
      );

  static Future<SpriteAnimation> get rakshasaJumpUp {
    return Sprite.load(
      "platform/rakshasa/rakshasa-jump.png",
      srcPosition: Vector2(89, 0),
      srcSize: Vector2(89, 110),
    ).then((value) {
      return SpriteAnimation.spriteList([value], stepTime: 1);
    });
  }

  static Future<SpriteAnimation> get rakshasaJumpDown {
    return Sprite.load(
      "platform/rakshasa/rakshasa-jump.png",
      srcPosition: Vector2(89, 0),
      srcSize: Vector2(89, 110),
    ).then((value) {
      return SpriteAnimation.spriteList([value], stepTime: 1);
    });
  }

  static Future<SpriteAnimation> get fire => SpriteAnimation.load(
        "platform/jewel.png",
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.08,
          textureSize: Vector2(86, 344 / 4),
        ),
      );
  static Future<SpriteAnimation> get fireOn => SpriteAnimation.load(
        "platform/fire.png",
        SpriteAnimationData.sequenced(
          amount: 9,
          stepTime: 0.8,
          textureSize: Vector2(192, 192),
        ),
      );

  static Future<SpriteAnimation> get itemFeedback => SpriteAnimation.load(
        "platform/item-feedback.png",
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.08,
          textureSize: Vector2(32, 32),
        ),
      );
}
