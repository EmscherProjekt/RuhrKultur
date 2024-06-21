
import 'package:get/get.dart';
import '../controllers/splash_view_controller.dart';


class SplashViewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashViewController>(() => SplashViewController());
        // Get.put<SplashViewController>(SplashViewController());
  }
}