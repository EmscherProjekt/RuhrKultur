import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/game_controller.dart';
import 'package:flame/game.dart';
//TODO Weiter machen https://docs.flame-engine.org/latest/tutorials/space_shooter/step_2.html
class GamePage extends GetView<GameController> {
  const GamePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(game: SpaceShooterGame()),
    );
  }
}

class Player extends PositionComponent {
  static final _paint = Paint()..color = const Color(0xFFFFFFFF);

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _paint);
  }
}

class SpaceShooterGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    add(Player()
      ..position = size / 2
      ..width = 50
      ..height = 50
      ..anchor = Anchor.center);
  }
}
