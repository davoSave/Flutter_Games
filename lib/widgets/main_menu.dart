import 'dart:ui';

import 'package:flutter/material.dart';

import '/widgets/hud.dart';
import '/game/dino_run.dart';
import '/widgets/settings_menu.dart';

class MainMenu extends StatelessWidget {
  static const id = 'MainMenu';

  final DinoRun game;

  const MainMenu(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.black.withAlpha(100),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 100,
              ),
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: [
                  const Text(
                    'Dino Run',
                    style: TextStyle(fontSize: 50, color: Colors.white),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      game.startGamePlay();
                      game.overlays.remove(MainMenu.id);
                      game.overlays.add(Hud.id);
                    },
                    child: const Text('Play', style: TextStyle(fontSize: 30)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      game.overlays.remove(MainMenu.id);
                      game.overlays.add(SettingsMenu.id);
                    },
                    child: const Text(
                      'Settings',
                      style: TextStyle(fontSize: 30),
                    ),
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
          ),
        ),
      ),
    );
  }
}
