import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:intl/intl.dart';
import 'package:senior_instagram/features/domain/entities/post/post_entity.dart';
import 'package:senior_instagram/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:senior_instagram/features/presentation/cubit/post/post_cubit.dart';
import 'package:senior_instagram/features/presentation/page/post/widget/like_animation_widget.dart';
import 'package:senior_instagram/profile_widget.dart';
import 'package:senior_instagram/util/consts.dart';
import 'package:senior_instagram/injection_container.dart' as di;

class SinglePagePostCardWidget extends StatefulWidget {
  final PostEntity post;
  const SinglePagePostCardWidget({super.key, required this.post});

  @override
  State<SinglePagePostCardWidget> createState() =>
      _SinglePagePostCardWidgetState();
}

class _SinglePagePostCardWidgetState extends State<SinglePagePostCardWidget> {
  bool _isLikeAnimating = false;
  String _currentUUid = " ";

  @override
  void initState() {
    di.sl<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUUid = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        widget.post.userProfileUrl!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  sizeHorizontal(10),
                  Text(
                    widget.post.username!,
                    style: const TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  _openModalBottomSheet(context, widget.post);
                },
                child: const Icon(Icons.more_vert, color: primaryColor),
              ),
            ],
          ),
          sizeVertical(10),
          GestureDetector(
            onDoubleTap: () {
              _likePost();
              setState(() {
                _isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.30,
                  child: profileWidget(imageUrl: "${widget.post.postImageUrl}"),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _isLikeAnimating ? 1 : 0,
                  child: LikeAnimationWidget(
                      duration: const Duration(milliseconds: 200),
                      isLikeAnimating: _isLikeAnimating,
                      onLikeFinish: () {
                        setState(() {
                          _isLikeAnimating = false;
                        });
                      },
                      child: const Icon(
                        Icons.favorite,
                        size: 100,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
          ),
          sizeVertical(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: _likePost,
                    child: Icon(
                      widget.post.likes!.contains(_currentUUid)
                          ? Icons.favorite
                          : Icons.favorite_outline,
                      color: widget.post.likes!.contains(_currentUUid)
                          ? Colors.red
                          : primaryColor,
                    ),
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
          Text(
            "${widget.post.totalLikes!} likes",
            style: const TextStyle(
                color: primaryColor, fontWeight: FontWeight.bold),
          ),
          sizeVertical(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.post.username!,
                style: const TextStyle(
                    color: primaryColor, fontWeight: FontWeight.bold),
              ),
              sizeHorizontal(10),
              Text(
                widget.post.description!,
                style: const TextStyle(color: primaryColor),
              ),
            ],
          ),
          sizeVertical(10),
          Text(
            widget.post.totalComments == 0
                ? "No Comments"
                : "View all comments",
            style: const TextStyle(color: secondaryColor),
          ),
          sizeVertical(10),
          Text(
            "${DateFormat('dd MMM yyyy').format(widget.post.createAt!.toDate())}",
            style: const TextStyle(color: secondaryColor),
          ),
        ],
      ),
    );
  }

  _openModalBottomSheet(BuildContext context, PostEntity post) {
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
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: GestureDetector(
                          onTap: () {
                            _deletePost();
                          },
                          child: const Text(
                            "Delete Post ",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: primaryColor),
                          ),
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
                            Navigator.pushNamed(
                                context, PageConsts.updatePostPage,
                                arguments: post);
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

  _deletePost() {
    BlocProvider.of<PostCubit>(context)
        .deletePost(post: PostEntity(postId: widget.post.postId))
        .whenComplete(() => Navigator.pop(context));
  }

  _likePost() {
    BlocProvider.of<PostCubit>(context)
        .likePost(post: PostEntity(postId: widget.post.postId));
  }
}
