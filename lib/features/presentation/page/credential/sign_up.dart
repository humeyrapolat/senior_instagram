import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:senior_instagram/features/presentation/widgets/button_container_widget.dart';
import 'package:senior_instagram/features/presentation/widgets/form_container_widget.dart';
import 'package:senior_instagram/util/consts.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgGroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(flex: 2, child: Container()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/ic_instagram.svg',
              ),
            ],
          ),
          sizeVertical(15),
          Center(
              child: Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(80),
                ),
                child: Image.asset("assets/profile_default.png"),
              ),
              Positioned(
                right: -10,
                bottom: -15,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.add_a_photo,
                    color: pinkColor,
                  ),
                ),
              )
            ],
          )),
          sizeVertical(30),
          const FormContainerWidget(
            hintText: 'Username',
            inputType: TextInputType.text,
          ),
          sizeVertical(10),
          const FormContainerWidget(
            hintText: 'Email',
            inputType: TextInputType.emailAddress,
          ),
          sizeVertical(10),
          const FormContainerWidget(
            hintText: 'Password',
            isPasswordField: true,
          ),
          sizeVertical(10),
          const FormContainerWidget(
            hintText: 'Enter your bio',
            inputType: TextInputType.text,
          ),
          sizeVertical(20),
          ButtonContainerWidget(
            color: pinkColor,
            text: 'Sign Up',
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
                'Don\'t you have an account?',
                style: TextStyle(color: secondaryColor),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, PageConsts.signInPage, (route) => false);
                },
                child: const Text(" Sign In",
                    style: TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
