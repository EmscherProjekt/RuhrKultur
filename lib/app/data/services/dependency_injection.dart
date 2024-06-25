import 'package:ruhrkultur/app/controllers/main_controller.dart';
import 'package:ruhrkultur/app/controllers/navigation_controller.dart';
import 'package:ruhrkultur/firebase_options.dart';


import 'package:firebase_core/firebase_core.dart';


import 'package:get/get.dart';

class DependecyInjection {
  static Future<void> init() async {
// firebase init
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    Get.put<NavigationController>(NavigationController());
    Get.put<MainController>(MainController());
  }
}
