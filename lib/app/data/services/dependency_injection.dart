import 'package:ruhrkultur/app/controllers/main_controller.dart';
import 'package:ruhrkultur/app/controllers/navigation_controller.dart';

import 'package:get/get.dart';

class DependecyInjection {
  static Future<void> init() async {
    Get.put<NavigationController>(NavigationController());
    Get.put<MainController>(MainController());
  }
}
