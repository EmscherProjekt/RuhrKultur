import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruhrkultur/app/controllers/login_view_controller.dart';
import 'package:ruhrkultur/app/data/emu/form_type.dart';
import 'package:ruhrkultur/app/ui/theme/styles.dart';


class DoNotHaveAccountText extends StatelessWidget {
  const DoNotHaveAccountText({super.key});
   LoginViewController get controller => Get.find<LoginViewController>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("DoNotHaveAccountText");
        controller.setFormType(FormType.register);
      },
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an account yet?',
              style: TextStyles.font11DarkBlue400Weight,
            ),
            TextSpan(
              text: ' Sign Up',
              style: TextStyles.font11Blue600Weight,
            ),
          ],
        ),
      ),
    );
  }
}
