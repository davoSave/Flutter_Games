import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/game/game_cubit.dart';

class GameOverWidget extends StatelessWidget {
  const GameOverWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'GAME OVER!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 38,
              ),
            ),
            SizedBox(height: 18),
            ElevatedButton(
                onPressed: () => context.read<GameCubit>().restartGame(),
                child: Text(
                    'PLAY AGAIN!',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                )
            ),
            IconButton(
              icon: const Icon(Icons.house, size: 30, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
