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
    // Add your initialization logic here
    await Future.delayed(Duration(seconds: 2)); // Simulating some async work
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
            return OnboardViewPageWrapper();
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

class OnboardViewPageWrapper extends StatefulWidget {
  @override
  _OnboardViewPageWrapperState createState() => _OnboardViewPageWrapperState();
}

class _OnboardViewPageWrapperState extends State<OnboardViewPageWrapper> {
  @override
  void initState() {
    super.initState();
    // Schedule any state changes after the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Perform state changes here
    });
  }

  @override
  Widget build(BuildContext context) {
    return OnboardViewPage();
  }
}
