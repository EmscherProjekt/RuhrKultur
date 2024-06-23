import 'package:get/get.dart';
import 'package:ruhrkultur/app/controllers/cache_controller.dart';
import 'package:ruhrkultur/app/routes/app_routes.dart';

class AuthenticationController extends GetxController with CacheController {
  final isLogged = false.obs;

  void logOut() {
    isLogged.value = false;
    removeToken();
    goRightPage();
  }

  void login(String? token) async {
    isLogged.value = true;
    //Token is cached
    print(token);
    await saveToken(token);
    goRightPage();
  }
  void goRightPage(){
    if(isLogged.value){
      Get.offAllNamed(AppRoutes.HOME);
    }else{
      Get.offAllNamed(AppRoutes.LOGIN_VIEW);
    }
  
  }
  void checkLoginStatus() {
    final token = getToken();
    if (token != null) {
      isLogged.value = true;
    }
  }
}
