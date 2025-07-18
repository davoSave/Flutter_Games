import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter_games/bloc/game/game_cubit.dart';
import 'package:flutter_games/component/hidden_coin.dart';
import 'package:flutter_games/component/pipe.dart';

import '../happy_bird_game.dart';

class Dash extends PositionComponent
    with
        CollisionCallbacks,
        HasGameRef<FlappyDashGame>,
        FlameBlocReader<GameCubit, GameState> {
  Dash(): super(
      position: Vector2(0, 0),
      size: Vector2.all(80),
      anchor: Anchor.center,
      priority: 10,
  );

  late Sprite _dashSprite;

  final Vector2 _gravity = Vector2(0, 1400);
  Vector2 _velocity = Vector2(0, 0);
  final Vector2 _jumpForce = Vector2(0, -500);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _dashSprite = await Sprite.load('happy_bird.png');
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (bloc.state.currentPlayingState != PlayingState.playing) {
      return;
    }
    _velocity += _gravity * dt;
    position += _velocity * dt;
  }

  void jump() {
    if (bloc.state.currentPlayingState != PlayingState.playing) {
      return;
    }
    _velocity = _jumpForce;
  }

  @override
  void  render(Canvas canvas) {
    super.render(canvas);
    _dashSprite.render(
        canvas,
        size: size,
    );
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    if (bloc.state.currentPlayingState != PlayingState.playing) {
      return;
    }
    if (other is HiddenCoin) {
      bloc.increaseScore();
      other.removeFromParent();
    } else if (other is Pipe) {
      bloc.gameOver();
    }
  }
}

class Dash2 extends SpriteComponent {
  Dash2({
    required super.sprite,
  });
}