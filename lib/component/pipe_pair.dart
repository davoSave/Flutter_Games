import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter_games/bloc/game/game_cubit.dart';
import 'package:flutter_games/component/hidden_coin.dart';
import 'package:flutter_games/component/pipe.dart';

class PipePair extends PositionComponent
    with FlameBlocReader<GameCubit, GameState>{
  PipePair({
    required super.position,
    this.gap = 200.0,
    this.speed = 200.0,
  });

  final double gap;
  final double speed;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    addAll([
      Pipe(
          isFlipped: false,
          position: Vector2(0, gap / 2),
      ),
      Pipe(
          isFlipped: true,
          position: Vector2(0, -(gap / 2)),
      ),
      HiddenCoin(
          position: Vector2(0, 0)
      ),
    ]);
  }

  @override
  void update(double dt) {
    switch(bloc.state.currentPlayingState) {
      case PlayingState.paused:
      case PlayingState.gameOver:
      case PlayingState.none:
        break;
      case PlayingState.playing:
        position.x -= speed * dt;
        break;
    }
    super.update(dt);
  }
}