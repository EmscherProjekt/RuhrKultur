
import 'package:get/get.dart';
import '../controllers/navpage_controller.dart';


class NavpageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavpageController>(() => NavpageController());
        // Get.put<NavpageController>(NavpageController());
  }
}
