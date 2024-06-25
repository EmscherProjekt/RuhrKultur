
import 'package:get/get.dart';
import '../controllers/funktion_aktivert_controller.dart';


class FunktionAktivertBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FunktionAktivertController>(() => FunktionAktivertController());
        // Get.put<FunktionAktivertController>(FunktionAktivertController());
  }
}