
import 'package:get/get.dart';
import '../controllers/onboard_view_controller.dart';


class OnboardViewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardViewController>(() => OnboardViewController());
  }
}
