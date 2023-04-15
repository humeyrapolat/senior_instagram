import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:senior_instagram/features/domain/entities/post/post_entity.dart';
import 'package:senior_instagram/features/presentation/cubit/post/post_cubit.dart';
import 'package:senior_instagram/features/presentation/page/home_page/widget/single_post_card_widget.dart';
import 'package:senior_instagram/util/consts.dart';
import 'package:senior_instagram/injection_container.dart' as di;

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
      body: BlocProvider<PostCubit>(
        create: (context) =>
            di.sl<PostCubit>()..getPosts(post: const PostEntity()),
        child: BlocBuilder<PostCubit, PostState>(
          builder: (context, postState) {
            if (postState is PostLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (postState is PostFailure) {
              toast("some error occured while creating posts");
            }
            if (postState is PostLoaded) {
              return postState.posts.isEmpty
                  ? _noPostYetWidget()
                  : ListView.builder(
                      itemCount: postState.posts.length,
                      itemBuilder: (context, index) {
                        final post = postState.posts[index];
                        return BlocProvider(
                          create: (context) => di.sl<PostCubit>(),
                          child: SinglePagePostCardWidget(post: post),
                        );
                      });
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  _noPostYetWidget() {
    return const Center(
      child: Text(
        "No Post Yet",
        style: TextStyle(
            color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}
