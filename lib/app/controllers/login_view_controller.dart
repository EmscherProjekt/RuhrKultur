import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruhrkultur/app/controllers/authentication_controller.dart';
import 'package:ruhrkultur/app/data/emu/form_type.dart';
import 'package:ruhrkultur/app/data/models/login_request_model/login_request_model.dart';
import 'package:ruhrkultur/app/data/models/register_request_model/register_request_model.dart';
import 'package:ruhrkultur/app/data/services/login_service.dart';
import 'package:ruhrkultur/app/routes/app_routes.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class LoginViewController extends GetxController {
  late final LoginService _loginService;
  late final AuthenticationController _authenticationController;
  RxBool isLoading = false.obs;

  Rx<FormType> formType = FormType.login.obs;

  @override
  void onInit() {
    super.onInit();
    _loginService = Get.put(LoginService());
    _authenticationController = Get.put(AuthenticationController());
  }

  Future<void> setFormType(FormType type) async {
    formType.value = type;
  }

  Future<void> loginUser(String email, String password) async {
    isLoading.value = true;
    final response = await _loginService
        .fetchLogin(LoginRequestModel(email: email, password: password));
    isLoading.value = false;

    if (response != null) {
      _authenticationController.login(response.token);
    } else {
      Future.delayed(Duration.zero, () {
        Get.defaultDialog(
          middleText: 'User not found!',
          textConfirm: 'OK',
          confirmTextColor: Colors.white,
          onConfirm: () {
            Get.back();
          },
        );
      });
    }
  }

  Future<void> registerUser(String firstName, String lastName, String username,
      String email, String password) async {
    isLoading.value = true;
    print(
        'First Name: $firstName Last Name: $lastName Username: $username Email: $email Password: $password');
    final response = await _loginService.fetchRegister(RegisterRequestModel(
        firstName: firstName,
        lastName: lastName,
        username: username,
        email: email,
        password: password));
    isLoading.value = false;

    if (response?.message == null) {
      Future.delayed(Duration.zero, () {
        AwesomeDialog(
          context: Get.context!,
          animType: AnimType.scale,
          dialogType: DialogType.error,
          title: 'Error',
          desc: response?.error,
          btnOkOnPress: () {
            Get.back();
          },
        ).show();
      });
    }
    if (response?.message != null) {
      Future.delayed(Duration.zero, () {
        AwesomeDialog(
          context: Get.context!,
          animType: AnimType.scale,
          dialogType: DialogType.success,
          title: 'Success',
          desc: response?.message,
          btnOkOnPress: () {
            Get.back();
          },
        ).show();
      });
    }
  }
}
