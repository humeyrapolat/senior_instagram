import 'package:flutter/material.dart';
import 'package:senior_instagram/util/consts.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgGroundColor,
      appBar: AppBar(
        backgroundColor: backgGroundColor,
        elevation: 0,
        title: const Text(
          'Activity',
          style: TextStyle(
            color: primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
