import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruhrkultur/app/controllers/authentication_controller.dart';
import 'package:ruhrkultur/app/routes/app_routes.dart';


import '../../../controllers/onboard_view_controller.dart';

class OnboardViewPage extends GetView<OnboardViewController> {
  const OnboardViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthenticationController authController = Get.find<AuthenticationController>();

    // Using a Future.delayed to give time for the UI to build before navigating
    Future.delayed(Duration.zero, () {
      if (authController.isLogged.value) {
        Get.offAllNamed(AppRoutes.HOME); // Replace the current route
      } else {
        Get.offAllNamed(AppRoutes.LOGIN_VIEW); // Replace the current route
      }
    });

    return Center(
      child: CircularProgressIndicator(), // You can show a loading indicator while navigating
    );
  }
}
