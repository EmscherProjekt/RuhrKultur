import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruhrkultur/app/controllers/authentication_controller.dart';
import '../../../controllers/onboard_view_controller.dart';

class OnboardViewPage extends GetView<OnboardViewController> {
  const OnboardViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure that navigation happens after the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AuthenticationController authController = Get.find<AuthenticationController>();
      authController.goRightPage();
    });

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Show a loading indicator while navigating
      ),
    );
  }
}
