import 'package:flutter/material.dart';
import 'package:senior_instagram/features/presentation/page/profile/widgets/profile_form_widget.dart';
import 'package:senior_instagram/util/consts.dart';

class UpdatePostPage extends StatelessWidget {
  const UpdatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgGroundColor,
      appBar: AppBar(
        backgroundColor: backgGroundColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            size: 32,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Icon(
                Icons.done,
                size: 32,
                color: pinkColor,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: secondaryColor,
                  shape: BoxShape.circle,
                ),
              ),
              sizeVertical(10),
              const Text(
                'Username',
                style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              sizeVertical(10),
              Container(
                width: double.infinity,
                height: 200,
                decoration: const BoxDecoration(
                  color: secondaryColor,
                ),
              ),
              sizeVertical(10),
              const ProfileFormWidget(
                title: 'Write a caption...',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
