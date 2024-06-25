import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:ruhrkultur/app/ui/theme/styles.dart';

class TermsAndConditionsText extends StatelessWidget {
  const TermsAndConditionsText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'auth_terms_and_conditions_one'.tr,
            style: TextStyles.font11MediumLightShadeOfGray400Weight,
          ),
          TextSpan(
            text: ' auth_terms_and_conditions_two'.tr,
            style: TextStyles.font11DarkBlue500Weight,
          ),
          TextSpan(
            text: ' auth_terms_and_conditions_three'.tr,
            style: TextStyles.font11MediumLightShadeOfGray400Weight
                .copyWith(height: 4.h),
          ),
          TextSpan(
            text: ' auth_terms_and_conditions_four'.tr,
            style: TextStyles.font11DarkBlue500Weight,
          ),
        ],
      ),
    );
  }
}
