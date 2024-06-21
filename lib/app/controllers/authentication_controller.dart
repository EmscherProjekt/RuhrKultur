import 'package:get/get.dart';
import 'package:ruhrkultur/app/controllers/cache_controller.dart';

class AuthenticationController extends GetxController with CacheController {
  final isLogged = false.obs;

  void logOut() {
    isLogged.value = false;
    removeToken();
  }

  void login(String? token) async {
    isLogged.value = true;
    //Token is cached
    print(token);
    await saveToken(token);
    checkLoginStatus();
  }

  void checkLoginStatus() {
    final token = getToken();
    if (token != null) {
      isLogged.value = true;
    }
  }
}
