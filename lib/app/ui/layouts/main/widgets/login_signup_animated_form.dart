import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:ruhrkultur/app/controllers/login_view_controller.dart';
import 'package:ruhrkultur/app/routes/app_routes.dart';
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
    super.key,
    this.isSignUpPage,
    this.isPasswordPage,
  });

  @override
  State<EmailAndPassword> createState() => _EmailAndPasswordState();
}

class _EmailAndPasswordState extends State<EmailAndPassword> {
  bool isObscureText = true;
  bool hasMinLength = false;

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
          nameField(),
          emailField(),
          passwordField(),
          SizedBox(height: 18.h),
          passwordConfirmationField(),
          forgetPasswordTextButton(),
          SizedBox(height: 10.h),
          PasswordValidations(
            hasMinLength: hasMinLength,
          ),
          SizedBox(height: 18.h),
          loginOrSignUpOrPasswordButton(context, controller),
        ],
      ),
    );
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

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    passwordFocuseNode.dispose();
    passwordConfirmationFocuseNode.dispose();
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
                return 'Please enter an email address';
              }
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
            'forget password?',
            style: TextStyles.font14Blue400Weight,
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  void initState() {
    super.initState();
    riveHelper.loadRiveFile('assets/animation/headless_bear.riv').then((_) {
      setState(() {});
    });
    setupPasswordControllerListener();
    checkForPasswordFocused();
    checkForPasswordConfirmationFocused();
  }

  AppTextButton loginButton(
      BuildContext context, LoginViewController controller) {
    return AppTextButton(
      buttonText: "Login",
      textStyle: TextStyles.font16White600Weight,
      onPressed: () async {
        passwordFocuseNode.unfocus();
        if (formKey.currentState!.validate()) {
          controller.loginUser(emailController.text, passwordController.text);
          Get.toNamed(AppRoutes.SPLASH_VIEW);
        }
      },
    );
  }

  loginOrSignUpOrPasswordButton(
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
  }

  Widget nameField() {
    if (widget.isSignUpPage == true) {
      return Column(
        children: [
          AppTextFormField(
            hint: 'Name',
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
              nameController.text = name;
              if (name.isEmpty) {
                riveHelper.addFailController();
                return 'Please enter a valid name';
              }
            },
            controller: nameController,
          ),
          SizedBox(height: 18.h)
        ],
      );
    }
    return const SizedBox.shrink();
  }

  AppTextButton passwordButton(
      BuildContext context, LoginViewController controller) {
    return AppTextButton(
      buttonText: "Create Password",
      textStyle: TextStyles.font16White600Weight,
      onPressed: () async {
        passwordFocuseNode.unfocus();
        passwordConfirmationFocuseNode.unfocus();
        if (formKey.currentState!.validate()) {
          controller.registerUser(
            nameController.text,
            emailController.text,
            passwordController.text,
          );
        }
      },
    );
  }

  Widget passwordConfirmationField() {
    if (widget.isSignUpPage == true || widget.isPasswordPage == true) {
      return AppTextFormField(
        focusNode: passwordConfirmationFocuseNode,
        controller: passwordConfirmationController,
        hint: 'Password Confirmation',
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
            return 'Enter a matched passwords';
          }
          if (value == null ||
              value.isEmpty ||
              !AppRegex.isPasswordValid(value)) {
            riveHelper.addFailController();
            return 'Please enter a valid password';
          }
        },
      );
    }
    return const SizedBox.shrink();
  }

  AppTextFormField passwordField() {
    return AppTextFormField(
      focusNode: passwordFocuseNode,
      controller: passwordController,
      hint: 'Password',
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
          return 'Please enter a valid password';
        }
      },
    );
  }

  void setupPasswordControllerListener() {
    passwordController.addListener(() {
      setState(() {
        hasMinLength = AppRegex.isPasswordValid(passwordController.text);
      });
    });
  }

  AppTextButton signUpButton(
      BuildContext context, LoginViewController controller) {
    return AppTextButton(
      buttonText: "Create Account",
      textStyle: TextStyles.font16White600Weight,
      onPressed: () async {
        passwordFocuseNode.unfocus();
        passwordConfirmationFocuseNode.unfocus();
        if (formKey.currentState!.validate()) {
          controller.registerUser(
            nameController.text,
            emailController.text,
            passwordController.text,
          );
          Get.toNamed(AppRoutes.SPLASH_VIEW);
        }
      },
    );
  }
}
