import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruhrkultur/app/controllers/authentication_controller.dart';
import 'package:ruhrkultur/app/ui/pages/onboard_view_page/onboard_view_page.dart';


import '../../../controllers/splash_view_controller.dart';

class SplashViewPage extends GetView<SplashViewController> {
  SplashViewPage({Key? key}) : super(key: key);
  final AuthenticationController authController =
      Get.put(AuthenticationController());

  Future<void> initSettings() async {
    authController.checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return waitingView();
        } else {
          if (snapshot.hasError)
            return errorView(snapshot);
          else
            return OnboardViewPage();
        }
      },
    );
  }

  Scaffold errorView(AsyncSnapshot<Object?> snapshot) {
    return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
  }

  Scaffold waitingView() {
    return Scaffold(
        body: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ),
          Text('Loading...'),
        ],
      ),
    ));
  }
}
