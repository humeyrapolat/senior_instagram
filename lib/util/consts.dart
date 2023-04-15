import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const backgGroundColor = Color.fromARGB(120, 0, 0, 0);
const pinkColor = Color.fromARGB(255, 173, 8, 91);

const black = Colors.black;
const primaryColor = Colors.white;
const secondaryColor = Colors.grey;
const darkGreyColor = Color.fromARGB(97, 97, 97, 1);

Widget sizeVertical(double height) {
  return SizedBox(height: height);
}

Widget sizeHorizontal(double width) {
  return SizedBox(width: width);
}

class PageConsts {
  static const String editProfilePage = "editProfilePage";
  static const String noPageFound = "noPageFound";
  static const String postPage = "postPage";
  static const String updatePostPage = "updatePostPage";
  static const String searchPage = "searchPage";
  static const String homePage = "homePage";
  static const String activityPage = "activityPage";
  static const String signInPage = "signInPage";
  static const String signUpPage = "signUpPage";
  static const String commentPage = "commentPage";
}

class FirebaseConsts {
  static const String users = "users";
  static const String post = "post";
  static const String comments = "comments";
  static const String likes = "likes";
  static const String followers = "followers";
  static const String following = "following";
  static const String feed = "feed";
  static const String replay = "replay";
  static const String feedItems = "feedItems";
  static const String activityFeed = "activityFeed";
}

void toast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: pinkColor,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
