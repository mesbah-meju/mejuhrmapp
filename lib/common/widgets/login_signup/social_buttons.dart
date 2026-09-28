import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:auth_ui_app/features/authentication/controllers/login_controller.dart';
import 'package:auth_ui_app/utils/constants/colors.dart';
import 'package:auth_ui_app/utils/constants/image_strings.dart';
import 'package:auth_ui_app/utils/constants/sizes.dart';

class TSocialButtons extends StatelessWidget {
  const TSocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(TSizes.xs),
          decoration: BoxDecoration(border: Border.all(color: TColors.grey), borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: controller.googleSignIn,
            icon: const Image(width: TSizes.iconMd + 4, height: TSizes.iconMd + 4, image: AssetImage(TImages.google)),
          ),
        ),
        const SizedBox(width: TSizes.spaceBtwItems),
        Container(
          padding: const EdgeInsets.all(TSizes.xs),
          decoration: BoxDecoration(border: Border.all(color: TColors.grey), borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: controller.facebookSignIn,
            icon: const Image(width: TSizes.iconMd + 4, height: TSizes.iconMd + 4, image: AssetImage(TImages.facebook)),
          ),
        ),
      ],
    );
  }
}
