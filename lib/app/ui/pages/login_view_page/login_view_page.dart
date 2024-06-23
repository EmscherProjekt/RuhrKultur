import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:ruhrkultur/app/data/emu/form_type.dart';
import 'package:ruhrkultur/app/routes/app_routes.dart';
import 'package:ruhrkultur/app/ui/layouts/main/widgets/already_have_account_text.dart';
import 'package:ruhrkultur/app/ui/layouts/main/widgets/do_not_have_account.dart';
import 'package:ruhrkultur/app/ui/layouts/main/widgets/login_signup_animated_form.dart';
import 'package:ruhrkultur/app/ui/layouts/main/widgets/progress_indicaror.dart';
import 'package:ruhrkultur/app/ui/layouts/main/widgets/sign_in_with_google_text.dart';
import 'package:ruhrkultur/app/ui/layouts/main/widgets/terms_and_conditions_text.dart';
import 'package:ruhrkultur/app/ui/theme/styles.dart';
import 'package:ruhrkultur/app/ui/utils/rive_controller.dart';
import '../../../controllers/login_view_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

// ignore: must_be_immutable
class LoginViewPage extends GetView<LoginViewController> {
  LoginViewPage({Key? key}) : super(key: key);
  final GlobalKey<FormState> formKey = GlobalKey();
  LoginViewController get controller => Get.find<LoginViewController>();
  final TextEditingController firstNameCtr = TextEditingController();
  final TextEditingController lastNameCtr = TextEditingController();
  final TextEditingController emailCtr = TextEditingController();
  final TextEditingController passwordCtr = TextEditingController();
  final TextEditingController usernameCtr = TextEditingController();

  final RiveAnimationControllerHelper riveHelper =
      RiveAnimationControllerHelper();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Obx(() => controller.formType == FormType.login
            ? _loginPage(context)
            : _registerPage(context)),
      ),
    );
  }

  Widget loginForm(BuildContext context) {
    return Obx(
      () {
        return LoadingOverlayPro(
          isLoading: controller.isLoading.value,
          child: ListView(
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
                  controller.loginUser(emailCtr.text, passwordCtr.text);
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
                      controller.setFormType(FormType.register);
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
        );
      },
    );
  }

  Widget registerForm(BuildContext context) {
    return Obx(
      () {
        return LoadingOverlayPro(
          isLoading: controller.isLoading.value,
          child: ListView(
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
                  controller.registerUser(firstNameCtr.text, lastNameCtr.text,
                      usernameCtr.text, emailCtr.text, passwordCtr.text);
                  Get.toNamed(AppRoutes.SPLASH_VIEW);
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
                      controller.setFormType(FormType.login);
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

  SafeArea _loginPage(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(left: 30, right: 30, bottom: 15, top: 5),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Login To Continue Using The App",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              EmailAndPassword(),
              const SizedBox(height: 5),
              const SigninWithGoogleText(),
              const SizedBox(height: 5),
              InkWell(
                radius: 50,
                onTap: () {
                  //TODO Immplent google
                },
                child: SvgPicture.asset(
                  'assets/svg/google_logo.svg',
                  width: 40,
                  height: 40,
                ),
              ),
              const TermsAndConditionsText(),
              const SizedBox(height: 5),
              const DoNotHaveAccountText(),
            ],
          ),
        ),
      ),
    );
  }

  SafeArea _registerPage(BuildContext context) {
    final LoginViewController controller = Get.put(LoginViewController());

    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.only(left: 30.w, right: 30.w, bottom: 15.h, top: 5.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Account',
                style: TextStyles.font24Blue700Weight,
              ),
              Gap(8.h),
              Text(
                'Sign up now and start exploring all that our\napp has to offer. We\'re excited to welcome\nyou to our community!',
                style: TextStyles.font14Grey400Weight,
              ),
              Gap(8.h),
              Obx(() {
                return Column(
                  children: [
                    if (controller.isLoading.value)
                      ProgressIndicaror.showProgressIndicator(context),
                    EmailAndPassword(
                      isSignUpPage: true,
                    ),
                    Gap(10.h),
                 //TODO:   const SigninWithGoogleText(),
                    Gap(5.h),
                 /*   InkWell(
                      onTap: () {
                        //TODO Implement google
                      },
                      child: SvgPicture.asset(
                        'assets/svg/google_logo.svg',
                        width: 40.w,
                        height: 40.h,
                      ),
                    ), */
                     const TermsAndConditionsText(),
                    Gap(15.h),
                    const AlreadyHaveAccountText(),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}


