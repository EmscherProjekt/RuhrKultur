import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruhrkultur/app/ui/theme/styles.dart';

class SigninWithGoogleText extends StatelessWidget {
  const SigninWithGoogleText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          'auth_sign_in_with'.tr,
          style: TextStyles.font13Grey400Weight,
        ),
      ],
    );
  }
}
