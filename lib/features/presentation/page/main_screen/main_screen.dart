import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:senior_instagram/features/presentation/page/activity/activity.dart';
import 'package:senior_instagram/features/presentation/page/home_page/home_page.dart';
import 'package:senior_instagram/features/presentation/page/post/post.dart';
import 'package:senior_instagram/features/presentation/page/profile/profile.dart';
import 'package:senior_instagram/features/presentation/page/search/search.dart';
import 'package:senior_instagram/util/consts.dart';

class MainScreen extends StatefulWidget {
  final String uid;
  const MainScreen({required this.uid, super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  late PageController
      _pageController; // we are going to initialize this in the initState

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void navigationTapped(int index) {
    _pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: black,
        bottomNavigationBar: CupertinoTabBar(
          backgroundColor: black,
          activeColor: Colors.white,
          inactiveColor: Colors.white,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Ionicons.md_home),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Ionicons.ios_search),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Ionicons.ios_add_circle),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: '',
            ),
          ],
          onTap: navigationTapped,
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: const [
            HomePage(),
            SearchPage(),
            PostPage(),
            ActivityPage(),
            ProfilePage(),
          ],
        ));
  }
}
