import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruhrkultur/app/controllers/authentication_controller.dart';
import '../../../controllers/onboard_view_controller.dart';

class OnboardViewPage extends GetView<OnboardViewController> {
  const OnboardViewPage({Key? key}) : super(key: key);
  void init() async {
    AuthenticationController authController =
        Get.find<AuthenticationController>();
    await authController.checkLoginStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var controller = Get.find<AuthenticationController>();
      controller.checkLoginStatus();
      if (controller.isLogged.value) {
        Get.offNamed('/home');
      }
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }
}
