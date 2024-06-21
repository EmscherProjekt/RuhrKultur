
import 'package:get/get.dart';
import '../controllers/ar_exmaple_controller.dart';


class ArExmapleBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArExmapleController>(() => ArExmapleController());
        // Get.put<ArExmapleController>(ArExmapleController());
  }
}