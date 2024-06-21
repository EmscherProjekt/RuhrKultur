import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:ruhrkultur/app/data/models/login_request_model/login_request_model.dart';
import 'package:ruhrkultur/app/data/services/login_service.dart';
import '../../../controllers/login_view_controller.dart';

class LoginViewPage extends GetView<LoginViewController> {
  LoginViewPage({Key? key}) : super(key: key);
  final GlobalKey<FormState> formKey = GlobalKey();
  LoginViewController get controller => Get.find<LoginViewController>();
  final TextEditingController emailCtr = TextEditingController();
  final TextEditingController passwordCtr = TextEditingController();
  final TextEditingController usernameCtr = TextEditingController();
  Rx<FormType> formType = FormType.login.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Obx(() => formType.value == FormType.login
          ? loginForm(context)
          : registerForm(context)),
    ));
  }

  Widget loginForm(BuildContext context) {
    return Obx(
      () {
        return LoadingOverlayPro(
          isLoading: controller.isLoading.value,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: ListView(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                ),
                Container(
                  height: 170.0,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset('assets/image/logo_login.png'),
                ),
                SizedBox(height: 10.0),
                Center(
                  child: Text(
                    'Log into your account',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w300,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailCtr,
                        validator: (value) {
                          return (value == null || value.isEmpty)
                              ? 'Please Enter Email'
                              : null;
                        },
                        decoration: inputDecoration('E-mail', Icons.person),
                      ),
                      SizedBox(height: 15.0),
                      TextFormField(
                        validator: (value) {
                          return (value == null || value.isEmpty)
                              ? 'Please Enter Password'
                              : null;
                        },
                        controller: passwordCtr,
                        decoration: inputDecoration('Password', Icons.lock),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.0),
                ElevatedButton(
                  onPressed: () {
                    LoginService().fetchLogin(
                        LoginRequestModel(
                            username: emailCtr.text, password: passwordCtr.text));
                  },
                  child: Text('Login'),
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account?'),
                    SizedBox(width: 5.0),
                    GestureDetector(
                      onTap: () {
                        formType.value = FormType.register;
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget registerForm(
    BuildContext context,
  ) {
    return Obx(
      () {
        return LoadingOverlayPro(
          isLoading: controller.isLoading.value,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: ListView(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                ),
                Container(
                  height: 170.0,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset('assets/image/logo_login.png'),
                ),
                SizedBox(height: 10.0),
                Center(
                  child: Text(
                    'Create your account',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w300,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: usernameCtr,
                        validator: (value) {
                          return (value == null || value.isEmpty)
                              ? 'Please Enter Username'
                              : null;
                        },
                        decoration: inputDecoration('Username', Icons.person),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: emailCtr,
                        validator: (value) {
                          return (value == null || value.isEmpty)
                              ? 'Please Enter Email'
                              : null;
                        },
                        decoration: inputDecoration('E-mail', Icons.email),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        validator: (value) {
                          return (value == null || value.isEmpty)
                              ? 'Please Enter Password'
                              : null;
                        },
                        controller: passwordCtr,
                        decoration: inputDecoration('Password', Icons.lock),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        validator: (value) {
                          return (value == null ||
                                  value.isEmpty ||
                                  value != passwordCtr.text)
                              ? 'Passwords does not match'
                              : null;
                        },
                        decoration:
                            inputDecoration('Retype Password', Icons.lock),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.0),
                ElevatedButton(
                  onPressed: () {
                    controller.registerUser(
                        usernameCtr.text, emailCtr.text, passwordCtr.text);
                  },
                  child: Text('Register'),
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?'),
                    SizedBox(width: 5.0),
                    GestureDetector(
                      onTap: () {
                        formType.value = FormType.login;
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  InputDecoration inputDecoration(String labelText, IconData iconData,
      {String? prefix, String? helperText}) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      helperText: helperText,
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.grey),
      fillColor: Colors.grey.shade200,
      filled: true,
      prefixText: prefix,
      prefixIcon: Icon(
        iconData,
        size: 20,
      ),
      prefixIconConstraints: BoxConstraints(minWidth: 60),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.black)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.black)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.black)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.black)),
    );
  }
}

enum FormType { login, register }
