import 'package:flutter/material.dart';
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
          'or Sign in with',
          style: TextStyles.font13Grey400Weight,
        ),
      ],
    );
  }
}
