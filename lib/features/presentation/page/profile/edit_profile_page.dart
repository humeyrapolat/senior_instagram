import 'package:flutter/material.dart';
import 'package:senior_instagram/features/presentation/page/profile/widgets/profile_form_widget.dart';
import 'package:senior_instagram/util/consts.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        backgroundColor: black,
        title: const Text('Edit Profile'),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.close,
              size: 32,
            )),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Icon(
              Icons.done,
              size: 32,
              color: pinkColor,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
              ),
              sizeVertical(15),
              const Center(
                child: Text(
                  "Change Profile Photo",
                  style: TextStyle(
                      color: pinkColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                ),
              ),
              sizeVertical(15),
              const ProfileFormWidget(
                title: 'Name',
              ),
              sizeVertical(15),
              const ProfileFormWidget(
                title: 'Usename',
              ),
              sizeVertical(15),
              const ProfileFormWidget(
                title: 'Website',
              ),
              sizeVertical(15),
              const ProfileFormWidget(
                title: 'Bio',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
