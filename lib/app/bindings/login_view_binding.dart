import 'package:get/get.dart';
import '../controllers/login_view_controller.dart';

class LoginViewBinding implements Bindings {
  @override
  void dependencies() {
     Get.put<LoginViewController>(LoginViewController());
  }
}
