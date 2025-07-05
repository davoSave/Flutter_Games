import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_games/component/dash_parallax_background.dart';
import 'package:flutter_games/component/pipe_pair.dart';

import 'bloc/game/game_cubit.dart';
import 'component/dash.dart';

class FlappyDashGame extends FlameGame<FlappyDashWorld>
    with KeyboardEvents, HasCollisionDetection {
  FlappyDashGame(this.gameCubit)
      : super(
        world: FlappyDashWorld(),
        camera: CameraComponent.withFixedResolution(
          width: 600,
          height: 1000,
        ),
      );

  final GameCubit gameCubit;

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event,
      Set<LogicalKeyboardKey> keysPressed,
      ) {
    final isKeyDown = event is KeyDownEvent;

    final isSpace = keysPressed.contains(LogicalKeyboardKey.space);

    if (isSpace && isKeyDown) {
      world.onSpaceDown();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
}

class FlappyDashWorld extends World
    with TapCallbacks, HasGameRef<FlappyDashGame> {

  late FlappyDashRootComponent _rootComponent;
  @override
  void onLoad() {
    super.onLoad();
    add(
      FlameBlocProvider<GameCubit, GameState>(
        create: () => game.gameCubit,
        children: [
          _rootComponent = FlappyDashRootComponent()
        ],
      ),
    );
  }

  void onSpaceDown() => _rootComponent.onSpaceDown();

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    _rootComponent.onTapDown(event);
  }
}

class FlappyDashRootComponent extends Component
    with HasGameRef<FlappyDashGame>, FlameBlocReader<GameCubit, GameState> {
  late Dash _dash;
  late PipePair _lastPipe;
  static const _pipesDistance = 400.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(DashParallaxBackground());
    add(_dash = Dash());
    _generatePipes(
        fromX: 400
    );
  }

  void _generatePipes({
    int count = 20,
    double fromX = 0.0,
  }) {
    const area = 600;
    for (int i = 0; i < count; i++) {
      final y = (Random().nextDouble() * area) - (area / 2);
      add(_lastPipe = PipePair(
          position: Vector2(fromX + (i * _pipesDistance), y)
      ));
    }
  }

  void _removePipes() {
    final pipes = children.whereType<PipePair>();
    final shouldBeRemoved = max(pipes.length - 5, 0);
    pipes.take(shouldBeRemoved).forEach((pipe) {
      pipe.removeFromParent();
    });
  }

  void onSpaceDown() {
    _checkToStart();
    _dash.jump();
  }

  void onTapDown(TapDownEvent event) {
    _checkToStart();
    _dash.jump();
  }

  void _checkToStart() {
    if (bloc.state.currentPlayingState == PlayingState.none) {
      bloc.startPlaying();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    bloc.state.currentScore.toString();

    if (_dash.x >= _lastPipe.x) {
      _generatePipes(
        fromX: _pipesDistance,
      );
      _removePipes();
    }
  }
}
