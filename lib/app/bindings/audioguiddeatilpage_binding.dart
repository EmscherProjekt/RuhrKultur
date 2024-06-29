import 'package:get/get.dart';
import 'package:ruhrkultur/app/controllers/audioguid_controller.dart';
import '../controllers/audioguiddeatilpage_controller.dart';

class AudioguiddeatilpageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AudioController>(() => AudioController());

    Get.lazyPut<AudioguiddeatilpageController>(
        () => AudioguiddeatilpageController());
    // Get.put<AudioguiddeatilpageController>(AudioguiddeatilpageController());
  }
}
