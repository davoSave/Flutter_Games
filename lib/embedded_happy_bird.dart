import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_games/bloc/game/game_cubit.dart';
import 'package:flutter_games/main_page.dart';

class EmbeddedHappyBird extends StatelessWidget {
  const EmbeddedHappyBird({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GameCubit(),
      child: const MainPage(),
    );
  }
}
