import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/src/widgets/framework.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameState());

  startPlaying() {
    emit(state.copyWith(
      currentPlayingState: PlayingState.playing,
      currentScore: 0,
    ));
  }

  void increaseScore() {
    emit(state.copyWith(
      currentScore: state.currentScore + 1,
    ));
  }

  void gameOver() {
    emit(state.copyWith(
      currentPlayingState: PlayingState.gameOver,
    ));
  }

  restartGame() {
    emit(state.copyWith(
      currentPlayingState: PlayingState.none,
      currentScore: 0,
    ));
  }
}
