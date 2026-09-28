import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:auth_ui_app/utils/constants/colors.dart';
import 'package:auth_ui_app/utils/constants/sizes.dart';
import 'package:auth_ui_app/utils/constants/text_strings.dart';
import 'package:auth_ui_app/utils/device/device_utility.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';
import 'package:auth_ui_app/features/authentication/controllers/signup_controller.dart';

class TTermsAndConditionCheckbox extends StatelessWidget {
  const TTermsAndConditionCheckbox({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SignupController.instance;
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Obx(
            () => Checkbox(
              value: controller.privacyPolicy.value,
              onChanged: (value) => controller.privacyPolicy.value = value!,
            ),
          ),
        ),
        const SizedBox(width: TSizes.md),
        Flexible(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: '${TTexts.iAgreeTo} ', style: Theme.of(context).textTheme.bodySmall),
                TextSpan(
                  text: TTexts.privacyPolicy,
                  recognizer: TapGestureRecognizer()..onTap = () => TDeviceUtils.launchWebsiteUrl('https://codingwitht.com/'),
                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                        color: THelperFunctions.isDarkMode(context) ? TColors.white : TColors.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: THelperFunctions.isDarkMode(context) ? TColors.white : TColors.primary,
                      ),
                ),
                TextSpan(text: ' ${TTexts.and} ', style: Theme.of(context).textTheme.bodySmall),
                TextSpan(
                  text: TTexts.termsOfUse,
                  recognizer: TapGestureRecognizer()..onTap = () => TDeviceUtils.launchWebsiteUrl('https://codingwitht.com/'),
                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                        color: THelperFunctions.isDarkMode(context) ? TColors.white : TColors.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: THelperFunctions.isDarkMode(context) ? TColors.white : TColors.primary,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
