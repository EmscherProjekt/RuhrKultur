
import 'package:get/get.dart';
import '../controllers/setting_view_controller.dart';


class SettingViewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingViewController>(() => SettingViewController());
  }
}
