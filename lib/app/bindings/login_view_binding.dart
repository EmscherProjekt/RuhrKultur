import 'package:get/get.dart';
import '../controllers/login_view_controller.dart';

class LoginViewBinding implements Bindings {
  @override
  void dependencies() {
    //Get.lazyPut<LoginViewController>(() => LoginViewController());

     Get.put<LoginViewController>(LoginViewController());
  }
}
