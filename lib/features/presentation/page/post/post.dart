import 'package:flutter/material.dart';
import 'package:senior_instagram/util/consts.dart';

class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgGroundColor,
      body: Center(
        child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              color: secondaryColor.withOpacity(.3),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.upload,
                color: primaryColor,
                size: 40,
              ),
            )),
      ),
    );
  }
}
