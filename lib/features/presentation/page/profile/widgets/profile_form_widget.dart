import 'package:flutter/material.dart';
import 'package:senior_instagram/util/consts.dart';

class ProfileFormWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? title;
  const ProfileFormWidget({super.key, this.controller, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        sizeVertical(10),
        TextFormField(
          controller: controller,
          style: const TextStyle(color: primaryColor),
          decoration: const InputDecoration(
            border: InputBorder.none,
            labelStyle: TextStyle(color: primaryColor),
          ),
        ),
        Container(
          width: double.infinity,
          height: 1,
          color: secondaryColor,
        ),
      ],
    );
  }
}
