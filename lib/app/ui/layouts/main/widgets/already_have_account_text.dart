import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruhrkultur/app/controllers/login_view_controller.dart';
import 'package:ruhrkultur/app/data/emu/form_type.dart';
import 'package:ruhrkultur/app/ui/theme/styles.dart';

class AlreadyHaveAccountText extends StatelessWidget {
  const AlreadyHaveAccountText({super.key});
  LoginViewController get controller => Get.find<LoginViewController>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.setFormType(FormType.login);
      },
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Already have an account?',
              style: TextStyles.font11DarkBlue400Weight,
            ),
            TextSpan(
              text: ' Login',
              style: TextStyles.font11Blue600Weight,
            ),
          ],
        ),
      ),
    );
  }
}
