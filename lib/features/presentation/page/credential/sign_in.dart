import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:senior_instagram/features/presentation/widgets/button_container_widget.dart';
import 'package:senior_instagram/util/consts.dart';

import '../../widgets/form_container_widget.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgGroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(flex: 2, child: Container()),
          Center(
            child: SvgPicture.asset(
              'assets/ic_instagram.svg',
            ),
          ),
          sizeVertical(30),
          const FormContainerWidget(
            hintText: 'Email',
            inputType: TextInputType.emailAddress,
          ),
          sizeVertical(10),
          const FormContainerWidget(
            hintText: 'Password',
            isPasswordField: true,
          ),
          sizeVertical(15),
          ButtonContainerWidget(
            color: pinkColor,
            text: 'Sign In',
            onTapListener: () {},
          ),
          Flexible(flex: 2, child: Container()),
          const Divider(
            color: secondaryColor,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already have an account?',
                style: TextStyle(color: secondaryColor),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, PageConsts.signUpPage, (route) => false);
                },
                child: const Text(" Sign Up",
                    style: TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
