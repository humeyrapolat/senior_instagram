import 'package:flutter/material.dart';
import 'package:senior_instagram/features/domain/entities/user_entity/user_entity.dart';
import 'package:senior_instagram/features/presentation/page/credential/sign_in.dart';
import 'package:senior_instagram/features/presentation/page/credential/sign_up.dart';
import 'package:senior_instagram/features/presentation/page/post/comment/comment_page.dart';
import 'package:senior_instagram/features/presentation/page/post/post.dart';
import 'package:senior_instagram/features/presentation/page/profile/edit_profile_page.dart';
import 'package:senior_instagram/util/consts.dart';

class OnGenerateRoute {
  static Route<dynamic>? route(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case PageConsts.editProfilePage:
        {
          if (args is UserEntity) {
            return routeBuilder(
              EditProfilePage(currentUser: args),
            );
          } else {
            return routeBuilder(
              const NoPageFound(),
            );
          }
        }
      case PageConsts.postPage:
        {
          return routeBuilder(
            const PostPage(),
          );
        }
      case PageConsts.signInPage:
        {
          return routeBuilder(
            const SignInPage(),
          );
        }
      case PageConsts.signUpPage:
        {
          return routeBuilder(
            const SignUpPage(),
          );
        }
      case PageConsts.commentPage:
        {
          return routeBuilder(
            const CommentPage(),
          );
        }
      default:
        {
          const NoPageFound();
        }
    }
  }
}

class NoPageFound extends StatelessWidget {
  const NoPageFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("No Page Found"),
      ),
      body: const Center(
        child: Text("No Page Found"),
      ),
    );
  }
}

dynamic routeBuilder(Widget child) {
  return MaterialPageRoute(
    builder: (context) => child,
  );
}
