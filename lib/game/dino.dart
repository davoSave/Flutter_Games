import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_games/game/heart.dart';

import '/game/enemy.dart';
import '/game/dino_run.dart';
import '/game/audio_manager.dart';
import '/models/player_data.dart';

enum DinoAnimationStates { idle, run, kick, hit, sprint }

class Dino extends SpriteAnimationGroupComponent<DinoAnimationStates>
    with CollisionCallbacks, HasGameReference<DinoRun> {

  static final _animationMap = {
    DinoAnimationStates.idle: SpriteAnimationData.sequenced(
      amount: 4,
      stepTime: 0.1,
      textureSize: Vector2.all(24),
    ),
    DinoAnimationStates.run: SpriteAnimationData.sequenced(
      amount: 6,
      stepTime: 0.1,
      textureSize: Vector2.all(24),
      texturePosition: Vector2((4) * 24, 0),
    ),
    DinoAnimationStates.kick: SpriteAnimationData.sequenced(
      amount: 4,
      stepTime: 0.1,
      textureSize: Vector2.all(24),
      texturePosition: Vector2((4 + 6) * 24, 0),
    ),
    DinoAnimationStates.hit: SpriteAnimationData.sequenced(
      amount: 3,
      stepTime: 0.1,
      textureSize: Vector2.all(24),
      texturePosition: Vector2((4 + 6 + 4) * 24, 0),
    ),
    DinoAnimationStates.sprint: SpriteAnimationData.sequenced(
      amount: 7,
      stepTime: 0.1,
      textureSize: Vector2.all(24),
      texturePosition: Vector2((4 + 6 + 4 + 3) * 24, 0),
    ),
  };

  double yMax = 0.0;
  double health = 5.0;
  final double maxHealth = 10.0;

  double speedY = 0.0;

  final Timer _hitTimer = Timer(1);

  static const double gravity = 800;

  final PlayerData playerData;

  bool isHit = false;

  Dino(Image image, this.playerData)
    : super.fromFrameData(image, _animationMap);

  @override
  void onMount() {
    _reset();

    add(
      RectangleHitbox.relative(
        Vector2(0.5, 0.7),
        parentSize: size,
        position: Vector2(size.x * 0.5, size.y * 0.3) / 2,
      ),
    );
    yMax = y;

    _hitTimer.onTick = () {
      current = DinoAnimationStates.run;
      isHit = false;
    };

    super.onMount();
  }

  @override
  void update(double dt) {
    speedY += gravity * dt;

    y += speedY * dt;

    if (isOnGround) {
      y = yMax;
      speedY = 0.0;
      if ((current != DinoAnimationStates.hit) &&
          (current != DinoAnimationStates.run)) {
        current = DinoAnimationStates.run;
      }
    }

    _hitTimer.update(dt);
    super.update(dt);
  }

  @override
  @override
void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
  if (other is Enemy && !(other is Heart) && !isHit) {
    hit();
  } else if (other is Heart) {
    increaseHealth(playerData.lives, 1);
    other.removeFromParent();
    print("Heart collected! Lives: ${playerData.lives}");
  }
  super.onCollision(intersectionPoints, other);
}


  bool get isOnGround => (y >= yMax);

  void jump() {
    if (isOnGround) {
      speedY = -300;
      current = DinoAnimationStates.idle;
      AudioManager.instance.playSfx('jump14.wav');
    }
  }

  void hit() {
    isHit = true;
    AudioManager.instance.playSfx('hurt7.wav');
    current = DinoAnimationStates.hit;
    _hitTimer.start();
    playerData.lives -= 1;
  }

  void _reset() {
    if (isMounted) {
      removeFromParent();
    }
    anchor = Anchor.bottomLeft;
    position = Vector2(32, game.virtualSize.y - 22);
    size = Vector2.all(24);
    current = DinoAnimationStates.run;
    isHit = false;
    speedY = 0.0;
  }

 void increaseHealth(int player, int amount) {
  int newLives = (player);
  playerData.lives = newLives;
}

}
