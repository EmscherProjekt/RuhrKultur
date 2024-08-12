import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruhrkultur/app/data/emu/form_type.dart';
import 'package:ruhrkultur/app/ui/layouts/main/widgets/already_have_account_text.dart';
import 'package:ruhrkultur/app/ui/layouts/main/widgets/do_not_have_account.dart';
import 'package:ruhrkultur/app/ui/layouts/main/widgets/login_signup_animated_form.dart';
import 'package:ruhrkultur/app/ui/layouts/main/widgets/progress_indicaror.dart';
import 'package:ruhrkultur/app/ui/layouts/main/widgets/terms_and_conditions_text.dart';
import 'package:ruhrkultur/app/ui/theme/styles.dart';
import 'package:ruhrkultur/app/ui/utils/rive_controller.dart';
import '../../../controllers/login_view_controller.dart';


import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

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
        child: Obx(() {
          // Ensure state updates are not within the build method
          final formType = controller.formType.value;
          return formType == FormType.login
              ? _loginPage(context)
              : _registerPage(context);
        }),
      ),
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
                if (controller.isLoading.value) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ProgressIndicaror.showProgressIndicator(context);
                  });
                }
                return Column(
                  children: [
                    EmailAndPassword(
                      isSignUpPage: true,
                    ),
                    Gap(10.h),
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
