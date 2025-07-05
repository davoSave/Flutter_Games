import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '/game/dino.dart';
import '/game/heart.dart';
import '/game/enemy_manager.dart';
import '/game/audio_manager.dart';
import '/models/player_data.dart';
import '/models/settings.dart';
import '/widgets/hud.dart';
import '/widgets/pause_menu.dart';
import '/widgets/game_over_menu.dart';

class DinoRun extends FlameGame with TapDetector, HasCollisionDetection {
  DinoRun({super.camera});

  static const _imageAssets = [
    'DinoSprites - tard.png',
    'AngryPig/Walk (36x30).png',
    'Bat/Flying (46x30).png',
    'Rino/Run (52x34).png',
    'parallax/plx-1.png',
    'parallax/plx-2.png',
    'parallax/plx-3.png',
    'parallax/plx-4.png',
    'parallax/plx-5.png',
    'parallax/plx-6.png',
    'corazon.png',
  ];

  static const _audioAssets = [
    '8BitPlatformerLoop.wav',
    'hurt7.wav',
    'jump14.wav',
  ];

  Dino? _dino;
  late Settings settings;
  late PlayerData playerData;
  EnemyManager? _enemyManager;
  late Random _random;
  late Sprite heartSprite;
  double _heartSpawnTimer = 0.0;

  Vector2 get virtualSize => camera.viewport.virtualSize;

  @override
  Future<void> onLoad() async {
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();

    playerData = await _readPlayerData();
    settings = await _readSettings();
    await AudioManager.instance.init(_audioAssets, settings);
    AudioManager.instance.startBgm('8BitPlatformerLoop.wav');

    await images.loadAll(_imageAssets);

    heartSprite = Sprite(images.fromCache('corazon.png'));

    camera.viewfinder.position = virtualSize * 0.5;

    final parallaxBackground = await loadParallaxComponent(
      [
        ParallaxImageData('parallax/plx-1.png'),
        ParallaxImageData('parallax/plx-2.png'),
        ParallaxImageData('parallax/plx-3.png'),
        ParallaxImageData('parallax/plx-4.png'),
        ParallaxImageData('parallax/plx-5.png'),
        ParallaxImageData('parallax/plx-6.png'),
      ],
      baseVelocity: Vector2(10, 0),
      velocityMultiplierDelta: Vector2(1.4, 0),
    );

    camera.backdrop.add(parallaxBackground);

    _random = Random();

    reset();
  }

  void startGamePlay() {
    _dino?.removeFromParent();
    _dino = Dino(images.fromCache('DinoSprites - tard.png'), playerData);
    world.add(_dino!);

    _enemyManager?.removeAllEnemies();
    _enemyManager?.removeFromParent();
    _enemyManager = EnemyManager();
    world.add(_enemyManager!);
  }

  void spawnHeart() {
    _heartSpawnTimer += 1 / 60.0;
    if (_heartSpawnTimer > 2.0) {
      _heartSpawnTimer = 0.0;

      if (playerData.lives < 5 && _random.nextDouble() < 0.5) {
        final heartPosition = Vector2(
          virtualSize.x + 24,
          virtualSize.y - 30 - _random.nextDouble() * 50,
        );

        final heart = Heart(position: heartPosition, sprite: heartSprite);

        heart.onCollected = () {
          if (playerData.lives < 5) {
            playerData.lives += 1;
            AudioManager.instance.playSfx('hurt7.wav');
          }
        };

        world.add(heart);
      }
    }
  }

  void reset() {
    _dino?.removeFromParent();
    _enemyManager?.removeAllEnemies();
    _enemyManager?.removeFromParent();

    playerData.currentScore = 0;
    playerData.lives = 5;

    startGamePlay();
  }

  @override
  void update(double dt) {
    super.update(dt);
    spawnHeart();

    if (playerData.lives <= 0) {
      overlays.add(GameOverMenu.id);
      overlays.remove(Hud.id);
      pauseEngine();
      AudioManager.instance.pauseBgm();
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (overlays.isActive(Hud.id)) {
      _dino?.jump();
    }
    super.onTapDown(info);
  }

  Future<PlayerData> _readPlayerData() async {
    final playerDataBox = await Hive.openBox<PlayerData>('DinoRun.PlayerDataBox');
    var playerData = playerDataBox.get('DinoRun.PlayerData');

    if (playerData == null) {
      playerData = PlayerData();
      await playerDataBox.put('DinoRun.PlayerData', playerData);
    }

    return playerData;
  }

  Future<Settings> _readSettings() async {
    final settingsBox = await Hive.openBox<Settings>('DinoRun.SettingsBox');
    var settings = settingsBox.get('DinoRun.Settings');

    if (settings == null) {
      settings = Settings(bgm: true, sfx: true);
      await settingsBox.put('DinoRun.Settings', settings);
    }

    return settings;
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (!(overlays.isActive(PauseMenu.id)) && !(overlays.isActive(GameOverMenu.id))) {
          resumeEngine();
        }
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        if (overlays.isActive(Hud.id)) {
          overlays.remove(Hud.id);
          overlays.add(PauseMenu.id);
        }
        pauseEngine();
        break;
    }
    super.lifecycleStateChange(state);
  }
}
