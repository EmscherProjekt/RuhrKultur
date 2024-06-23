
import 'package:get/get.dart';
import '../controllers/audioguiddeatilpage_controller.dart';


class AudioguiddeatilpageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AudioguiddeatilpageController>(() => AudioguiddeatilpageController());
        // Get.put<AudioguiddeatilpageController>(AudioguiddeatilpageController());
  }
}
