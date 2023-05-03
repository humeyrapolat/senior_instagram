import 'package:flutter/material.dart';
import 'package:senior_instagram/features/domain/entities/app_entity.dart';
import 'package:senior_instagram/features/domain/entities/post/post_entity.dart';
import 'package:senior_instagram/features/domain/entities/user_entity/user_entity.dart';
import 'package:senior_instagram/features/presentation/page/credential/sign_in.dart';
import 'package:senior_instagram/features/presentation/page/credential/sign_up.dart';
import 'package:senior_instagram/features/presentation/page/post/comment/comment_page.dart';
import 'package:senior_instagram/features/presentation/page/post/post.dart';
import 'package:senior_instagram/features/presentation/page/post/update_post_page.dart';
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
          if (args is UserEntity) {
            return routeBuilder(
              UploadPostPage(currentUser: args),
            );
          } else {
            return routeBuilder(
              const NoPageFound(),
            );
          }
        }
      case PageConsts.updatePostPage:
        {
          if (args is PostEntity) {
            return routeBuilder(
              UpdatePostPage(
                post: args,
              ),
            );
          } else {
            return routeBuilder(
              const NoPageFound(),
            );
          }
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
          if (args is AppEntity) {
            return routeBuilder(
              CommentPage(
                appEntity: args,
              ),
            );
          }
          return routeBuilder(
            const NoPageFound(),
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
