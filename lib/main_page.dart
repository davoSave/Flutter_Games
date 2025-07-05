import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_games/bloc/game/game_cubit.dart';

import 'package:flutter_games/happy_bird_game.dart';
import 'package:flutter_games/widget/game_over_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  late FlappyDashGame _flappyDashGame;
  late GameCubit gameCubit;
  PlayingState? _latestState;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    gameCubit = BlocProvider.of<GameCubit>(context);
    _flappyDashGame = FlappyDashGame(gameCubit);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameCubit, GameState>(
      listener: (context, state) {
        if (state.currentPlayingState == PlayingState.none &&
            _latestState == PlayingState.gameOver) {
          setState(() {
            _flappyDashGame = FlappyDashGame(gameCubit);
          });
        }
        _latestState = state.currentPlayingState;
      },
      builder: (context, state) {
        return Scaffold(
            body: Stack(
              children: [
                GameWidget(game: _flappyDashGame),
                if (state.currentPlayingState == PlayingState.gameOver)
                  const GameOverWidget(),
                if (state.currentPlayingState == PlayingState.none)
                  Align(
                    alignment: Alignment(0, 0.2),
                    child: const Text(
                      'PRESS TO START',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        letterSpacing: 2
                      ),
                    ),
                  ).animate(
                    onPlay: (controller) => controller.repeat(
                      reverse: true,
                    ),
                  ).scale(
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.2, 1.2),
                    duration: const Duration(milliseconds: 500),
                  )
              ],
            )
        );
      },
    );
  }
}
