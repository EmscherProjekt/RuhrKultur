import 'package:get/get.dart';
import 'package:ruhrkultur/app/controllers/cache_controller.dart';

class AuthenticationController extends GetxController with CacheController {
  final isLogged = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  void logOut() {
    isLogged.value = false;
    removeToken();
  }

  void login(String? token) async {
    isLogged.value = true;
    // Token wird zwischengespeichert
    print(token);
    await saveToken(token);
  }

  void checkLoginStatus() {
    final token = getToken();
    if (token != null) {
      print("Token: $token");
      isLogged.value = true;
    } else {
      print("Token: $token");
      isLogged.value = false;
    }
  }
}
