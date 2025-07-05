import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/game/game_cubit.dart';

class FlappyHud extends StatelessWidget {
  const FlappyHud({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocBuilder<GameCubit, GameState>(
              builder: (context, state) {
                return Text(
                  'Score: ${state.currentScore}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(blurRadius: 4, color: Colors.black, offset: Offset(2, 2))
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
