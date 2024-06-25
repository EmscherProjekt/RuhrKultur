import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:ruhrkultur/app/controllers/login_view_controller.dart';
//Stehen lassen sonst ist bär nicht da
// ignore: unused_import
import 'package:flutter_svg/flutter_svg.dart';

import 'package:ruhrkultur/app/ui/theme/styles.dart';
import 'package:ruhrkultur/app/ui/utils/app_regex.dart';
import 'package:ruhrkultur/app/ui/utils/rive_controller.dart';

import 'app_text_button.dart';
import 'app_text_form_field.dart';
import 'password_validations.dart';

// ignore: must_be_immutable
class EmailAndPassword extends StatefulWidget {
  final bool? isSignUpPage;
  final bool? isPasswordPage;

  EmailAndPassword({
    Key? key,
    this.isSignUpPage,
    this.isPasswordPage,
  }) : super(key: key);

  @override
  State<EmailAndPassword> createState() => _EmailAndPasswordState();
}

class _EmailAndPasswordState extends State<EmailAndPassword> {
  bool isObscureText = true;
  bool hasMinLength = false;
  final TextEditingController firstNameCtr = TextEditingController();
  final TextEditingController lastNameCtr = TextEditingController();
  final TextEditingController usernameCtr = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();

  final formKey = GlobalKey<FormState>();

  final RiveAnimationControllerHelper riveHelper =
      RiveAnimationControllerHelper();

  final passwordFocuseNode = FocusNode();
  final passwordConfirmationFocuseNode = FocusNode();

  @override
  void initState() {
    super.initState();
    riveHelper.loadRiveFile('assets/animation/headless_bear.riv').then((_) {
      setState(() {}); // Ensure the state is updated once the file is loaded
    });
    setupPasswordControllerListener();
    checkForPasswordFocused();
    checkForPasswordConfirmationFocused();
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    passwordFocuseNode.dispose();
    passwordConfirmationFocuseNode.dispose();
    super.dispose();
  }

  void checkForPasswordConfirmationFocused() {
    passwordConfirmationFocuseNode.addListener(() {
      if (passwordConfirmationFocuseNode.hasFocus && isObscureText) {
        riveHelper.addHandsUpController();
      } else if (!passwordConfirmationFocuseNode.hasFocus && isObscureText) {
        riveHelper.addHandsDownController();
      }
    });
  }

  void checkForPasswordFocused() {
    passwordFocuseNode.addListener(() {
      if (passwordFocuseNode.hasFocus && isObscureText) {
        riveHelper.addHandsUpController();
      } else if (!passwordFocuseNode.hasFocus && isObscureText) {
        riveHelper.addHandsDownController();
      }
    });
  }

  void setupPasswordControllerListener() {
    passwordController.addListener(() {
      setState(() {
        hasMinLength = AppRegex.isPasswordValid(passwordController.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final LoginViewController controller = Get.find();
    return Form(
      key: formKey,
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 5,
            child: riveHelper.riveArtboard != null
                ? Rive(
                    fit: BoxFit.cover,
                    artboard: riveHelper.riveArtboard!,
                  )
                : const SizedBox.shrink(),
          ),
          if (widget.isSignUpPage == true) nameField(),
          emailField(),
          passwordField(),
          SizedBox(height: 18.h),
          if (widget.isSignUpPage == true || widget.isPasswordPage == true)
            passwordConfirmationField(),
          forgetPasswordTextButton(),
          SizedBox(height: 10.h),
          PasswordValidations(hasMinLength: hasMinLength),
          SizedBox(height: 18.h),
          Obx(() {
            return controller.isLoading.value
                ? CircularProgressIndicator()
                : loginOrSignUpOrPasswordButton(context, controller);
          }),
        ],
      ),
    );
  }

  Widget emailField() {
    if (widget.isPasswordPage == null) {
      return Column(
        children: [
          AppTextFormField(
            hint: 'Email',
            onChanged: (value) {
              if (value.isNotEmpty &&
                  value.length <= 13 &&
                  !riveHelper.isLookingLeft) {
                riveHelper.addDownLeftController();
              } else if (value.isNotEmpty &&
                  value.length > 13 &&
                  !riveHelper.isLookingRight) {
                riveHelper.addDownRightController();
              } else if (value.isEmpty) {
                riveHelper.addDownLeftController();
              }
            },
            validator: (value) {
              String email = (value ?? '').trim();
              emailController.text = email;
              if (email.isEmpty) {
                riveHelper.addFailController();
                return 'auth_email_error'.tr;
              }
              return null; // Return null if no error
            },
            controller: emailController,
          ),
          SizedBox(height: 18.h)
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget forgetPasswordTextButton() {
    if (widget.isSignUpPage == null && widget.isPasswordPage == null) {
      return TextButton(
        onPressed: () {
          // Get.toNamed(Routes.forgotPassword);
        },
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            'auth_forgot_password'.tr,
            style: TextStyles.font14Blue400Weight,
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  AppTextButton loginButton(
      BuildContext context, LoginViewController controller) {
    return AppTextButton(
      buttonText: "auth_login".tr,
      textStyle: TextStyles.font16White600Weight,
      onPressed: () async {
        passwordFocuseNode.unfocus();
        if (formKey.currentState!.validate()) {
          await controller.loginUser(
              emailController.text, passwordController.text);
        }
      },
    );
  }

  AppTextButton passwordButton(
      BuildContext context, LoginViewController controller) {
    return AppTextButton(
      buttonText: "auth_create_password".tr,
      textStyle: TextStyles.font16White600Weight,
      onPressed: () async {
        passwordFocuseNode.unfocus();
        passwordConfirmationFocuseNode.unfocus();
        if (formKey.currentState!.validate()) {
          await controller.registerUser(
            firstNameCtr.text,
            lastNameCtr.text,
            usernameCtr.text,
            emailController.text,
            passwordController.text,
          );
        }
      },
    );
  }

  AppTextButton signUpButton(
      BuildContext context, LoginViewController controller) {
    return AppTextButton(
      buttonText: "auth_regster_titel".tr,
      textStyle: TextStyles.font16White600Weight,
      onPressed: () async {
        passwordFocuseNode.unfocus();
        passwordConfirmationFocuseNode.unfocus();
        if (formKey.currentState!.validate()) {
          await controller.registerUser(
            firstNameCtr.text,
            lastNameCtr.text,
            usernameCtr.text,
            emailController.text,
            passwordController.text,
          );
        }
      },
    );
  }

  Widget loginOrSignUpOrPasswordButton(
      BuildContext context, LoginViewController controller) {
    if (widget.isSignUpPage == true) {
      return signUpButton(context, controller);
    }
    if (widget.isSignUpPage == null && widget.isPasswordPage == null) {
      return loginButton(context, controller);
    }
    if (widget.isPasswordPage == true) {
      return passwordButton(context, controller);
    }
    return SizedBox.shrink(); 
  }

  Widget nameField() {
    if (widget.isSignUpPage == true) {
      return Column(
        children: [
          AppTextFormField(
            hint: 'auth_regster_firstName'.tr,
            onChanged: (value) {
              if (value.isNotEmpty &&
                  value.length <= 13 &&
                  riveHelper.isLookingLeft) {
                riveHelper.addDownLeftController();
              } else if (value.isNotEmpty &&
                  value.length > 13 &&
                  riveHelper.isLookingRight) {
                riveHelper.addDownRightController();
              }
            },
            validator: (value) {
              String name = (value ?? '').trim();
              firstNameCtr.text = name;
              if (name.isEmpty) {
                riveHelper.addFailController();
                return 'auth_regster_firstName_error'.tr;
              }
              return null; // Return null if no error
            },
            controller: firstNameCtr,
          ),
          SizedBox(height: 18.h),
          AppTextFormField(
            hint: 'auth_regster_lastName'.tr,
            onChanged: (value) {
              if (value.isNotEmpty &&
                  value.length <= 13 &&
                  riveHelper.isLookingLeft) {
                riveHelper.addDownLeftController();
              } else if (value.isNotEmpty &&
                  value.length > 13 &&
                  riveHelper.isLookingRight) {
                riveHelper.addDownRightController();
              }
            },
            validator: (value) {
              String name = (value ?? '').trim();
              lastNameCtr.text = name;
              if (name.isEmpty) {
                riveHelper.addFailController();
                return 'auth_regster_lastName_error'.tr;
              }
              return null; // Return null if no error
            },
            controller: lastNameCtr,
          ),
          SizedBox(height: 18.h),
          AppTextFormField(
            hint: 'auth_regster_username'.tr,
            onChanged: (value) {
              if (value.isNotEmpty &&
                  value.length <= 13 &&
                  riveHelper.isLookingLeft) {
                riveHelper.addDownLeftController();
              } else if (value.isNotEmpty &&
                  value.length > 13 &&
                  riveHelper.isLookingRight) {
                riveHelper.addDownRightController();
              }
            },
            validator: (value) {
              String name = (value ?? '').trim();
              usernameCtr.text = name;
              if (name.isEmpty) {
                riveHelper.addFailController();
                return 'auth_regster_username_erro'.tr;
              }
              return null; // Return null if no error
            },
            controller: usernameCtr,
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget passwordConfirmationField() {
    if (widget.isSignUpPage == true || widget.isPasswordPage == true) {
      return AppTextFormField(
        focusNode: passwordConfirmationFocuseNode,
        controller: passwordConfirmationController,
        hint: 'auth_regster_password_retype'.tr,
        isObscureText: isObscureText,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              if (isObscureText) {
                isObscureText = false;
                riveHelper.addHandsDownController();
              } else {
                riveHelper.addHandsUpController();
                isObscureText = true;
              }
            });
          },
          child: Icon(
            isObscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
        ),
        validator: (value) {
          if (value != passwordController.text) {
            riveHelper.addFailController();
            return 'auth_regster_password_retype_error_not_match'.tr;
          }
          if (value == null ||
              value.isEmpty ||
              !AppRegex.isPasswordValid(value)) {
            riveHelper.addFailController();
            return 'auth_regster_password_retype_error'.tr;
          }
          return null; // Return null if no error
        },
      );
    }
    return const SizedBox.shrink();
  }

  AppTextFormField passwordField() {
    return AppTextFormField(
      focusNode: passwordFocuseNode,
      controller: passwordController,
      hint: 'auth_regster_password'.tr,
      isObscureText: isObscureText,
      suffixIcon: GestureDetector(
        onTap: () {
          setState(() {
            if (isObscureText) {
              isObscureText = false;
              riveHelper.addHandsDownController();
            } else {
              riveHelper.addHandsUpController();
              isObscureText = true;
            }
          });
        },
        child: Icon(
          isObscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
        ),
      ),
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            !AppRegex.isPasswordValid(value)) {
          riveHelper.addFailController();
          return 'auth_regster_password_error'.tr;
        }
        return null; // Return null if no error
      },
    );
  }
}
