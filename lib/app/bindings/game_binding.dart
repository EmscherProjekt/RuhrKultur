
import 'package:get/get.dart';
import '../controllers/game_controller.dart';


class GameBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GameController>(() => GameController());
        // Get.put<GameController>(GameController());
  }
}
