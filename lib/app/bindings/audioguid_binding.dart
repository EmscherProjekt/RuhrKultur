
import 'package:get/get.dart';
import 'package:ruhrkultur/app/controllers/audioguid_controller.dart';

class AudioguidBinding implements Bindings {
  @override
  void dependencies() {
        Get.lazyPut<AudioController>(() => AudioController());

   // Get.lazyPut<AudioGuideController>(() => AudioGuideController());
        // Get.put<AudioguidController>(AudioguidController());
  }
}
