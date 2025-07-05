import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/effects.dart';

class Heart extends SpriteComponent with CollisionCallbacks, HasGameRef {
  Heart({required Vector2 position, required Sprite sprite})
      : super(position: position, sprite: sprite, size: Vector2(24, 24));

  final Vector2 _velocity = Vector2(-100, 0);
  void Function()? onCollected;

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
    anchor = Anchor.center;

    add(MoveByEffect(
      Vector2(0, -4),
      EffectController(duration: 0.5, reverseDuration: 0.5, infinite: true),
    ));
  }

  @override
  void update(double dt) {
    position += _velocity * dt;

    if (position.x < -size.x) {
      removeFromParent();
    }

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other.runtimeType.toString() == 'Dino') {
      onCollected?.call();
      removeFromParent();
    }
    super.onCollision(intersectionPoints, other);
  }
}
