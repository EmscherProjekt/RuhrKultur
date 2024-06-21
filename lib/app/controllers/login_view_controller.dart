import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruhrkultur/app/controllers/authentication_controller.dart';
import 'package:ruhrkultur/app/data/models/login_request_model/login_request_model.dart';
import 'package:ruhrkultur/app/data/models/register_request_model/register_request_model.dart';
import 'package:ruhrkultur/app/data/services/login_service.dart';

class LoginViewController extends GetxController {
  late final LoginService _loginService;
  late final AuthenticationController _authenticationController;
  RxBool isLoading = false.obs;
  @override
  void onInit() {
    isLoading.value = true;
    super.onInit();
    _loginService = Get.put(LoginService());
    _authenticationController = Get.put(AuthenticationController());
    isLoading.value = false;
  }

  Future<void> loginUser(String username, String password) async {
    isLoading.value = true;
    final response = await _loginService
        .fetchLogin(LoginRequestModel(username: username, password: password));

    if (response != null) {
      /// Set isLogin to true
      _authenticationController.login(response.token);
    } else {
      /// Show user a dialog about the error response
      Get.defaultDialog(
          middleText: 'User not found!',
          textConfirm: 'OK',
          confirmTextColor: Colors.white,
          onConfirm: () {
            Get.back();
          });
      isLoading.value = false;
    }
    isLoading.value = false;
  }

  Future<void> registerUser(
      String username, String email, String password) async {
    isLoading.value = true;
    final response = await _loginService
        .fetchRegister(RegisterRequestModel(username: username,email:  email, password: password));
    if (response == null) {
      /// Set isLogin to true
      loginUser(username, password);

    } else {
     

      /// Show user a dialog about the error response
      Get.defaultDialog(
          middleText:"error occured!",
          textConfirm: 'OK',
          confirmTextColor: Colors.white,
          onConfirm: () {
            Get.back();
          });
      isLoading.value = false;
    }
    isLoading.value = false;
  }
}
