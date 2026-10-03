import 'package:flutter/material.dart';

import 'package:auth_ui_app/common/widgets/login_signup/form_divider.dart';
import 'package:auth_ui_app/common/widgets/login_signup/social_buttons.dart';
import 'package:auth_ui_app/utils/constants/text_strings.dart';
import 'widgets/login_form.dart';
import 'widgets/login_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              TLoginHeader(),
              SizedBox(height: 20),
              TLoginForm(),
              SizedBox(height: 20),
              TFormDivider(dividerText: TTexts.orSignInWith),
              SizedBox(height: 18),
              TSocialButtons(),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
