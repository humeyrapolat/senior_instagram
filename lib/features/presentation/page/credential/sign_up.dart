import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senior_instagram/features/domain/entities/user_entity/user_entity.dart';
import 'package:senior_instagram/features/presentation/cubit/auth/cubit/auth_cubit.dart';
import 'package:senior_instagram/features/presentation/cubit/credential/cubit/credential_cubit.dart';
import 'package:senior_instagram/features/presentation/page/main_screen/main_screen.dart';
import 'package:senior_instagram/features/presentation/widgets/button_container_widget.dart';
import 'package:senior_instagram/features/presentation/widgets/form_container_widget.dart';
import 'package:senior_instagram/profile_widget.dart';
import 'package:senior_instagram/util/consts.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  bool _isSigningUp = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  File? _image;

  Future selectImage() async {
    try {
      final pickedFile =
          await ImagePicker.platform.getImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          toast("No image selected");
        }
      });
    } catch (e) {
      toast("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgGroundColor,
      body: BlocConsumer<CredentialCubit, CredentialState>(
        listener: (context, credentialState) {
          if (credentialState is CredentialSuccess) {
            BlocProvider.of<AuthCubit>(context).loggedIn(context);
          }
          if (credentialState is CredentialFailure) {
            toast("Invalid Email and Password");
          }
        },
        builder: (context, credentialState) {
          if (credentialState is CredentialSuccess) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return MainScreen(
                    uid: authState.uid,
                  );
                } else {
                  return _bodyWidget();
                }
              },
            );
          }
          return _bodyWidget();
        },
      ),
    );
  }

  _bodyWidget() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            sizeVertical(110),
            Center(
                child: SvgPicture.asset(
              "assets/ic_instagram.svg",
              color: primaryColor,
            )),
            sizeVertical(15),
            Center(
              child: Stack(
                children: [
                  SizedBox(
                      width: 60,
                      height: 60,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: profileWidget(image: _image))),
                  Positioned(
                    right: -10,
                    bottom: -15,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(
                        Icons.add_a_photo,
                        color: pinkColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            sizeVertical(30),
            FormContainerWidget(
              controller: _usernameController,
              hintText: "Username",
            ),
            sizeVertical(15),
            FormContainerWidget(
              controller: _emailController,
              hintText: "Email",
            ),
            sizeVertical(15),
            FormContainerWidget(
              controller: _passwordController,
              hintText: "Password",
              isPasswordField: true,
            ),
            sizeVertical(15),
            FormContainerWidget(
              controller: _bioController,
              hintText: "Bio",
            ),
            sizeVertical(15),
            ButtonContainerWidget(
              color: pinkColor,
              text: "Sign Up",
              onTapListener: () {
                _signUp();
              },
            ),
            sizeVertical(10),
            _isSigningUp == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Please wait",
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      sizeHorizontal(10),
                      const CircularProgressIndicator()
                    ],
                  )
                : Container(
                    width: 0,
                    height: 0,
                  ),
            sizeVertical(105),
            const Divider(
              color: secondaryColor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account? ",
                  style: TextStyle(color: primaryColor),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, PageConsts.signInPage, (route) => false);

                    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignInPage()), (route) => false);
                  },
                  child: const Text(
                    "Sign In.",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: primaryColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _signUp() {
    setState(() {
      _isSigningUp = true;
    });
    BlocProvider.of<CredentialCubit>(context)
        .signUpUser(
          user: UserEntity(
              email: _emailController.text,
              password: _passwordController.text,
              bio: _bioController.text,
              username: _usernameController.text,
              totalPosts: 0,
              totalFollowing: 0,
              followers: [],
              totalFollowers: 0,
              website: "",
              following: [],
              name: "",
              imageFile: _image),
        )
        .then((value) => _clearControllers());
  }

  _clearControllers() {
    setState(() {
      _usernameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _bioController.clear();
      _isSigningUp = false;
    });
  }
}
