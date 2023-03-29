import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:senior_instagram/util/consts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgGroundColor,
        appBar: AppBar(
          backgroundColor: backgGroundColor,
          title: SvgPicture.asset(
            "assets/ic_instagram.svg",
          ),
          actions: [
            IconButton(
              icon: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  MaterialCommunityIcons.facebook_messenger,
                  color: primaryColor,
                ),
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      sizeHorizontal(10),
                      const Text(
                        "Username",
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      _openModalBottomSheet(context);
                    },
                    child: const Icon(Icons.more_vert, color: primaryColor),
                  ),
                ],
              ),
              sizeVertical(10),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height *
                    0.30, // 30% of screen height
                decoration: const BoxDecoration(
                  color: secondaryColor,
                  shape: BoxShape.rectangle,
                ),
              ),
              sizeVertical(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.favorite_border,
                        color: primaryColor,
                      ),
                      sizeHorizontal(10),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, PageConsts.commentPage);
                        },
                        child: const Icon(
                          Feather.message_circle,
                          color: primaryColor,
                        ),
                      ),
                      sizeHorizontal(10),
                      const Icon(
                        Feather.send,
                        color: primaryColor,
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.bookmark_border,
                    color: primaryColor,
                  ),
                ],
              ),
              sizeVertical(10),
              const Text(
                "34 likes",
                style:
                    TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
              ),
              sizeVertical(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "username",
                    style: TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                  sizeHorizontal(10),
                  const Text(
                    "description ",
                    style: TextStyle(color: primaryColor),
                  ),
                ],
              ),
              sizeVertical(10),
              const Text(
                "View all 100 comments",
                style: TextStyle(color: secondaryColor),
              ),
              sizeVertical(10),
              const Text(
                "15.01.2023",
                style: TextStyle(color: secondaryColor),
              ),
            ],
          ),
        ));
  }

  _openModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 150,
            decoration: BoxDecoration(
              color: backgGroundColor.withOpacity(0.8),
            ),
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "More Options",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: primaryColor),
                        ),
                      ),
                      sizeVertical(10),
                      const Divider(
                        thickness: 1,
                        color: secondaryColor,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "Delete Post ",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: primaryColor),
                        ),
                      ),
                      sizeVertical(7),
                      const Divider(
                        thickness: 1,
                        color: secondaryColor,
                      ),
                      sizeVertical(7),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, PageConsts.postPage);
                          },
                          child: const Text(
                            "Update Post ",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: primaryColor),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      sizeVertical(7),
                      const Divider(
                        thickness: 1,
                        color: secondaryColor,
                      ),
                      sizeVertical(7),
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "Logout",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: primaryColor),
                        ),
                      )
                    ]),
              ),
            ),
          );
        });
  }
}
